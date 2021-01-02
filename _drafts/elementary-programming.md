---
title: Elementary programming
tags: 
- programming 
- haskell
---

What's the difference between this program

```haskell
mapMaybe :: (a -> Maybe b) -> [a] -> Maybe [b]
mapMaybe f [] = Just []
mapMaybe f (a:as) = (:) <$> f a <*> mapMaybe f as 
```

and this one?

```haskell
mapMaybe :: (a -> Maybe b) -> [a] -> Maybe [b]
mapMaybe = traverse
```

The second one is certainly shorter, but I believe it would also be considered to be *better* by many Haskell programmers.

<!-- more -->

Why would we think that it's actually better? 
It has a few qualities:

- It's shorter
- It reuses existing code
- It's more general (will work on more kinds of input) 

If we're lucky, we might even realize that we can generalize the type signature.
If we're really lucky, we might be able to generalize the calling code too, which can lead to a virtuous cycle of generalizing and deleting code.

On the other hand, I think there's a good argument that the first program is more understandable.

- It does not use many externally defined functions
- It uses fewer abstractions (`Traversable`)

The first advantage of the simpler code is in direct conflict with code reuse: every time you reuse a function, that's something that a reader of your code has to understand (at least superficially) in order to understand what you wrote.
I'm all in favour of code reuse, but it's worth remembering that it can increase the comprehension burden on the reader.
In practice, I don't find this to be too much of a problem, but it does suggest that you should hesitate before, say, pulling in a library for just one function.

The second advantage of the simpler code is more troubling. 
Abstraction tends to make code harder to understand for a reader who is unfamiliar with the abstraction, because they may have to master the abstraction before they can understand how it specializes to the case that they are actually interested in.
Your code may be working with the `Maybe` monad, but if you call lots of monad-generic functions, your readers may struggle if they don't yet grasp the monad abstraction in full.
On the other hand, once you *have* mastered the abstraction, it is useful both for writers *and* readers: writers can quickly apply familiar and powerful tools to new domains; and readers can recognize familiar patterns applied in a new setting.

So we have a dilemma: abstraction is great for the advanced users, but is inevitably going to make your code hard for less advanced users to understand. 
And if they can't understand your code, they certainly aren't going to be able to maintain it.

## Elementary proofs, elementary programs

In mathematics, it's common to have what are known as "elementary" proofs of a theorem. 
An elementary proof aims to be a valid proof, but one which does the job using the most basic tools that it can. 
This both makes it accessible for less advanced students, and also builds their familiarity with manipulating the specific structure at hand, which makes it easier to grasp later abstractions.

However, for the "working" mathematician, elementary proofs are more trouble than they're worth. 
They take up more space, and the more abstract approach may well be more obvious to an advanced practitioner.
The situation is similar in programming
The advanced programmer wants to just slap down `traverse` and get on with the next bit, while the novice programmer hasn't made it to `Traversable` yet, and moreover having to manually work through the implementation of `traverse` over lists is likely to be a helpful stepping stone in understanding that abstraction.

So what can we do about it? 
Mathematicians provide elementary proofs *as well* as the non-elementary one (or some helpful educator will come along and provide the elementary version).
We *could* do the same thing when writing code, but it's a burden on the programmer, especially when things change: it's bad enough having to update *one* function, let alone a second, tediously elementary version as well.

Alternatively, we can just accept that some codebases will be out of reach of novices.
In mathematics, we expect students to work their way up to the right conceptual level *before* they are able to be able to contribute to advanced work. 
Furthermore, they're expected to use learning materials like textbooks to get there, and that provides a natural place to concentrate elementary proofs. 
But this is somewhat unsatisfactory: we would *like* people to be able to jump right in to contributing to our programming projects, especially in open-source.
"Fancy code" is a barrier to entry.

Which I guess leaves it as a judgement call (boo). 
If you're keen to draw in novice contributors, or you want your project to be particularly pedagogical, then it may make sense to write more elementary programs.

I do think there are some places where it's worth having multiple copies of a function.
One particularly important example is code that has been optimized for speed.
This often makes it *extremely* obscure, and hence hard to read.
Having an elementary version is also good for sanity-checking: you can test the two against each other.
Of course, a reader still has to trust that the optimized version does the same as the non-optimized version, but the same is true any time you provide an equivalent elementary program.
