---
layout: post
title: "Covariance and Contravariance in Scala"
date: 2012-12-29 15:54
comments: true
categories: [programming, Scala, category theory]
---

I spent some time trying to figure out co- and contra-variance in Scala, and it turns out to be both interesting enough to be worth blogging about, and subtle enough that doing so will test my understanding!

So, you've probably seen classes in scala that look a bit like this:

``` scala
sealed abstract class List[+A] {
    def head : A
    def ::[B >: A](x : B) : List[B] = ...
    ...
}
```

And you've probably heard that the ```+A``` means that ```A``` is a "covariant type parameter", whatever that means. And if you've tried to use classes with co- or contra-variant type parameters, you've probably run into cryptic errors about "covariant positions" and other such gibberish. Hopefully, by the end of this post, you'll have some idea what that all means.

<!-- more -->
The first thing that's going on there is that ```List``` is a "generic" type. That is, you can have lots of ```List``` types. You can have ```List[Int]```, and ```List[MyClass]``` or whatever. To put this in another way, ```List[_]``` is a _type constructor_; it's like a function that takes another concrete type and produces a new one. So if you already have a type ```X```, you can use the ```List``` type constructor to make a new type, ```List[X]```.

## A little bit of category theory ##
To get the cool stuff in all its generality, we're going to need to start thinking about things in terms of categories. Fortunately, it's pretty non-scary categories stuff. Recall that a [category](http://en.wikipedia.org/wiki/Category_%28mathematics%29) \\(\mathcal{C}\\) is just some objects and some arrows (which we usually gloss as "functions"). Arrows go from one object to another, and the only requirements for being a category are that you have some binary operation on arrows (usually glossed as "composition"), that makes new arrows that go from and to the right places; and that you have an "identity" arrow on every object that does just what you'd expect.[^categorylaws] The category we're mostly interested in is the category of _types_: types like ```Int```, ```Person```, ```Map[Foo, Bar]``` are the objects, and arrows are precisely functions.

[^categorylaws]: In full, the requirements are:

    A class of objects: \\(Obj(\mathcal{C})\\)

    For every pair of objects, a class of morphisms between them: \\(Hom(A, B)\\)

    A binary operation \\(\circ : Hom(A, B) \times Hom(B, C) \rightarrow Hom(A, C)\\) which is associative and has the identity morphism as its identity.

The other concept we're going to need is that of a [functor](http://en.wikipedia.org/wiki/Functor). A functor \\(F : \mathcal{C} \rightarrow \mathcal{D}\\) is a mapping _between_ categories. However, there's no reason you can't have functors from categories to themselves (helpfully called "endofunctors"), and those are the ones we're going to be interested in. Functors have to turn objects in the source category into objects in the target category, and they also have to turn arrows into new arrows. Again, functors have to obey certain laws, but don't worry too much about that.[^functorlaws]

[^functorlaws]: These are:

    \\(F(id_X) = id_{FX}\\)

    \\(F(f \circ g) = F(f) \circ F(g)\\)

Okay, so who cares about functors? The answer is that type constructors are basically functors on the category of types. How is that? Well, they turn types (which are our objects) into other types: check! But what about the arrows (i.e. functions). Don't functors have to map those over as well? Yes, they do, but in Scala we don't call the function that comes out of the ```List``` functor ```List[f]```, we call it ```map(f)```.[^map]

[^map]: The astute reader will have noticed that not all type constructors come with a map function. This does indeed mean that not all type constructors are functors. But pretend that they are for now.

One final concept and then I promise this will start to get relevant. Some mappings between categories look a lot like functors, except that they reverse the direction of arrows. So instead of getting \\(F(f): FX \rightarrow FY\\), you get \\(F(f): FY \rightarrow FX\\). So these got a special name, they're called _contravariant_ functors. To distiguish them, normal functors are called _covariant_ functors.

Look at that, there are those funny words again. But what on _earth_ do contravariant functors have to do with Scala?

Good question.

## Subtyping ##
The key feature of Scala, for our purposes, is that it's a language with _subtyping_. Classes (types) can be sub- or super- types of other classes. This gives us the familiar idea of a class hierarchy. Looking at it mathematically, we can say that we have a relation \\(<:\\) between types that acts as a [partial order](http://en.wikipedia.org/wiki/Partially_ordered_set#Formal_definition). Here comes neat Category Theory Trick no. 1: we can view any partially ordered set as a category! The objects are the objects, and we have an arrow \\(A \rightarrow B\\) iff \\(A <: B\\). This is a bit weird, because we're only ever going to have one arrow between objects, and they're not really "functions" any more, but all the formal machinery still works.[^po]

[^po]: Crucially, we can use the relation to give us our arrows because it's transitive, and hence composition will work properly.

Now some type constructors on this category still look like functors. They map objects to other objects, and if one of those objects is a subtype of the other, then they may or may not impose a relationship between the mapped objects.

This is where the Scala type annotations come in. When we declare ```List[+A]```, we are saying that ```List``` is covariant in the parameter ```A```.[^parameters] What that means is that it takes a type, say ```Parent```, to a new type ```List[Parent]```, and if ```Child``` is a subtype of ```Parent```, then ```List[Child]``` will be a subtype of ```List[Parent]```. If we'd declared ```List``` to be _contravariant_ (```List[-A]```), then ```List[Child]``` would be a _supertype_ of ```List[Parent]```.

[^parameters]: Yes, there can be more than one parameter. Don't worry about it for now.

There's one final possibility. Since subtyping is a partial order, we can have two types where neither one is a subtype of the other. There's no reason in principle why a type constructor ```T``` couldn't take ```Parent``` and ```Child``` to new types which were completely unrelated. In Scala, this is the case when you don't provide an annotation for the type in the declaration; such a constructor is said to be _invariant_ in that parameter. Arrays, for example, have this property.

And that, fundamentally, is it. That's what those little +s and -s on type paramters mean. You can go home now.

``` scala Covariance and contravariance in action
class GParent
class Parent extends GParent
class Child extends Parent
class Box[+A]
class Box2[-A]

def foo(x : Box[Parent]) : Box[Parent] = identity(x)
def bar(x : Box2[Parent]) : Box2[Parent] = identity(x)

foo(new Box[Child])     // success
foo(new Box[GParent])   // type error

bar(new Box2[Child])    // type error
bar(new Box2[GParent])  // success
```

## But what about those cryptic errors? ##

``` scala A cryptic error
class Box[+A] {
    def set(x : A) : Box[A]
}
// won't compile
```

You get these kinds of errors in Scala because of the subtleties of how variance relates to _functions_ (and later, methods). We can see that there's something weird going on if we look at the declaration of the Function trait:

``` scala
trait Function1[-T1, +R] {
    def apply(t : T1) : R
...
}
```

Whoa. That's pretty strange. Not only does it have two type parameters, one of them is contravariant. Weird. Let's work through this methodically.

We have ```Function1[A,B]```, which is a _type_ of one-parameter functions that go from type ```A``` to type ```B```. It can therefore be a sub- or super-type of other (function) types. For example, 

``` scala
    Function1[GParent, Child] <: Function1[Parent, Parent]
```

How do I know this? Because of the variance annotations on ```Function1```. The first parameter is contravariant, so can vary upwards, and the second parameter is covariant, so can vary downwards.

The reason why ```Function1``` behaves in this way is a bit subtle, but makes sense if you think about the way substitution has to work when you have subtyping. If you have a function from ```A``` to ```B```, what can you substitue for it? Anything you put in its place must make _fewer_ requirements on it's input type; since the function can't, for example, get away with calling a method that only exists on subtypes of ```A```. On the other hand, it must return a type at least as specialised as ```B```, since the _caller_ of the function may be expecting all the methods on ```B``` to be available.

## Function Functors ##
There's actually a nice category theory justification for why things have to be this way. In general, for any category \\(\mathcal{C}\\) we can also construct a category of the Hom-sets of \\(\mathcal{C}\\). Functions between these sets will just be higher-order functions that turn functions into different functions. There is then an obvious functor, \\(Hom(-, -)\\) that takes two objects A and B and produces \\(Hom(A, B)\\). The [Hom-functor](http://en.wikipedia.org/wiki/Hom_functor) is a bit tricky because it's a _bifunctor_: it takes two arguments. The easiest way to deal with it is to sort of "partially apply" it and look at how it behaves on each of its arguments individually.

So \\(Hom(A, -)\\) takes an object B to the set of functions from A to B. How does it act on functions? If we have a morphism \\(f:B \rightarrow B'\\) we need a function \\(Hom(A, f): Hom(A, B) \rightarrow Hom(A, B')\\). The obvious definition is

