#! /usr/bin/env bash

rm -f Gemfile.lock
rm -f gemset.nix

# See https://github.com/NixOS/nixpkgs/issues/190084
BUNDLE_FORCE_RUBY_PLATFORM=true nix-shell -p bundler bundix --command "bundler update && bundix -l"
