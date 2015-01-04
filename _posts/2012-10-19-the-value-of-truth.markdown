---
layout: post
title: "The Value of Truth"
date: 2012-10-19 15:25
comments: true
categories: [philosophy]
published: false
author: Michael PJ
---

>The Will to Truth, which is to tempt us to many a hazardous enterprise, the famous Truthfulness of which all philosophers have hitherto spoken with respect, what questions has this Will to Truth not laid before us! What strange, perplexing, questionable questions! ... In fact we made a long halt at the question as to the origin of this Will-until at last we came to an absolute standstill before a yet more fundamental question. We inquired about the VALUE of this Will. Granted that we want the truth: WHY NOT RATHER untruth? And uncertainty? Even ignorance? -- *Beyond Good and Evil*, 1.1

Of all the insights I gained from reading Nietzsche (almost all, I hasten to add, due to him making me think, not being *right*), the one that has stuck with me the most is almost the first thing you read when you open *Beyond Good and Evil*. Nietzsche raises a question that I don't think had even occurred to me the first time I read it: what is the value of truth?

<!-- more -->
Nietzsche is mostly interested in slagging off all past philsophers (going so far as to name names, extensively), but the starting point of his critique is the claim that all philosophical activity rests on a set of unjustified presumptions. To even get started doing philosophy, we have to believe that what we are doing is *worthwhile*, that it is *good*. And the most basic of these presuppositions is that it is good to believe the truth. 

This is not normally a controversial claim. One of the fundamental tenets of modern liberal thought is that the truth is good for us ("The truth will set you free"). But *why* is that? As Nietzsche says: "Why nor rather untruth? And uncertainty? Even ignorance?". To refuse even to ask these questions is to simply *fetishize* truth.

>In spite of all the value which may belong to the true, the positive, and the unselfish, it might be possible that a higher and more fundamental value for life generally should be assigned to pretence, to the will to delusion, to selfishness, and cupidity. -- *BGE*, 1.2

We needn't go the whole way with Nietzsche here, but he paints the picture well enough. It certainly seems possible that it could be bad to believe the truth; or at least we haven't argued that it can't be, yet.

The second strand of Nietzsche's argument is to claim that the only way we can decide this issue is by assessing whether the pursuit of the truth furthers our values, and thus at the very foundation of philosophy we have slipped in a *moral* premiss.

>It has gradually become clear to me what every great philosophy up till now has consisted of - namely, the confession of its originator, and a species of involuntary and unconscious auto-biography; and moreover that the moral (or immoral) purpose in every philosophy has constituted the true vital germ out of which the entire plant has always grown. Indeed, to understand how the abstrusest metaphysical assertions of a philosopher have been arrived at, it is always well (and wise) to first ask oneself: "What morality do they (or does he) aim at?" -- *BGE*, 1.6

That is, before enquiry can even begin, there must be some kind of value-judgement made.

Nietzsche, then, leaves us with two questions:

1. Is the truth valuable?
2. How are we to decide that question?

TODO: talk about 2 first, it's more fundamental!

## Is the truth valuable?

In general, if we're thinking about how we should behave, there are two kinds of considerations we could appeal to: prudential and moral. As I've argued, there's no way around making assumptions about these, so let's make some! I'm going try and get away with using examples that are as general as possible, but I'm going to assume that maximizing expected satisfaction of our preferences is what we ought, prudentially, to do, and that maximizing some kind of aggregation of people's personal welfare is what we ought, morally, to do.[^consequentialism] I'm going to use moral and prudential examples pretty interchangeably; for a consequentialist the two are fairly continous, it's just a case of changing whether one is aiming only at one's own good, or at everyone's good. 

