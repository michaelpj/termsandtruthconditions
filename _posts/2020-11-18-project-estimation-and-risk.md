---
layout: post
title: Why doesn't software project management handle risk better?
tags:
- notebook
- programming
- maths
- probability
date: 2020-11-18 17:52 +0000
---
I work in software. 
A perennial bugbear of software project management is: why do so many software projects go over time?
Moreover, why do they do this when so much time is spent trying to break down projects and get engineers to estimate how long the pieces will take?

The answer is simple: things take longer than we expect.
And we *know* that we're uncertain about our estimates when we make them, i.e. there's actually some probability distribution over the time the task will take.
So why are we *surprised* that things blow out and why don't we have the tools to measure and deal with this?

<!-- more -->

## Point estimates

I think the answer is that we're working with point estimates. 
A "point estimate" of a probability distribution just means looking at that whole, complex distribution, and saying "nah, let's just pick one number to summarize it".
Typically this is the mean or the median, and while the mean has nice properties, point estimates of probability distributions *always* lose information.

The first thing you lose is the variance information.
The variance of a distribution is *critical* information if you care about risk: it's the difference between a task that will definitely take a week and a task that will, generally, take a week, but might take six months.
The moment you take a point estimate this is gone.
Let alone if you then sum up 45 different point estimates of different tasks.
What's the variance of that?

The second thing you lose is the ability to calculate.
Suppose we have some summarisation function `s` and we have computed `s(X)` and `s(Y)`, and now we want to know `s(X+Y)`.
Is it `s(X)+s(Y)`?
If `s` is "take the mean" then fortunately the answer is yes, but even for the mean this is not true if you perform other kinds of operations (say, multiplication, or taking a minimum).

[^multiplication]: As an example of how drastically wrong you can go if you multiply point-estimates, [this paper](https://arxiv.org/abs/1806.02404) argues that the Fermi paradox is an illusion caused by inappropriately multiplying means of heavy-tailed distributions

We're talking about time estimations here, so you might not think that anything other than addition matters much. 
But sometimes you are uncertain how *many* times you will have to do some thing, like "answer a support ticket" or "write a data ingestor".
If you try and quantify this, then you need to multiply an uncertain quantity (number of instances) by an uncertain quantity (time to do one instance).
Or you might use a minimum to "race" two parallel approaches to a problem --- bzzt, wrong!

More worryingly, the *median* is not even additive!
[Eric Bernhardsson](https://erikbern.com/2019/04/15/why-software-projects-take-longer-than-you-think-a-statistical-model.html) makes a compelling case that people tend to estimate medians rather than means, and that this leads to chronic mis-estimation when you start adding things up.[^why-medians]

[^why-medians]: Why do people tend to estimate medians?
    Eric doesn't offer a hypothesis, but I have one.
    Estimating a median can be done by visualizing a "typical" *scenario*, and then deciding how long that would take.
    Estimating the mean is much harder: you would need to think of a scenario with a typical *time*, which is much harder without a global analysis.

## What to do?

What if we didn't throw away the distribution?
It's actually perfectly feasible to work with probability distributions the whole way up.[^monte-carlo]
For an example of this have a look at [Guesstimate](https://www.getguesstimate.com/). 

[^monte-carlo]: You do want some computer assistance, though, since the most straightfoward way to do this is computational Monte Carlow simulations.
    This idea is not new: you can see it in the still-relevant ["How To Measure Anything"](https://www.amazon.co.uk/How-Measure-Anything-Intangibles-Business/dp/1118539273/), although the book does it with unwieldy spreadsheets.

Guesstimate looks like a spreadsheet, but cells have distributions in them.
You can input distributions at the leaves, by entering confidence intervals and picking one of a few distribution types.
Then you can put arbitrary calculations in derived cells, and Guesstimate will work out what the distribution is for that computed value.
This avoids all of the problems above.
Variance? Incorporated. 
Point estimates? Gone.

And it gives you new things for free.
Guesstimate can calculate the *sensitivity* of a particular cell to other cells.
In a project estimation context, this means it can tell you which subtask contributes the most uncertainty (i.e. risk) to the overall endeavour.
That's *huge* - and it just works with no additional input.

This all comes with some cost in learning, but I think the basic principles are graspable with less than an hour of training.
And it's well known that you can do calibration training to rapidly make people much better at giving good confidence intervals.[^htma]

[^htma]: See ["How To Measure Anything"](https://www.amazon.co.uk/How-Measure-Anything-Intangibles-Business/dp/1118539273/) for much more in this vein.

## Why don't people do this already?

Project management is all about risk.
So why aren't project managers all over this?
I've never seen any project manager even *think* about quantifying risk, let alone try to get me to use some kind of complicated risk management tool.

I have no idea, to be honest.
Guesstimate unfortunately doesn't scale well to really large calculations, and the workflow isn't optimized for the time-estimation usecase.
So perhaps the right tool just hasn't been written yet.[^liquid-planner]

[^liquid-planner]: The closest thing I've found is [Liquid Planner](https://www.liquidplanner.com/), but it's an unfashionable paid native application.

