---
title: Why don't we handle our errors properly?
layout: post
date: 2017-07-19
tags: [computer science, types]
---

If you're anything like me, you often find yourself writing code like this:

```java
public List<ThingBit> getTheThings(ThingHolder t) {
  if (t.hasThings()) {
    List<Thing> things = t.getThings();
    List<ThingBit> thingBits = new ArrayList<ThingBit>();
    for (Thing t : things) {
      things.add(t.getBit());
    }
    return thingBits;
  } else {
    return null;
  }
}
```

Now, there's a lot wrong with this code[^map], but the intent is at least clear.
However, there's a good chance this will actually blow up when I actually try and use
it, because it doesn't account for errors. Did you know that in the context this
method may be called in, `t` may be null? Or that some `Thing`s don't have bits,
shown by `getBit()` being null? Or that `getBit()` actually interfaces with a
database and can throw all kinds of exceptions?

[^map]: Every time I write another pointless for-loop to get around the lack of
    `map`, I die a little inside.
    
Well, if you didn't know that, you didn't handle it, and after running it a bit
you'll get lots of lovely `NullPointerException`s. So that's problem number 1.

__Sometimes you don't know what the error behaviour of code is__

However, sometimes I *do* know that `getBit()` might be null. I've seen it
before, and it can certainly happen, but a lot of the time it doesn't. So I know
I *should* handle the null case... but I don't anyway. Why do I code for the
happy path when I know there's an unhappy path? I'm just going to have to go
back and put it in once I write some tests, or worse, after it crashes when in
use.

My favourite CWE is the wonderfully unenforceable [CWE-655: Insufficient
Psychological Acceptability](http://cwe.mitre.org/data/definitions/655.html).
This makes the kind-of-obvious point that if your security measures are too
annoying or difficult to use, then people *will* bypass them, rendering them
entirely pointless. The same is true for error-handling techniques in
software: if they're too painful to use, then people won't use them until they're
forced to[^language]. So that's problem number 2.

[^language]: If your programming language doesn't *enforce* handling of errors,
    then ensuing that errors are handled is a basic software quality issue. And often a
    security issue - perhaps this deserves its own CWE!

__Sometimes correct error handling is psychologically unacceptable to the programmer__

Okay, so what do we actually do about this?

<!-- more -->

## Knowledge is power

There are two approaches to solving problem 1. We could view it as a discipline 
issue: we just need to document everything carefully, and make sure to read
a function's documentation before using it. But this is both highly fallible, and
relies on each individual doing the right thing. We're never going to get systematically
more reliable software that way, because humans aren't like that.

How can we make sure we always at least *know about* possible error conditions? The
answer to that is sipmle: get the machine to do it. That means that inference of
error conditions needs to be *automatic* and it needs to be *reliable*. Fortunately,
we already have a tool for getting reliable and automatically checked information
about the behaviour of code: types.

Reporting error conditions via the result types of functions seems to pretty much
solve this problem from my point of view. Even if it doesn't force you to deal with
them sanely, it at least means you have to be explicit about ignoring them, which
is a [boon]({{site.baseurl}}{% post_url 2015-03-26-types_and_reading_code %}) 
to future maintainers of the code.

However, to do this well you need static types, generics, and ideally sum types.
If you don't have that... better get used to reading (terrible) documentation. And if
you're writing Java then of course the entire system can be subverted by just passing
`null` instead of whatever rich result type you're using. Sigh.

## Make handling errors easy

There are similarly two approaches to solving problem 2. Again, we could view
it as a personal discipline issue: we just need to get over ourselves and do 
things properly, even if it's ugly. But that's bad for the same reasons as before. 
The more interesting question is: why is it that handling errors is ugly and 
difficult, and how can we fix that?

Let's look at a "better" attempt in Java:

```java
public List<ThingBit> getTheThings(ThingHolder t) {
  if (t == null)
    return null;

  try {
    if (t.hasThings()) {
      List<Thing> things = t.getThings();
      List<ThingBit> thingBits = new ArrayList<ThingBit>();
      for (Thing t : things) {
        ThingBit bit = t.getBit();
        if (bit != null)
          things.add(t.getBit());
      }
      return thingBits;
    } else {
      return null;
    }
  } catch (IOException e) {
    log("Exception retrieving bits", e);
    return null;
  }
}
```

Now, while the first version wasn't exactly pleasant, this version is just a
*mess*. The code for dealing with various errors practically takes up more space
than the actual logic[^go]. And what makes this egregious is that the error handling
logic itself is not that complex. 

[^go]:The most egregious example of this is probably Go, which has elevated ugly error 
    handling to a virtue.

Sometimes failure logic *is* complex. Suppose you're writing a disk-based cache
and you hit an out-of-disk-space error. Do you

1. Just report a cache miss?
2. Report a cache miss, but also log the error?
3. Propagate the error upwards in some form?
4. Attempt to free some disk space by ejecting some entries and retry?

What about if you retrieve a file that has become corrupted? What about if you hit an error
while trying to recover from another error?

These are all real complexities of error handling, and if the space of possible error states
is high relative to the normal operation of our code, then it may well be *appropriate* for
there to be a lot of code handling errors. 

On the other hand, sometimes we're writing code like the snippet above, where we're just trying to
do the *obvious thing*, or at least the *same thing* in all the cases. In this case the error strategy
is simple: ignore errors, and return an error value if anything goes wrong overall.

I could go through how various languages make this more or less easy, but let's cut to
the good stuff: here's the Haskell version (minus the IO errors)
```haskell
getTheThings :: ThingHolder -> Maybe [ThingBit]
getTheThings t = do
  things <- getThings t
  bits = catMaybes $ map getBit things 
  return bits
```

So we're using the fact that we're working in `Maybe` to handle the normal error cases,
and we use `catMaybes` to show that we're interested in just keeping the good cases from
each of the things.

And crucially, we don't have to deviate much from the direct style. The error handling
intrudes here in three places:
1. We have to work in a monad and use `do` notation.
2. We have to select an appropriate error type.
3. We have to use `catMaybes` to filter out error cases.

I maintain that this is about as good as you can possibly get: all of these represent actual
error policy decisions, with very little additional noise in carrying them out.

So if the answer to "why don't we handle our errors properly?" is "we don't use 
decent statically typed programming languages", then the obvious follow up question
is "why don't we use those languages?"[^empirics]. But that's not a question I think I can answer here.

[^empirics]: Along with "is there empirical data that these languages encourage better error
    handling?". I'd love to know the answer to this!

