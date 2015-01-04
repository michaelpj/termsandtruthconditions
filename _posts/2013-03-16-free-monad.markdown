---
layout: post
title: "Using the Free Monad to Avoid Stack Overflows in Scala"
date: 2013-03-16 13:10
comments: true
categories: [Scala, programming] 
---

_The code for this post can be downloaded [here](https://github.com/michaelpj/free-monad)._

One of the joys of Scala is actually being able to code in a much more functional style than you can in Java. But inevitably as you start down that route you start using the machinery of advanced functional programming: monads, monad transformers and their ilk.

So it's a bit of a shock when what looks like some perfectly innocent code stack overflows in your face.

<!-- more -->

## A simple example ##

``` scala
def naive = {
  val foo: Reader[Int, Seq[Int]] = for {
    x <- (1 to 3000).toList.map(_ => Reader[Int, Int](identity)).sequenceU
  } yield x

  foo(1).sum
}

```

This is similar to the situation where I first observed the problem: imagine you want to manage access to a connection with Reader, so you map over a list of "things to do", giving you a list of Readers, which you sequence and then feed in the connection. In this case the "thing to do" is trivial: just return what you got. And then I add them up, just so you can add this to your list of "stupid ways to get the length of a list".

Okay, that's pretty bad, what's going on here? The problem is that we're building up a big Reader object (and a Reader is just a function, remember), which we only actually _execute_ at the end. And the way sequence works means we end up building a huge stack of functions (proportional to the length of the list!), and so when we run them we stack overflow.

### Uh oh ###

This is bad. We _really_ don't want to have to break out of monadic style arbitrarily where we're worried that we might end up processing a lot of data. And we just generally don't want our programs to die depending on the length of the data involved!

(Yes, we'd be okay if the Scala compiler had better tail-call optimization, but at the moment it only optimizes self-recursive calls, which isn't quite what's going on here.) 

### A solution? ### 

I actually hit this problem at work, and I popped into the #scalaz IRC room to seek help. Naturally, what I got was a somewhat cryptic comment from Tony Morris that "the Free monad" was what I needed, but this was enough to put me on the trail. And yes, it does solve our problem, but as ever, it's no fun if we don't delve into the theory for a bit. So humour me for a while (or you can skip ahead to the bit where I tell you how to [fix the problem](#solution)).

## Category theory time ##

Yep, as ever, the terminology leads us smack bang into category theory territory. I'm going to assume a bit more knowledge this time, if you're not familiar with the basics up to functors (and how they relate to Scala), then you might want to brush up now. I explain the basics in a [previous post](http://www.termsandtruthconditions.com/blog/2012/12/29/covariance-and-contravariance-in-scala/) as well.

Free functors, loosely, are functors from one category to another that add "as little structure as possible". For example, the free monoid functor, \\(F\_{Mon}: \mathbf{Set} \rightarrow \mathbf{Mon}\\), is the functor that takes a set of elements to the "list monoid" on that set. We all know that list is a monoid:

- Singleton sets are the basic elements.
- The monoid operation is appending sets.
- The zero of the monoid operation is the empty set.

But in a sense list is "the most basic" monoid. You can describe stuff that happens in any monoid in terms of a list of the elements involved and the "real" monoid operation: you just fold the operation over the list! A list just, well, lists the elements that were put together but "doesn't decide" which operation to use to put them together. And that's the sense in which lists are the free monoids over sets.

### Freedom and Forgetfulness ###

We can pin down what a free functor has to do a bit more precisely, however. Free functors have a relationship with another kind of functor: forgetful functors. The forgetful functor is really boring: it just takes an object and "forgets" some of its structure. So the forgetful functor \\(U\_{Mon}: \mathbf{Mon} \rightarrow \mathbf{Set}\\) just takes a monoid and gives you the set of its elements. It "forgets" that there was an operation on them.

The final concept we need is that of two functors being "adjoint". This is a bit of a complicated one, but given \\(F: \mathcal{C} \rightarrow \mathcal{D}\\) and \\(G: \mathcal{D} \rightarrow \mathcal{C}\\), we say that \\(F\\) is left-adjoint to \\(G\\) (or vice versa with "right adjoint") if there is a bijection \\(Hom(X, FY) \cong Hom(GX, Y)\\) for any X and Y.[^natural]

[^natural]: Technically, these bijections have to be "natural", which really means "behave sensibly", so don't worry about that.

That's a bit of a lot to take in, so let's do an example. Free functors are _left adjoint_ to forgetful functors! And we actually demonstrated (most of) that bijection earlier: given a set X, and a monoid Y, if there's a function from X to the set of elements of Y (i.e. \\(g: X \rightarrow U\_{Mon}Y\\), then we can make a function \\(f: Free\_{Mon}X \rightarrow Y\\) by doing (in pseudocode) \\(\lambda x \rightarrow x.map(g).fold(mzero\_{Y})(mappend\_{Y})\\).

That's just like what we described before - going from lists to any monoid by folding, it's just that this time we don't assume that the list monoid and the other monoid have to have the same basic elements: just so long as we've got a mapping between them, we're fine.[^exercise]

[^exercise]: Also, the adjunction requires a bijection, and I've only shown one direction. The reverse is left as an exercise for the reader.

## Back to monads ##

Okay, so much for monoids, what about _monads_? Monads are already functors, what's our free functor going to be, a functor functor?

Damn straight.

This isn't actually scary at all, it's just like saying that we have a type-constructor that takes a type parameter that's _itself_ a type-constructor. We actually do this all the time, but the way we write it in Scala is to write our type parameter as ```F[_]```, indicating that it itself has a "hole" for a type parameter. In this case, we're going to have two type parameters as we still want to parametrize over our "base" type. So in Scala we'd have something like:

``` scala
case class FunctorFunctor[F[_], A]
```

In the case of our free monad functor, we're going to claim that, given a functor ```F```, it's going to give us a monad in the remaining parameter ```A```.

### The free monad ###

Okay, so what should a free monad look like? It's actually not too difficult to puzzle out. Suppose we have a functor ```F``` and we want to make a monad just from that functor. Well, let's start by just using our functor. As a first bash:

``` scala
case class Free[S[_], A](run: S[A])(implicit F: Functor[S]) {
    def map[B](f: A => B) : Free[F, B] = 
        F.map(this)(f)
}
```

We've got a functor, might as well use it.

Flatmap is a bit harder. In fact, let's just think about flatten/join (remember, you just need to define one or the other to have a monad). How on earth are we going to turn a ```Free[S, Free[S, A]]``` into a ```Free[S, A]```? We've just got nothing to work with.

Okay, so we're going to need to define our Free functor a bit differently. We can do whatever we like, though, so what would make it work? Well, how about if a ```Free[S, Free[S, A]]``` just _was_ a ```Free[S, A]```?

``` scala
sealed trait Freee[S[+_], +A]
case class Return[S[+_]: Functor, +A](run: A) extends Freee[S, A]
case class Roll[S[+_]: Functor, +A](run: S[Freee[S, A]]) extends Freee[S, A]
```

Let's run with this for a bit. We're going to define our own Free monad[^stolen], imaginatively named ```Freee``` (to avoid name collisions with Scalaz's Free), as the union of several cases, so we do that with a sealed abstract trait and some case classes that extend it. Also, in order to do some stuff with partially applying type constructors, I'm going to start using the super-ugly ["type-lambda"](http://stackoverflow.com/questions/8736164/what-are-type-lambdas-in-scala-and-what-are-their-benefits) trick.

[^stolen]: By "our own", I mean blatantly stolen from the Haskell implementation, with the main source for my plagiarism being this excellent [SO answer](http://stackoverflow.com/questions/13352205/what-are-free-monads).

So we've got a case for just putting a thing in there straight (```Return```), and then we can have things that are examples of our functor wrapping something else. Which might itself be just a wrapped value (a ```Return```), or it might be another thing wrapped in a functor (a ```Roll```). This is a bit weird, since it's kind of recursive, but it solves our flattening problem: we don't flatten, we just declare that we've got an instance of ```Roll``` and we're done!

Also, this isn't actually that odd. Consider the recursive definition of a list (this isn't exactly how it's done in scala, but near enough):

``` scala
sealed trait List[A]
case class Nil[A] extends List[A]
case class Cons[A](head: A, tail: List[A]) extends List[A]
```

This is actually very similar to our definition of ```Freee```! Which isn't super surprising, given that ```List``` is a free functor itself.[^impl]

[^impl]: In fact, we can write ```List``` using the Free monad as follows:

    ```type List2[A] = Freee[({type f[+x] = (A, x)})#f, Unit]```

    This is actually a bit different from the usual list, as ```join``` will act as concatenation, instead of flattening.

Okay, let's go ahead and actually define the Monad instance for ```Freee```:

``` scala
// type-lambda mess to deal with the fact that we want a monad
// in Freee's second type parameter
implicit def FreeeMonad[S[+_]: Functor]: Monad[({ type f[x] = Freee[S, x] })#f] =
  new Monad[({ type f[x] = Freee[S, x] })#f] {
  
  // just stick it in a Return
    def point[A](a: => A) = Return(a)
    
    override def map[A, B](a: Freee[S, A])(f: A => B): Freee[S, B] = a match {
      case Return(b) => Return(f(b))
      // use the implicit functor we have for S to map over the outer S, then
      // recursively call ourselves on the inner Freee
      case Roll(b) => Roll(b.map(map(_)(f)))
    }

    override def join[A](a: Freee[S, Freee[S, A]]): Freee[S, A] = a match {
      // the outer Freee can be either a Return or a Roll
      // b has type Freee[S, A]
      case Return(b) => b
      // b has type S[Freee[S, Freee[S,A]]], so we use the implicit functor
      // to map over the S, and then use our own map to call flatten recursively
      // inside
      case Roll(b) => Roll(b.map(join(_)))
    }
    
    // scalaz wants this for a Monad instance
    def bind[A, B](fa: Freee[S, A])(f: A => Freee[S, B]): Freee[S, B] = 
      join(map(fa)(f))
  }

def liftFreee[S[+_]: Functor, A](a: S[A]): Freee[S, A] = 
  Roll(a.map(Return(_)))

def foldFreee[S[+_]: Functor, A](a: Freee[S,A])(f: S[A] => A): A = a match {
  case Return(b) => b
  case Roll(b) => f(b.map(foldFreee(_)(f)))
}

```

Hopefully that all makes some sense: we're really just propagating the maps and joins down our list of functors until we hit a ```Return``` and we can do the obvious thing.

I've thrown in a couple of other useful functions in there as well: ```liftFree``` is like taking ```x``` to ```[x]```, and ```foldFree``` is, well, like the folding operation I described. Since the free monad doesn't actually _do_ anything, just makes a big list of all the functors you've stacked up, ```foldFree``` takes a way to to "get out" of your functor and then just works it's way down the list. (In the scalaz version, this function is called "go"). 

### Cool stuff ###

Free monads are pretty cool, because of the properties that come from them being an adjunction, particuarly the "folding" property. That means that you can define a functor that represents stuff that you want to do, wrap it in a free monad, and end up with functions that you can use in monadic style and which produce a kind of "program". That is, it just _lists_ all the things that you've put together, but you can then "interpret" the program by folding over it with an interpreter that takes your functor objects and _does_ something with them.

Again, this is all pretty reasonable when we think about our definition and the similarity to lists: the free monad doesn't actually _do_ anything, it just builds up a "list" of all the functors you've stuck on, and then you have to come along and provide it with a way to actually flatten all those functors -- maybe doing something along the way. And that's what ```foldFree``` does for us.

This is really powerful, and it's particularly cool because you can easily stick on different interpreters, say adding on the possibility of executing your "program" in a concurrent fashion.[^more]

[^more]: If you're interested in this kind of thing, [this](http://www.haskellforall.com/2012/06/you-could-have-invented-free-monads.html) is an excellent discussion of free monads in the context of interpreters.

## Return to the stack ##

This is all well and good, but how does it help us with our stack problems? Well, the answer is that it doesn't directly, but in scalaz the implementation of the free monad has two useful properties:

1. It is a proper implementation of the free monad, so we can do all the stuff we've been talking about with it.
2. It implements ```flatMap``` by returning continuation _objects_, thus effectively transferring the execution stack instead to the _heap_, and cleverly ensuring that the evaluation remains tail-recursive.

These are really two distinct things, but they go nicely together precisely because the free monad provides so little structure. This makes it easy to bolt on when you really want property 2!

The idea for this comes from Runar's excellent paper [Stackless Scala with Free Monads](http://days2012.scala-lang.org/sites/days2012/files/bjarnason_trampolines.pdf). It's well worth a read: he generalises the idea of a "trampoline" and shows that you end up with... the free monad! A trampoline is essentially just a free monad where the "suspension functor" is a ```Function0```, i.e. a no-arguments continuation. But if you generalise this to allow other suspension functors, you get the free monad. Plus, with a little messing around you can do the whole thing without making any non-tail-recusive calls. Awesome!

(I'm not going to go into the details of how this works, as Runar's paper does a better job than I would (and this post is already far too long!). There are a few clever tricks, but if you've made it through this post, you should have all the conceptual machinery you need.)

The scalaz implementation, then, is a bit different from the one we derived above. In particular, there are a few naming differences:

- ```Roll``` becomes ```Suspend```
- ```foldFree``` becomes ```go```

The rest is mostly machinery around making property 2 work, but most of it gets explained in Runar's paper.

<a name="solution"/>

### A heap of Readers ##

So, let's refactor our original problem case to use the scalaz's ```Free```.

``` scala 
// type alias for Free partially applied to Id
type FreeId[+A] = Free[Id, A]
// type alias for ReaderT on top of FreeId
type FreeReader[A, B] = ReaderT[FreeId, A, B]
object FreeReader {
  // convenience method for making FreeReaders, analagous to the apply method on
  // Reader. The kleisli is due to the fact that Readers are implemented as 
  // Kleislis (functions A => M[B]) in scalaz
  def apply[A, B](f: A => B) : FreeReader[A, B] = kleisli(f(_).point[FreeId])
}

def free = {
  val foo: FreeReader[Int, Seq[Int]] = for {
    x <- (1 to 3000).toList.map(_ => FreeReader[Int, Int](identity)).sequenceU
  } yield x
  
  // after running our reader we need to get out of Free, which we do by using 
  // "go", which is foldFree. Getting out of our suspension functor is trivial
  // (it's Id!), so we formally use the copoint method
  println(foo(1).go(_.copoint).sum)
}

```

There are a few things going on here.

1. We're stacking monads on top of each other, so we're going to need to start using monad transformers. If you're not familiar with them, they're not too scary: they're really just monads wrapping other monads with all the plumbing handled for you.[^subtle]
2. We're not interested in using the interpreter-like properties of the free monad, we're pretty much just using it for property 2 above, so we're just going to us ```Id``` as our "suspension" functor.
3. We have to do a little bit of a dance to get in and out of ```Free```: we have to point the output of our Reader functions into ```FreeId``` and then (trivially) fold the whole thing down at the end using ```go```.

[^subtle]: One subtlety is that they often appear to be "inside out" -- that is, a ```FooT[BarT[Baz]]``` is sometimes really a ```Foo``` wrapped in a ```Bar``` wrapped in a ```Baz```, which is the opposite to how it appears.

And that's it! You can make the list as long as you want now, and you won't hit stack overflow errors (well, unless it's so long you OOM, but that's not really fair). This _does_ mean you'll take a performance/memory hit, as you're trading stack space for heap space, which both means that it's not as optimised for what we're doing, and, you know, you use up heap space. From a code point of view, the main cost you bear is having to switch over to using monad transformers, even if you only had one in play to begin with. This can be alleviated with some sensible type aliases, but it does make things conceptually more complicated. There is also the cost of having to get in and out of ```Free```, but this should be fairly localised and can be hidden with some sensible methods.

Boom. No more stack overflows.
