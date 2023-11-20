---
layout: post
title: cpp-partial-evaluation
date: 2023-11-20 21:31 +0000
---
The Haskell Language Server (HLS) codebase has a lot of CPP conditionals.
A lot of them look like this:
```
#if MIN_VERSION_ghc(9,2,0)
```
which says that the version of the `ghc` library has to be at least 9.2; or this
```
#if MIN_VERSION_ghc(9,2,0) && !MIN_VERSION_ghc(9,3,0)
```
which says that the version of the `ghc` library has to be between 9.2 and 9.3; or this
```
#if __GLASGOW_HASKELL__ < 902
```
which says that the version of GHC itself has to be less than 9.2.

When we stop supporting a version of GHC, many of these conditonals become obsolete.
If we have code like this:
```
x = 
#if MIN_VERSION_GHC(9,2,0)
  1
#else
  2
#endif
```
then once we only support GHC 9.2 and above, the conditional will always evaluate to true, and so we can simplify it away.
Until now, we've mostly done this by hand.
But surely there should be a way to do this automatically!

What we want to do is similar to _partial evaluation_: we want to evaluate _some_ of the CPP, given values for _some_ of the inputs, and get as a result a reduced version of our input.

There are several tools that do this:
- unifdef: https://dotat.at/prog/unifdef/
- cppp: https://www.muppetlabs.com/~breadbox/software/cppp.html
- coan: https://coan2.sourceforge.net/index.php

I tried `unifdef` and `coan`, as they are packaged on NixOS, which I use.

The first hurdle is that neither tool really has good support for function macros like `MIN_VERSION_ghc`.
They're mostly focused on simple macros that are either defined or undefined, or set to a particular value.

My solution to this is grimy but it works: replace all the function macros with constants using `sed`.
That is, we replace everything that looks like the `MIN_VERSION_ghc` macro that we want to replace with some simple macro like `ALWAYS_TRUE` that we can define later.
Now we have not only a pre-processor partial evaluator but a pre-processor pre-processor!

This works fairly well.
Both `unifdef` and `coan` were able to remove `MIN_VERSION_ghc` macros and the code that they were guarding.
However, `coan` was significantly better in that it was able to simplify conditionals like the second example, turning `MIN_VERSION_ghc(9,2,0) && !MIN_VERSION_ghc(9,3,0)` into just `!MIN_VERSION_ghc(9,3,0)`
From this point on I just used `coan`.

The steps looked like this:
```bash
sed -i -e 's/MIN_VERSION_ghc(9,0,[0-9]*)/ALWAYS_TRUE/g' $FILE 
coan source -r -DALWAYS_TRUE=1 $FILE
```

1. Replace `MIN_VERSION_ghc(9,0,<anything>)` with `ALWAYS_TRUE`
2. Run `coan` to evaluate with `ALWAYS_TRUE` set to 1

You can then use `grep` and `xargs` to run this on all Haskell files.

The final problem is `__GLASGOW_HASKELL__` conditionals.
`coan` _can_ set `__GLASGOW_HASKELL__` to a value, but we don't actually want that.
If we set `__GLASGOW_HASKELL__` to `903`, then that will remove any `__GLASGOW_HASKELL__ < 903` conditionals (false) but _also_ `__GLASGOW_HASKELL__ < 904` (true), and so on.
We would really want to tell `coan` that `__GLASGOW_HASKELL__` is some constant greater than `902`, but not exactly what it is.

In the end, I just did the same trick of replacing the conditionals with `ALWAYS_TRUE`.
In principle, there could be all kinds of `__GLASGOW_HASKELL__` conditionals with various comparison operators, but in practice there aren't that many, and a quick grep through the codebase will identify them.

Overall this was very successful!
Normally doing this would have taken me a couple of hours, and in this case there was a lot to do and I was rather dreading it.
Automation to the rescue!
