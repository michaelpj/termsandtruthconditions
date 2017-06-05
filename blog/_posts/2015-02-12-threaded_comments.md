---
title: Threaded comments
layout: post
tags: [rant]
date: 2015-02-12 21:16

---

Why are many threaded comment systems so bad? It seems pretty clear to me that
you need a couple of things to have a workable threaded comment system:

1. The ability to present long sequences of replies in a readable fashion.
2. The ability to collapse comment threads.

If you lack either of these, comments threads become horrific if you accumulate
more than a few comments. As an example of abject failure, consider the comments 
on Wordpress blogs.[^example]

[^example]: If you're looking for an example, have a look at any of the
    posts on the rather wonderful [Slate Star Codex](http://slatestarcodex.com),
    which always generate a lot of comment.

You can have precisely three replies in sequence before all comments are shown
at the same level (destroying the replied-to relationship), and comments are
squashed to fit into ever-smaller portions of the blog's column-width, which
makes long chains of replies truly *long* in terms of how far you have to scroll
to get past them.

<!-- more -->

This excacerbates the latter problem. If you've decided you're not interested
in a thread, there's no way to collapse them, and so you're left to scroll
furiously, while keeping an eye out for a break in the rightward march that
signifies a new thread. It's also very difficult to get context for a comment
that appears after a long sequence above it - which comment was it replying to?
That suggests that you probably need a way to collapse the thread *above* a
comment, a feature which I've never seen anywhere.

The site I've seen which comes closest to doing this right is probably Reddit:
you can collapse threads; and if a series of replies becomes too long, it gives
you a link to continue it in a new window.[^ergonomics]

[^ergonomics]: This still seems kind of a pain, but I haven't thought of a more
    ergonomic way of doing it.

Arguably, if you're generating the kind of discussion that SSC gets, then what
you need is a forum, not a comment thread. But most forums don't actually have
threaded comments (except Reddit), although they *do* tend to have much wider
text areas, which mitigates some of the problems.

Anyway, Disqus comments seem to be reasonably okay for small volumes of
comments, but I'm just surprised that this problem isn't solved well more often.
