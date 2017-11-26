---
layout: post
title: "Towards effective entrepreneurship: Good Technology Project post-mortem"
tags: [effective altruism]
date: 2017-11-24 22:00
---

# Introduction

This document aims to be two things: a summary of the things that we learned
from the Good Technology Project (GTP), and a post-mortem of the project itself.

I'm going to simply state my beliefs in this post, but I should clarify beforehand that
I am not very certain about these, they are my current best guesses.

# What was GTP?

GTP started in late 2015 when Richard Batty and I met up for coffee in Oxford. We ended up
talking about entrepreneurship: both Richard and I were working in software, and
we believed that entrepreneurship could provide a route to leverage our skills.
But work on the concrete problem of how to *actually do* that was frustratingly
sparse.

<!-- more -->

Once we started thinking about the area, we realised there was more to do. 
The goal of GTP became broadly to do whatever we could to "fix" technology
entrepreneurship. 
We observed that technology entrepreneurship is very powerful, and yet the
industry is not strongly incentivised to solve important problems.
While they may prioritize well when it comes to profit, they *don't* prioritize
well when it comes to impact, even when this is an explicit goal.

We gradually ramped up our work on the project: in the middle of 2016 when we
started making real progress, Richard quit his job to work part time on the GTP, supporting himself
with freelancing. I also dropped down to four days a week at work, with one day
on GTP. We continued in this way for about a year, which gave us quite a lot of
flexibility, since Richard could adjust his hours easily, and I frequently
worked Saturdays in addition to my one weekday.

