{
  description = "Hack rust-lang.org Script";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let
      version = "0.1.0";
      allSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
        "aarch64-linux" # 64-bit ARM Linux
        "x86_64-darwin" # 64-bit Intel macOS
        "aarch64-darwin" # 64-bit ARM macOS
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      packages = forAllSystems ({ pkgs }: {
        default = pkgs.stdenv.mkDerivation {
          name = "hack-rlo-${version}";
          src = self;
          dontUnpack = true;
          installPhase = ''
            install -m755 -D $src/hack-rlo $out/bin/hack-rlo
          '';
          buildInputs = [ jq curl ];
          meta = {
            description = "Helper script for working on rust-lang/rust";
          };
        };
      });
      devShells = forAllSystems ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            jq curl
          ];
        };
      });
    };
}
