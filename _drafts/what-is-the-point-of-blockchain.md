---
layout: post
title: What the fuck is the point of blockchain?
---

_Note: much ink has been spilled on this topic, and I do not claim to be original. But I wanted to write down my perspective on this, if nothing else so I can stop explaining it to people._

Seriously, what is the point of blockchain?
What is it for?
What value does it provide?

## The positive case

The simplest positive case for blockchain technology comes from the observation that they give us a _new capability_.
This can be a big deal!
Cryptographic advances that give us new capabilities have been very important in the past.

I find it helpful to compare with an unquestionably useful technology: public key cryptography.
Public key cryptography lets me publicly advertise a piece of information which you can use to encrypt a message that only I can decrypt.
This is incredibly useful and foundational tool that is used throughout the internet.[^more-to-public-key]

[^more-to-public-key]: There's a bit more to it than that, but we'll get to that later.

It's also, in my opinion, magic.
I think it's genuinely non-obvious that public-key crypto should even be _possible_.
If you went back and told my teenage self that it was proven to be impossible, I would probably have believed you - it just doesn't sound like the sort of thing that should necessarily be doable.
It's like one of those magic tricks where the magician pulls your card out of a hat, 
except in this case the magician can sit down and explain with basic mathematics how your card somehow moved from your hand to their hat.

Blockchains give us the abilities for two parties to coordinate in evolving some shared state in a without requiring a centralizing party to keep everyone honest.
That's pretty cool, and seems like it _ought_ to be useful.
It's not that complicated either, the original Bitcoin paper is only 11 pages and is very readable, relying only on pretty basic mathematics and cryptography.

So it seem like we've found a new technology that gives us a decent amount of utility, but without too much complexity.

## Problems, solutions, complexity

Okay, but: doesn't Bitcoin (and proof-of-work blockchains in general) waste a huge amount of energy?
Yes it does!

Bitcoin has, in fact, quite a lot of problems.
It's not at all obvious how to solve them, which means that many people have gone off in many different directions.
What is common to essentially all "later generation" blockchains is that they are _hugely more complex_.

Consider Cardano, which is (in my opinion) a pretty well-designed system:
all the design work is written up properly and published in peer-reviewed journals;
security properties are actually proved; etc.

Just the _latest_ change to the underlying Ouroboros protocol is 25 pages. 
The original Ouroboros paper is about 60, and there have been several in-between.
Cardano is _enormously_ more complex than Bitcoin, and a lot of that is just trying to deal with the problems of Bitcoin (switching to proof-of-stake; defusing various different kinds of attack; improving throughput).
Apart from the disappointing lack of elegance, this also implies that the system is going to be expensive to maintain and develop.
Indeed Cardano has quite some number of highly paid (and skilled!) developers working on it, which it turns out is only enough to move at a moderately slow pace.

So we our current options are low-complexity-low-utility in the form of Bitcoin, or very-high-complexity-slightly-better-utility in the form of something like Cardano.
This is not the deal that we want!

## Sharp edges are not good for humans

## The penumbra of shit

So what are people actually doing on blockchains?
I claim that most blockchains quickly get two large populations of users, but that they tend to not really be performing meaningful economic activity.
Those groups are:

1. Artificial scarcity grifters
2. Derivative service providers

### Artificial scarcity

Artificial scarcity is where you create a new kind of resource which is scarce by design.[^original-meaning]
Scarce resources often have inflated prices, since there is competition to own them. 
Hence there is an incentive to make things artificially scarce, and we see this all the time: trading cards; video game items; physical art.

[^original-meaning]: I am slightly abusing the original meaning, which is supposed to apply to things that don't _have_ to be scarce, but I think it's interesting to consider things that are necessarily scarce but were deliberately created. There is no way for an original painting not to be scarce, but that scarcity was in a sense created by making the painting.

The inflation of price happens in a few ways. 
Firstly, you might just be very keen to own the thing, and not want to lose out if someone else buys it
Secondly, you might anticipate that other people will be _desperate_ to own the thing in the future, and thus you will be able to sell it for an increased price.
This mechanism lends itself to wild price increases from speculative bubbles: once the price starts going up, people want to buy because the price is going up, which drives the price up. 

