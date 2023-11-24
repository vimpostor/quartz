{
	description = "A modern Qt Quick library";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		flake-utils.url = "github:numtide/flake-utils";
	};

	outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
		let
			pkgs = nixpkgs.legacyPackages.${system};
		in {
			packages = rec {
				default = pkgs.stdenv.mkDerivation {
					pname = "quartz";
					version = builtins.head (builtins.match ".*project\\([[:alnum:]]+ VERSION ([0-9]+\.[0-9]+).*" (builtins.readFile ./CMakeLists.txt));

					src = ./.;

					nativeBuildInputs = with pkgs; [
						cmake
						qt6.wrapQtAppsHook
					];

					buildInputs = with pkgs; [
						qt6.qtbase
						qt6.qtdeclarative
						qt6.qtsvg
					];
				};
			};
		}
	);
}
