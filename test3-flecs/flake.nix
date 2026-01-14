{
	description = "test3-flecs";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		utils.url = "github:numtide/flake-utils";
	};

	outputs = { nixpkgs, utils, ... }:
	utils.lib.eachDefaultSystem(system:
		let
			pkgs = import nixpkgs {
				inherit system;
			};
		in {
			devShells.default = pkgs.mkShell {
				buildInputs = [
					pkgs.zig
					pkgs.zls
				];
			};
		}
	);
}
