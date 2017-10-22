---
layout: post
title: Zero-knowledge cooperation
tags: [decision theory, security]
---

A lot of ink has been spilled about how to get various decision algorithms to
cooperate with each other. However, most approaches require the algorithm to provide some
kind of information about itself to a potential cooperator.

Consider [FDT](https://arxiv.org/abs/1710.05060), the hot new kid on the block. 
In order for FDT to cooperate
with you, it needs to reason about how your actions are related to the algorithm
that the FDT agent is running. The naive way of providing this information is
simple: give the other agent a copy of your "source code". Assuming that said
code is analyzable without running into halting problem issues, this should
allow FDT to work out whether it wants to cooperate with you.

## Security needs of decision algorithms

However, just handing out your source code to anyone isn't a great idea. This is
because agents often want to pretend to have a different decision algorithm to
the one that they really do.

<!-- more -->

### Threats and capitulation thresholds

Many people adopt some version of the "don't give in to threats" heuristic. The
reasoning here is solid: while refusing to give in to a threat carries a penalty
in the particular instance, being the kind of person who doesn't give in to threats pays
off in the long run because you receive fewer threats.

However, usually this will come with an escape hatch in case the stakes get too
high. If I am trying to extort £100 from you by plausibly threatening to destroy
the planet, *you should just pay the money*. Why is this okay? Well, threats of
higher magnitude are usually harder to create, or carry higher costs for the
threatener, so an agent can expect to face relatively few of them.

The absolute *best* thing for an agent, though, would be to have the reputation
of *never* giving in to threats, no matter how high the cost, while *actually*
being willing to give in to threats above some threshold. That way you never get
threatened, but if by some ill luck you do face an enormous threat, you
can still capitulate. In general, an agent would like their capitulation
threshold to be perceived to be as high as possible, ideally infinity.

It is therefore in an agent's interest to hide their capitulation threshold. If
an adversary finds out what it is, and it's something they can exceed easily,
then they can exploit you, even if they only get one shot at threatening you.

This makes an agent's capitulation threshold a piece of sensitive data, and
keeping it secret is a *security* problem. Obviously just handing our your
source code is right out, but an agent should also take other security
precautions. To give a short list:
- Be cautious about talking about how you make decisions.
- Try to conceal any evidence of occasions when you have capitulated in the past.
- Avoid revealing information about your past behaviour in general, or at least
  follow [glomarization](https://en.wikipedia.org/wiki/Glomar_response) rules.
- Avoid interacting with agents who appear to be probing for sensitive
  information (e.g. escalating threats).[^fail2ban]
  
[^fail2ban]: Even if you have good security procedures you still want to do
    this. You should install fail2ban even if you think SSH is secure.

### All data is sensitive

I've been talking about a capitulation threshold because it's an easy example,
but the history of computer security tells us that leaking *any*
kind of information about your implementation can be dangerous. It's best to
just assume that attackers have magical attack powers and hide as much as you can.

(Aside: what about FDT? Isn't it immune to this kind of exploitation? Sure, but
you're not going to be running FDT, you're going to be running some approximation to it. 
Imagine an agent running FDT-approx, which spends N cycles computing an approximation to FDT,
then acts on that. The value of N is then sensitive data - knowing that could
allow an adversary to construct a situation just complicated enough to lead to
poor behaviour without being too costly to construct.)

But if we are operating in a context where revealing information about how we work
is dangerous, how are we supposed to reveal enough about ourselves to be able to
cooperate effectively?

## Zero knowledge cooperation

We can borrow some ideas from security to help us here. Suppose that A wishes to
convince B that they are likely to cooperate in an upcoming game. What A *actually* wants
to convey to B is that precise fact: they are likely to cooperate. Ideally they
would reveal no other knowledge at all. What we want is a *zero-knowledge proof* 
of A's willingness to cooperate.

This seems like it could be a whole subfield of work, but here are a few suggestions.

### Private histories

One way for A provide evidence that they are likely to cooperate is to provide
historical evidence that they cooperated in similar situations in the past.
However, this is sensitive information, so ideally they would like it
not to be public.

So let's suppose that after a game has played out, the results are made public,
but identifying each agent with a unique token, for which they can provide a
[zero-knowledge proof of ownership](https://en.wikipedia.org/wiki/Zero-knowledge_proof#Discrete_log_of_a_given_value).

Thus A can reveal that they were a participant in a previous game,
providing evidence towards their future actions, but without providing this
knowledge to anyone except B.

### Secret source-code sharing

The most convincing evidence A could provide would be a copy of its source
code.[^running] However, they don't want B to *end up* with that, but only the derived
information that it "looks trustworthy".

[^running]: There is, of course, the small matter of proving that the source
    code you provided is the code you're actually running, but this is
    independent of the security problem.

To that end we can run the following protocol.[^protocol]

[^protocol]: This protocol actually allows B to extract one bit of information
    of any kind from A's secret data, so could be used for other purposes too.
    As far as I know it's novel.

First, A provides B with a copy of A's source code, encrypted using A's secret
key and a [fully
homomorphic](https://en.wikipedia.org/wiki/Homomorphic_encryption#Fully_homomorphic_encryption) 
encryption scheme.[^expensive] Then B runs (homomorphically) a
program (the Validator) on the source code that validates a property (in this case
"trustworthiness"), and outputs 0 or 1 depending on whether the property holds.
Crucially, the Validator also *signs* this output with B's secret key.

[^expensive]: FHE is prohibitively expensive to perform at the moment, but we're
    looking for a possibility proof here. Yes, I'm using a very large hammer to
    crack this nut.

Now what B actually receives is an encrypted version of the Validator's
output, so B has to return this to A for decryption. A can validate that the decrypted
response matches an agreed upon pattern (is 0 or 1, not, say, the full source code), in
which case they pass it back to B, along with the signature. Since A cannot
forge B's signature, B trusts that this really is the output of the
Validator.

I *think* this is a zero-knowledge proof, since B cannot replicate the process
for someone else without having A's secret key, and a log of the transactions
does not rule out B having provided A with the response beforehand. Informally,
the "surprising" part of the protocol is A producing a token with B's signature,
but this is only surprising to B, and could be easily faked for a third part if
A and B were colluding.

## Conclusion

I think the situation looks surprisingly good here. A cautious agent should be
able to get by with revealing the minimum amount of information about itself.
The biggest problem is the currently prohibitive cost of FHE, but I'm optimistic
that that will come down over time.
