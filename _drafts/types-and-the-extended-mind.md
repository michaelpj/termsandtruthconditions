---
title: Types and the Extended Mind
---

Lots of arguments about static typing and AOT compilation centre around certain
supposed benefits of these disciplines: correctness, speed, and abstraction.

I want to talk about the *information management* aspects of typing. My thesis
is that any system which allows (and, ideally, requires) you to give the
computer information about what you're doing at development time amounts to
moving some of that information into an automatically managed external storage
system, and that when well done, this can form a valuable part of your extended
mind.

# The extended mind

What do I mean by "the extended mind"? In this case I *don't* mean the
philosophical thesis championed by David Chalmers that sufficiently integrated
information technologies should be considered "a part of our mind". Instead, I
mean the colloquial usage of that term to refer to a system that we offload some portion of our cognition to. In particular,
the goal with the extended mind is to *completely* stop thinking about some
aspect of our lives, freeing our minds up to do something else.

In order to do that, a system has to be:
- Trustworthy.
- Usable as a real-time data source.

For me, the canonical example of this kind of system is an electronic calendar,
so lets see how that fulfills these criteria.

## Trustworthiness

To trust a system it has to tell you only the truth (reliability), and it has to
tell you everything you need to know (completeness).

### Reliability

Having an unreliable memory is a curse. Those of us who have one we often find ourselves
paranoically cross-checking our memories with other evidence to check whether
they make sense.

This is a massive impediment to working. On the other hand, if the system is reliable, then you
don't need to check it and you can just get on with things.

I don't think it's controversial to say that electronic systems (when they
work!) tend to be more reliable at recall than the human mind. If you're me,
they can be a *lot* more reliable. I used to spend a lot of energy making sure
that I didn't forget where I was supposed to be, which was pretty stressful.

Even a paper calendar is a big step up in reliability from keeping all of that in
your head! Electronic calendars mainly win here by being easy to back up and
replicate.

However, no matter how technically robust a system is, it will become unreliable
if it is not updated. So to really run an extended mind system you need to
religiously keep it up to date.

### Completeness

If a system is not complete, then you can't trust it to tell you negative
things. If you haven't entered all your appointments into your calendar, then
when your phone tells you that you have a free hour, that might not be true.

As long as a replacement system is not complete, you have to keep whatever
system is the "source of truth" running. Which is just what we don't want!

This gives us another behavioural component that we need: you have to put
*everything* into your system.

## Working in real time 

Humans are real-time systems. That means that we have to act and respond within
short time spans, often of fixed maximum duration. This puts a limit on how long
we can take to access the information that we need to act. These time spans
vary - it is usually okay to take minutes to access your diary, but it is not
okay to take minutes to come up with your next line in a conversation.

It is also important to be able to act quickly with less than perfect
information. Your friend is leaving the cafe, and you need to suggest a
time to meet *right now* - you need to have some summary information of your schedule
available in your mind so that you can do *something*, even if it's not the best
action.

To abuse a metaphor slightly, we can think of your mind as your L0 cache. It's
super fast, and pretty reliable, but under heavy demand for storing interim results of thoughts (our
"working memory").[^memory]

[^memory]: In fact, we've also got a slower-access, higher capacity storage unit
    in the form of our long-term memory, but for most people its unreliability
    can be a problem.

We'd therefore like to add some higher-capacity caches which we can offload some
of the information storage to.  
    
A paper diary is like a L3 cache - it's reliable, and much higher capacity, but
it's a *lot* slower to access (and that's if you keep it on you the whole time -
if you leave it at home it's more like disk or network access). 
An electronic diary is a lot faster to access. You don't have to page to the
day, and you're probably pretty adept at getting your phone out quickly.

This increased speed manifests itself in having to keep a reduced amount of
information in short-term memroy. When I had a paper diary I would usually memorize my daily schedule, and only actually go to
the diary for checking or entering events in the future. It was just too
annoying to get my diary out every time I wanted to know what I was supposed to
be doing next! So I still had to keep my schedule in my head. Now I have my
diary on my phone I don't even bother doing that. Often my schedule will end up
in my L0 cache anyway, but I don't make any effort to keep it there - it's so
low cost to access my phone that I can entirely offload the business of
remembering what I'm doing next to it.

This is the point where the real payoff of an extended mind system hits. Often
we're unaware of how much of our memory is taken up with managing information of
various kinds. It's a marvellous feeling to realise that you can permanently
de-allocate one of these sections.

## Going further: let the machine do it

"Please schedule me a meeting with James"

This is almost a command you can give today. Calendly will let you specify 

# Programming and the extended mind
 

