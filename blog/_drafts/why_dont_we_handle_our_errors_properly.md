---
title: Why don't we handle our errors properly?
layout: post
date: 2015-01-18
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
However, there's a good chance this will all blow up when I actually try and use
it, because it doesn't account for errors. Did you know that in the context this
method may be called in, `t` may be null? Or that some `Thing`s don't have bits,
shown by `getBit()` being null? Or that `getBit()` actually interfaces with a
database and can throw all kinds of exceptions?

[^map]: Every time I write another pointless for-loop to get around the lack of
    `map`, I die a little inside.

Well, if you didn't know that, you didn't handle it, and after running it a bit
you'll get lots of lovely `NullPointerException`s. So that's problem number 1.

1. Sometimes you don't know what the error behaviour of code is.

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
software: if they're too painful to use, then people won't use them[^language].

[^language]: If your programming language doesn't *enforce* handling of errors,
    then ensuing that people do is a basic software quality issue. And therefore a
    security issue - perhaps this deserves it's own CWE!

2. Sometimes correct error handling is psychologically unacceptable to the programmer.

There are two responses to this line of thought. We could view it as a personal
discipline issue: we just need to get over ourselves and do things properly,
even if it's ugly. But that's an individual solution. The more interesting
question is: what is it about programming languages that make this so, and how
can we make them better?

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
than the actual logic. 


