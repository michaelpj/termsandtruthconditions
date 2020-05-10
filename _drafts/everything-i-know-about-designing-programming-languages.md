---
layout: post
title: Everything I know about designing programming languages
---

## Don't screw the user

(Note: if you are successfully [avoiding success](#consider-avoiding-success), this may not be an issue)

If you have users and you want to retain them, the one thing you must not do (frequently) is screw them over.

Screwing the user over can include:
- Making their code not compile
- Silently changing the behaviour of their code (really don't do this)
- Degrading the performance of their code

Users will usually accept a breakage if the previous behaviour was clearly wrong, i.e. if you can argue "your code was already broken, you just didn't know it".

Not degrading performance in particular can be tough. 
There is really no substitute for extensive testing - enlist your users to send you their [weird programs](#users-will-do-weird-things).

## Tear the bandaid off

[Don't break things](#dont-screw-the-user).
But if you do, break them as soon as possible.

Breaking changes become enormously harder the longer a feature has been in the language (and users have been [doing weird things](#users-will-do-weird-things) with it).
If you know you're going to break X, then try and do it as soon as possible.

An extreme version of this is where you know you're going to change the behaviour of X, but you don't know what the new behaviour will be.
Then I think there's a good case for just straight-up removing X before you even know what the replacement is, so long as this doesn't make things impossible.

## Avoid global anything

Global is bad. 
Global does not compose. 
Global means everything depends on it.
Avoid it unless you absolutely need it.

If I were designing a programming language today, nothing would be in scope by default, any built-ins would be behind an import.[^global-module]

[^global-module]: But then surely the builtin module must be in the global scope?
    True - even this does not fully get away from the global scope. I think the
    real bold step would be to have what would normally be builtins in a
    completely independent *package*.

## Users will do weird things

Congratultions, you've added a new feature. 
It just has this one weird case where you can do something odd with it, but nobody will do that, right?

Wrong. 
Someone will do it, and then file a bug report that it's weird. 
Or worse, nobody will tell you that they're using it, and then it will turn out that they completely rely on it behaving in that specific weird way.

## Think long-term

Programming languages are comparatively long-lived software projects, so your mistakes will haunt you *forever*.

As usual in software, "forever" means "the lifetime of this project", but for PLs that's a damn sight closer to *actually* forever.

## Code is read more often than it is written

## PL design is a HCI problem

It's tempting to think that all you really need is a simple, batch-processing compiler. 
This is certainly the easiest thing to write, but it ignores a huge part of the programming process.

Your goal as a *PL designer* is help people write programs that do what they want to do (you may have other goals as a compiler writer too!). 
That means understanding the processes that people use to make software, and how your tools fit into that.

In particular, people write software in an iterative fashion, during which their program is usually fairly "broken".
Providing feedback during this process is incredibly useful, hence, it is good if your compiler works as much as possible with "broken" code (see [error recovery](#error-recovery-is-vital)).

Despite this being an incredibly familiar use case (you, compiler writer, have you ever *written some code*?), often we still don't prioritize it!

## Always think about tooling

Do not underestimate the importance of good tooling. 
Good tooling can make a terrible language bearable, or even enjoyable (*cough* Go *cough*). 
If you have not used an IDE with reliable, cross-project rename refactoring go try one now. 
It is hard to live without once you've got used to it!

That said, good tooling can be hard to make.[^eclipse]
It's even harder to make if you haven't planned for it from the beginning!

[^eclipse]: The Eclipse Java IDE is really remarkably good. But people sometimes forget that Eclipse
    was originally developed by a commercial company with millions of dollars of expenditure. Good tooling
    doesn't "just happen".

A simple example is making sure you maintain good position information so you can give useful errors. 
A complex example is maintaining your compiler state so that you can partially invalidate it when files change and then only recompute the bits that have changed (I have done this, it makes things a lot faster!).

This also affects language design. 
When adding a feature think "will I be able to write tooling that helps the user understand how this is working?", and "does this affect the quality of existing tooling?".

For example, consider extension methods in C#. 
Without extension methods, you just need to know the type of a value in order to know what autocomplete suggestions to provide. 
Once you have extension methods, you *also* need to know all the extension methods that are in scope. 
You also have to decide if you want to offer extension methods that *aren't* in scope, but which could be imported, in order to aid discovery.[^implicits-scala]
The feature is probably still good enough that it's worth it despite the tooling complexity, but you need to think about it.

[^implicits-scala]: The same applies to the "implicit extension methods" pattern in Scala.

## Consider avoiding success 

Haskell is notorious for the unofficial motto "avoid success at all costs". 
This is given a number of glosses, but I think that "(avoid success) at all costs" (taken slightly tongue-in-cheek) can be good advice for a PL.

Users (or perhaps more accurately, users you care about) are a huge constraint on any project, because then you need to [not screw them](#dont-screw-the-user).
Not having users is a great way to avoid this, and lets you move very fast, especially in the early days.

## Removing things is hard

Once a feature is in your programming language, people will start using it. 
Once that's happened, it's very hard to remove anything without a lengthy deprecation process (remember [not to screw the user](#dont-screw-the-user)). 
Even if you think it's a bad feature and not many people are using it, you usually don't *know* that, and so you have to be careful.

If you're lucky, you may still control all the code written in your language. 
In that case you might be able to get away with changing the implementation and all the uses simultaneously.
However, if you need to be able to handle code written in old versions of your language, you may still be screwed.

# Syntax

## Syntax matters

Syntax matters. 
Often people think that syntax matters because it makes a language easier to pick up, or more familiar. 
I think this is true, but it is a relatively minor benefit.

Syntax can affect:
- [Error recovery](#error-recovery-is-vital)
- Human reader comprehension
- Human ease of writing code
- Human aesthetic experience of reading and writing code

As ever, aim for [simplicity](#simple-and-easy). 
Ideally your syntax should be consistent, and itself suggest new ways that features can be combined. 
"Hmm, X looks like Y, I wonder if I can use it in this place Y is used?" - ideally the answer should be yes.

## Claim all the keywords you will ever want

Keywords are [very useful](#error-recovery-is-vital). 
However, claiming a keyword is effectively removing that identifier from the allowed set, and [removing things is hard](#removing-things-is-hard). 
Witness e.g. Java's flailing about what keywords to use for its module syntax.

The easy way to avoid this is just to claim all the ones you think you might want early on. 
People will grumble a little that they can't use the word and you're not even using it, but you'll be grateful later.

Suggestions:
- `module`
- `import`
- `export`
- `package`
- `type`
- `class` if you're OO
- `function`

I bitterly wish we'd claimed `type` early on for QL - we ended up having to use `class` when declaring type aliases, which is ugly.

# Compiler and tooling

## Error recovery is vital

In a [realistic interactive development process](#pl-design-is-a-hci-problem), the *usual* state of a program is to be invalid. 
Often a user will want to do substantial work on a program that doesn't even parse correctly. 
It is therefore important that your tooling works as well as it can in this state.

That means:
- Parser error recovery is vital - if you can't recover from an error you will lose the rest of the file at best, and interpret it wrongly at worst.
- Your intial program analysis passes (ideally everything up to codegen) should work with incomplete programs.
- Handling programs errors should not be egregiously slow - usually it's fine to say that the error case can be slower, but ideally not too much slower here.
  
You should be wiling to make substantial sacrifices in pursuit of these goals. 
For example, in QL there are two kinds of entity which look similar, but which we can distinguish in the parser depending on context. 
However, we eventually stopped doing this and instead parsed them with the same production, fixing up the AST afterwards. 
This made the parser error recovery *significantly* better, since it was no longer context-sensitive, and made it give better errors to boot.

Here are some things that help parser error recovery specifically:
- Start syntactic forms with unique keywords.
- Use start and end delimiters.
    - These also make it possible to put things on one line, which can matter, see e.g. Python's [issues with multiline lambdas](https://softwareengineering.stackexchange.com/questions/99243/why-doesnt-python-allow-multi-line-lambdas).
    - Yes, I'm coming out in favour of braces and semicolons.
- Use a parser generator (or other tooling) with good error recovery.
- Avoid ambiguity in your grammar.

In particular, although I think it's aesthetically pleasing (which is [important](#syntax-matters)!), I have come to believe that significant whitespace is bad both for tooling and human comprehension.

Another argument for making your language easy for a computer to parse is that it makes it easier for a *human* to parse. 
Humans don't parse things by magic, and all the same markers that make it easier for a machine to be sure what's going on, or interpret a partial piece of code, also make it easier for a human to do the same. 

## Errors should be signposts

The [usual state of a program is error](#error-recovery-is-vital). 
In that state, the tooling is going to deliver a bunch of errors to the user, in addition to whatever else it does.

One thing an error can do is help the user locate themselves in the space of wrong programs. 
"My program is wrong" becomes "My program has a syntax error" or hopefully "My program is missing a semicolon here".

However, since our goal is to [help people write correct programs](#pl-design-is-a-hci-problem), ideally an error should also be a *signpost* pointing the user towards nearby correct programs.

I think there are roughly four levels of error helpfulness:
0. "error"
1. Locates the user precisely in error space
2. Extrapolates from the problem the compiler experienced to try and guess the kind of mistake the user made
3. Actively suggests fixes to the problem

Level 3 is hardly unattainable - an easy example is to try and diagnose typos by suggesting other identifiers with similar names. 

Integrating fixes with the IDE is even better. 
The Java Development Tools for Eclipse will automatically import a type if the current file is missing a type of that name and there is only one such type in the workspace (if there is more than one you can still select from a dropdown). 
If you haven't experienced this yourself, I recommend trying it, it is truly delightful.

## Have many IRs

Most PL implementers will be familiar with the idea of an "intermediate representation" (IR). 
This differs from the "surface" language in that it is usually much simpler, and is designed to make some of the compiler's jobs easier in some way.

You may well want several IRs for optimization, codegen, etc., but I would argue that you always want at *least* one.

This IR is the "core" version of your language. 
It should look like the surface language (ideally being a subset of it), but with only the features that are *essential* to your language's semantics. 
Anything which can be desugared or expressed with another language feature should be.

The advantages of having a core language are:

- It is smaller, so easier to reason about.
- It is not user-facing, so does not have to be [easy](#simple-and-easy)
    - It can be more verbose
    - It can make everything explicit
- It can often be changed without users noticing

You can usually get away with the core language being implicit, or rather a set of "core features". 
However, I recommend actually having a separate language if you can to keep yourself honest.

## Write tooling early

As well as [thining about tooling](#always-think-about-tooling), consider
actually *writing* some early. In particular, basic editor integrations will
force you to improve the quality of your tooling, *especially* if you use it
yourself.

Fortunately, these days it's easier than ever to get something basic started. I
recommend implementing a [language server
protocol](https://microsoft.github.io/language-server-protocol/) server - it has
ready-made clients for a number of editors, and you can progressively add
support for features.

# Language features