It often seems like artificial scarcity performs an economic magic trick. 
It creates value out of nothing: on Tuesday you announce a new limited release of 100 Shiny Toucan cards, and on Thursday they are selling for \\$1000 each.
Surely by normal economic analysis this means that people value having them at least \\$1000, which means you have created \\$100,000 of value for the happy card-holders!

I think it's pretty uncontroversial that this is a massive over-estimate of the real value that people derive due to the distorting effects above.
One way to see this is to imagine that we removed the ability to _re-sell_ the item. 
Do people value the Shiny Toucan cards at \\$1000, even if all they get from that is just the permanent ownership of the card, and not the option to sell into the future speculative bubble? 
I suspect not.[^economist]

[^economist]: I am not an economist and this is an opinion piece. I'm sure there are proper economic analyses of this effect, do send them to me!

Schemes that run on artificial scarcity can collapse.
If, for whatever reason, people lose confidence in the ever-increasing asset price, then the market can quickly go to zero, leaving the last holders of the hot potato taking all the losses.
An artificial scarcity scheme that collapses in this way is pretty much just a Ponzi scheme but without the intermediary payouts: it can sustain itself so long as there is an incoming stream of suckers, but otherwise it collapses and everyone still in it loses their money.

All blockchains rely on some kind of internalized economy in order to make the engine work -- that's part of the magic.
Unfortunately, this immediately provides an artificially scarce asset that brings in speculators.

Even worse, many blockchains provide the ability to make new tokens, usually referred to as NFTs (non-fungible tokens).[^nfts]
NFTs are in principle interesting and useful things, but their other uses are dominated by their tremendous facility for supporting artificial scarcity schemes.
When you issue Shiny Toucan cards in the real world people have to ship them around physically and sell them on sites appropriate to that purpose like eBay.
When you "issue" Shiny Toucan cards on the blockchain you immediately get convenient digital transfer and ownership tracking as well as potentially access to useful derivative services.

[^nfts]: There are lots of different kinds of tokens in fact, but we'll round it off to just NFTs for this discussion.

NFTs are an absolute goldmine for grifters.
You can start almost any project, and then connect it however incidentally to some kind of token that has artificial scarcity and whose price might perhaps increase if your project takes off, and then the magic of human irrationality will take over and you have a decent chance of making a lot of money... so long as you can keep that confidence going.

The artificial scarcity grift is seductive and corrupting:
- Some people will deliberately set out to use it to defraud people of lots of money
- Some people will [unconsciously]({% post_url 2024-03-06-unconscious-scams %}) perform it as part of a possibly-legitimate real project
- Some people will accidentally trigger it as part of a real project and find that it somehow becomes the most valuable thing they are doing

It's also corrupting for the people working on the blockchain itself.
The grifters will show up to your meetups and conferences.
They will talk like sensible business people, and will apparently be very successful.
They may well push up the price of the main assets on the chain, which probably makes you money (which you need to make any progress under your crushing complexity burden).
You might not have any other users.
So it's hard not to embrace them... even if you worry that maybe their product seems a bit like bullshit.

### Derivatives

Any blockchain worth its salt has a vibrant and competitive ecosystem of services offering various kinds of trades ("swaps") with other users.
This is a totally reasonable thing to have!
A legitimate service! 

But is it actually providing much value?
That depends on who is using it.

Our normal financial system has lots of derivative products that are useful for people who are already using the marketplace.
If you are trading in wheat, then wheat futures are useful and valuable.
If nobody is trading in wheat, wheat futures are pointless.

Similarly, a swap system on a blockchain that has a healthy and vibrant userbase is valuable.
A swap system on a blockchain that is mostly occupied by artificial scarcity grifters and their marks is pointless, like offering Shiny Toucan futures.
But it looks like a legitimate business, so we see a lot of people crowding into various complicated derivative products, despite the fact that the underlying activity is mostly just grifters.

{% img /blog/images/miners-shovels.jpg %}

### Is that it?

Some people actually use blockchains to make payments in the real world!
Some people do this for legitimate reasons, including breaking the law where that is a good thing to do (which it sometimes is).
Some people do this for illegitimate reasons, including breaking the law where that is a bad thing to do (like paying to kill people).

Some people claim to be using more advanced features provided by smart contracts to do useful things in the real world, but I am sceptical.

Overall, I don't think there's enough of this to sustain anything close to the value that blockchains currently have.
Which is a problem, since as we've previously discussed they need a huge amount of money to sustain their development and operation given the terrible complexity tradeoffs that they currently face.



