# Reference https://discourse.nixos.org/t/easy-install-pypi-python-packages-mach-nix-poetry2nix/23825/6
{
  description = "IaC using Nix";
  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

  };
  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ]
    (system:
    let
    	pkgs = import nixpkgs {
    	  inherit system;
    	  config.allowUnfree = true;
    	};
    in
    {
      devShells = {
        default = pkgs.mkShell {
          packages = with pkgs; [
            prek
            terraform
            terraform-docs
            alejandra
            checkov
            terraform-ls
          ];
          shellHook = ''
            prek install --install-hooks
          '';
        };
      };
    });
}
