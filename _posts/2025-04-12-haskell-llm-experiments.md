---
layout: post
title: Experiments with writing Haskell with Aider
date: 2025-04-12 11:03 +0100
---
I recently had a golden opportunity to try out using LLMs to write code. 
I had a completely green-field, standalone project at work, namely implementing support for an industry standard protocol (details omitted, but I work for CircuitHub, so you can imagine the sort of thing).

<!-- more -->

A few details about the protocol:
- The protocol transport format is XML over TCP
- The protocol is specified in a massive PDF (no, they don't provide an XML schema!)
- The protocol specification _does_ include state machine diagrams for the evolution of a protocol session

I decided to use `aider` for this.
Possibly I should have used Cursor, but I like the fact that I have more control over `aider`, and it's more compatible with me keeping the project open in Emacs to do my own edits.
For the model I started out using Claude 3.5, but moved on to Claude 3.7 which was released while I was working.

## Step 1: get a schema

Intuitively, I figured that it would be easier for the LLM to work from more structured information than the PDF, plus if I actually had a schema I could use it for validation, which would be pretty handy.
So the first thing I tried to do was to try and extract an XML schema from the tables in the PDF.
This was pretty non-trivial, since the tables featured such fun choices as using a small image icon next to a field name to indicate whether it should be encoded as an XML attribute or child element...

Getting a LLM to do this turned out to be quite hard!
I used GPT 4o-mini-high for this, and even at the beginning it would do a decent job.
But it really struggled to get things fully accurate.

I also had a fun bug where the LLM would hallucinate nonsense after a certain point in the specification.
For a while I thought it was simply the volume of material, but eventually I thought to ask it _why_ everything was so bad after section N, and it happily told me that it couldn't really work out what to do because the PDF was truncated!
It turned out there was a upload limit and my PDF was being silently truncated before it even got to the LLM.
Fortunately, I could just crop out the section I was interested in and have it work on that.
(How had it known to hallucinate the additional message types? The start of the PDF had the table of contents!)

Eventually I had to give up on going straight from PDF to schema, it just wasn't working.
But I hit on another idea: get GPT to just transcribe the PDF tables into markdown, and then work on generating an XML schema from the markdown.
This isolated one of the hard problems (interpreting the PDF) from the next one (turning the content into a schema).

This second approach was more successful, and I was able to generate the schema from the markdown content using `aider` locally.
This was also more efficient as it was easier to iterate on and just ask it to edit the schema partially to fix problems (there were still a _lot_ of errors).

In the end, I got GPT to transcribe all the sections of the PDF into markdown and I checked them in so I could pass them as context to `aider` when it was relevant.
I think this was pretty helpful.

## Step 2: message (de-)serialization

The obvious next bit I needed was just the definitions of the message types and the translation to and from XML.
I already had a schema, so surely this shouldn't be too hard?

Indeed, this part was pretty smooth. 
The LLM generated a _lot_ of code (there are a lot of message types!), but I didn't want to try and make it do anything too clever with generics or otherwise, so this seemed unavoidable.
With a bit of prompting it was also able to tidy it up and reduce the duplication somewhat, although it was quite bad at this generally. 
For example, I asked it to make a helper function for a particular pattern: it did so but only updated about ~30% of the possible use sites, and despite further prompting was not able to get them all.

This part was also pretty slow, as most edits involved changing tens or hundreds of lines of code.
Still, surely this was much faster than doing it myself?
Unclear, because I would just have done it right the first time!
This was a repeated pattern: the LLM can generate a lot of code quite fast, but you need to review it, and usually go through many revisions to get something good, whereas I would often have produced that in one pass.

One thing that was really excellent was that I was able to ask it to produce golden tests for each message type, and it did so perfectly first time, with all the messages formatted exactly correctly. 
That was amazing.

In retrospect, I think this would have been a better tool for a more standard code generator, since it's _so_ regular.
Trying to get the LLM to make tweaks to ist implementation of XML parsing across dozens of instances is possible, and better than doing it by hand, but still a lot slower and less reliable than just tweaking the behaviour of a more standard code generator.
I should have just got the LLM to help me write a XSD-to-Haskell code generator instead!

## Step 3: make an implementation plan

The rest of the implementation was going to be much more complex.

I had read elsewhere that LLMs often struggle to remember what they're doing, especially over the course of multiple ephemeral sessions.
This indeed turned out to be a real problem, as I often had to restart sessions for one reason or another.
Even just clearing the context (as inference costs scale up the more context you pass in) is quite costly in this respect, as it also wipes out any useful parts of your chat history with the LLM.

So I decided to guide the LLM into writing an implementation plan.
This went reasonably well: the plan was broadly sensible, but it was hard to know which details needed to be in there and which didn't.
I was unsure how much it helped, but I think it did keep the LLM on basically the same page when we resumed work after a break.

I also think I could have committed to this approach more.
I was too lazy to really treat the LLM like a junior employee who need micromanagement and write down plans for each smaller step in detail.
I would tend to get annoyed and just do it myself.
But I think if I had instead focussed on being painfully explicit in my instructions that might have also worked.

## Step 4: draw the rest of the damn owl

The rest of the implementation was moderately successful.
In practice, I think I heavily edited essentially all the code that the LLM wrote at some point.
The thing I found most difficult was that it would make bad architectural decisions, and it was hard to get it to come up with good ones, especially since I often also didn't know the right answer.
When I'm working by myself, I often work these things out by just trying it.
So I would end up starting to try out an idea, and then just keep on writing code because it was less annoying that trying to get the LLM to understand what I was groping towards.

The LLM was particularly bad at anything relating to concurrency, or tricky exceptional behaviour.
This is hard for humans, and the LLM would just do something that looked vaguely plausible, but pretty much never the right thing.
It was also utterly useless at helping me fix my concurrency bugs (hey, I said it was hard for humans too...).

It was generally pretty good at writing tests, or at least setting up the scaffolding (and then provoking me into finishing it because of its bad code...).
In fact, it was pretty good at scaffolding overall. 
When I wanted to have a little CLI tool to interact with the protocol, it could get 80% of the basics down very fast, and then even if I wanted to tweak bits I at least had most of the piece in place.

The tests provided a good example of the LLM's mediocre judgement: it would tend to handle tests that had concurrency in them by writing lots of explicit waits, rather than using synchronization primitives to ensure that things happened in the right order (e.g. "wait 500ms for the server to start up" versus "wait on an `MVar` that the server will fill when it has started up").
Overall I think it's right to say that the LLM is like a diligent junior programmer at the moment, and the tricky bit is trying to get it to write more senior code.
Probably there is a lot of skill in this that I simply don't have yet.

## Misc thoughts

Amazing thing number 1: LLMs can write Haskell!
And it mostly compiles!
Including using third-party libraries!
Honestly, this is just pretty damn impressive already.
I thought the whole project might be a wash, but the LLM was basically able to do it.

I found the feedback loop disappointingly slow.
I don't know why, but it often seemed to take a very long time for `aider` to actually do something: the LLM would respond with some prose, then some long code blocks, and then finally it would go into find/replace mode (which involved more massive code blocks), all of which would stream in at a moderate pace.
In practice, I would often go away and do something else for a few minutes after asking for anything substantial.
Decreasing the latency here _massively_ improve the experience - quite possibly there are things you can do that I just don't know about.

`aider` has lots of nice features, it's worth exploring them. 
`--subtree-only` and prompt caching were pretty important for me.

LLMs _can_ be decently good at fixing compiler errors or test failures.
`aider` has a neat feature where you just run a command and send the output to the LLM, which can then try and fix the issue.
However, it can also easily just make things worse, so I was often relcutant to do this and if the fix was obvious it was generally safer to do it myself.

Writing a little `STYLE_GUIDE` including things like your preferred libraries for various tasks was pretty handy.
Some instructions were just impossibly hard for the LLM: we tend to use explicit import and export lists at work, and it really couldn't manage that (working out exactly what things need to be imported is pretty hard!).

It also never really understood how I wanted it to document things - but again, maybe this is my problem. 
Were my instructions clear enough for a human?
Probably not, so it's perhaps unsurprising that the LLM didn't understand.
In some ways I think this could be quite a nice outcome of increasing adoption of LLMs for development: finally we will have clear and explicit guidance on the style and approach that an individual or team wants to apply to their codebase, because if isn't clear and explicit, the LLMs won't get it!

## Conclusion

Overall I think I managed to do the project faster with the help of the LLM, and it would probably have been a lot faster if I'd known what I was doing.
I got a decent project with a pretty good test suite and okay documentation.
I spent about ~$60 on inference costs, which is a decent amount but really not a lot for a major productivity gain.

The main things preventing me from trying to use it more is:
1. I found the process just generally quite annoying, much more so than just writing code myself. It felt like those days where you spend most of your day fighting with supporting tooling and don't get to actually do much concrete work.
2. Things generally got worse when trying to deal with more code and more context, so I don't think it would deal well with my normal work which involves touching various bits of a much larger codeabase. 

That said, a lot of that is my own skill with the tools, so do I think it's worth investing more time in.
