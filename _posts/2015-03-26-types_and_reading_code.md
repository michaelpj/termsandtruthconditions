---
title: Types and readibility
layout: post
date: 2015-03-26 22:34

tags: [programming, types, flamebait]
---

(or: why I won't write anything longer than a page in a dynamically-typed
langauge)

Reading and understanding code is a huge part of being a developer.

When I'm at work, I probably spend most of my time reading code, rather than
writing it. Pretty much anything you do that involves existing code will require
you to read some of it. At some point, you're going to need to answer a question
like:

1. What can I do with X?
2. What kind of thing is X?
3. How do I do X with Y?

and then you're going to need to read some code. If you use, fix, or
interface with existing code, then these questions are always going to crop
up.[^exhaustive]

[^exhaustive]: Obviously, that's not an exhaustive list!

The *amount* of reading that you need to do will vary depending on what you're
trying to do and how much you already know about the code in
question. If you're fixing a small bug in code that you wrote yourself, chances
are that you won't need to do much reading. If you're making extensive changes
to someone else's code, then you may well need to read and understand a
significant fraction of it.

Even when you're writing totally fresh code, you're likely to need to do some
reading. Once you've put down a project for a while, it's pretty easy to forget
the details of even code that you wrote yourself. Hopefully it comes back to you
a bit quicker, but there will still be corners that are as fresh to you as if
they were written by a stranger.

Given that reading code is such a big part of my experience of being a
programmer, I think it's pretty important to figure out the factors make reading and
understanding code easier or harder. Let's start with an example.

<!-- more -->

## The mysteries of Python ##

Suppose you want to make a really quick alteration to a routine that processes
messages in some format. There's something funny with the normalization
process, and you want to print the message header each time so you can see if
anything sticks out at you. 

```python
def process(message):
    normalized = normalize(message)
    if not normalized.isValid:
        raise new MessageFormatError("Invalid message!")
    handle(normalized)
```

Alright, we just need to insert a `print` call on the first line with the message header. But how
do I get that? (Question 3) Well, maybe I can do something with `message` that
might allow me to get the header? (Question 1) In fact, maybe it has some class
methods! But what's the class of `message`? (Question 2)
Now things get tricky. I have a couple of options, in decreasing order of
attractiveness:

1. Maybe I have my editor set up with some fancy Python type-inferencing thing
like [rope](https://github.com/python-rope/rope). Then, so long as it's not too complicated, it might be able to
work out the type for me.
2. I can run the code in a REPL or directly; break in the function; and then inspect
the object directly.
3. I can guess that there might be a class called `Message`, and have a
look for that.
4. I can try and find callers of `process`, and work my way back up various
hypothetical call stacks until I can find something that lets me pin it down.

However, all of these have pretty severe disadvantages: `rope` gets confused pretty
easily; running the code can be prohibitively expensive, if the component you
are interested in is in the middle of a routine; guessing is, well, guesssing; 
and working up the call stack is tedious and tricky.

At least once you've got the name of the class, you can usually find its
definition pretty quickly, and then you're probably in safe territory. Assuming
you don't have to do anything more than call a single method to get the header.
And assuming that it's not such "dynamic" code that message might have *many*
classes.

In a relatively unfamiliar codebase, this process can easily take 10-15 minutes,
and in the worse case, a lot longer.

(The attributes are kept in a map that's populated with a schema that's taken
from a JSON blob that you get from the internet whose constitution depends on the
version of the API that you're talking to... )

## A bad answer: documentation ##

I've been deliberately assuming that there is absolutely no documentation
anywhere in this hypothetical codebase. That's both somewhat unfair, and a
depressingly realistic assumption. Useful documentation is rare, although you're
more likely to find it in open-source code than in that module your coworker
whipped up last week in a hurry.

But what kind of documentation would actualy help here? What definitely does
*not* help is a kind of verbose, English description of what the function does.

"This function processes a message, normalizing it to ensure that any
special characters due to BLAH are removed."

Great, that's actually pretty useful in general, since it told me why the
normalization is necessary. It's totally useless for telling me how to work with
the `message`. All it's told me is that it can be described in English as a
"message". You don't say.

What *would* help is to tell me what class `message` is expected to have. I do
see that in some Python libraries, and it's really helpful for figuring how to
actually do stuff.

Depressingly, even knowing the class might not be enough. If the function I need
is actually just a standalone function, then it's another painful hunt to try
and find functions that take `Message`s.

## A better answer: static types and resolution ##

It's telling that the kind of documentation that I find most useful when
actually working with Python is essentially a neutered type signature.

Having static types and resolution makes a lot of these problems easier. You
know (*always*), at the press of a button, what kind of thing a variable is. You
know, at the press of a button, what kind of methods it has, if it has a class.
You know with maybe a single command (or a Hoogle) what functions operate on
that type. You know, at the press of a button, all the callers of a function in
your codebase.

I use these features *all the time* when I'm working on reasonably-sized Java
codebases. When working on Python I pay the (amortized) 10 minute cost. Which
wastes my time, encourages me to guess and pray, and is just plain *painful*.

Note that the types are only half of this. Static resolution of calls is
just as useful, because you can just go, at the press of a button, to the code that
will definitely be run. And yes, dynamic dispatch in object-oriented languages
breaks this - and it can be extremely difficult to figure out what is going on
in code that abuses dispatch![^static]

[^static]: I work for a company that does static analysis. *The horrors I have
    seen*.

The best bit about delegating this to the compiler is that it's maintenance
free, and always up to date. Okay, I lied, if you're writing Java it's a massive
pain, but all sane langauges have type inference these days.

## But isn't Python supposed to be very readable? ##

I would say that Python is superficially readable.

If you glance at a function you can probably describe in English what it's
doing. That's great for a high-level overview, but then you get into the details
and you realise you have no idea what's going on at the operational
level. Which is where you work when you actually *write* Python. It's great that you
know that it's a message-processor, but that doesn't tell you how to get the message
header.

On the other hand, something like Java is superficially a mess, with all the
type annotations everywhere, but when you need to work with it you've got the
information you need at your fingertips. Need the message header?
`message.<C-SPC>hea<TAB><CR>`, done, move on to the next thing. Being constantly
dragged out of flow to go and hunt down information that should be trivially
available is horrendous.

Obviously, I think that languages with static typing and type inference have a
strict improvement in readibility over both Python and Java. You *do* need the
compiler around a bit more to tell you the inferred types, but it's better than
having all the redundant noise that Java forces on you. However, I highly doubt 
that such languages are the supremum of readibility - no doubt there is further
to go.

But when it comes down to it, I would rather read Java than Python any day, and
I don't want to inflict it on anyone else either. And that, more than anything
to do with expressiveness, or even safety, is the *real* reason I won't use Python
for anything longer than a page.
