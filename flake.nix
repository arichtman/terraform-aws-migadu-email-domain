# Reference https://discourse.nixos.org/t/easy-install-pypi-python-packages-mach-nix-poetry2nix/23825/6
{
  description = "IaC using Nix";
  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.uv2nix.follows = "uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    uv2nix,
    pyproject-nix,
    pyproject-build-systems,
    ...
  } @ inputs:
    flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
    (system:
    let
    # Ref: https://github.com/FerranAD/simple-uv2nix
      inherit (nixpkgs) lib;

      # Load a uv workspace from a workspace root.
      # Uv2nix treats all uv projects as workspace projects.
      workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ./.; };

      # Use Python 3.12 from nixpkgs
      python = pkgs.python312;

    	pkgs = import nixpkgs {
    	  inherit system;
    	  config.allowUnfree = true;
    	};

      overlay = workspace.mkPyprojectOverlay {
        sourcePreference = "wheel";
      };
      baseSet = pkgs.callPackage inputs.pyproject-nix.build.packages {
        inherit python;
      };
      pythonSet = baseSet.overrideScope (
        pkgs.lib.composeManyExtensions [
          inputs.pyproject-build-systems.overlays.default
          overlay
        ]
      );
      venv = pythonSet.mkVirtualEnv "venv" workspace.deps.all;
    in
    {
      devShells = {
        default = pkgs.mkShell {
          packages = [
            python
            venv
            pkgs.uv
            pkgs.terraform
            pkgs.terraform-docs
            pkgs.alejandra
            pkgs.checkov
            pkgs.terraform-ls
          ];
          env =
            {
              # Don't create venv using uv
              UV_NO_SYNC = "1";

              # Prevent uv from managing Python downloads
              UV_PYTHON_DOWNLOADS = "never";
              # Force uv to use nixpkgs Python interpreter
              # UV_PYTHON = python.interpreter;
            }
            // lib.optionalAttrs pkgs.stdenv.isLinux {
              # Python libraries often load native shared objects using dlopen(3).
              # Setting LD_LIBRARY_PATH makes the dynamic library loader aware of libraries without using RPATH for lookup.
              LD_LIBRARY_PATH = lib.makeLibraryPath pkgs.pythonManylinuxPackages.manylinux1;
            };
          shellHook = ''
            unset PYTHONPATH
            # Get repository root using git. This is expanded at runtime by the editable `.pth` machinery.
            export REPO_ROOT=$(git rev-parse --show-toplevel)
            pre-commit install --install-hooks
          '';
        };

      };
    });
}
