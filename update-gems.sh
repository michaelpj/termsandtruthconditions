#! /usr/bin/env bash
nix-shell -p bundler --command "bundler update && bundler package --path /tmp/vendor/bundle"
$(nix-build '<nixpkgs>' -A bundix)/bin/bundix --lockfile=Gemfile.lock
