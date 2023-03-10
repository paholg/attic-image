{
  description = "Docker image with attic";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    attic.url = "github:zhaofengli/attic";
  };

  outputs = inputs: with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs {
        inherit system;
        overlays = [ attic.overlays.default ];
      };
      in
      {
        packages.default = pkgs.dockerTools.buildImage {
          name = "attic";
          tag = "latest";

          copyToRoot = pkgs.buildEnv {
            name = "image-root";
            paths = [
              pkgs.attic
              pkgs.nix

              pkgs.bashInteractive
              pkgs.coreutils-full
              pkgs.gnutar
              pkgs.gzip
              pkgs.gnugrep
              pkgs.which
              pkgs.curl
              pkgs.less
              pkgs.wget
              pkgs.man
              pkgs.cacert.out
              pkgs.findutils
            ];
          };

          runAsRoot = ''
            #!${pkgs.runtimeShell}
            ${pkgs.dockerTools.shadowSetup}
            mkdir -p /etc/nix
            echo "experimental-features = flakes nix-command" >> /etc/nix/nix.conf
          '';

          config = {
            Cmd = [ "/bin/sh" ];
            User = "root";
          };

          created = "now";
        };
      });
}
