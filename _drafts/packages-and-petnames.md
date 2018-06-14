---
layout: post
title: Packages and petnames
---

[Petname systems](http://www.skyhunter.com/marcs/petnames/IntroPetNames.html)
are designed to get past "Zooko's Triangle", the observation that names
cannot generally be all of global, secure, and memorable.

<!-- more -->

# Petname systems

Petname systems begin with the notion of *keys*. A key is a secure (unforgeable),
global, but usually unmemorable name. SSH or GPG keys are good
examples of this, but arguably so are things like web URLs. Crucially, keys
don't inherently come with any knowledge about what they identify.
`www.paypal.com` strongly *hints* that it belongs to PayPal, but this should not
usually be taken as read without some other form of verification. This is much
more obvious with GPG keys, where the key itself contains no information at all.

A *nickname* is a global, memorable, but insecure name. Google acts like a
nickname system, as do other searches, package repositories, etc.

A *petname* is local (usually user-defined), secure, memorable name. It thus represents a
user's personal state of trust with respect to a particular opaque key. If Alice
sends me a GPG key for Bob, it might initially start out with the petname
"Alice's Bob", and then eventually get renamed to just "Bob" after I become more
sure that it really belongs to Bob.

A bookmark system is another example of a petname system.[^not-bidirectional]
Again, the user provides a local name that they can use, both for their own
convenience, and to represent their state of trust about the URL.

[^not-bidirectional]: Stiegler doesn't want to allow bookmark systems as
    "proper" petname systems because the user is not always presented with the
    petname wherever the entity is referred to, but I think it's interestingly
    similar enough that it deserves to be categorized as a petname system.
    
Now, let's talk about programming language package management.

# Package management

In a language package manager we typically have several ways of identifying a package:

- By URL
    - This is typically the "true" package and acts as the key.
- By a name declared in the packages's own metadata
    - This can function as a nickname, but need not be unique
- By a name used in a package database of some kind
    - This is the thing that most obviously acts as a nickname, and while it
      might be unique if there is only one package database, there can in
      practice be several.
      
But there is (as far as I know) rarely any true *petname* for a package.

Why might we want a petname for a package? Just the same reasons as normal:
security and convenience.

## Package security

Most package managers currently have you referring to packages by their
*nickname*. This is insecure - if the nickname changes in the repository, then
you will blindly start referring to the wrong package. This is not an idle
fantasy, this is more or less exactly what happened with the [leftpad fiasco](https://qz.com/646467/how-one-programmer-broke-the-internet-by-deleting-a-tiny-piece-of-code/).

And this makes perfect sense in the petname model: nicknames are good for
discovery, but after you've found what you want you should set up a personal
mapping from a petname to the real, canonical location of the package.

## Convenience and namespacing

Programming languages have to solve the problem of "how do I get program
elements from many contributors into my program without all their names
clashing?". There are a number of solutions to this:

- Everything goes into the global namespace, but you piggyback by
  convention on [an existing unique identifier
  scheme](https://en.wikipedia.org/wiki/Reverse_domain_name_notation). 
    - Java
    - dconf
- Everyting goes in the global namespace, but you can rename easily at import
  time.
    - Rust
    - Scala
    
This last one is almost a petname system, but you can have many different names
at different points in your program, and the link isn't to the "key" for the
package, so you don't get any security properties.

- Provide packages under a user-provided name by which they can be referred to
in the source.
    - Rust (`extern crate foo` uses the name and `--extern foo=/path/to/bar`
      provides the value)
    - Nix (`import <foo>` uses the name `NIX_PATh=foo=/path/to/bar` provides the
      value)

Rust's system is somewhat complex (you also have implicitly-named lookup paths
as well as explicit `--extern` arguments), but I think the `NIX_PATH` design is
pretty good: keep the familiar lookup-path pattern, but simply name the arguments.

This is most of the support we need for an actual petname system! It solves the
convenience side pretty well, but unless the package manager links up the key to
the petname directy, it doesn't gain any security properties.

Here's a design proposal for how to do that: extend the "lockfile" approach
and have the package manager config file specify nicknames (and petnames), 
which are locked down to keys when the lockfile is created. Ideally the tool 
should warn the user any time a key changes due to a lockfile update, at 
which point it can be manually verified again.

I think this has pretty much all of the convenience of current systems, with
little additional overhead. 
