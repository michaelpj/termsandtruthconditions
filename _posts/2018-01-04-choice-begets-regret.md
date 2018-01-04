---
title: Choice begets regret
layout: post
tags: [ decision theory, psychology ]
---

Epistemic status: speculative

[Choice](https://thezvi.wordpress.com/2017/07/22/choices-are-bad/) 
[is](https://thezvi.wordpress.com/2017/08/12/choices-are-really-bad/) 
[bad](https://en.wikipedia.org/wiki/Overchoice). 
I want to focus on one aspect of this badness: *regret*. I'm going to
argue that increased choice predictably increases the amount of regret that an
agent feels, even if they are actually better off, and that this is bad for
humans in particular.

<!-- more -->

Suppose that John is an uneducated child of subsistence farmers. 
Then John has a very limited set of options available to him (his "choice
set") - work at his parents' farm, work at someone *else's*
farm in the village, start his own farm... and that's about it. While John might
*prefer* to be a lawyer, the fact that he was unable to
become one does not reflect badly on *him*, since it was just not an available option.
Given the limited set of alternatives, John ends up
taking over the family farm (gaining 100 utils of satisfaction), and is quite satisfied
with himself (starting his own farm being the best option at 110 utils).

Now, suppose that Kim is an educated child of farmers (with exactly the same preferences
as John). Kim could still become a farmer,
but also has some new, intriguing possibilities as a clerk, or clergyman, or
a lawyer. Some of these options are much better than becoming a farmer, but 
it is increasingly unclear how to reach them. Kim ends up becoming a clerk
(gaining 150 utils of satisfaction), but is mildly dissatisfied (becoming a lawyer
being the best at 200 utils).

Now, suppose Liam is an educated child of professionals in the developed world (with the same preferences as
John and Kim). Liam has many options far better than being a farmer or a clerk,
including some that seem vastly better but are hard to acquire (the best is
starting a spaceship company). Liam ends up being a well-paid software developer (gaining
300 utils of satisfaction), but is perennially dissatisfied with his choices
(spaceship company CEO being the best at 1000 utils).

John, Kim, and Liam have the same preferences, and they each satisfy them
progressively more. But Liam has the *most* regret, despite having done best.
What's going on?

Well, first of all I've been casually using this word "regret" without really
saying what I mean. Let's assume for the moment that "regret" works a bit like
it works in decision theory: an individual's regret about a decision is the
difference between the best option (post facto) and the option that they
actually took. So John has regret 10, Kim has regret 50, and Liam has regret 700.

This concept of regret is a useful one because *minimizing* regret is dual to
*maximizing* value (for any fixed $X$, minimizing $X - V$ is the same as
maximizing $V$). Moreover, regret makes a handy summary of how good your past
decisions were, how much they deviated from optimal. So you can get a long way
as a regret-minimizer.

But are *humans* regret-minimizers? I doubt that we are *entirely*, but
people certainly do find regret very aversive, so it's hard to deny that it plays
*some* part in our decision process. So let's hypothesize that humans are at
least partly regret-minimizers.

But what does a regret-minimizer [feel like from the
inside](http://lesswrong.com/lw/no/how_an_algorithm_feels_from_inside/)? For a
regret-minimizer, regret is *bad*, and it's going to feel worse the more regret
it has. Operationally, this works just as well as making it feel good in
proportion to how much value it has, but subjectively the experience is quite
different. 

This already seems somewhat cruel, but we should also expect that the
*absolute amount* of regret that an agent feels is going to be larger the larger
their choice set (even though their actual outcome should actually be better).
Buyer's remorse is worse the more options there are!

This is not a sure thing: if the new additions to the choice set are
very easy to acquire, then the regret may go down (consider the degenerate
case where there is no uncertainty). But even if you always manage to get
an option within 5% of the best, the absolute size of that difference
will still be bigger in a bigger set of choices. And in fact our world seems to
lean towards high-uncertainty high-payoff options in the tails, which are
especially bad.

(There's something weird about this - the world hasn't *changed* when the choice
set expands. There was always someone off being a lawyer while John was a
farmer, but because that wasn't an option that was open to him, we're not
counting it as part of his regret. Let's call the equivalent of regret but for
*all* options "envy" (I suppose this is technically unbounded if you envy God, but whatever).
Then John has (at least 1000) units of envy (since he envies the lawyer), but
this isn't regret because he can't do anything about it. Regret is the bit of
envy that you blame on yourself. Increasing your choice set converts all that
envy into regret.)

Earlier I suggested that regret minimization doesn't behave differently to value
maximization in terms of outcomes. That's true... unless your agent gradually
shuts down and becomes less effective when its regret gets too high (how the
algorithm feels is not an epiphenomenon in this case!). Evolution won't save
you: the best it can do is make sure that your regret thresholds are
well-calibrated for the ancestral choice environment. Which looks a lot more
like John's than Liam's. Even worse, since we actually care about what it's like
to be our algorithm, we are not neutral between the two choices. Being a
value-maximizer seems *subjectively better* than being a regret-minimizer.

High regret doesn't only make people sad in retrospect, it can also make them
sad in prospect. If you are assessing options based on expected regret, then as
a regret-minimizer you're still going to *feel* bad about an option that is high
in expected regret (even if it is the lowest of the set). That's what it's like
to want to minimize regret. That might manifest as a sense of hopelessness,
despair, or a feeling that the all the options are bad.

Putting it together we get a sad just-so story: humans evolved to be partially regret-minimizers 
because that worked fine at the time. But our choice set has expanded rapidly,
and especially at the tails, which means our absolute levels of regret are
climbing, along with our performance.

I have no idea what we do about this, other than try and think like a
value-maximizer rather than a regret-minimizer ("don't compare
yourself to other people"). Suggestions welcome.

