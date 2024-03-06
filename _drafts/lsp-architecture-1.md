---
layout: post
title: "The architecture of a language server: non-language-specific parts"
---

I have been thinking a bunch about how to architect a language server.
This is both for [HLS](https://github.com/haskell/haskell-language-server), which I work on quite a bit, but also for other contexts.
I find it helpful to think about the parts that are mostly universal, as this makes it clearer how to design libraries such as the Haskell [`lsp`](https://github.com/haskell/lsp) library, which aims to provide generic framework for writing language servers.

The reason we can give a generic architecture is that we have certain _tasks_ that we know we need to do, and certain _constraints_.
I am going to make one assumption about the way we want to define our server, which is that we mostly want to write it as a set of _handlers_ for the different methods that the protocol defines.
What those handlers _do_ is the language-specific bit, which I'm going to leave out for now.

The tasks we need to do are:

- Read messages over whatever transport we are using 
    - This is usually stdin/stout, but in principle JSON-RPC can work over other transports
- Parse messages from JSON-RPC into whatever format we expect 
    - This is slightly non-trivial because in order to know what the structure of a response should look like, you need to know the method it corresponds to, and _JSON-RPC responses don't include the method_. So your parsing needs to refer to state that tells you the methods that correspond to requests you have sent.
- Direct messages to whatever handler expects them 
- Schedule the execution of the handler 
- Deal with the results of running the handler 
- Serialise messages into JSON-RPC
- Send messages over the transport 
- (Maybe) Handle document synchronization notifications and maintain a server-side VFS
    - This could be left to the language-specific part, but it is very generic and we might as well do it generically
- (Maybe) Handle configuration synchronization and updates
    - Ditto
- (Maybe) Handle lifecycle notifications such as `shutdown`
    - Ditto

The constraints we have are:

- The server must handle notifications in the order that it received them, because notifications can cause state modification (e.g. `textDocument/didChange`).[^notifications-should-be-request]
    - So: handling of notifications should _not_ be concurrent with handling of other notifications
- The server must be able to handle a notification that comes after a request R while still handling R, otherwise `$/cancel` cannot work.
    - So: handling of notifications must be concurrent with handling of requests
- The server must be able to send a request R2 and process the response to R2 _while_ processing an initial request R1, otherwise `window/workDoneProgress/create` cannot work.
    - So: sending of messages must be concurrent with running handlers 
    - So: reading of messages must be concurrent with running handlers (this is also good to make sure we promptly pull messages from the transport layer, which can potentially back up otherwise)
    - So: handling of responses must be concurrent with handling requests
- The server really should be able to process an additional request R2 while processing an initial request R1, since otherwise any long-running request will block all functionality.
    - So: handling of requests should be (mostly) concurrent with handling other requests
    - Possibly: the server should not reorder request handling across a notification that modifies state
- If the transport terminates then the server should terminate.
- If a handler terminates abnormally then the server should _not_ terminate (the language-specific stuff is always buggy and prone to throwing exceptions)

[^notifications-should-be-request]: This [blog post](https://matklad.github.io/2023/10/12/lsp-could-have-been-better.html#Causality-Casualty) makes a convincing case that using notifications for state changes is a fundamental mistake precisely because it makes it hard to establish causality and ordering, since the server doesn't respond to the notification to say when it's handled it.
