#! /usr/bin/env bash
pushd ..
nix-shell -p bundler --command "bundler update && bundler package --path /tmp/vendor/bundle"
popd
$(nix-build '<nixpkgs>' -A bundix)/bin/bundix --lockfile=../Gemfile.lock
