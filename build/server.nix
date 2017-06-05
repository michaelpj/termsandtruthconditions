{
  network.description = "michaelpj.com";

  blog = 
    { config, pkgs, ... }:
    {
      services.nginx = {
        enable = true;

        # Redirect non-www to www
        # Note: doesn't do anything when deployed to testing
        virtualHosts."michaelpj.com" = { 
          extraConfig = "return 301 $scheme://www.michaelpj.com$request_uri;";
        };

        virtualHosts."www.michaelpj.com" = { 
          # This makes things work nicely when we're not deployed to the real host, so
          # hostnames don't match
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
