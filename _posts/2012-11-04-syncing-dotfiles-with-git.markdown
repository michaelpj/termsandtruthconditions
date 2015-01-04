---
layout: post
title: "Syncing Dotfiles with Git"
date: 2012-11-04 18:20
comments: true
categories: [programming, git]
---

So I've been using [Vim](http://www.vim.org/) recently for text editing and coding. I'll write a post someday about why, but what really sucked me over from using [Emacs](http://www.gnu.org/software/emacs/) was the awesome way that you can naturally build up commands with a kind of "verb-object" form.

Anyway, part of using an editor like Vim is building up a bunch of settings for your editor: things like remapping Caps Lock (AKA: the least useful key ever) to Esc (which you use *all the time* in Vim). These live in a little file in your home directory called .vimrc.[^dotfiles]

[^dotfiles]: On Unix systems, files beginning with . are hidden.

So naturally, when I fired up Vim at work and started writing, the first thing I get is

    Look at me writing some text!
    :WQ
    ::asd;lfsgihaspoihtasdophif

{% img center /images/rageface.png %}

Suddenly, muscle memory is no longer your friend.

<!-- more -->

Okay, but we have ways of dealing with this kind of thing. Want to keep a repository of stuff that you can pull down anywhere: this calls for Git!

Looking around the internet, I'm obviously not the first person to think of this. Broadly speaking there seem to be two ways of going about it:

1. Initialise a Git repo in ~, but set it to ignore everything except your precious dotfiles.
2. Put your repo in a subfolder, say ~\dotfiles, and then symlink them to your home directory.

Solution 1. has problems. Firstly, there are issues with getting .gitignore set up right, but these seem to be surmountable. More worrying is from then on you can run git commands in any subfolder of your home directory and have them *do things* unexpectedly. This seems pretty bad.

Solution 2. is nicer in that respect, but it does require you to faff around with symlinks. Fortunately, even Windows can do symlinks these days, so it's not that bad. I decided to go with this in the end.

The final pillar, of course, is hosting your Git repository somewhere you can get at it, and so mine is [here](https://github.com/michaelpj/dotfiles). The repository actually also contains my Vim plugins: these are pretty portable, so can happily live in there too.

And that's it, no more rageface. 

