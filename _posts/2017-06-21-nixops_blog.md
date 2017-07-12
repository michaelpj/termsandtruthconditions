---
title: Deploying this blog with NixOps
---


This blog has been built with [Nix](https://nixos.org/nix/) for some time, but
the _deployment_ of the blog has been a hand-written shell script that just
rscny'd the files across to a VPS. How quaint.

I was bored and looking for a reason to try it out, so now all the deployment
happens with [Nixops](https://nixos.org/nixops/), which is really quite nice.

<!-- more -->

Here's the file that defines the server that it's hosted on (`michaelpj.com`):

{% highlight nix %}
{
  network.description = "michaelpj.com";

  blog = 
    { config, pkgs, ... }:
    {
      services.nginx = {
        enable = true;

        # I don't know what I'm doing, so recommendations seem good
        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;

        # Redirect non-www to www
        # Note: doesn't do anything when deployed to testing
        virtualHosts."michaelpj.com" = { 
          extraConfig = "return 301 $scheme://www.michaelpj.com$request_uri;";
        };

        virtualHosts."www.michaelpj.com" = { 
          # This makes things work nicely when we're not deployed to the 
          # real host, so hostnames don't match
          default = true;

          locations."/blog" = {
            alias = pkgs.callPackage ../blog/build/default.nix {};
          };
          locations."/.well-known" = {
            alias = ../well-known;
          };

          extraConfig = "rewrite ^/$ /blog redirect;";
        };
      };

      networking.firewall.allowedTCPPorts = [ 80 ];
    };
}
{% endhighlight %}

This is pretty straightforward.
- Turn on nginx
- Set up two virtual hosts:
    - `michaelpj.com` redirects to `www.michaelpj.com`
    - `www.michaelpj.com` is the actual website
- `/blog` points to the output of the blog derivation, which is the static site 
  (note that this is actually a directory in the Nix store!)
- `/.well-known` points to the `.well-known` folder (again, this will be copied
  into the Nix store)
- We put in a redirect from `/` to `/blog`
- Oh, make sure that we open a firewall port for HTTP traffic

The nice thing about this is that I can then deploy it to multiple 
backends transparently. I have a simple virtualbox backend set up:

{% highlight nix %}
{
  blog = 
    { config, pkgs, ... }:
    {
      deployment.targetEnv = "virtualbox";
      deployment.virtualbox.memorySize = 1024; # megabytes
      deployment.virtualbox.vcpu = 2; # number of cpus 
    };
}
{% endhighlight %}

This will create a single VM running the blog. This doesn't work *quite* as well
as I'd like, because the VM obviously doesn't have the right hostname, so
redirects don't work well. However, making the `www.michaelpj.com` virtual host
the default makes this work in practice.

The other backend is on [Vultr](https://www.vultr.com/).
{% highlight nix %}
{
  blog = 
    { config, pkgs, ... }:
    {
      imports = [ ./configuration.nix ];
      deployment.targetHost = "104.238.170.56";
    };
}
{% endhighlight %}

This is pretty bare-bones, since there isn't a proper Vultr backend yet, so 
it's using the "none" backend to talk to an existing NixOS machine. 
That is, NixOps isn't going to be creating and destroying the VM, I did that
manually and NixOps just manages its configuration.

The sum total of this is quite nice. I have two deployments set up:
```
nixops create server.nix virtual.nix -d testing
nixops create server.nix vultr.nix -d production
```

Now I can test out any changes to the site with `nixops deploy -d testing`, and
do an actual deploy with `nixops deploy -d production`. And of course I get
atomic rollbacks for free with `nixops rollback`.

Complete overkill for a simple static blog? Sure. I'm not really making use of
the ability to manage the creation of machines (except for the local VMs), and
I'm not deploying multiple machines. But it's still pretty nice.

