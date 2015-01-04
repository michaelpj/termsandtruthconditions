---
layout: post
title: "Slides for Variance talk"
date: 2013-03-06 23:30
comments: true
categories: [scala, computer science, category theory]
---

I gave my [post](/blog/2012/12/29/covariance-and-contravariance-in-scala/) as a talk at the recent [ScalaSyd](http://www.meetup.com/scalasyd/), and you can get the slides [here](/downloads/pdf/covariance-talk.pdf).

<!--more-->
As an aside, I made the somewhat hand-wavy allegation that the normal Hom-functor that we use is in some way the "right" one. I sat down to actually try to prove this, and I haven't been able to come up with anything satisfactory. On the face of it, there's no reason why there shouldn't be other functors that behave the same as the Hom-functor on objects, but do something different to the arrows. So unless there's a cunning proof that there can't be such a functor in generality, or there's an independent characterisation of the Hom-functor that I haven't thought of, I'm a bit stumped.

Ideas welcome!
