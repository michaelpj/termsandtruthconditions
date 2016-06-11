{ bundlerEnv, ruby }:

bundlerEnv {
  name = "good-technology-project";

  inherit ruby;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;
}