Since then we tried a number of different approaches (which I'll discuss below),
before eventually stopping the project due to a combination of failure and lack
of remaining steam.

# A guiding model

Before we discuss what GTP did, I'm going to present an abstract model of how we
believe the entrepreneurship process works. The point of this is to
situate what we learned in terms of where we think it fits into the bigger picture.

## The entrepreneurship landscape

We can think of the space of potential startups as a height map over a plane.[^owen]
The plane corresponds to roughly "where" the startup is, what problem it is
solving, how it is solving it, etc. The "height" corresponds to how good the
startup is by some measure (for now we'll assume there is just one kind of
"success", and that our entrepreneurs actually care about impact as well as
profit and so will try to maximize it as best they can).

[^owen]: Thinking about our space of opportunities like a landscape to explore
    is not a new metaphor - c.f. Owen Cotton-Barratt's [EAG 2016
    talk](https://www.youtube.com/watch?v=67oL0ANDh5Y), and [other uses in the literature](https://link.springer.com/article/10.1007/s11138-015-0302-3).

Then what we want to do is to locate the highest peaks in this landscape. These
correspond to the best opportunities to get whatever it is that we want - money
and impact, in this case.

We have some broad beliefs about the landscape:
- There is a huge amount of variation globally: the highest peaks are *much*
  higher than the median.
- There is a lesser, but still substantial, amount of *local* variation: even
  within a region there is a big difference between the best and the median.
- Peaks are relatively sparse: most of the points are low.

These are based on the usual observations about the distributions of startup
earnings/impact. While a significant portion of the variance there is going to
be due to luck and other exogenous factors, I think that the most significant portion is
due to the nature of the startup in question. So these aren't entirely
uncontroversial assumptions, but I'm not going to defend them further here
simply because I don't think it's the most interesting part of this post.

### Meet the locals

Many people are trying to navigate the landscape and find peaks. Commonly these
people have an "area" of expertise in which they're much better at surveying the
landscape, and have a better ability to climb nearby hills. For example, someone
who already has experience in retail business will be better able to assess
opportunities that target retail businesses, and better able to tackle the
problems along the way to making them a success.

These "locals"" correspond to individual entrepreneurs or potential entrepreneurs,
and their situation in the landscape corresponds to their specialised knowledge,
skills or beliefs (their 
["edge"](https://medium.com/entrepreneur-first/understanding-founder-idea-fit-f16d658c0e8f),
to borrow a term from EF).

A helpful distinction that EF makes is between people with a "domain" edge
and people with a "technology" edge. This isn't a hard-and-fast distinction, but
the idea is that people with a domain edge have some advantage relating to the
problem or the business idea at hand, whereas people with a technology edge have
an advantage in some aspect of the implementation.

Since we think of startups that solve the same problem as being "close
together" in our landscape, we can think of people with a domain
edge as inhabiting a fairly compact region, whereas people with a technology
edge occupy a cross-cutting strip of the landscape. If you know about
distributed systems, then you might have an advantage in specific parts of both
financial technology and medicine. (This isn't tremendously important, but I find it
helpful to visualise the complex ways in which people's skills and knowledge
might intersect.)

### Sky high 

Far above the landscape are the "planners". The planners still want to find the
highest peaks, but they have very poor visibility of
the landscape. They may be able to tell that one area is generally hillier than
another, but little more than this. They can drop expeditions down onto the
landscape, but this is costly and is generally unlikely to land on a peak.

When we think about deliberately starting high-impact ventures, we are like the
planners. We are trying to deliberately zoom in on the peaks across the whole
landscape, even though we're not already situated in that area.

We can learn about areas in more detail, but this requires laborious research,
and even then our understanding is likely to be inferior to that of the locals.

### Implications of the landscape model

This model is generally *pessimistic* about the ability of the planners to get
to the peaks that they want to find. Because they have poor visibility into the
landscape, it is hard for them to actually explore effectively without going
through the effort of actually "becoming" a local. Most
successful startups instead come from locals who know the region, and happen to
be in the vicinity of a substantial peak.

This leaves us in the rather unsatisfying state that Julia Galef outlines in
["Can we intentionally improve the
world?"](https://juliagalef.com/2017/02/19/can-we-intentionally-improve-the-world-planners-vs-hayekians/).
Julia contrasts two approaches: the top-down approach favoured by "Planners"
(governments, foundations, effective altruists), and the bottom-up approach
favoured by "Hayekians" (entrepreneurs of various stripes).

While the Planner approach has had some success, the prevailing wisdom in modern
startup theory is that the Hayekian approach is the only viable one. Success
(as Paul Graham [argues](http://paulgraham.com/startupideas.html)) comes from 
using situated knowledge to find and solve problems that actually occur on the
ground, rather than by trying to impose a top-down plan.

I broadly agree with these conclusions, but I think there's some hope
for "hybrid" top-down/bottom-up solutions, which I'll outline later.

### How general is this model?

The landscape model seems like it is a good fit in situations where:
- There is a large space of opportunities
- The opportunities are very varied by some metric
- There are many people with strong "local" knowledge
- Local optimization is reasonable at finding nearby peaks
- Global optimization is hard, and gaining enough knowledge to do local
  optimization is also hard

This applies not only to for-profit entrepreneurship, but to other exploratory domains, including
charity entrepreneurship and perhaps even research. Exactly how hilly the
landscape is or how strong the "local" advantage is will vary, but I think it
may be a useful tool in other domains too.

# Improving entrepreneurship

So we've decided we want to improve the entrepreneurship process. What should we
try?

## Advise entrepreneurs directly

The first strategy we tried was to try and influence entrepreneurs directly.
However, since we wanted to change what projects they worked on, we needed to
get to them before they had committed to an idea. 

To that end we teamed up with [EF](https://www.joinef.com/), a startup
accelerator that takes individuals pre-idea, and helps them form teams and
generate ideas.[^influence] We pitched to the Summer 2017 EF cohort before they started,
and we got an excellent response: over 10% of the cohort said they were
interested in talking about how to have more of an impact with their startup.

[^influence]: We've become broadly convinced that EF is improving the process by
    getting involved earlier, and our startup theory has been significantly
    influenced by them.
    
However, the advice process itself was an almost total failure. There were three
main problems:

Firstly, the number one thing that entrepreneurs wanted from us was a better idea to
work on. We were simply unable to provide such ideas (or at least appropriate
ones, see the next point).

This points towards one of the features of the landscape model: it is hard for
planners to know an entrepreneur's local area even as well as the entrepreneur, let alone *better*.

Secondly, it was more or less impossible to persuade people to move towards
domains they didn't know about. EF pushes very hard to get people to embrace
their "edge", and this means that it simply isn't realistic either to get
someone who knows about medicine to look at a finance idea, nor to get someone
with flexible technical skills to work on an idea without a domain cofounder.

We think this is good advice! We looked at [50 potentially high-impact tech
companies](https://docs.google.com/spreadsheets/d/1ecr4NikKJBqtMjaLThGZ5srHzzDYU85DWEC_RnaqJgc/edit#gid=0), 
and almost all of them had a founder who had a strong background
in the area. Complete outsiders were rare.

Our observations of the cohort subsequently bore this out: everyone we knew
ended up in a team where the problem was determined by the founder with the
domain expertise.[^sparrho]

[^sparrho]: Another similar story about how 
    [Sparrho was founded](http://eastldn.co.uk/2015/06/17/the-biochemistry-of-an-entrepreneur-vivian-chan-from-sparrho/):
    “I had a great postdoctoral researcher in 
    my lab called Steve and he would spend about five or ten minutes every 
    morning reading pre-prints from journals that he thought was relevant 
    to the group. He knew what every single person was working on and he 
    could recommend serendipitous papers that you can never find using a 
    linear keyword search. Those kind of serendipitous recommendations lead to 
    innovations. When I realised and I told Nilu that I had this problem 
    and I had this great solution called Steve, Nilu’s background is machine 
    learning so he asked why don’t we digitise Steve? Instead of just one 
    person reading a couple of journals each day we now are using technology 
    to do the same for tens of millions pieces of content.”

This points to another feature of the landscape model: entrepreneurs are locally
situated by their existing background knowledge, and this is part of what lets
them do what they do. Attempts to "move" them are likely to both meet with
resistance and be ultimately counterproductive.

Finally, the number of people who were willing to actually contribute some work
towards working out how to have a higher impact was almost zero (we had only one person from
EF7 who substantially engaged). That's not to say that they didn't care about
having an impact, but merely that it wasn't a goal that could override the other
pressures on them from the EF programme.

There were many other problems with our content and the way we presented our
pitch, but these were the problems that looked like structural ones.

During this time we also developed a fair amount of object-level material about
what we think are the important factors in a high-impact startup. We presented
this in some workshops to EF participants, and at EAG Oxford 2016. This is
perhaps of interest, but it's not as relevant to the high-level picture so 
I've relegated it to a follow-up post.

### So what do we say to entrepreneurs?

From this point on we had a somewhat ambivalent relationship to individual
entrepreneurs. They tended to either be already working in broadly the right
area, in which case we had nothing further to say to them (except some general
advice about how to keep on track), or they were in an area that seemed unlikely
to be high-impact, in which case we *also* had little to say to them.

Surprisingly, the most common advice we gave after this point was "try working
or studying in an important area for a few years, then reconsider
entrepreneurship". This is particularly important for people with a technology edge, since
you want to either develop some domain edge in an important area, or find a
cofounder there. This advice wasn't generally terribly well-received - people who've got to the
point of thinking of themselves as potential entrepreneurs usually want to do
something *soon*.

### Glimmers of hope: serial entrepreneurs

By far our most successful individual advice process was with a *repeat*
entrepreneur, who had already sold his first company. This made a huge
difference: he had far more resources to deploy on the process, he had time, and
most of all he cared enough to be willing to go in for another round because he
wanted the change rather than the money.

He had a pre-existing inclination to work on climate change, but we were able to
help him narrow down the area to negative emissions technologies. I don't think
he's actually started anything yet, but perhaps it will turn out that we had an
impact there.

Possibly targeting serial entrepreneurs as a market could work. I'd be excited
to see Founders' Pledge, or someone similar, looking into this.

## Find better problems

One reason we couldn't advise entrepreneurs well was because we didn't have
*good problems* to offer them. So perhaps we could get better at that?

At a first brush, "what problem should I work on?" is a classic EA question -
isn't this just cause prioritization? However, if you look at the cause
prioritization work that we've actually done, it's all *far* too high-level to
be action-guiding if you're actually looking to do new things. Knowing that
animal welfare is high-priority is useful, but then you want to know which are
the most important parts of the problem, and then which are the most important
parts of *that* problem, until you find something you can actually tackle.

I think there are a couple of reasons why this hasn't been apparent. One is
simply that EAs haven't focussed on doing this kind of prioritization before.
We have something to say to donors, early-career employees, and perhaps even
later-career employees; but the "explorer" is a comparatively new personality
for us. 

Another reason is that EAs have often operated in an evaluating capacity. 
If you are being trying to find the best donation opportunity, you are in the
position of evaluating an discrete set of existing opportunities (the thing has
to be established enough that you can donate to it!). If you are being presented 
with existing ideas in this way and need to evaluate them, you can use a coarse 
cause prioritization as an initial filter
and then move on to more laborious methods. However, if you're looking for *new*
ideas, then initially filtering down to a priority cause helps, but still
leaves far too much work for an individual to realistically do.

So what we need is much more granular cause prioritization, ideally right down
to the size of a problem that can be worked on by an individual or
team.[^inspiration]

[^inspiration]: Some inspirations: Brett Victor's ["tools for
    problem-finding"](http://worrydream.com/ClimateChange/#tools-finding); the
    amazing [Global Burden of Disease
    visualizations](https://vizhub.healthdata.org/gbd-compare/); MIRI's
    [research agendas](http://intelligence.org/files/TechnicalAgenda.pdf).

The most ambitious version of this might look like an atlas of the world's
problems, broken down by subproblems, and prioritized as best we can. This could
be useful both for people working on solving problems, and also for establishing
common vocabulary about just what they *are*. For example, Amodel et al's ["Concrete Problems
in AI Safety"](https://arxiv.org/abs/1606.06565) paper did wonders for 
just clarifying *what* the problems are, and was
generally regarded as a very useful contribution for that reason.

Nice as this vision is, it number of problems:
- It would be a hilariously enormous amount of work to create and maintain.
- It's not clear that it's possible to nicely break down problems in this way.
- It's unclear how the prioritization would work, or who would do it.

I [pitched](https://docs.google.com/document/d/17M--h_p73ARL3_keji53O3gHka4xPYrwE2Zp8GEobPM/edit?usp=sharing) 
this idea to a few people and got some interest, but I never took it very far. I
still think it could be valuable, and a reasonable MVP would be a thin,
"vertical", slice through a domain. I think health would be a good area for
this, in that much of the needed material is already present. Indeed, I think this is one of the reasons that
[Charity Entrepreneurship](http://www.charityentrepreneurship.com/) 
has made so much progress with the top-down approach in health.
    
The existence of this problem and the difficulty of solving it also supports the
landscape model, since it illustrates the problems that the planners have in
understanding the landscape in enough detail to make decisions.
    
## Institutional solutions

If we can't do much with individual entrepreneurs, perhaps we can achieve more
by targeting the institutions that play a role in the entrepreneurship process.

There are *a priori* reasons to think this might be a good strategy.
Institutions already show signs of being more goal-driven and prioritizing than
entrepreneurs: while entrepreneurs may be fixed on a particular idea or area,
[VCs operate more like
experimenters](http://pubs.aeaweb.org/doi/pdfplus/10.1257/jep.28.3.25), looking
for promising areas and picking startups to fund as "trials". So if there is
already strategic thought going on at this level, we might be able to influence it.

One way in which startup accelerators and incubators in particular can affect
the process is by changing the mix of people who become entrepreneurs. So the
following idea suggests itself: pick an important area, and then bias recruitment
towards people who *already* have the skills and inclination to work in that
area (for example, you might recruit epidemiologists, development economists, and
doctors, as well as technologists). If we can't win a hand, perhaps we can stack the deck.

A minimal institutional solution would be to find an institution like EF and
persuade them to let us bias their intake in this way. In practice, this is a
difficult goal with a for-profit institution. Even if they might *want* to adjust
their process to have more of an impact, anything that risks damaging
the bottom line is dangerous. It's possible that some existing institutions
might be willing to try this -- YC, for example, has been experimenting with some
less profit-driven initiatives -- but we didn't manage to find any that we could
work with.

We might expect to have more success with institutions with a more explicitly
altruistic mission. We didn't manage to talk to as many people in this area, but our experiences
suggested that they were either altruistic but not interested in taking an
effective altruist approach; or they were still too young and so
were still overly worried about profitability. This approach might work
if we could find the right institution, but we weren't able to find one in the
time we allowed ourselves.

A third alternative would be to start a completely new institution explicitly
designed with this goal in mind (we called this "the Lab", inspired by Bell Labs). This would also
offer the opportunity to design the programme and the funding process to help
keep things on track in the later stages of startup formation. This isn't a
new idea: I suggested something like this in a [previous
post](http://www.michaelpj.com/blog/2017/02/05/exploration-and-exploitation.html),
and Spencer Greenberg's "Spark Wave" programme is a similar project (and is
making some exiting progress).
    
Furthermore, an institutional solution has the potential to scale well, by
replicating itself, in a way that can be harder to do if you are targeting
individuals. Matt Clifford has a lovely metaphor for EF: startup investment is currently
like running after lightning strikes, whereas EF is trying to build an electricity
generator. We should do this for high-impact startups too, and then make lots of them.

I think this is a really exciting idea, but it's heavy on operations, sales, risk, and
hustle, so we don't think that we are the right people to tackle
it.[^matt-and-alice] 
Ideally, we could start such a project by splitting off an existing
institution, piggybacking off its existing operations capacity and connections.[^hard-work]

[^matt-and-alice]: People do start institutions like this from scratch (e.g. Matt and Alice with EF),
    but I fear survivorship bias.

[^hard-work]: If that sounds like getting someone else to do all the hard work - 
    yes, that's the idea! More reasonably, we want to vary only the *new*
    component, rather than having to also leap all the other hurdles which are
    incidental to the core variation being tried.
    
## Unexplored ideas

### Technologist's careers 

We think that entrepreneurs start companies based on the experience of 
the founding teams. So that means that a way to increase the number of people
who work on important problems is to have more entrepreneurs who are deeply
familiar with those problems. Then when these people turn to starting companies,
they will naturally solve the problems that they have become familiar with.

From an individual point of view, that means if you're considering starting a
social impact start-up in the future a good way of doing that would be to gain
experience in an important problem area.

Concretely, we could develop a more detailed advice programme for potential
entrepreneurs and individuals later in their career. 80,000
Hours would be the natural home for something like this, although they aren't
currently prioritizing it. Currently, a lot of their advice is focussed on people
early in their careers, and making sure that they go into the right areas and
build the right career capital. Helping to guide the process after people get
further into their careers is a lot more work since it is quite career-specific,
but not as much work as actually scoping out
the problem space would be, since you are still assuming that people will find the most
important problems themselves.

The problems with this approach is that it has a very long lead time, and it
relies on a long chain of fallible steps between influencing someone’s career
and them actually starting an important company. However, it could also be tried
fairly easily as a natural extension of the work that 80,000 Hours is already
doing.

### Influence funders

Investors tend to be an influence on the ideas that get started even before
start-ups try to seek funding. This is because entrepreneurs tend to be thinking
about whether an idea will be interesting to investors as their developing it.
So by changing what investors are looking for, we can try and persuade the
bottom-up explorers to optimize for something different.

We are not sure exactly how effectively investors influence entrepreneurs but
there seems to be a sense among entrepreneurs that certain things are ‘hot’
among investors at a particular time. A big enough philanthropic investor could
therefore influence what gets started, although probably still only within broad
areas.

A variant of this approach is the venerable one of offering prizes for companies
tackling particular problems. This amounts to offering easy funding to anyone
who works on a particular problem. Prizes are increasingly popular now (e.g.
X-Prize), but we don’t have a good sense for how effective they are, or how
scalable they are as a funding institution.

The main problem with this plan is that it relies heavily on finding sensible,
wealthy investors. 

# Open problems

The picture I've painted represents my best guess at the truth, but it has some
big open questions.

## Can you maximise for both profit and impact?

The landscape model implicitly assumes you are targeting one metric, but a
startup that has an impact needs to be profitable too. Is it possible to do
this? Is it *practically* possible to do this, given the pressure from investors
etc.? Can we design governance structures that make this easier?

## How come Charity Entrepreneurship can do top-down problem search?

Firstly, I think [Charity Entrepreneurship](http://www.charityentrepreneurship.com/) 
is *awesome*, and one of the best
things to come out of the EA movement in years. I am a huge fan.

How is it that they were able to do this top-down search in a way that I argued
was, if not impossible, at least extremely hard? I think the answer is that they
worked very hard; the non-profit sector is less efficient than the for-profit
sector; and health is an unusually well-evidenced area. There
already *are* big compendiums of the health problems in the world (see the
Global Burden of Disease), and good evidence on which ones work. There's still a
big research and deployment task, and I think that is certainly more difficult
for outsiders, but I think they provide a great example of it being *possible* to do
this kind of thing.

However, I don't think this scales, and I think it will be a lot harder in areas
outside of health.
    
# Whither GTP?

The previous section has given a brief history of the intellectual and practical
progress of GTP, from its inception to its eventual death when we realised that
none of the ideas that we thought were plausible were feasible for us to tackle.

What follows is a brief post-mortem of the project itself. Feel free to skip
this if you're not interested.

## What went well?

### Refinement of problems and concepts

The journey I've described to you may sound relatively clear-cut, but that's
because I've described it to you in terms of our *current* understanding of what
happened. It actually took us a long time to come up with what we have, even
though much of it seems obvious in retrospect.

This makes me think that many of the things that we came up with are in the camp
of "surprisingly useful obvious truths", which take a deceptively large amount
of sweat to discover. So I hope you will not disdain our offerings.

I also think we did a good job of refining the problems that we were
working on. We changed tack fairly frequently, and were fairly responsive to new
evidence as we got it (with a lot of soul-searching along the way). I think we
were guilty both of stopping things too early and of stopping things too late,
but it could have been worse.

One thing that we found surprising was just how easy it was to make *some*
progress, and say some things that had not obviously been said before. Even
after spending a couple of years reading and talking about these problems, I
still think that a lot of what we did was fairly original (of course, we might
just have missed things!). I think
the moral is that there are still uncharted areas to investigate,
and if you're in early then even amateurs like ourselves can make progress.

### Team cohesion

Richard and I worked very well together. I found that team cohesion and work habits made a
huge amount of difference - GTP has been by far my most extensive and successful
project to date.

I think we also did the right thing keeping the team to just the two of us. I don't think we'd
have been much more productive with more people, and we were able to keep
scheduling to a minimum and be fairly spontaneous about meeting people.

### Unexpected useful outcomes

In the course of our work we inevitably ended up looking at a lot of actual
companies, and many of those at least looked like they *might* be high impact.
We ended up keeping a
[list](https://docs.google.com/spreadsheets/d/1ecr4NikKJBqtMjaLThGZ5srHzzDYU85DWEC_RnaqJgc/edit?usp=sharing)
(warning: out of date) of these. This ended up being one of the things that
people were most interested in, usually because they were looking for employers.

### Personal discovery and development

Both Richard and I learned a lot during the process. In particular, I learned
that I just really don't like the kind of desk research we were doing, and I
didn't come around to it over time. That was in some ways a relief, and I'm
aiming to avoid that kind of work in future.

Richard, on the other hand, really likes it, and is now doing much more of that
kind of thing for 80,000 Hours.

Both of us found that actually running a project, while rewarding, was
ultimately more difficult and stressful than we really wanted. I have gained
even more respect for people who pull it off.

### Organization

We got a surprising amount of value out of just writing everything down and
putting it in Google Docs. The ability to refer back (and refer other people to
it) is just invaluable. Writing documents was very helpful for mental
clarification even if the end product was "disposable".[^strategy]

[^strategy]: Don't ask how many half-written documents there are in the "strategy" folder!

## What went badly?

### Lack of commitment

We both worked on GTP in our free time for about a year; and then Richard
started working 2-3 days a week on it, and I moved to one day a week for another
year.

Since we worked much better together, the fact that I was committing less time
meant that we got a lot less done than we could have. In general, I think a lot
of things would have progressed faster, been better, or generally *more* if I'd
committed more time.

The project might well still have failed, but perhaps more interestingly.[^elon-musk]

[^elon-musk]: The unfair version of this is to say "would the project have
    failed if Elon Musk had been running it?" If the answer is no, you weren't
    working hard (or smart!) enough.
    
### Especially unclear goals

Even for a "startup-like" project, our "product" shifted *wildly*, because our
goals were so lofty. We couldn't focus in on individual entrepreneurs as our
target market, because we concluded that they were the *wrong* market. This
meant that we were constantly finding our feet in new areas, or doing three
things at once.

### Credulity

We had many meetings where the other party seemed very keen and interested, but
then nothing actually materialized. We inevitably then ended up wasting a lot
of time preparing for and thinking about projects that never happened. I think 
the lesson here is familiar: don't count your customers until they've actually bought your product. 

### Research

While I don't think this went *terribly*, I do think that much it was largely
useless. Our research mostly consisted of shallow reviews of one kind or
another: either for entrepreneurs who we were trying to advise, to help them
narrow down a field; or to help us figure out what fields to focus on; or as
part of a number of abortive collaborations with institutions. In very few of
these cases did anyone actually *use* the research that we'd done.

One surprising thing we learnt was that by far the most useful people
to talk to were relatively junior EAs in a field. Unlike their seniors who had
more breadth of experience, but often hadn't thought about things through a
prioritizing lens until we talked to them, even junior EAs have often thought
about this a *lot*, and can be a great starting point.

Similarly, we got much better material from people working at foundations, who
are used to looking at whole fields and assessing the importance and overall
direction of research.

A positive effect of having done a lot of shallow research is that can give you
enough "interactive knowledge" to talk to specialists and read papers with some understanding.
This is very helpful if you are frequently dipping into an area.

### Organization

*Apart* from recording things in Google Docs, our organization was pretty bad.
We constantly attempted to record tasks in Asana, but the fluid nature of the
work and my loathing of Asana made this an uphill struggle.

# Conclusion

I think GTP as a whole has been a failure: it certainly failed to achieve its stated goals, 
although these were fairly ambitious.
However, I think we've learned some useful things along the way.

My list of high-level takeaways would be:
- Entrepreneurship has a lot of potential, and there are many opportunities
  which could do with further exploration
- Influencing the entrepreneurship process is tricky, and may require applying
  leverage indirectly (via institutions, funders, etc.)
- More granular cause prioritization would be very useful for "explorers"
- The top-down/bottom-up conflict is real, but there is scope for hybrid solutions

I'm still very interested in this area, and I'd be very happy to talk to anyone
about it in more detail. In particular, if you're interested in working on any
of the ideas in this document, please do get in touch.

## Thanks

I'd like to take a moment to thank some of the people who helped particularly
with this project. In no particular order:

- Ben Clifford
- Ben Todd
- Eric Gastfriend
- Goodwin Gibbins
- Kit Harris
- Mario Pinto
- Matt Clifford
- Matt Gibb
- Max Dalton
- Naomi Morton
- Owen Cotton-Barratt
- Peter Hartree
- Rob Collins
- Sam Hilton
- Spencer Greenberg

Your generosity with your time and brainpower has been much appreciated.

