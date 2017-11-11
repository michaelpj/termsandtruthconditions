---
title: Towards effective entrepreneurship
---

# Introduction

This document aims to be two things: a summary of the things that we learned
from the Good Technology Project (GTP), and a post-mortem of the project itself.[^double-duty]

[^double-duty]: Why put both in the same post? I think that
    in retrospect, a narrative description of what we did also serves as 
    a reasonable path through the ideas that we came up with, and so it might as well serve double duty.
    
# What was GTP?

The goal of GTP was broadly to do whatever we could to "fix" technology
entrepreneurship. We observed that technology entrepreneurship is very powerful, 
and yet most of its energy is going into solving unimportant problems ("Tinder for cats").

How you might actually go about doing that is part of the topic of this document.

# A guiding model

Before we discuss what GTP did, I'm going to present an abstract model of how we believe the entrepreneurship
process works.[^similar] The point of this is to situate what we learned in
terms of where we think it fits into the bigger picture.

[^similar]: I think something like this model applies to other domains
    where you are trying to start new things, like charity entrepreneurship.

## The entrepreneurship landscape

We can think of the space of potential startups as a height map over a plane.[^owen]
The plane corresponds to roughly "where" the startup is, what problem it is
solving, how it is solving it, etc. The "height" corresponds to how good the
startup is by some measure (for now we'll assume there is just one thing we care
about).

[^owen]: Thinking about our space of opportunities like a landscape to explore
    is not a new metaphor - c.f. Owen Cotton-Barratt's [EAG 2016 talk](https://www.youtube.com/watch?v=67oL0ANDh5Y).

Then what we want to do is to locate the highest peaks in this landscape. These
correspond to the best opportunities to get whatever it is that we want - money
or impact, in this case.

We have some broad beliefs about the landscape:
- There is a huge amount of variation globally: the highest peaks are *much*
  higher than the median.
- There is a lesser, but still substantial, amount of *local* variation: even
  within a region there is a big difference between the best and the median.
- Peaks are relatively sparse: most of the points are low.

These are based on the usual observations about the distributions of startup
earnings/impact. I think they are fairly uncontroversial, so I'm not going to
defend them further here.

### Meet the locals

The landscape is "inhabited" by individuals. The people local to an area of the
landscape have a superior (although still imperfect) ability to survey it, and
can often have success at identifying and climbing nearby hills. 