$$ Hom(A, f)(g) = f \circ g $$

That is, you do g first, to get from A to B, and then f to get from B to B'. So \\(Hom(A, -)\\) acts as a covariant functor.

On the other hand, if you try and make \\(Hom(-, B)\\) into a covariant functor, good luck! The types just don't line up if you try and do composition. What _does_ work is the following:

$$ Hom(f, B)(g) = g \circ f $$

where g is in \\(Hom(B', B)\\), rather than \\(Hom(A, B)\\). So \\(Hom(-, B)\\) acts as a contravariant functor.[^uniqueness] Which makes \\(Hom(A, B)\\) contravariant in A, and covariant in B -- just like ```Function1```![^bifunctor]

[^uniqueness]: If you're wondering whether there couldn't be some other way of mapping the functions that would work, it turns out that there can't be one that also makes the functor laws work. You can try it yourself if you don't believe me!

[^bifunctor]: We actually need to do a little bit more work to show that \\(Hom(-, -)\\) is a true bifunctor (functor on the product category), but it's not terribly interesting.

This is actually a more general result, since it applies in any category, and not just in the category of types with subtyping. Cool!

## Back to Earth ##
Okay, so functions in Scala have these weird variance properties. But from a theoretical point of view, methods are just functions, and so they ought to have the same variance properties, even though we can't see them (methods don't have a trait in Scala!). 

So we can now see why we got that cryptic compile error. We declared that ```A``` was covariant in our class, and also that ```set``` takes a parameter of type ```A```. But then, for some ```B <: A``` we could replace an instance of ```Box[A]``` with an instance of ```Box[B]```, and hence an instance of ```Box[A].set(x)``` with ```Box[B].set(x)```, where ```x:B```. But ```set[A]``` _can't_ be replaced by ```set[B]```  as an argument, for the reasons we disucussed above; at best it can be contravariant. So this would allow us to do stuff we shouldn't be able to do. Likewise, if we declared ```A``` as _contravariant_ then we would run into conflict with the _return_ type of ```set```. So it looks like we have to make ```A``` invariant.

As an aside, this is why it's an absolutely terrible idea that Java's arrays are covariant. That means that you can write code like the following:

``` java Unsound covariant arrays
Integer[] ints = [1,2]
Object[] objs = ints
objs[0] = "I'm an integer!"
```

Which will _compile_, but throw an ```ArrayStoreException``` at runtime. Nice.

Actually, we don't _have_ to make container types with an "append"-like method invariant. Scala also lets us put type bounds on things. So if we modify ```Box``` as follows:

``` scala BoundedBox
class BoundedBox[+A] {
    set[B >: A](x : B) : Box[B]
}
```

then it will compile. This ensures that the input type of the ```set``` method is properly contravariant.

And that's about it. The thing to remember with Scala is that _everything_ is a method. So if you're getting surprising variance errors, it might be that you have a sneaky method somewhere that needs a lower bound.

