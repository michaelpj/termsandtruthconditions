---
layout: post
title: Lenses for Tree Traversals Redux
tags:
- programming
- haskell
date: 2022-06-12 20:59 +0100
---
[Previously]({% post_url 2020-08-02-lenses-for-tree-traversals %}) I wrote about how you can use explicit `Traversal`s from `lens` to simplify some aspects of tree manipulation.
I recently had another win using this, so here's another case study!
It also provides a better example for when you want to fold over things than the previous post had.

<!-- more -->

Same setup:

```haskell
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE DeriveTraversable #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE TemplateHaskell #-}
module LensesForTreeTraversalsRedux where
import Control.Lens
import Data.Maybe (fromMaybe)
import qualified Data.Set as S
import Data.Set.Lens (setOf)
import qualified Data.MultiSet as MS

type Name = String

data Type = IntegerType | FunType Type Type

data Term = 
    Var Name
    | Lam Name Type Term
    | App Term Term
    | Plus Term Term
    | Constant Integer

-- We defined this last time, but we'll want it again.
termSubterms :: Traversal' Term Term
termSubterms f = \case
    Lam n ty t -> Lam n ty <$> f t 
    App t1 t2 -> App <$> f t1 <*> f t2
    Plus t1 t2 -> Plus <$> f t1 <*> f t2
    x -> pure x
```

## Traversing free variables

I noticed that we had a free-variable function that produced a set of free variables, like so:

```haskell
freeVarsSet :: Term -> S.Set Name
freeVarsSet = go mempty
  where
    -- Use a set to keep track of the bound names as we recurse
    go bound = \case
      Var n -> if n `S.member` bound then mempty else S.singleton n
      Lam n _ t -> go (S.insert n bound) t
      App t1 t2 -> go bound t1 <> go bound t2
      Plus t1 t2 -> go bound t1 <> go bound t2
      Constant _ -> mempty
```

This is perfectly fine, except I found myself wanting occurrence counts, that is, I wanted a *multiset* not a set.
It's easy enough to write the corresponding function to produce a multiset, or to modify the existing one (we can throw away the counts to get a set), but it seems like there should be some common logic here.
Really what I want is to have a `Fold` over the free variables.
Then I can use the `Fold` to get a set or a multiset or whatever!

How do you write a custom `Fold`?
I'm never really sure with custom optics so I just default to writing them explicitly as function-transformers.
In this case that works out well, since we want to continue passing down the set of bound variables explicitly as we recurse.[^1]

[^1]: Isn't this secretly running in `ReaderT f (Set Name)`? Yes, and you *can* make that work out... but I couldn't work out how to do it *simply*, so in this case I just stuck with a boring function argument.

```haskell
freeVars = go mempty 
  where
    go bound f = \case
      Var n -> Var <$> (if n `S.member` bound then pure n else f n)
      Lam n ty t -> Lam n ty <$> go (S.insert n bound) f t 
      -- This is a bit clever: we can reuse our existing subterm 
      -- traversal to cover the boring cases generically!
      t -> (termSubterms . go bound) f t
```

Okay, so this should be a `Fold`, right?
In fact, we accidentally did better, its a `Traversal` (we'll use that fact in a bit)!

```haskell
freeVars :: Traversal' Term Name
```

Now we can write our free variable accumulations very easily.

```haskell
-- copied from the definition of 'setOf', it's identical just with a
-- different 'singleton'
-- | Create a 'MultiSet' from a 'Getter', 'Fold', etc.
multiSetOf :: Getting (MS.MultiSet a) s a -> s -> MS.MultiSet a
multiSetOf l = views l MS.singleton

freeVarsSet' :: Term -> S.Set Name
freeVarsSet' = setOf freeVars
freeVarsMultiSet :: Term -> MS.MultiSet Name
freeVarsMultiSet = multiSetOf freeVars
```

## Naive substitution for free

The fact that we have a `Traversal` means that we can do more than just fold, we can *modify* the targets of the traversal.
The obvious example that jumped out at me for a free variable traversal was naive (i.e. not capture-avoiding) substitution.
That's a process that takes every free variable occurrence, and replaces it with some new term.

However, what we have won't quite work there, because `freeVars` focuses on the `Name`s themselves, and that's not what we want to modify.
We need to focus on the corresponding `Term`s.

```haskell
freeVars' :: Traversal' Term Term
freeVars' = go mempty
  where
    go bound f = \case
      -- This time we apply `f` to the node itself, not the name
      v@(Var n) -> if n `S.member` bound then pure v else f v
      Lam n ty t -> Lam n ty <$> go (S.insert n bound) f t 
      t -> (termSubterms . go bound) f t

-- Thanks to the magic of lens, we can get back our original 
-- traversal -- by composing with a prism for the constructor, 
-- so we're still able to avoid duplicating the traversal code.
makePrisms ''Term
freeVarNames :: Traversal' Term Name
freeVarNames = freeVars' . _Var
```

Now we can actually write our naive substitution function, by just saying what we want to do at each of the nodes corresponding to a free variable.

```haskell
substitute :: (Name -> Maybe Term) -> Term -> Term
substitute subst = over freeVars' $ \case
  v@(Var n) -> fromMaybe v (subst n)
  t -> t

-- Oh, you want an effectful substitution function so you can generate 
-- fresh names while substituting?
substituteM :: Applicative f => (Name -> f (Maybe Term)) -> Term -> f Term
substituteM subst = traverseOf freeVars' $ \case
  v@(Var n) -> fromMaybe v <$> subst n
  t -> pure t
```

As it turned out, I already had both of these functions in the codebase written explicitly.
So I got to delete them too.
Pretty neat.

The thing I find especially cool about this is how it brings the code closer to the conceptual expression of the algorithm.
How do you do naive substitution?
You apply the substitution function to each free variable!
Lenses let us talk about 'each free variable' in a very usable way, which is nice.

