---
layout: post
title: Thoughts about defunctionalization
tags:
- haskell
- programming
date: 2024-03-11 10:05 +0000
---
_Note: this post assumes you know quite a bit about defunctionalization. If you don't read [this post](https://www.pathsensitive.com/2019/07/the-best-refactoring-youve-never-heard.html) first._

<!-- more -->

## Change of representation

Most explanations of defunctionalization focus on the fact that it turns higher-order programs into first-order programs.
I think there is another way to look at it: defunctionalization _changes the representation of closures_ in the program.
In particular, it makes their representation _visible_ in the source program. 
This opens up opportunities for optimization by both the user and the compiler.

Consider the classic example of `sum` (1):

```haskell
sum :: [Int] -> Int
sum []       = 0
sum (x : xs) = x + sum xs
```

When evaluating this version of `sum` we will build up a series of _stack frames_ which contain the `x + <result>` computations that are waiting to be applied when the recursive calls return.
Each stack frame also has a pointer to the frame above it so it knows where to return to when it is finished.
The stack is implicit: we can't see it or do anything with it.

Now we CPS-transform it (2):

```haskell
sum' :: [Int] -> (Int -> r) -> r
sum' []       k = k 0
sum' (x : xs) k = sum' xs (\y -> k (x + y))

sum :: [Int] -> Int
sum xs = sum' xs (\x -> x)
```

The function is now tail-recursive, so we don't use any stack.
Instead, we build up a series of _continuations_ (on the heap).
Each continuation is represented at runtime as a _closure_ containing the `x + <result>` computation that is waiting to be applied; or is the one representing that we are done.
Each continuation except the final one also has a pointer to the next continuation in its environment (the `y`) variable, and will use that to jump to the next continuation when it is finished.

Now we defunctionalize the continuation (3):

```haskell
data Kont = Adding Int Kont | Done

applyKont :: Kont -> Int -> Int
applyKont (Adding x k) y = applyKont k (x + y)
applyKont Done y = y

sum' :: [Int] -> Kont -> r
sum' []       k = applyKont k 0
sum' (x : xs) k = sum' xs (Adding x k)

sum :: [Int] -> Int
sum xs = sum' xs Done
```

Now we no longer create closures.
Instead we build up a series of `Kont` objects (on the heap).
The `Kont` constructors are specialized representations of the closures we had before: one represents an `x + <result>` computation, and has a pointer to the next continuation; one represents the case where we are done.

Now we optimize our representation (4):

```haskell
-- Obviously, this can now be replaced by a plain Int, giving
-- the usual accumulating solution
data Kont = Adding Int 

applyKont :: Kont -> Int -> Int
applyKont (Adding x) y = x + y

sum' :: [Int] -> Kont -> r
sum' []       k          = applyKont k 0
sum' (x : xs) (Adding y) = sum' xs (Adding (x + y))

sum :: [Int] -> Int
sum xs = sum' xs (Adding 0)
```

Now finally we no longer need to use linear space to track the pending computation, since we've realised that we can collapse the `Kont` structure.
This bit is a domain-specific optimization! 
To know that this is valid, we have to look at how `Kont` is used and be a little bit clever (or at least, I don't know a mechanical way to do this bit).

So, what happened?

Firstly, we made the continuation visible as a value. 
In version (1) we can't see the continuation structure at all; after that we can. 
This provides opportunities for optimization: we can now move the continuation around, inline it, evaluate it, etc.
This is why people say that CPS makes programs easier to optimize.
This step also moves the space usage from the stack to the heap, which can be significant.

Secondly, we changed the representation of the continuation.
(1), (2), and (3) all have fundamentally the same structure: they're a linked list of stack frames/closures/constructor objects.
But we make this structure progressively more accessible. 
The stack frame or closure structure is not directly accessible to the programmer or compiler to manipulate, it's a side effect of how the program is evaluated; whereas the datatype version is entirely transparent.
This change is what _enables_ the optimization in version (4).
We simply don't have the option of being clever with the stack frames or closure structure.

## Classifying functions

The CPS-transformed version of our function (2) has a problem: uses of the continuation are _unknown function calls_.
As far as the compiler is concerned, those `k`s could be literally anything.
In particular, it doesn't know where it is jumping to, and it may not even know the calling convention of the function (in Haskell it could be a curried lambda, or a known function with a given arity).

Looking at (3) again, it is already better.
`applyKont` is a known call, and the case expression goes to an unknown location but from a set of at most two.

Let's look at what happens if we inline `applyKont` once:

```haskell
sum' :: [Int] -> Kont -> r
sum' []       k = case k of 
  Done -> 0
  Adding x k -> applyKont k (x + 0)
sum' (x : xs) k = sum' xs (Adding x k)
```

Now we are able to do some context-sensitive optimization: in this context `y` is `0` in the second branch, so we can reduce `x+0` to just `x`.
That's trivial in this instance, but in general this means we can put the code (or all the potential code) for the continuation at the call site, which gives us much more opportunity for optimization.

This also applies to reasoning about the code.
"Defunctionalization at Work" gives two examples of proving the correctness of an algorithm, one in CPS and one defunctionalized.
The natural approach is different, but in particular for the defunctionalized version it is natural and easy to reason by cases on the continuation, because we have classified it into an exhaustive set of cases.
In contrast, for the CPS version the continuation is just a bare function, and we need to reason inductively about its properties.

Humans and computers are no different here: classifying what the continuation can actually be into smaller, well-defined subsets is helpful whatever we want to do with it.

## Scott-encoding is the refunctionalization

This is more just drawing attention to something that I think is very cool.
The inverse of defunctionalization is refunctionalization, and this is exactly Scott-encoding.[^def-at-work]
I think this makes defunctionalization seem less like a weird trick and more like an example of a fundamental correspondance of relationship between datatypes and fucntions.

[^def-at-work]: "Defunctionalization at Work" says it's Church encoding but I think this is just wrong. "Refunctionalization at Work" gets it right.
