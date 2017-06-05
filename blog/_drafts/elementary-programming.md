---
title: Elementary programming
---

What's the difference between this program

and this one?

The second one is certainly shorter, but I believe it would also be considered
to be *better* by many Haskell programmers.

Why would we think that it's actually better? It has a few qualities:

- It's shorter
- It reuses existing code
- It requires fewer assumptions about the data on which it is operating

If we're lucky, we might even realise that the code which uses this function can
similarly manage with fewer assumptions, at which point we've generified the
whole thing and made it more reusable.

On the other hand, I think there's a good argument that the first program is
more understandable.

- It does not use many externally defined functions.
- It does not use many high-level abstractions (`Traversable`, in this case).

The first point is in conflict with code reuse. I'm all in favour of code reuse,
and I don't think I need to reiterate the points in its favour here, but it's
worth remembering that every time you reuse code you require the reader to
understand at least some of the library you're using.

This is, if anything, less bad in Haskell, as you can often grasp the
denotational meaning of code without actually having to dig through their source
code.[^slow]

[^slow]: Although if you're slow like me you may find you often have to read it
    anyway to understand the denotation!

That's a balance we have to strike, but I think the cards come down in favour of
code reuse overall.

The second point is more troubling. Abstraction tends to make code hard to
understand for someone who is unfamiliar with the abstraction, becuase they may have
to master it before they can understand how it specialises to the case that they
are actually interested in.

On the other hand, once you *have* mastered the abstraction, it can make you
much more productive by allowing you to quickly apply existing powerful
techniques to new domains.

So we have a dilemma - abstraction is great for the advanced users, but is
inevitably going to make your code hard for less advanced users to understand.
And if they can't understand your code, they certainly aren't going to be able
to maintain it.

## Elementary proofs, elementary programs

In mathematics, it's common to have what are known as "elementary" proofs of a
theorem. An elementary proof aims to do the job at hand using the most basic
tools that it can. This both makes it accessible for less advanced students, and
also builds their familiarity with manipulating the specific structure at hand, which
makes it easier to grasp later abstractions.

However, for the "working" mathematician, these proofs are likely to be far more
trouble than they're worth. The working mathematician will not actually
construct the dual vector space of a vector space from linear maps, they will
simply deduce its necessary existence from the X theorem. 

I think the parallel with programming is clear. The advanced programmer
wants to just slap down `traverse` and get on with the next bit, while the
novice progammer hasn't made it to `Traversable` yet, and moreover having to
manually construct the implementation of `traverse` over lists is likely to
be a helpful stepping stone in understanding that abstraction.

So what can we do about it? I'd like to say that we should just try and provide
equivalent elementary definitions for key functions in our libraries. But I
think that puts too high a burden on the "working" programmer. In mathematics,
we expect students to work their way up to the right conceptual level before
they expect to be able to contribute to advanced work. Furthermore, they're
expected to use learning materials like textbooks to get there, and that
provides a natural place to concentrate elementary proofs. On the other hand, in
programming, and particularly in open-source programming, we want people to be
able to dive right in, and it's rightly perceived as a barrier to entry (and
hence bad for both the community and your project) if your project has a big
label saying "WARNING: requires understanding of Traversable, Profunctors, and
Zippers!".

Which I guess leaves it as a judgement call. If you're keen to draw in novice
contributors, or you want your project to be of particularly pedagogical value,
then it may make sense to write more elementary programs.

There is one place where I think it's unambiguously a good idea to keep an
equivalent elementary program around, and that's for functions that have been
optimized for performance. In a similar way to functions which have been written
with a high level of abstraction these can be hard to understand, but they're also
harder to reason about and guarantee the correctness of. Keeping the elementary
version around does your readers a favour, and also means you can write a nice
QuickCheck property checking that the two are equivalent.
