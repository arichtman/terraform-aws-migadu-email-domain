# Reference https://discourse.nixos.org/t/easy-install-pypi-python-packages-mach-nix-poetry2nix/23825/6
{
  description = "IaC using Nix";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    poetry2nix,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
    (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        #TODO: Why can't we access inputs.poetry2nix.mkPoetryEnv directly?
        inherit (poetry2nix.legacyPackages.${system}) mkPoetryEnv;
        poetryEnv = mkPoetryEnv {
          projectDir = ./.;
        };
      in {
        devShells.default = with pkgs;
          mkShell {
            nativeBuildInputs = [
              poetryEnv
              terraform
              terraform-docs
              poetry
              alejandra
              checkov
              terraform-ls
            ];
            shellHook = ''
              pre-commit install --install-hooks
            '';
          };
      }
    );
}
