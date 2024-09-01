---
layout: post
title: LSP, the good, the bad, and the ugly
---

For a few years now I have been working on the [Haskell Language Server](https://github.com/haskell/haskell-language-server) (HLS), and the [`lsp` library](https://github.com/haskell/lsp) for the LSP protocol and writing LSP servers. 
Unsurprisingly, I have developed some opinions about the design of the LSP! 

Recently I gave a talk about HLS and LSP at the Haskell Ecosystem Workshop at Zurihac 2024.
One slide featured a hastily-written table of "LSP: the good, the bad, and the ugly".
As I gave the talk I realised that there was plenty to say on that topic, hence this post.

I will repeat this a few times, but I want to be very clear that LSP is great and I am very happy that it exists.
While this is going to be a mostly critical post, it is criticism that exists in the context of me being happy to be working on editor tooling that is going to Just Work for a wide spectrum of users!

I want to also mention the excellent [LSP could have been better](https://matklad.github.io/2023/10/12/lsp-could-have-been-better.html), which is the best critical post I've read on LSP, and inspired several of the points I'm going to make.

<!-- more -->

# The good

## It addresses the problem!

The most important things about the LSP are:
1. It exists
2. It is omnipresent
3. It works well enough 

That is, it actually succeeds in significantly addressing the problem of providing IDE tooling to a wide variety of editors at much lower cost to tooling developers.
This is huge, and not to be under-appreciated!
It now seems awful to remember the situation even a few years ago, where most open-source editors had poor and inconsistent support for most programming languages.
Now someone can write a new editor and, with a bit of work on a LSP client, come out with best-in-class programming language support.
Amazing!

## Focus on presentation over semantics

As [Alex says](https://matklad.github.io/2023/10/12/lsp-could-have-been-better.html#Focus-on-Presentation) it's a great choice for the LSP to focus on presentation, i.e. the things that actually appear in the editor, rather than the semantic structure of the program (which is wildly different from language to language).

This works pretty well, although some semantic elements have crept in over time.
For example:
- There is a "type hierarchy" request. Is this just a widget that represents a tree of arbitrary stuff that you can consider "types"? Or is there some implication that the relationship that the tree shows should be _subtyping_, making it a bit more specific to languages with inheritance? Unclear.
- There are various tags that indicate the nature of entries in e.g. completion lists, and these are usually semantic rather than presentational. For example, a completion item is tagged as _deprecated_, rather than being tagged as _non-emphasized_ or similar.

It's awkward, since obviously the appropriate editor widgets for a IDE protocol will make some references to programming language constructs!
But I think it's a good direction, I wish they'd committed even more to it.

## Backwards compatibility 

Perhaps because it is a Microsoft project, the LSP has always hewed to pretty strict backwards compatibility.
This is great for users!
It means that even older or less-maintained language servers or editors continue to pretty much just work, which is a real blessing.
I even think the "capability" model that they chose to indicate what servers and clients do support is fine.[^capability-inconsistent]

[^capability-inconsistent]: Although as usual it's wildly inconsistent, and there is no standard way to find the capabilities corresponding to a method, or to be answer the question "is this enabled?".

Occasionally backwards compatibility is not handled well. 
Take for example the [messy situation](https://github.com/microsoft/language-server-protocol/issues/1888) with configuration:
- Initially, configuration was pushed from the client to the server using the `workspace/didChangeConfiguration` notification
- Then, they added the ability for the server to pull configuration using `workspace/configuration`
- In order to keep receiving change notifications, you now have to dynamically register for `workspace/didChangeConfiguration`
- This broke old servers, which were not dynamically registering because they didn't have to before

However, I think it's pretty remarkable that this is the only real backwards compatibility break I know of!

## Machine-readable specification of types

Thank all that is holy[^dirk-the-saviour] that there is a [machine-readable specification](https://github.com/microsoft/vscode-languageserver-node/blob/main/protocol/metaModel.json) of the LSP types and methods.

[^dirk-the-saviour]: Specifically, our friend Dirk, who we will see more of later.

Is it a bit weird? 
Yes! 
Is it written in their own home-rolled format? 
Yes!
Do I care?
No!

The LSP [is massive](#massive-specification).
The Haskell implementation of the protocol, which I maintain, used to have all of those types and their serializations defined _by hand_.
This was awful, tedious, and error-prone (especially given the [weirdness of the types](#weird-types)).
It took me quite a long time, but this is now all generated, which has removed 90% of the toil from maintaining that library, and nearly eliminated bugs relating to the JSON serialization of types.[^nearly]

[^nearly]: It's "nearly" because while I think _we_ now get it right, plenty of clients get it wrong occasionally. People are particularly fond of just sending `null` occasionally instead of an empty list or an optional field which is actually non-nullable. Thanks Javascript.

## Dynamic registration

I'm just going to briefly disagree with [Alex](https://matklad.github.io/2023/10/12/lsp-could-have-been-better.html#Dynamic-Registration) here. 
Dynamic registration is good, actually.
The reason is that the LSP supports changing configuration at runtime, and that means that the server's capabilities can change at runtime.
If the user un-checks "semantic tokens" in their configuration, then the server really wants to say to the client "I can't do semantic tokens any more!". 
Otherwise the client will keep asking, and the server has to either return empty data or errors, neither of which is quite right.

It's implemented messily[^dynamic-registration-options] and is a pain to work with, but I think there's a fundamentally good idea there.

[^dynamic-registration-options]: _Why_ are the static and dynamic registration options [not always the same](https://github.com/microsoft/language-server-protocol/issues/1908)?

# The ugly

(I know, it's supposed to be "The bad" next, but I wanted to talk about the really interesting stuff first!)
    
## Not a truly open project

Given how crucial LSP has become to the open-source community, you would hope that the project itself was an open one.
Sadly this is not at all the case.

The LSP specification has, as far as I can tell, _one_ committer, Dirk Bäumer, who works for Microsoft (I assume on the VSCode team).[^dirk]
There have been many small contributions by outsiders, but nobody else has commit access.

[^dirk]: I have nothing against Dirk, in fact given how much of the specification he wrote and the fact that he added the machine-readable types, the man deserves a medal.

Major changes to the spec are driven by internal forces inside Microsoft.
For example, the latest version of the spec adds a bunch of new content for supporting notebooks.
That doesn't look to me like something the community was particularly asking for, but I guess some PM inside Microsoft decided they wanted VSCode to support it, so now it's in the spec.

There is zero open discussion of features before they are added to the spec.
Typically they are implemented in VSCode, and then the specification is updated as a _fait accompli_ to document those changes.
Implementers of open-source language servers get very influence on the development of the specification.[^dirk-again]
There is not even a [community space for implementers of language servers](https://github.com/microsoft/language-server-protocol/issues/1642) to get together and talk about the many tricky corners.

[^dirk-again]: Dirk is pretty helpful though, and does respond to tickets and review PRs. But the structural factors don't promote that, and I would rather not be reliant just on Dirk's good will!

Another consequence of the lack of openness     is that there is no forum for agreeing on extensions to the somewhat arbitrary enumerations that the LSP specification has for things like symbol types.
In _theory_ the client and the server can agree on what types they support, and then use those.
But in practice the way it ususally works is that there is a well known set of identifiers that is agreed upon outside the main specification process.
What happens in the LSP world is that we have no way of agreeing at all, so in practice the set of types that get used are exactly the ones that are in the spec.

This is not really good enough for such an important project, in my opinion.
The LSP should be an open standard, like HTTP, with an open committee that represents the large community which is invested in LSP, and can offer their insight in how to evolve it.

## Non-acknowledgment of concurrency

Here's what the specification has to say about concurrency:

> Responses to requests should be sent in roughly the same order as the requests appear on the server or client side. So for example if a server receives a `textDocument/completion` request and then a `textDocument/signatureHelp` request it will usually first return the response for the `textDocument/completion` and then the response for `textDocument/signatureHelp`.
>
> However, the server may decide to use a parallel execution strategy and may wish to return responses in a different order than the requests were received. The server may do so as long as this reordering doesn’t affect the correctness of the responses. For example, reordering the result of `textDocument/completion` and `textDocument/signatureHelp` is allowed, as each of these requests usually won’t affect the output of the other. On the other hand, the server most likely should not reorder `textDocument/definition` and `textDocument/rename` requests, since executing the latter may affect the result of the former.

This pretty much amounts to "yeah, you'll want to use concurrency, but if something weird happens that's your problem".
That's a pretty disappointing attitude.
Working out a way to make everything make sense at the protocol level in the face of concurrency is hard, but it's really necessary.

In particular, it's somewhat disingenuous to suggest that concurrent server processing is an unusual approach when the specification itself simply cannot work without it.[^concurrency]
For example:

- Requests cannot be cancelled unless the server can handle the cancellation request concurrently with processing the original request.
- Progress tracking cannot work unless the server can send notifications (_and_ in the case of `window/workDoneProgress`, send and handle responses to requests!) concurrently wit  h processing a request.

[^concurrency]: I attempted to articulate a slightly more complete version of this [here](https://github.com/haskell/lsp/issues/538#issuecomment-1875696174).

## Missing causality

As [Alex points out](https://matklad.github.io/2023/10/12/lsp-could-have-been-better.html#Causality-Casualty), the LSP has a problem accounting for causality.
In particular, both failure and asynchronous processing lead to situations where we may not be sure of the ordering of events.

Consider:
1. The client sends the server a document change notification for document D
2. The server updates its internal state (e.g. compilation results) to account for the change to D
3. The client requests code actions for D, and the server responds.

The question is: when does 2 happen in relation to 3?
- If the server fails to apply the change entirely, then 2 may not ever happen.
- If the server processes the change asynchronously but responds to the code action request before it finishes, then 2 may happen after 3.

So the client really has no idea whether or not the results it is getting are up-to-date or not.
This matters _most_ for applying text edits, which we will discuss shortly, but it's a general problem.
Contra Alex, I don't think it's enough to just avoid throwing away the causality that you get from message sequencing.
If we expect the server to process requests asynchronously, then we are inevitably going to lose this ordering, and we need something stronger.

## State synchronization

A lot of the core operations of the LSP are _state synchronization_ processes.
That is, one of the parties (server or client) has some state, and they want to keep the other party updated about what the state is.
Usually this is uni-directional -- meaning that one side is the source of truth, and the other side just needs to be updated -- but sometimes it is (or could be) bi-directional, meaning that both sides can change the state.

Here's a big table of the features in the LSP that I think are secretly just state synchronization:

| Feature             | Direction           | Dependencies      | Push/pull              | Incremental        | Filtering                 | Invalidation       |
|---------------------|---------------------|-------------------|------------------------|--------------------|---------------------------|--------------------|
| Configuration       | C to S              |                   | Push (old), pull (new) | :x:                | :heavy_check_mark:        | :x:                |
| Text documents      | C to S[^apply-edit] | Config            | Push                   | :heavy_check_mark: | :x:                       | :x:                |
| Diagnostics         | S to C              | Config, documents | Push (old), pull (new) | :x:                | :heavy_check_mark: (pull) | :x:                |
| Symbols             | S to C              | Config, documents | Pull                   | :x:                | :heavy_check_mark:        | :x:                |
| Semantic tokens     | S to C              | Config, documents | Pull                   | :heavy_check_mark: | :heavy_check_mark:        | :heavy_check_mark: |
| Progress[^progress] | S to C              |                   | Push                   | :x:                | :x:                       | :x:                |
| Code actions        | S to C              | Config, documents | Pull                   | :x:                | :heavy_check_mark:        | :x:                |
| Code lenses         | S to C              | Config, documents | Pull                   | :x:                | :heavy_check_mark:        | :heavy_check_mark: |
| Inlay hints         | S to C              | Config, documents | Pull                   | :x:                | :heavy_check_mark:        | :heavy_check_mark: |
| Inline values       | S to C              | Config, documents | Pull                   | :x:                | :heavy_check_mark:        | :heavy_check_mark: |
| Document link       | S to C              | Config, documents | Pull                   | :x:                | :heavy_check_mark:        | :x:                |
| Document highlight  | S to C              | Config, documents | Pull                   | :x:                | :heavy_check_mark:        | :x:                |
| Document colour     | S to C              | Config, documents | Pull                   | :x:                | :heavy_check_mark:        | :x:                |

[^apply-edit]: This is _mostly_ client to server, see below.

[^progress]: This one is maybe a bit controversial, but I think we can perfectly well view progress tracking as synchronizing the state of the progress from the server to the client. The interaction model is exactly the same: the producer sends a stream of updates to the consumer!

Let's talk a little about each of these columns.

**Direction** means "which direction do updates go?". 
If the server is the source of truth, then updates flow from server to client.

The LSP very much has state on both sides of the protocol.
Fortunately, it is almost always synchronized in one direction only.
The one exception to this is text document contents, because the _server_ has the ability to change the state of text documents though `workspace/applyEdit`!
This is quite interesting, and causes causality problems: the server needs to track document versions when it sends `applyEdit` messages so that the client knows whether they apply to its version of the state.
Perhaps this ad-hoc version tracking is enough, and we can just tag it on to a primarily uni-directional synchronization.
But possibly this indicates that we should be looking at text document synchronization as a truly bi-directional synchronization problem.[^crdts]

[^crdts]: Bi- or multi-directional text document synchronization is an especially well-studied problem. Lots of the literature on CRDTs and operational transforms is aimed at collaborative text editors, which are solving precisely this problem.

**Dependencies** lists _other_ pieces of state which this state depends on. The state of the diagnostics managed by the server _depends on_ the state of the text documents managed by the client. A change to the text document state may invalidate the diagnostic state, and to interpret the diagnostic state you need to know what text document state it is based on.

Dependencies complicate the causality story significantly. 
I don't know how you handle this gracefully, but I'm pretty sure that you need to.

**Push/pull** indicates whether updates are pushed from the producer to the consumer, or pulled from the consumer to the producer. 

Both methods have advantages and disadvantages:
- Push
    - Producer can ensure that the consumer gets up-to-date information promptly
    - Producer can send updates as soon as they have computed them
    - Consumer may receive updates frequently or while it is doing something else
- Pull
    - Consumer can avoid dealing with updates when they don't care about them
    - Consumer must take responsibility for ensuring they are up to date
    - Producer may need to compute updates for the client at any time
  
Over time the LSP spec has moved towards having the client be in control (i.e. push state to the server, pull state from the server).[^exceptions]
But in general it makes sense to use either method for any given kind of state.

[^exceptions]: The exceptions, for some reason, are configuration and progress, which are pulled-from-server, pushed-to-client respectively. I don't really know why.

**Incremental** indicates whether there is support for sending updates that only include what has changed since the previous update.
This is obviously useful when updates are large.
Unsurprisingly, the two features that support incremental updates are the ones that involve transferring lots of data: text document contents and semantic tokens. 

However, incremental updates are in principle useful for almost any kind of state, if the state gets big enough.

**Filtering** indicates whether or not the synchronized state can be filtered to a subset. 
Often this is done using a document and range selector to only get the state in that visible region.

Filtering is a natural way to reduce the amount of data being sent.
If you don't need the diagnostics for the whole project, then you don't have to send (and process) the diagnostics for the whole project.
Filtering works naturally with a pull-based model (since you can specify the filter when you pull), but can also work perfectly well in a push-based model: the consumer just needs to keep the producer updated about what subset of the state it is interested in.

**Invalidation** indicates whether the producer has the means to tell the consumer to invalidate any cached state it has and re-request it.
Invalidation is mostly necessary in a pull-based model, since in a push-based model the producer can usually just promptly tell the consumer what has changed.
In a pull-based model, the producer needs to be able to push a notification that tells the consumer that they can't keep using the state they currently have and must re-sync.

### Whither state synchronization?

Okay, that was a lot of dimensions to consider! There are a whole bunch of problems here:

1. The implementations of state synchronization are inconsistent between different features. 
    - Pretty much every single entry in this table is implemented completely differently.
    - Compare how delta updates are encoded in `WorkspaceEdit` versus `SemanticTokensDelta`, and how they are used!
1. The feature sets are inconsistent. 
    - Incrementality is only implemented for text document contents and semantic tokens, if you want it for a different state, you're out of luck.
1. Many methods are required. 
    - In the JSON-RPC world we need a bunch of requests for each feature in order to handle the different things we want to do.
    - Semantic tokens needs 4!
1. Dependency tracking is ad-hoc or unimplemented. 
    - This is an extended version of the [causality](#missing-causality) problem. 
    - With a few exceptions (text document versions), information about state dependencies is lost.

The other lesson is that the problem is quite complex.
There are many things we might want to do, and it's not easy to fit them all together.
As usual, I don't fault the LSP designers here: the complexity clearly emerged over time, and it's not that surprising that they didn't manage to design ahead of it.
But with the benefit of hindsight, I think we could do better.

Specifically, I think we could have a _generic_ state synchronization protocol as part of the LSP that would allow synchronizing many different kinds of state, and support _all_ of the operations listed above.
While I'm not an expert and I wouldn't want to have to draft such a thing myself[^lies], state synchronization is a well-studied problem in the academic literature, so we should be able to benefit from a lot of prior art.

[^lies]: That's a complete lie, I would love to, it sounds fun.

# The bad

This is just stuff that's kind of annoying but not a huge fundamental problem. 
There's a lot of it, though.

## Massive specification

The LSP specification is big. 
Really big.
Last time I checked it had 90 (!) methods and 407 (!!) types.
Printing it to a PDF gives you 285 pages (!!!).

This just makes it hard to understand and implement. 
Now I'm not necessarily saying that there should be fewer _features_ in the spec, but I do believe that what is there could be significantly simplified (see for example the discussion of [state synchronization](#state-synchronization)).
But it seems unlikely that we are going to get simplification, and instead we will just get an ever-increasing long tail of features.

## Backwards compatibility

Didn't I just list this under the good features? 
I did, but it's a double-edged sword. 
Being backwards compatible means keeping old features and behaviours in the spec.
This imposes a cost on implementers because they need to understand and support all variants of behaviour, or risk old language servers not working.

There is no clean solution to this.
I think the best approach is to continue trying hard to keep backwards compatibility, and then occasionally do a large break to a new "major version" that is very noticeably different.
Of course, this also has costs.[^python3]

[^python3]: See: Python 3.

## Weird types

Here is the definition of the `InitializeParams.workspaceFolders` field:
```
workspaceFolders?: WorkspaceFolder[] | null;
```

There are no fewer than _three_ empty states here:
1. The field is absent
1. The field is present, and the value is the empty list
1. The field is present, and the value is null

What is the difference between these? 
Why do we have all of them? 
How should servers interpret them?

Certainly the spec needs to tolerate missing fields in many cases for backwards compatibility reasons: a server that does not support a feature will not send messages with empty lists, it will send messages with missing fields.
But this could be handled uniformly and strictly: such fields should be missing iff the server/client states that it does not support that feature.

A lot of this is just the Typescript origin of the LSP leaking out, with it being common to allow `null` in lots of places it doesn't need to be.
At the very least, the specification should _say_ what the different cases mean, or if it's okay to treat them equivalently.[^encourage-sense]

[^encourage-sense]: Perhaps having to justify the weird types might encourage the designers to avoid them...

This combines badly with the relics left by backwards compatibility.
It can be hard to tell if a type is just strange, or whether it is the union of an old form and a new form, which both need to be supported (and are maybe equivalent or maybe not).

## Specification is imprecise and inconsistent

The LSP specification is just not very tightly written.
It leaves a lot unspecified, which is a real problem.

Importantly, while I earlier praised the LSP for [focussing on presentation](#focus-on-presentation-over-semantics)... the specification usually does not actually _specify_ the presentation.

Consider "code lenses". 
The specification for `textDocument/codeLens` says:

> A code lens represents a command that should be shown along with source text, like the number of references, a way to run tests, etc.

What does that mean? 
"A command that should be shown along with source text", shown where?

In the absence of clear direction about how a presentation feature should be implemented, most people turn to the _de facto_ reference implementation: VSCode.
VSCode implements code lenses by rendering them inline in the buffer, triggerable by clicking.

However, since the specification doesn't actually say where the code lens is supposed to be displayed, implementations can differ.
Emacs' `lsp-mode` plugin has an option to display code lenses at the _end_ of lines.
This results in odd behaviour for servers that [erroneously assumed](https://github.com/microsoft/language-server-protocol/issues/1558) that VSCode's implementation was normative.

While that example is arguably not the fault of the specification (it wasn't offering normative guidance, but I think it could have been clear about that!), the spec is riddled with details that clearly are intended to affect presentation, but it is unclear how.

For example:
- `CompletionItem`s can have `detail`, `documentation`, `labelDetails.detail`, and `labelDetails.description`. I challenge you to work out what the effect of setting these various fields is intended to be without trying it out in VSCode.
- `InlayHint`s can have a `paddingLeft` boolean field, but it is not specified how much padding to insert, or what the goal of the padding is.

Also, to be a bit petty, there are quite a few small but annoying errors of the sort that I feel would really have been caught if there was more that one person looking at the changes. 
This one tripped me up recently: _server_ capability fields are usually suffixed with "provider". But there is exactly one client capability field that is suffixed with "provider", probably just by mistake: `colorProvider`.

## Configuration model

It's a [particularly](https://github.com/microsoft/language-server-protocol/issues/972) [big](https://github.com/microsoft/language-server-protocol/issues/567) mess.
For some reason they have been reluctant to specify what the configuration methods are actually supposed to do, which led to a lot of confusion.
The configuration model is actually very simple (basically just JSON blobs that you can fetch by path prefixes), they just really need to write it down.

## Text encoding 

[Much](https://github.com/microsoft/language-server-protocol/issues/376) [ink](https://matklad.github.io/2023/10/12/lsp-could-have-been-better.html#Coordinates) has been spilled over this already.
I don't have much to add: UTF-16 was a bad choice driven by Windows, it should just have been unicode code points from the start.

## Impoverished interaction model

If you want to go outside what the LSP has built in, then you pretty much have to do it by offering code actions, or something similar.
But the interaction model for code actions is very basic: the user triggers them, and then they do something.
In particular, you can't really do the kind of multi-step operations that we're used to from fancy IDEs in the past, or even something as basic as telling the user what you're going to do and asking them to confirm before doing it.

Even the built-in refactorings have pretty simplistic interaction models, as [Alex points out](https://matklad.github.io/2023/10/12/lsp-could-have-been-better.html#Simplistic-Refactorings).

## JSON-RPC

JSON-RPC is... okay. 
It's not the best transport layer, but it's pretty simple to implement correctly and once you've done that once you're done with it.

The main problem with JSON-RPC is that it enables other problems:
    
1. The presence of unacknowledged notifications encourages loss of [causality](#missing-causality)
1. The fact that some fields can be omitted is just [annoying](https://github.com/microsoft/language-server-protocol/issues/1883) and not used in practice.

It wouldn't be my choice but I don't hate it that much.

# LSP 2.0?

Realistically, most of the complaints I have are problems for developers of language servers and clients, which is a comparatively small population compared to the number of people who use those tools.
So it is unlikely to really be a good idea to do a big re-engineering of the protocol to make it easier for implementers... and doing so would make things harder for those people in the short term as there would be a new protocol to implement.
Hence I don't hold out much hope for a big LSP 2.0.

What I _would_ like is for the spec to transition to a truly open model.
I have no idea how that would come about and I don't have the zeal to pursue it, but if it's something you're interested in, maybe drop me a line.
