---
layout: post
title: On Commenting Code
date: 2022-04-24 16:16 +0100
---
Programmers like to go on about how you should or should not comment your code.
This is my contribution.
But first, go read [Antirez's take on this][antirez] which is fantastic and says almost everything that needs to be said, I agree with essentially all of it.

<!-- more -->

## It's about maintenance, stupid

> Software is read much more than it is written, so optimize for reading rather than writing.

A truism, but it's really true.
Like many truisms, you perhaps have to learn it for yourself, usually by reading a lot of code written by people (often your past self) who didn't take the time to care for the future reader.
After you've done that a bunch, you start to find that a little bit of writing saves you a lot of pain later.
Even now, I often find myself wishing I'd written even more in my past code!
Never have I read some code that I found to be over-documented.

Writing comments is about making the code maintainable and comprehensible, both for you and for other people.
And you *will* be maintaining this code.
That one-off shell script you threw into `~/bin`?
In two years you'll be staring at it wondering what on earth it does and why it's broken.
Maintenance is inescapable - you might as well make it suck less.[^1]

[^1]: Exception: it's code for your job, you're not planning to stay, and you hate your coworkers/are an asshole.

## Don't burn your knowledge

How often have you seen this?

Pull request description:

> Initially I thought this bug was due to X, but after three days of strenuous debugging I was unable to verify this.
> Fortunately I tried arcane technique Y, which revealed that the problem was really Z, which can only occur under obscure circumstances C.
> I then reasoned carefully through the code and realised that this can only occur when the system is in state S, which we don't rely on and can be made illegal.
> This can easily be done with a simple guard, which I added here.

Diff: one line of code, no comment.

The author of such a change (let's call them Janet) has done a huge amount of _work_.
This work has produced two things: a code diff of a single line that fixes the problem, and some knowledge.
Janet now knows 

- That this piece of code is non-obviously connected to conditions C
- That such issues with this code can be investigated with technique Y
- That the design of the system should make state S illegal
- That S can be avoided through a guard at this location

All of this knowledge is at risk of being lost!

"But it's in the PR description." 
PR descriptions are ephemeral, and hard to look up later.

"But Janet also put it in the commit message, so it can be looked up later with `git blame`." 
This is true, and in principle a version control system is a sensible place to store historical information about the evolution of a codebase.
But in practice this information is often hard to find, and is easily covered up by future changes to the same part of the codebase.

"But Janet knows it, and her colleagues who reviewed the PR also know it."
Everyone forgets things.
Worse, people leave companies and move on from projects.
Information that is not written down is very easily lost.

When I see this kind of change I see people _burning their intellectual labour_.
Janet has gone to so much effort to discover the knowledge she needed to make the change, and now she is throwing it away.
Future contributors to the codebase will have to painfully rediscover it, or will blunder along without it, making more mistakes as a result.

My preferred solution to this is simple: 

1. Write down as much as you can of what you learned[^2] in the process of finding out how to make a change.
2. Write it down somewhere durable, probably in the code.[^3]

[^2]: Or even things you already know: Antriez's "teacher comments" encode knowledge that is probably not new to the person writing them, but which may be new (and helpful) to the reader. 
    But this requires more time and more judgement about what your reader is likely to know.

[^3]: Not all things are appropriate to record in the code.
    For example, if you learned ""how to run our code under a profiler", you may well want to write that down in your project's developer documentation.
    
I think that many, if not all, changes to a reasonably mature codebase come with a significant penumbra of knowledge.
If you take the task of recording that knowledge seriously, it suggests that a large codebase might be significantly or even mostly knowledge.
Obviously this will differ by domain: some domains require more knowledge, or require more obscure knowledge that can't be assumed to be common knowledge.

As a data point, my current work codebase (programming language stuff, in Haskell) is ~40kloc of code and ~20kloc of comments.
And I would be happy if it was even more documented!

## Notes: a knowledge organization technique

If you take the maxim to record all your knowledge seriously, you start to have a *lot* of comments.
Sometimes it's not clear where to put them.

One particular case comes up a lot:

- You need to write a long (multi-paragraph) comment explaining something.
    - If it was short, you could just put it inline.
- What is explained in the code is relevant in multiple places, potentially even in different files.
    - If it was only relevant to one place you could probably get away with just putting it "nearby", or maybe in the module docs.
- The comment does not obviously belong to some source code 'entity'.
    - If it did relate to an entity then you could put it in the documentation for that entity and use it as a reference anchor.
    
For this I use a convention I borrowed from the GHC codebase: the Note Convention.

- A Note is a block comment with a special header
    - The header has a fixed format, so it is easy to grep for, and includes a title
    - e.g. `Note [The importance of writing notes]`
- A Note can be referenced in a comment by using exactly the same text as appears in the header
    - e.g. `This is important, see Note [The importance of writing notes]`
- Notes in a file should generally live at the bottom of the file.

Example:
```haskell
-- This function really needs some documentation
-- See Note [The importance of writing notes]
foo x y = x+y
   
{- Note [The importance of writing notes]
It's heplful to write notes for future people!
-}
```

The Note Convention is very crude, and it's hard to keep up to date since you don't have a proper documentation system checking your links and so forth.
Sadly, I have never met a code documentation system that supports these kind of free-floating documentation chunks, perhaps because they're mostly focussed on API documentation.
But Notes are a lot better than nothing, and having a collection of standalone chunks of documentation which you can independently reference seems to work reasonably well.

In practice Notes tend to contain "design" and "why" comments, since those are the sorts of knowledge that get referenced repeatedly.
However, sometimes it's a nice way to just get a massive inline comment out of the way.

## Some additional types of comment

Antirez's comment taxonomy is great, but I wanted to call out a couple of additional types of comment that I think are interesting.

### Knowledge debt comments

Sometimes you don't know why something works.
Or you think you know but you're not sure.
Or it sort of makes sense that it works, but you're still suspicious about that one thing...

I think you should write this sort of thing down!
It is very useful for a future reader.
They might be able to contribute the missing knowledge to explain how things do actually work, or perhaps it will be just what they need to put them on the trail of that obscure bug.

It's tempting not to write knowledge debt comments because it makes you seem stupid.
But it's okay not to know everything: the future will be better off with an accurate picture of your partial knowledge than a misleading lack of commentary.

I think knowledge debt comments are interestingly different to the kinds of "debt" comments that Antirez points out. 
Those typically encode things that you know are wrong about the *code*, but which you haven't had the time or ability to fix yet.
Knowledge debt comments reflect known deficiencies in the *knowledge* which you have encoded around the code (and which may point to deficiencies in the code, but you don't know!).
If we are serious about recording our knowledge, then recording such deficiencies is also useful.

Example: "The documentation says to call this with the NOBLOCK parameter, but from reading the source, that seems to do nothing. Nonetheless, this doesn't work unless I do that, so I've left it in."

### Road-not-travelled comments

Sometimes I look at a piece of code and I think "this seems very roundabout, why not do X instead?".
Often there is a good answer: the original author thought of or tried X, but found some reason not to do it.
Sometimes there is not a good reason, and switching to X would be an improvement.
So pointing out which case it is can be very helpful!

Example: "Initially I tried using an IntMap for this, but because of the distribution of the keys it turned out that a HashMap got better performance."

## Random objections

"Won't I end up with more comment than code? Isn't that clearly excessive?"
How much work did it take you to come up with that code?
If it was a lot then you probably need a lot of writing to convey that.
This is especially pronounced if you spent a lot of time figuring out how to write short, "clever" code.
Such code probably needs *more* comments even though it's shorter!

"This is a deficiency in programming languages, if your language is more expressive you need fewer comments."
I certainly agree that your language can help you avoid the need for comments.
If you have a statically typed language you (mostly!) don't need to explain what kind of arguments your function can handle in the function documentation![^4]
But since many comments reflect the _knowledge_ of the author, including historical and personal aspects, it's hard to see how this could ever be entirely encoded in the code, no matter how advanced the language.

[^4]: Another example is Antriez's "checklist" comments.
    Especially in a language with good algebraic datatypes and patten match incompleteness warnings you can structure your code so that the compiler will enforce these for you!

"It's obvious what this function does, there's no point documenting it."
It's obvious to you, with your current state of knowledge.
Would it be obvious to your most junior team member (hint: probably not)?
If so, fair enough, leave it to stand in its self-evident glory.

"I'm a programmer, I'm paid to write code, not prose."
No, you're paid to build software as part of a team.
Which requires maintainability and communication, so you might as well accept it and get good at it.

## Writing good comments

I was going to say something about writing good comments, but I don't think I have anything original to say.
It's just the same as doing any other kind of technical writing, and you can find plenty about that elsewhere (know your reader, focus on clarity, etc.).

## Conclusion

Comment your damn code.

[antirez]: http://antirez.com/news/124
