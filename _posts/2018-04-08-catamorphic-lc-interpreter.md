---
layout: post
title: A catamorphic lambda-calculus interpreter
tags: [programming, haskell]
---

I was playing around with
[recursion-schemes](https://hackage.haskell.org/package/recursion-schemes), 
which is pretty cool. It's very
nice to be able to define interpreters like this, so my immediate thought was:
can we do this for the lambda-calculus?

Strangely, I couldn't find any examples online of lambda-calculus interpreters
written as catamorphisms, and it actually
turns out to be a little bit tricky. So here's what I came up with.

<!-- more -->

```haskell
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Lambda where

import Data.Functor.Foldable
import Control.Monad.Reader
```

Let's kick off by defining our term functor and the fixpoint type. We'll use
de-Bruijn indices for simplicity.

```haskell
data LambdaF e = Index Int | Abs e | Apply e e
  deriving (Functor)

type Lambda = Fix LambdaF
```

Now, what are we going to evaluate terms *into*? This is an important decision,
because our algebra will take a `LambdaF` with all the subterms evaluated. So
the value needs to contain everything we need to know about that subterm.

This is a bit awkward for function values. The 
[traditional](http://dev.stephendiehl.com/fun/evaluation.html) 
[thing](https://github.com/kach/haskell-lambda-calculus/blob/master/lambda.lhs) to do is to
evaluate a function term into a "closure", which includes the original *term* as
well as the captured environment. But we don't want to be carting around terms
if we can help it, and evaluating a whole term later will require calling the
*recursive* evaluation function, not our one-layer algebra.

Well, what *is* a closure? It's a kind of suspended computation, so what if we
just evaluated it *into* a suspended computation?

```haskell
data Value m where
  Num  :: Int -> Value m
  Clos :: Monad m => [Value m] -> m (Value m) -> Value m
  
instance Show (Value m) where
  show (Num i) = show i
  show (Clos _ _) = "closure"
```

Our `Clos` value constructs a closure out of a captured environment (just a list
of values, since we're using de-Bruijn indices), and a suspended computation
which will eventually produce another `Value`.

The rather unsatisfactory `Show` instance highlights one problem with this
approach - because we're representing computation values with actual *Haskell*
computations, they're difficult to introspect.

Okay, we can now write our algebra:

```haskell
type Algebra f a = f a -> a

-- specialisation of the real signature
-- cata :: Algebra f a -> Fix f -> a

-- note the weird contstraint
evalAlgebra :: (MonadReader [Value m] m) => Algebra LambdaF (m (Value m))
evalAlgebra term = case term of
  Index i -> do
    e <- ask
    pure $ e !! i
  Abs t -> do
    -- capture the environment
    e <- ask
    -- store the environment and the un-evaluated body 
    -- computation in a closure
    pure $ Clos e t
  Apply f x -> do
    -- this will cause pattern match failures if the term 
    -- isn't well-typed
    Clos ctx t <- f
    c <- x
    -- current env doesn't matter, prepend argument to 
    -- captured env and evaluate stored computation in that context
    local (\_ -> (c:ctx)) t
```

This is pretty neat - the body of an abstraction has been evaluated to a `m (Value m)`,
which we can just put into the closure value. Later, when evaluating an
application we can just fish out the monadic computation and evaluate it in the
expanded environment.

Initially I thought that I would want to write this as a [monadic
catamorphism](https://github.com/ekmett/recursion-schemes/issues/3). However,
with monadic catamorphisms the idea is that the `Traversable` constraint allows
us to automatically evaluate all the monadic computations for sub-terms before evaluating the
next level of the algebra. But this is *not* what we want, because we want to
take the *un*-evaluated computation for the body of an abstraction and save it to evaluate later in a different
environment. So we just want a normal catamorphism which computes monadic values.

We've ended up with a *weird* constraint on our `m`, though: `(MonadReader [Value m] m)`.
This is a bit tricky to satisfy, but we can just define our own recursive type:

```haskell
newtype EnvM t = EnvM { unEnv :: Reader ([Value EnvM]) t } 
  deriving (Functor, Applicative, Monad)

instance (MonadReader [Value EnvM] EnvM) where
  ask = EnvM $ ask
  local f = EnvM . local f . unEnv

eval :: Lambda -> [Value EnvM] -> Value EnvM
eval t initial = runReader (unEnv (cata evalAlgebra t)) initial
```

Aside: this is pretty unpleasant, especially having to write instances for the
new type rather than just using a generic monad transformer stack. I'd be
interested if anyone has a nicer way of doing this.

And that's more or less it, let's give it a spin.

```haskell
-- convenience constructors
index :: Int -> Lambda
index i = Fix $ Index i

abst :: Lambda -> Lambda
abst e = Fix $ Abs $ e

app :: Lambda -> Lambda -> Lambda
app e1 e2 = Fix $ Apply e1 e2

-- SKI combinators
i :: Lambda
i = abst $ index 0

k :: Lambda
k = abst $ abst $ index 1

s :: Lambda
s = abst $ abst $ abst $ 
    ((index 2) `app` (index 0)) `app` ((index 1) `app` (index 0))
```

Checking that `k` and reverse-`k` work as expected:

```
> eval (k `app` (index 1) `app` (index 0)) [Num 1, Num 2]
2
> eval (s `app` k `app` (index 1) `app` (index 0)) [Num 1, Num 2]
1
```

Overall this seems like a pretty nice approach and I'm surprised I can't find
any examples of people doing it before. There are some resemblances to HOAS, but
I think this version works more nicely with a monadic interpreter (e.g. it would
be easy to insert logging).
