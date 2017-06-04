{
  network.description = "Blog";

  blog = 
    { config, pkgs, ... }:
    {
      services.nginx = {
        enable = true;
        
        virtualHosts."michaelpj.com" = { 
          root = pkgs.callPackage ./default.nix {};
          extraConfig = "rewrite ^/$ /blog redirect;";
        };
      };

      networking.firewall.allowedTCPPorts = [ 80 ];
    };
}
