---
layout: post
title: Roll your own stack traces
tags: [programming, haskell]
---

(This post seems almost too obvious to write, but I couldn't find any other
instances of people talking about this kind of pattern, or any libraries.
Pointers welcome!)

If you've written code in Java, Python, or some other language with ubiquitous
exceptions, then you are probably familiar with *stack traces*. Stack traces are
great for a developer because they give you more contextual information about
where in your code an error occurred, and often this can be enough to help you
pin down the bug.

But what about in Haskell?

<!-- more -->

Haskell *does* have exceptions, and they *do* now have stack traces. However,
most Haskellers frown on using exceptions for anything other than tricky IO
problems or assertion failures, since they pollute the purity of the code.
Rather, the advice is to return an `Either` (or, getting a bit fancier, use
`MonadError` from `mtl`). 

But using this approach gives you no contextual information at all! The error
value which you return is created at the site of the error and then
short-circuited all the way back up to the top level, with no additional
information added.

Here's a small example, with a little arithmetic expression evaluator that can
throw divide-by-zero errors

```haskell
{-# LANGUAGE FlexibleContexts #-}
import Control.Monad.Except

data Expr = Const Int | Plus Expr Expr | Minus Expr Expr | Div Expr Expr

instance Show Expr where
    show (Const i) = show i
    show (Plus e1 e2) = "(" ++ (show e1) ++ " + " ++ (show e2) ++ ")"
    show (Minus e1 e2) = "(" ++ (show e1) ++ " - " ++ (show e2) ++ ")"
    show (Div e1 e2) = "(" ++ (show e1) ++ " / " ++ (show e2) ++ ")"

data Error = DivByZeroError

instance Show Error where
    show DivByZeroError = "division by zero"

eval :: (MonadError Error m) => Expr -> m Int
eval e = case e of 
    Const i -> pure i
    e@(Plus e1 e2) -> (+) <$> eval e1 <*> eval e2
    e@(Minus e1 e2) -> (-) <$> eval e1 <*> eval e2
    e@(Div e1 e2) -> do
        e1' <- eval e1
        e2' <- eval e2
        when (e2' == 0) $ throwError DivByZeroError
        pure $ e1' `div` e2'
```

We're going to feed this an expression with a division by zero, but with two 
slightly obfuscated divisions in it, so it's not immediately obvious which one 
is responsible for the error. This is exactly the sort of situation where a
stack trace is useful!


```haskell
printEval :: Expr -> IO ()
printEval = putStrLn . either show show . runExcept . eval

main = printEval $
      ((Const 1) `Div` ((Const 1) `Minus` (Const 1)))
      `Plus`
      ((Const 2) `Div` ((Const 1) `Plus` (Const 2)))
```

As we expect, we get a rather unhelpful error:
```
division by zero
```

What to do? Well, we're not devoid of tools. In particular, `catchError` allows
us to catch an error and rethrow a new one. We can use this to roll our own
contextual error enhancement:

```haskell
data Error = DivByZeroError 
           | Context String Error

instance Show Error where
    show DivByZeroError = "division by zero"
    show (Context c e) = c ++ "\n" ++ (show e)
    
eval :: (MonadError Error m) => Expr -> m Int
eval e = (case e of 
    Const i -> pure i
    e@(Plus e1 e2) -> (+) <$> eval e1 <*> eval e2
    e@(Minus e1 e2) -> (-) <$> eval e1 <*> eval e2
    e@(Div e1 e2) -> do
        e1' <- eval e1
        e2' <- eval e2
        when (e2' == 0) $ throwError DivByZeroError
        pure $ e1' `div` e2')
    `catchError` (\err -> throwError $ Context ("evaluating " ++ (show e)) err)
```

Here we're using `catchError` to catch any errors thrown by `eval`, wrap them in
a new error (it has to be of the same type, hence why we need a new `Error`
constructor), and then rethrow them.[^abstract]

[^abstract]: We could abstract this a little more. Introducing a wrapper for
    errors with context and writing some common context-adding functions might
    be worth it. 

Running our program again, we now get something more helpful:
```
evaluating ((1 / (1 - 1)) + (2 / (1 + 2)))
evaluating (1 / (1 - 1))
division by zero
```

So we can see which expression is the problematic one. 

Now, it's not really fair to call this a "stack trace": it's more of a "context
trace", and we have to put all the information in ourselves. So it's less useful
for the case where something fails in a way you hadn't anticipated, but it's
still very useful for cases where you're expecting errors.


