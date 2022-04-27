---
layout: post
title: Lenses for Tree Traversals
tags:
- programming
- haskell
date: 2020-08-02 22:05 +0100
---
If there's one thing compiler writers spill a lot of ink over, it's tree traversals.
Tree traversals are infuriatingly simple conceptually, but can be a lot of boilerplate to actually write.
This post covers a couple of tricks that I've found useful recently using tools from `lens`.

<!-- more -->

Let's suppose we have a simply lambda calculus with some primitive integer operations.

```haskell
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE DeriveTraversable #-}
{-# LANGUAGE RankNTypes #-}
module LensesForTreeTraversals where
import Control.Lens
import Data.Monoid
import Data.Functor.Foldable hiding (fold)
import Data.Foldable

type Name = String

data Type = IntegerType | FunType Type Type

data Term = 
    Var Name
    | Lam Name Type Term
    | App Term Term
    | Plus Term Term
    | Constant Integer
```

We'd like to write a simple constant-folding pass over this AST. 
The algorithm is extremely simple, in prose:

> Recursively transform all the subterms, and if the resulting node is then the sum of two constants, replace it with a constant equal to their sum. 

We would really like to reach this level of clarity in our code.
The subtlety, of course, is how we talk about "all the subterms", and that will be the theme of this post.

A naive implementation of the constant folding function is as follows:

```haskell
-- | Do the local part of the constant folding transformation.
cf :: Term -> Term
cf = \case
    Plus (Constant i1) (Constant i2) -> Constant (i1 + i2)
    x -> x

constantFold :: Term -> Term
-- Do the local transformation after recursively calling ourselves 
-- on the subterms, if any
constantFold t = cf $ case t of 
    Plus t1 t2 -> Plus (constantFold t1) (constantFold t2)
    Lam n ty t -> Lam n ty $ constantFold t
    App t1 t2 -> App (constantFold t1) (constantFold t2)
    x -> x
```

