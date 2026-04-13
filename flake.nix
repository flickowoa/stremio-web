{
  description = "Dev shell for stremio-web with pnpm and Node.js 20";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      
      # Helper to generate an attrset for each system
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in {
          # Define the 'default' shell for each system
          default = pkgs.mkShell {
            buildInputs = [
              pkgs.nodejs_20
              pkgs.nodePackages.pnpm # Recommended way to grab pnpm
              pkgs.git
            ];

            shellHook = ''
              echo "🚀 Entering stremio-web dev shell"
              echo "Node version: $(node -v)"
              echo "pnpm version: $(pnpm -v)"
            '';
          };
        });
    };
}