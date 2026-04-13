{
  description = "Dev shell for stremio-web with pnpm and Node.js 20";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
      makeShell = system: let
        pkgs = import nixpkgs { inherit system; };
      in pkgs.mkShell {
        buildInputs = [
          pkgs.nodejs-20_x
          pkgs.pnpm
          pkgs.git
        ];
        shellHook = ''
          echo "Entering stremio-web dev shell with pnpm and Node.js 20"
        '';
      };
    in {
      devShells = builtins.listToAttrs (map (system: {
        name = system;
        value = makeShell system;
      }) systems);
    };