Tediously, we have to explicitly pull out each subterm and call the function on it recursively, which is not only boilerplate, but error-prone (nothing will tell us if we've missed a subterm!).

## `Traversal`s

Now, we want to do something for *every* subterm, which sounds like the sort of thing we should be able to do with `traverse`.
But it's a pain to make `Traversable` work with our AST. 
In particular `Traversable` expects your type to have kind `* -> *`, i.e. to be able to "contain" values of any type. 
This isn't really right for us: a term is like a *monomorphic* container of its subterms.

Enter `Traversal`s from `lens`.
A traversal is very closely related to `Traversable.traverse`:

```haskell
-- traverse :: (Traversable t, Applicative f) => (a -> f b) -> t a -> f (t b)
-- type Traversal s t a b = forall f. Applicative f => (a -> f b) -> s -> f t
```

A `Traversal` is a `traverse`-like function, but it can be more specific if that's appropriate.
In particular, we can define a `Traversal` that *only* traverses the subterms of a term.

(Maybe there's a clever way to write traversals, but I do it the stupid way: take the effectful function and the value, and apply it to the subparts.)

```haskell
-- Traversal' a b = Traversal a a b b, useful if you're not doing clever stuff
termSubterms :: Traversal' Term Term
termSubterms f = \case
    Lam n ty t -> Lam n ty <$> f t 
    App t1 t2 -> App <$> f t1 <*> f t2
    Plus t1 t2 -> Plus <$> f t1 <*> f t2
    -- Terms without subterms. Note that you should *not* put 'f x' as the 
    -- RHS: that would say that the term was its own subterm!
    x -> pure x
```

What does `termSubterms` do?
It's like `traverse`: you give it a function that does stuff to subterms, and it will give you one that does that to all the subterms of a particular term.
It's also usable with a lot of `lens` functions, for example, it's a `Setter` so you can write to all the targets of a `Traversal`.

Now we can write our constant folder more cleanly:

```haskell
constantFold2 :: Term -> Term
-- 'over' applies a function to all targets of an optic, we can use it with a 
-- 'Traversal' to apply the function to all of the things which it traverses 
-- (the subterms)
constantFold2 t = cf $ over termSubterms constantFold2 t
```

I think this is pretty close to our original English specification!

We can abstract this a little bit further to factor our the local part of the transformation. 
Then we get a nice little function `transformOf` which is already defined for us in `Control.Lens.Plated`.

```haskell
-- The real version is a bit more general than this
-- transformOf :: Traversal' a a -> (a -> a) -> (a -> a)
-- transformOf l f = go where go = f . over l go

constantFold3 :: Term -> Term
constantFold3 = transformOf termSubterms cf
```

## `Fold`s and mixing `Traversal`s

As a bonus, we can also do folds. For example, let's count the number of term nodes in a term.

```haskell
countTerms :: Term -> Sum Integer
countTerms t = 
    -- The number of terms is 1...
    Sum 1 
    -- ... plus the number of terms in all the subterms
    <> foldMapOf termSubterms countTerms t
```

Note that we don't need to do *any* case analysis since the algorithm happens to be completely generic over the different kinds of term.

This problem also gives us the opportunity to show off another very useful feature of `Traversal`s: we can mix and match various different `Traversal`s of the same type.
In particular, we haven't counted the *types* within our terms: if we care about the number of AST nodes then we should probably count them too!

We need a couple more traversals: one to get the types within a term, and one to get the types within a type.

```haskell
termSubtypes :: Traversal' Term Type
termSubtypes f = \case
    Lam n ty t -> Lam n <$> f ty <*> pure t 
    x -> pure x

typeSubtypes :: Traversal' Type Type
typeSubtypes f = \case
    FunType ty1 ty2 -> FunType <$> f ty1 <*> f ty2
    x -> pure x
```

Now we can say how to count the nodes in a type, and how to count the nodes in a term.
Again, this is completely generic and doesn't need to do any case analysis.

```haskell
countTypeNodes :: Type -> Sum Integer
countTypeNodes t = 
    -- The number of nodes is 1...
    Sum 1 
    -- ... plus the number of nodes in all the subtypes
    <> foldMapOf typeSubtypes countTypeNodes t

countTermNodes :: Term -> Sum Integer
countTermNodes t = 
    -- The number of nodes is 1...
    Sum 1 
    -- ... plus the number of nodes in all the subterms 
    <> foldMapOf termSubterms countTermNodes t
    -- ... plus the number of nodes in all the subtypes
    <> foldMapOf termSubtypes countTypeNodes t
```

There are a bunch of other nice tools `lens`, although as ever that depends on your willingness to wade through it.

## Addendum: why not `recursion-schemes`?

You can achieve some of these goals withe `recursion-schemes`.
The style there is to define your type as a fixpoint of a "one-level" functor.

```haskell
data Term2F a = 
    Var2F Name
    | Lam2F Name Type a
    | App2F a a
    | Plus2F a a
    | Constant2F Integer
    deriving (Functor, Foldable, Traversable)
    
type Term2 = Fix Term2F
```

Now, recursion schemes is all about folds, so we can go ahead and "fold" (`cata`) our term into another term.

```haskell
cf' :: Term2F Term2 -> Term2F Term2
cf' = \case
    Plus2F (Fix (Constant2F i1)) (Fix (Constant2F i2)) -> Constant2F (i1 + i2)
    x -> x
    
constantFold4 :: Term2 -> Term2
constantFold4 = cata (embed . cf') 
```

Also, `Term2F` *is* of the right shape for `Traversable`, so we can use `traverse` as well!

This is fine as far as it goes, but there are two major problems:
1. `recursion-schemes` does badly with mutually recursive types. If this is a problem for you, you'll realise pretty quickly.
2. `recursion-schemes` is good at dealing with the sub-parts of the *same* type, but not those of *different* types.

For example, let's try and write `countTermNodes`.

```haskell
countTermNodes2 :: Term2 -> Sum Integer
countTermNodes2 = cata f where
   f = \case
       Lam2F _ ty tc -> Sum 1 <> countTypeNodes ty <> tc
       x -> Sum 1 <> fold x
```

The normal case is similarly concise, but there's no way to handle the types generically.
So we have to do the case for `Lam` manually, and we would have to do this for every term with a type in, if we had others.

*RESPONSES*: This [post](https://oleg.fi/gists/posts/2020-08-03-mutually-recursive-traversals.html) by Oleg Grenrus tackles the mutually recursive traversals problem, and this [comment](https://www.reddit.com/r/haskell/comments/i2js6q/lenses_for_tree_traversals/g0eyfvf?utm_source=share&utm_medium=web2x&context=3) by Chris Penner gives an alternative way of doing the recursion.
