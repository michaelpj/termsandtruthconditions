---
layout: post
title: Your orphan instances are probably fine
tags: [ programming , haskell ]
---

"Orphan" typeclass instances are instance declarations `instance T A` that occur in any module other than 
1. the module where the class `T` is defined, or 
2. the module where the type `A` is defined

The orthodox Haskeller viewpoint is that orphan instances are bad and you should never write them, because they can lead to *incoherence*.
Incoherence is where we end up using two differing instances for the same type in our program.
This can manifest in two unpleasant ways:
1. If you actually import both instances, your program will fail to compile.
2. If you do not directly import both, but rather use two modules which independently use the differing instances, you can end up with [incoherent behaviour](https://stackoverflow.com/questions/12735274/breaking-data-set-integrity-without-generalizednewtypederiving/12744568#12744568).

Both of these are pretty bad problems, in that neither of them is immediately apparent when you write the offending instance, but down the line they can cause some unsuspecting user's code to not compile, or worse, silently misbehave.

However, these failures can only happen if is *possible* for an *unsuspecting* user to import the type and the instance separately.
Moreover, in the case of compilation failure, the user must be *unable* to fix the source of the problem.
With a little bit of care, we can use orphans quite safely so long as we can avoid the problematic cases.

<!-- more -->

## Private components

A common place to define orphan instances is in a test suite.
Say you use `quickcheck` and you need `Arbitrary` instances for your types. 
You don't want to add a `quickcheck` dependency to your library, so you can't write the instances next to the types, and you certainly can't add them to `quickcheck` itself.
So you either `newtype` all of your types (hah), or make some orphans.

This is *totally fine*.
Why?
Because nobody can go wrong this way, since nobody can depend on your test suite and accidentally get your instances!

This isn't *quite* true, because the instances will be in some particular module of your test suite, so you *could* get incoherence within the test suite itself.
This is why I said that no *unsuspecting* user should be able to import the instances separately: people working on the test suite itself can reasonably be expected to know what's going on (and if you're really worried, write a big comment).

The same goes for all other "private" components: executables, benchmarks, etc.
Even some libraries: if it's a cabal internal library that's only used from other private components then it's also safe from hapless external users.
Of course, with a sufficiently convoluted multi-layered internal library structure you could perhaps trick your own team into importing the instances incorrectly---to which I say "don't do that".

## "Private" modules

Here's a pattern I've seen a bit at work:

```
Foo.hs
Foo
├── Instance
│   ├── Eq.hs
│   ├── Pretty.hs
├── Instance.hs
└── Type.hs
```

We have some type `Foo` which is quite complicated (an AST, say), which we define in `Foo.Type`. 
The instances for `Foo` are also quite complex, so to keep the modules not too big, we put some of the instance definitions in their own modules, but we re-export them all from `Foo.Instance`, and then both the type and all the instances get re-exported from `Foo`.
Crucially, we then *only* use the module `Foo` in the rest of the project (and in `exposed-modules`).[^why-private-modules]

[^why-private-modules]: Why do this? Mostly it's tidier, but Matt Parsons [recommends](https://www.parsonsmatt.org/2019/11/27/keeping_compilation_fast.html#hidden-orphans) something similar as part of getting faster compiles.

The (unenforced) intention is that `Foo.Instance.Eq` is a *private* module, accessible only from `Foo`.
What this means is that external users (assumed hapless) cannot import the type and the instances separately. 
You can still do this *inside* the component, but again this relies a team-member being both hapless and getting it through code-review.

## "Private" packages

[The](https://www.reddit.com/r/haskell/comments/cyfs94/someones_haskell_disappointment_gist_i_came_across/eysjq9t/) [prevailing](https://www.reddit.com/r/haskell/comments/cyfs94/someones_haskell_disappointment_gist_i_came_across/eyrvm94/) [wisdom](https://www.reddit.com/r/haskell/comments/5rcfyd/haskell_maxims_and_arrows/dd6e7sd/) is that putting orphans into a *public library* is a bad idea.
Orphans in a library are precisely the sort of thing that an unsuspecting user might pull in (maybe transitively!) and have no way to fix the issue.

The problem, then, is how to *export* instances for classes when you don't want to incur the dependency in your main library.
For example, we might want to expose our `Arbitrary` instances for other people to use, but we still don't want to depend on `quickcheck`.
The only way to do this today is to define a new package that has the instances in as orphans.[^public-libraries]

[^public-libraries]: In the glorious future we will have multiple public libraries per-package, but the situation is pretty much the same.

This is annoying for authors of public libraries posted on Hackage, but these days it's common for non-public applications to be structured as multiple packages (with a `cabal.project` or similar).
In this situation it makes sense to describe those packages as *private* packages: they're not going to be used by hapless external people, and they're entirely under the control of your team.
Even in the case of team haplessness, you can at least fix the problem directly.

The risk from "private" packages can grow as your organization grows.
If you have, say, half a dozen repositories depending on each other via `source-repository-package`, each of which has half a dozen packages, then the risk of haplessness increases significantly, as does the pain of fixing an issue.
God help you if you have an internal Hackage.
So: use your judgement.

## Think

The received wisdom about orphans ("just don't do it") is nice: it's a clear unambiguous bright line.
The reality is a little more complicated than that, but not *much* more complicated.
If you can easily avoid doing it, don't do it; otherwise think about whether something could actually go wrong due to the instance you're writing, add a note, and carry on with your life.

