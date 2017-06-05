---
title: Linear preferences and Pascal's Wager
layout: post
date: 2015-04-08 23:49
tags: [philosophy, maths]
---

Expected value is the de-facto standard way of extending preferences over outcomes
to preferences over choices under uncertainty. If you have some cardinal-valued
valuation of outcomes, then you just multiply that by the probability and 
you have the expected value of the choice.

That's great and all, but it's philosophically interesting to think about
whether we need to *directly* justify preferring choices with higher expected value, 
or whether we can deduce it from a simpler set of axioms.

I want to focus here on a claim that I think I heard Amanda MacAskill
make[^cite]: if you accept "dominating" improvements as preferable, you also
have to prefer improvements in expected value.

[^cite]: 
    It was in the context of Pascal's Wager, although her
    [post](http://www.amandamacaskill.com/pascals-wager/) on the topic doesn't
    use it or the argument I make below.

<!-- more -->

By a "dominating" improvement, I mean one where either the probability or the
utility of the other choice is strictly greater, and the other is no worse. So a
coin flip with a chance of winning £5 would be preferable to a coin flip where
you could win £1; as would simply being given £1.

I think we can actually prove a very similar claim. First, we need to make
sure we're doing cardinal comparisons, not just ordinal ones. So let us assume
that we have a utility funtion $u$ over outcomes, and that the probability of
an outcome is given by $p$.  Furthermore, suppose that the preferability of a
choice depends only on its utility and probability. Then we are looking for
some function $V(X) = v(u(X), p(X))$ which encodes the preferability of
choices, with the implication that if $V(A) = 2 \cdot V(B)$ then $A$ is *twice
as preferable* as $B$.

Then I claim that if $V(X)$ depends linearly and positively on $u(X)$ and $p(X)$
("linear preferences") then 
$$V(X) = EV(X) = u(X) \cdot p(X)$$ 
That is, expected value is the unique function consistent with your preferences.

(We also need an uncontroversial boundary condition: if $p(X) = 0$ or
$u(X) = 0$, then $V(X) = 0$.)

## The maths

*Warning: light calculus ahead.*

We want to show $v(u, p) = u \cdot p$.

We can formalise the antecedent of the claim as follows: the partial deriviatives of
the valuation function with respect to the utility axis and the probability axis
are constant, i.e.
\begin{equation}
  \frac{\partial v}{\partial u} = f(p)
\end{equation}
\begin{equation}
  \frac{\partial v}{\partial p} = g(u)
\end{equation}
where $f$ and $g$ are functions.[^functions]

[^functions]:
    The right hand sides need to be functions because 
    although the slope is constant for a given $p$ or $u$, it may still vary.

And the boundary conditions:
$$v(0, u) = 0$$
$$v(p, 0) = 0$$

Integrating equation 1 with respect to $u$ and equation 2 with respect to $p$, we get
\begin{equation}
  v(u, p) = f(p)\cdot u + \phi(p)
\end{equation}
\begin{equation}
  v(u, p) = p \cdot g(u) + \psi(u)
\end{equation}
where $\phi$ and $\psi$ are differentiable functions.

Using our boundary conditions, it is clear that
$$0 = v(0, p) = \phi(p)$$
and
$$0 = v(u, 0) = \psi(u)$$

So we can eliminate $\phi$ and $\psi$ from equations 3 and 4, giving us
$$f(p) \cdot u = p \cdot g(u)$$
which implies that $f(p) = p$ and $g(u) = u$. Hence $v(u, p) = u \cdot p$
which is precisely the expected value formula.

## Philosophical implications

If we can recover expected value from linear preferences, then that means we
can take the latter as the prior notion without having to give up expected
value. But linear preferences actually distinguish some cases
that expected value doesn't - not in the finite case, but in the infinite case.
That's interesting for philosophical questions that involve infinite
utilities (e.g. Pascal's wager).

In particular, if $u(A) = u(B) = C$ is an infinite cardinal, then
no matter what $p(A)$ and $p(B)$ are, the expected values will be the same
($C$). That means that the expected value of being a Christian
and being an atheist are the same - both have *some* chance of getting you into
heaven (infinite utility!), and so they have identical expected values.

However, if $p(A) > p(B)$ then $A$ *dominates* $B$ in probability, and so we
should prefer it if we have linear preferences. That means the Pascalian can
prefer being a Christian over being an atheist, on the grounds that it is *more
likely* to get them into heaven.

So if you're a Pascalian looking to avoid some of the stranger implications of
accepting the validity of the wager, consider arguing for linear preferences
over expected value!