[^consequentialism]: Yep, I'm assuming some kind of consequentialism here. If you're a non-consequentialist, a lot of what I'm going to say won't apply to you. At some point I'll try and present some more argument for why you should be a consequentialist, but in the mean time you can try [Yvain's Consequentialism FAQ](http://www.raikoth.net/consequentialism.html).

On the face of it, it seems pretty weird that believing the truth might be bad for you. Knowing more means that your map of the world matches the world better, and so you can act with more confidence in how your actions will affect the world, and hence achieve your aims better. The *benefits* of believing the truth in general seem pretty clear. There's even a theorem about it proved by I.J. Good: for a Bayesian agent, gathering more information before acting is always the option that maximizes utility, so long as the cost of doing so is sufficiently small.[^Good] In particular, if you could get more information for free, you should always do so!

[^Good]: Good, I.J. (1967) QOn the Principle of Total Evidence.

On the other hand, it doesn't seem that hard to come up with a counterexample:

>**Omega 1**: 
>
>An nigh-omnipotent extra-galactic superintelligence named Omega threatens to torture everyone on Earth for eternity unless, by next Tuesday, you come to believe that you are a salmon.

In this case, it seems to be pretty clear that it would be better to believe that you are a salmon: while that might make life pretty difficult for you, it's clearly better than eternal torture for everyone. So what's going on?

There are a couple of ways in which Good's theorem can fail to apply, and these nicely split things up:

1. The agent may not be a perfect Bayesian agent.
2. The act of gathering information, or the simple possession of it, may affect the outcome of the situation.

Both of these can apply. The first is less interesting: obviously humans are nowhere near perfect Bayesian agents, and so there is no guarantee that gaining more information will actually lead to us making better decisions. There are a whole host of biases that interfere with good decision-making; the [LessWrong Wiki](http://wiki.lesswrong.com/wiki/Bias) has a good collection of material on the topic. There are plenty of wholly mundane examples:

>**Depression**: 
>
>Your boss informs you that you're about to be fired in a wave of redundancies. But if you work extremely hard he might be able to justify keeping you. However, he can only do this for about 1% of the employees. Instead of working hard, this knowledge sends you into a fit of depression, and you do nothing.

(Strictly, it's a bit unclear which category this falls under. Is it a case of you failing at acting so as to best pursue your goals, or is it an example of your epistemic state affecting your options by rendering some of them emotionally impossible? In general, there isn't always going to be a clear-cut distinction here.)

The other possibility is more interesting, and it's what's going on in Omega 1. Sometimes an agent's *own epistemic state* can affect their situation. In the Omega 1 case, Omega explicitly bases its actions upon your beliefs. But these kind of problems, where what is in your head affects what is outside, have bedevilled decision theorists and moral philsophers for a long time. For which reason we're going to take a whirlwind detour, after whch hopefully we'll be able to draw out some similarities.

### Decision theory

In decision theory, matters get very complicated once it is possible for the situation to depend upon the mental states of the agents. Often the problems faced are actually more general than what we've been considering so far: rather than just the agent's epistemic state, the situation may be conditional on some other aspect of their nature. Consider the following famous example:

>**Omega 2 (Newcomb's Problem)**: 
>
>Omega offers you the chance to take one or both of two boxes, A and B. B contains $1000 no matter what. A contains $1 million iff Omega predicts that you will take only box A. (Omega is, as far as you know, an infallible predictor).

In this case, Omega's actions are conditional on the agent's *decision procedure*: if I am the sort of agent who will take only box A in this circumstance, then Omega will fill it with $1 million, otherwise not. Newcomb's problem is famous for tying decision theories in knots. Under many analyses it seems obvious that one should two-box: at the time you make your decision, either Omega has filled box A or not; either way, you come out $1000 ahead if you take both boxes. However, annoyingly, agents who reason like this will end up with only $1000, whereas those who one-box will (entirely predictably) end up with the million.

In general, situations like this where it's advantageous to behave otherwise than simply maximizing for the situation one is currently in can be handled by making *precommitments*. Consider a simpler example:

>**Chicken**: 
>
>You and an advesary are competing in a game of chicken for a great prize. The rules are as follows: you both drive towards each other as fast as possible, and the first person who swerves aside loses.

If you are given a chance to prepare for such a contest, what should you do? You should drink yourself blind, tear out the steering wheel and blindfold yourself. If your opponent is truly convinced that you *will not* turn aside, then their options are much simpler: turn aside themselves, or cause both of you to die. If they're behaving rationally, then they'll turn aside, and you will claim your prize (unless they managed to tear out their steering wheel first!). Similarly, if you know that Omega is coming, then you should swear blind that you will one-box, perhaps going so far as to get a reliable third party to promise to shoot you if you do not do so. That is, you should *make yourself* into the kind of agent that will one-box, and hence end up with the money.

Precommitments can be counter-intuitive because they tend to involve committing yourself in the future to one course of action, even though at that point it would be better for you to take another one. For another example, consider:

>**Hitch-hiker**: 
>
>You are stuck in the desert with no source of water or means of communication, without which you will surely die. A passer-by offers to drive you into town for $100. You don't have the money on you, and you are a perfectly selfish person who acts only as will best further their interests. So you know that once you get back to town you will refuse to pay your rescuer, as there would then be no downside for you. Unfortunately, you're also a terrible liar, and no matter how you promise, your potential rescuer believes (correctly) that you won't pay him. And so you are left in the desert to die.[^Parfit]

[^Parfit]: This example comes from Parfit's *Reasons and Persons* - Parfit was one of the first moral philosophers to discuss the kind of "rational irrationality" that we're talking about here.

In this case, being able to precommit to paying the passer-by, even though once you get back to town such an action would be sub-optimal for you, is an extremely good idea, if you can manage it! Indeed, arguably one of the useful features of social norms in favour of keeping your promises is that it helps us negotiate this kind of situation.[^TDT] 

[^TDT]: 
    The problem with precommitments is that they need to be made beforehand. They often don't work if you're already facing the situation (or worse, if the other guy commits before you do!). We might then wonder if there's any way to reap the amazing benefits of precommitments without having to know what's coming. We could try and work out lots of general precommitments that we could make, which is hard. Or we could just make a *fully general* precommitment: say something like "I will always act in the way that I would like to have precommitted to act". If you can truly precommit in this way, then you can come out on top in a whole bunch of tricky situations.

    It's no coincidence that the slogan I've given you for making general precommitments is one of the informal ways of understanding what's going on with TDT, a decision procedure invented by Eliezer Yudkowsky for dealing with these kinds of problems. 

## Moral philosophy

In modern discussions about consequentialism, much ink has been spilt worrying about what consequentialist agents would be like. In particular, it seems like a "perfect" consequentialist agent (one who always tried to act so as to maximize the good) would be a bit of a dick. Constantly calculating whether the consequences of one's actions are optimal sometimes seems like fundamentally the wrong attitude to take, particularly in many human relationships. It seems hard to see how such a person could, for example, really be in *love*. ("I nearly got you a birthday present, darling, but then I realised the money would do more good if I sent it to starving children in Africa"). Even if there were no morally overriding constraints, such a person might just be constitutionally incapable of loving. ("I decided nobody else needed the money more, so I actually bought you a present!") This seems bad! [^BW]

[^BW]: This kind of argument is usually sourced from Bernard Williams (AKA the most overrated philosopher ever), and is often phrased in terms of "integrity". The classic consequentialist response is Raliton's *Alienation, Consequentialism and the Demands of Morality*.

Again, there are a couple of ways in which being such an agent could lead to bad consequences. Firstly, calculating consequences is hard, and can be slow or just downright intractable. There are times when the best thing to do is act swiftly, and an agent with a simple dispostion to do so would be better overall than one who calculated. For example, taking the time to calculate whether it is worth saving a drowning person may simply result in them dying. In this case adopting a simple heuristic - save people where there's trivial inconvenience - may lead to much better outcomes in general.

On the other hand, 


 









And behind all logic and its seeming sovereignty of movement, there are valuations, or to speak more plainly, physiological demands, for the maintenance of a definite mode of life For example, that the certain is worth more than the uncertain, that illusion is less valuable than "truth"...

 The falseness of an opinion is not for us any objection to it: it is here, perhaps, that our new language sounds most strangely. The question is, how far an opinion is life-furthering, life-preserving, species-preserving, perhaps species-rearing...



