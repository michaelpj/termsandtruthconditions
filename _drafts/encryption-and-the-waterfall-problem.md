---
layout: post
title: Encryption and the waterfall problem
---

In the philosophy of computer science, there is a problem sometimes
called the "waterfall problem": properly interpreted, isn't *everything*
doing computation?

Suppose we have a waterfall, and we compare the positions of the atoms at the
start of the waterfall to their positions at the bottom (which we will assume are
randomly but deterministically, changed). Now, suppose we want
to argue that this waterfall is implementing a chess-playing algorithm. Then
all we have to do is provide some mapping from a chess position to the "input" 
of the waterfall, and some mapping from the "output" to a legal move, and we're
done. And, of course, we can always do this, provided we're willing to spend enough
time gerrymandering our mappings!

Scott Aaronson [argues](http://www.scottaaronson.com/papers/philos.pdf#page=22) that all the real work is going into producing the mapping -
in practice, computing the mapping would require solving the chess-playing problem! We could
show this by producing a program that solves the problem *without* access to the 
waterfall as quickly (in complexity terms) as one *with* access to the waterfall.

## The epistemic question

There's a related question, though, which is: given a waterfall, how can we tell if it
is computing *something* (or some particular computation)? We might think that we can 
at least answer negatively in some cases. If the action of the waterfall is indistinguishable 
from a random function (that is, it is a [pseudorandom function](https://en.wikipedia.org/wiki/Pseudorandom_function_family)), then *surely* it 
cannot be computing anything.

<!-- more -->

But pseudorandom functions are an integral building block of encryption systems. In particular,
we would like the function "encrypt `m` with key `k`" to be a pseudorandom function for any
given `k` - that means that an attacker gets no information about `m` from the ciphertext.
So an encryption function looks like a "waterfall", but it is definitely doing computation,
even under Scott's constraints (we can't get rid of the waterfall without adding work).

This makes it essentially impossible to distinguish waterfalls that aren't doing computation
from those that are, at least by just looking at inputs and outputs. Perhaps we could 
do better if we look at the implementation of the waterfall, but that's a much harder problem.

## Homomorphic encryption

We can go even further. We know that homomorphic encryption is possible, wherein we
can perform arbitrary computations on encrypted data. That means that we can encrypt
the initial state of a Turing machine, and then run it in an encrypted state, such that
at all points the state is indistinguishable from randomness, but at the end we can
extract the result by "merely" decrypting it. 

So homomorphic encryption means that we can turn *any* computation into a "waterfall", and
hence for any waterfall it could be implementing any computation, as far as we know.

## Philosophical implications

The waterfall problem is often used to attack computationalism in the theory of mind. The 
epistemic version can also be used for this purpose. If we can't tell whether a waterfall
is implementing any given computation, and certain computations give rise to minds, then
we can't tell whether waterfalls have minds. But we can tell that waterfalls don't have minds, 
*reductio*.

I think that the computationalist can just bite the bullet here. If a waterfall really is
implementing a encrypted mind, then it does have a mind! But that is very unlikely. We can
still argue that most waterfalls aren't doing any computational work, in Scott's sense. What
was particularly damaging about the original argument was that it implied that *all* waterfalls
were implementing *all* computations (including those giving rise to minds). Here, even if 
we could argue that all waterfalls implement *some* (possibly encrypted) computation, it 
seems very unlikely that they implement *all* computations.