The locals correspond to individual entrepreneurs or potential entrepreneurs,
and their situation in the landscape corresponds to their specialised knowledge,
skills or beliefs (their 
["edge"](https://medium.com/entrepreneur-first/understanding-founder-idea-fit-f16d658c0e8f)).
We can think of people with more cross-cutting knowledge, like technology
specialists, as inhabiting a "strip" across the landscape rather than a more
compact region.

### Sky high 

Far above the landscape are the "planners". They have very poor visibility of
the landscape. They may be able to tell that one area is generally hillier than
another, but little more than this. They can drop expeditions down onto the
landscape, but this is costly and is generally unlikely to land on a peak.

We are the planners. We are trying to deliberately zoom in on the
peaks across the whole landscape, without being already situated in that area.
We can learn about areas in more detail, but this requires laborious research,
and even then our understanding is likely to be inferior to that of the locals.

### Implications of the landscape model

This model is generally *pessimistic* about the ability of the planners to get
to the peaks that they want to find. Most
successful startups come from locals who know the region, rather from planning.
This leaves us in the rather unsatisfying state that Julia Galef outlines in
["Can we intentionally improve the
world?"](https://juliagalef.com/2017/02/19/can-we-intentionally-improve-the-world-planners-vs-hayekians/),
where we more or less have to concede that "Hayekian" camp is the major driver
of innovation.

I broadly agree with this, but I think there's some hope for "hybrid" solutions,
which I'll outline later.

# Improving entrepreneurship

So we've decided we want to improve the entrepreneurship process. What should we
try?

## Advise entrepreneurs directly

The first strategy we tried was to try and influence current, but pre-idea,
entrepreneurs and get them to work on higher-impact projects.

To that end we teamed up with [EF](https://www.joinef.com/), a startup
accelerator that takes individuals pre-idea, and helps them form teams and
generate ideas.[^influence] We pitched to the EF7 cohort before they started,
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
their "edge"[^edge], and this means that it simply isn't realistic either to get
someone who knows about medicine to look at a finance idea, nor to get someone
with flexible technical skills to work on an idea without a domain cofounder.

[^edge]: We think this is good advice! We looked at 50 high-impact tech
    companies, and almost all of them had a founder who had a strong background
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
resistance and be ultimately [counterproductive](http://paulgraham.com/startupideas.html).

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
I've relegated it to an appendix.

### So what do we say to entrepreneurs?

From this point on we had a somewhat ambivalent relationship to individual
entrepreneurs. They tended to either be already working in broadly the right
area, in which case we had nothing further to say to them (except some general
advice about how to keep on track), or they were in an area that seemed unlikely
to be high-impact, in which case we *also* had little to say to them.

Surprisingly, the most common advice we gave after this point was "try working
or studying in an important area for a few years, then reconsider
entrepreneurship". This is particularly important for tech specialists, since
you want to either develop some domain edge in an important area, or find a
cofounder there. This advice wasn't generally terribly well-received - people who've got to the
point of thinking of themselves as potential entrepreneurs usually want to do
something *soon*.

### Glimmers of hope: serial entrepreneurs

By far our most successful individual advice process was with a *repeat*
entrepreneur, who had already sold his first company. This made a huge
difference: he had far more resources to deploy on the process, and most of all
he had *time*.

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
animal welfare is high-priority is useful, but then you want to now which are
the most important parts of the problem, and then which are the most important
parts of *that* problem, until you find something you can actually tackle.

[^search-vs-filtering]: I think part of the reason this hasn't been apparrent is
    that EAs have often operated in an evaluating capacity. If you are being presented
    with existing ideas and need to evaluate 
    them, you can use a coarse cause prioritization as an initial filter
    and then move on to more laborious methods. However, if you're looking for *new*
    problems, then initially filtering down to a priority cause helps, but still
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
common vocabulary about just what they *are*. For example, MIRI's "Open Problems
in AI" paper did wonders for just clarifying *what* the problems are, and was
generally regarded as a very useful contribution for that reason.

Nice as this vision is, it number of problems:
- It would be a hilariously enormous amount of work to create and maintain.
- It's not clear that it's possible to nicely break down problems in this way.
- It's unclear how the prioritization would work, or who would do it.

I [pitched](https://docs.google.com/document/d/17M--h_p73ARL3_keji53O3gHka4xPYrwE2Zp8GEobPM/edit?usp=sharing) 
this idea to a few people and got some interest, but I never took it very far. I
still think it could be valuable, and a reasonable MVP would be a thin,
"vertical", slice through a domain. I think health would be a good area for
this, in that much of the needed material is already present.[^charity-entrepreneurship]

[^charity-entrepreneurship]: Indeed, I think this is one of the reasons that
    [Charity Entrepreneurship](http://www.charityentrepreneurship.com/) 
    has been successful with the top-down approach in health.
    
The existence of this problem and the difficulty of solving it also supports the
landscape model, since it illustrates the problems that the planners have in
understanding the landscape in enough detail to make decisions.
    
## Institutional solutions

If we can't do much with any given entrepreneur, perhaps we can do something to
change the mix of entrepreneurs who go on to form companies. 

The fundamental idea is this: pick an important area, and then bias recruitment
towards people who *already* have the skills and inclination to work in that
area (for example, you might recruit epidemiologists, development economists, and
doctors, as well as technologists). If we can't win a hand, stack the deck.

A minimal institutional solution would be to find an institution like EF and
persuade them to let us bias their intake in this way. In practice, this is a
hopeless goal with a for-profit institution. Even if they might *want* to adjust
their process to have more of an impact, in reality anything that risks damaging
the bottom line is too dangerous.

We might expect to have more success with institutions with a more explicitly
altruistic mission. We didn't get as much exposure here, but our experiences
suggested that they were either "ineffective altruists", and hence not terribly
interested in our ideas; or they were still too young or too desperate and so
were still overly worried about profitability. Possibly this approach might work
if we could find the right institution, but we gave up.

A third alternative would be to start a completely new institution explicitly
designed with this goal in mind (we called this "the Lab" in a vain aspiration
to be a new Bell Labs). This would also
offer the opportunity to design the programme and the funding process to help
keep things on track in the later stages of startup formation.[^previous-discussion]

[^previous-discussion]: I first suggested something like this in 
    a [previous post](http://www.michaelpj.com/blog/2017/02/05/exploration-and-exploitation.html).
    
Furthermore, an institutional solution has the potential to scale well, by
replicating itself, in a way that can be harder to do if you are targeting
individuals. Matt Clifford has a lovely metaphor for EF: startup investment is currently
like running after lightning strikes, whereas EF is trying to build an electricity
generator. We should do this for high-impact startups too, and then make lots of them.

I think this is a really exciting idea, but it's simply too high-risk and
difficult to be tackled by a couple of relative nobodies like
us.[^matt-and-alice] Ideally, we could do this by splitting off an existing
institution, piggybacking off its existing operations capacity and connections.[^hard-work]

[^matt-and-alice]: Sure, people have done this (e.g. Matt and Alice with EF),
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

Concretely, we could develop a more detailed advice programme for this. 80,000
Hours' advice is currently on the level of 'go into software development' or 'go
into data science', rather than tailored material to help someone who is already
in a technical career to be able to maximise their domain knowledge for future
impact. We’d like like to see more material for these people who are already in
technology careers.

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

Firstly, I think [Charity Enterpreneurship](http://www.charityentrepreneurship.com/) 
is *awesome*, and one of the best
things to come out of the EA movement in years. I am a huge fan.

How is it that they were able to do this top-down search in a way that I argued
was, if not impossible, at least extremely hard? I think the answer is that they
worked very hard, and that health is an unusually well-evidenced area. There
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
of sweat to discover. So I hope you will look upon them tenderly.

I also think we did a pretty good job of refining the problems that we were
working on. We changed tack fairly frequently, and were fairly responsive to new
evidence as we got it (with a lot of soul-searching along the way). I think we
were guilty both of stopping things too early and of stopping things too late,
but it could have been worse.

### Team cohesion

We worked very well together. I found that team cohesion and work habits made a
huge amount of difference - GTP has been by far my most extensive and successful
project to date.

I think we also did the right think keeping the team small. I don't think we'd
have been much more productive with more people, and we were able to keep
scheduling to a minimum and be fairly spontaneous about meeting people.

### Doing something in a relatively uncharted space

One thing that we found surprising was just how *easy* it was to make some
progress, and say some things that nobody appeared to have said before. I think
the moral is that there are still uncharted wilds to conquer,
and if you're in early then even amateurs like ourselves can make progress.

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
    failed if Elon Musk had been runnning it?" If the answer is no, you weren't
    working hard enough.
    
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
useless. 

One surprising thing we learnt was that by far the most useful people
to talk to were relatively junior EAs in a field. Unlike their seniors who had
more breadth of experience, but often hadn't thought about things through a
prioritizing lens until we talked to them, even junior EAs have often thought
about this a *lot*, and can be a great starting point.

Similarly, we got much better material from people working at foundations, who
are used to looking at whole fields and assessing the importance and overall
diretion of research.

### Organization

*Apart* from recording things in Google Docs, our organization was pretty bad.
We constantly attempted to record tasks in Asana, but the fluid nature of the
work and my loathing of Asana made this an uphill struggle.

# Conclusion

I think GTP as a whole has been a failure: it certainly failed to achieve its goals.
However, I think we've learned some useful things along the way.

I'm still very interested in this area, and I'd be very happy to talk to anyone
about it in more detail. In particular, if you're interested in working on any
of the ideas in this document, please do get in touch.

## Thanks

I'd like to take a moment to thank some of the people who helped particularly
with this project. In no particular order:

- Ben Clifford
- Kit Harris
- Matt Clifford
- Matt Gibb
- Max Dalton
- Mario Pinto
- Naomi Morton
- Owen Cotton-Barratt
- Peter Hartree
- Rob Collins
- Sam Hilton
- Spencer Greenberg

Your generosity with your time and brainpower has been much appreciated.

# Appendix

This section owes a great deal to prior work and thought by Spencer Greenberg,
Eric Gastfriend, and Peter Hartree.

A lot of this material is more-or-less obvious applications of EA thought to
startup theory. Nonetheless, it managed to be surprising and useful to people,
so perhaps it is less obvious than it seems.

In addition, some of it relates to how to manage a startup in later stages. We
never really got a chance to try this out, so it is especially speculative.

## What makes a startup high impact?

We’re interested in startups because we think that they might be a mechanism 
by which we can have a large positive impact on the world. But what are the qualities that we should look for in a startup?

## Impact model

Before we get started on assessing how good a company is, we should try and get 
clear on how that company benefits the world, to make an impact model for the company.

The first big consideration is who the company helps. Usually there will be one
group in particular that you are expecting to benefit. A good way of figuring
out who these are is to consider the various groups of “affectees” for your company.

### Customers

Customers are the most obvious people who benefit (or suffer) from the existence 
of a company. They pay a cost in money and time, and they gain your product in return. 

For example, [Mesh Power](https://www.meshpower.co.uk/)’s[^bust] primary beneficiary group is its customers (insofar as
you think that promoting clean energy over burning kerosene might have
environmental benefits, Mesh Power may also have some externality benefits, see below).

[^bust]: Sadly, it looks like they've gone bust since I last checked, but
    they're still a good example of the principle.

While we can usually assume that people will buy things that actually improve
their lives, this isn’t universally true. Cigarettes and addictive drugs or games are examples of this.

### Third parties

The operation of your company will also affect people who are not part of the
transaction, or even involved at all. These effects are called externalities.
Often these are positive, in the case of innovation and economic growth, but
they can also be negative, such as pollution, developing dangerous new
technologies, or causing technological unemployment.

For example, despite being a car company, arguably Tesla’s primary beneficiary
group are third parties, because accelerating the progress of electric cars and
storage will help to ameliorate climate change.

An important class of externality is benefits produced by your customers, which
will often happen if you’re selling to businesses or institutions. For example,
disease outbreak monitoring systems may be sold to governments, but the
beneficiaries are the people who don’t get ill because of the government's’
improved preventative action.

### Employees

A third category of beneficiaries is your employees. They will gain pay and
satisfaction from working for you, but will also spend their time. In bad cases 
they could experience physical or psychological harm because of the job.

For example, one of [M-PESA](https://www.mpesa.in/)’s beneficiary groups are among its employees, since
it needs lots of places for customers to buy and sell mobile money, and this 
provides additional income for a lot of relatively poor shop owners.

### Impact mechanism

The next thing to do is to work out how you think your startup will actually
affect your target group of beneficiaries. This is likely to be very uncertain,
especially if you expect to create an impact through externalities. However,
it's better to explicitly write down what you're uncertain about nonetheless.

For example, here's one mechanism by developing a better test for drug-resistant
TB might improve wellbeing:
- Decrease cost of TB test
- Increase availability of test in low-resource areas
- Accurately distinguish more cases of drug-resistant TB from normal TB
- Give more drug-resistant TB sufferers the correct drugs
- Cure more people of drug-resistant TB than otherwise
- Fewer people go through the lengthy suffering of drug-resistant TB
- Increase wellbeing

There may well be several such mechanisms, of course!

Once you have an explicit impact mechanism, that gives you a two useful things: a set of
hypotheses about how your impact occurs, which you can *test*; and a set of stages
in the mechanism which you can *measure*.

Most of these won't be things you can test or measure now, but it's worth
thinking from time to time whether you might be able to measure more of them.
For example, in early development you might focus on measuring the cost of the
test, but as you roll out you might also be able to measure improvements in availability.

## Assessing the impact model

We can apply our usual INT heuristics in this case, although we can pick out some
particular considerations for the domain.

### Scale

As ever, we care about both how many people we help and how much we help
them.

We should think about maximum scale here: if you could eventually sell your
product to everyone on Earth, that's better than if you're limited to just one
national market. If we think about our possible beneficiary groups, third parties
tend to be the biggest group, followed by your customers, and then your employees.

Similarly, a life-saving product is much better for each person than something
that merely saves them some money.

### Tractability

There are a couple of big things that affect tractability.

The first is obvious: the problem may be hard. Or the problem may be easy, but
making it *profitable* may be hard. And we're primarily thinking about
businesses here, so if you can't make it profitable, you can't do it.

Secondly, you might not *want* to do it. Running a business is hard work, and
you face pressure not only to drop out, but to cave in on issues where your
investors or advisors may not be aligned with what you want. If your beneficiary
group is your customers, then your profit goals and your impact goals are
relatively aligned, so this may be easier. 

In other cases this is less
likely. For example, Uber (may be) benefiting its 1.5 million drivers. But they
are not incentivised to employ these people, because doing so costs them, so as
soon as they can automate them away, they will.

Finally, you might not be able to figure out *what* to do. Even if you can
identify the problem, you may not be able to figure out a plausible mechanism to
actually have an impact on it, or your mechanism might fail to work.

Tractability issues result in two big failure modes:
- The business fails entirely
- The business succeeds, but it has a low or negative impact

### Counterfactuals/Neglectedness

Assuming that you start a business that solves a real problem, we can assume
that someone would have solved it eventually. That means that the effect you
have is the *difference* between those two, which will look like getting X extra
years of the solution. We can call this your *time advantage*.

Generally, the bigger the time advantage the better. If the problem is big
enough, then even a short time advantage may not be a problem - getting a
malaria vaccine a year earlier would be huge!

But generally bigger is better. There are a few ways you might have a big time
advantage:

Firstly, the technology you use has existed for a while but hasn't been applied to the
problem that you are applying it to. That suggests that it would continue to
be unsolved in that way for a long time if you don't do it. 

Counterintuitively,
this suggests that you should stay *away* from new technologies: it is very
likely that someone will try "machine learning for X" relatively soon, so it is
unlikely to be neglected.

Another common case is that the problem requires an unusual combination of skills, knowledge, or
inclinations. For example, you might know about both financial services and the
developing world, while also being altruistic. Combinations of traits are
correspondingly rarer - if you have at least one moderately rare skill, then it
is likely that you also have one *very* rare combination of skills. 
It may be a long time before this combination comes along again, and so if there
are problems that require it, they may go unsolved until then.[^secrets]

[^secrets]: Peter Thiel talks about "secrets" which are unusual beliefs that you
    have which make you think that a problem is soluble, even though the general
    belief may be that it is not. These are another thing that can make you unusual.

This suggests that you should look especially hard for problems that *only you*
(or you and your friend with the other unusual skills) can solve, because that
is likely to give you a big time advantage.

Finally, the incentives to solve the problem may be lacking (e.g. the customers
are poor). This is a tough case, because those incentives will also be lacking
for *you*. So you need a good story about how you are going to keep your impact
on track. Many benefits to third parties have this form. Often if the
externality is innovation then a strong founder can ensure that most of the
benefit is produced before they are phased out. For example, Tesla has chosen to
give away their patents for free, which might not have happened with a less
altruistic CEO.

