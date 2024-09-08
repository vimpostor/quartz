{
	description = "A modern Qt Quick library";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
	};

	outputs = { self, nixpkgs }:
	let eachSystem = with nixpkgs.lib; f: foldAttrs mergeAttrs {} (map (s: mapAttrs (_: v: { ${s} = v; }) (f s)) systems.flakeExposed);
	in { lib = { inherit eachSystem; }; } // eachSystem (system:
		let pkgs = nixpkgs.legacyPackages.${system}; in
		{
			packages = {
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
					];
				};
			};
			checks = {
				format = pkgs.runCommand "format" { src = ./.; nativeBuildInputs = [ pkgs.clang-tools pkgs.git ]; } "mkdir $out && cd $src && find . -type f -path './*\\.[hc]pp' -exec clang-format -style=file --dry-run --Werror {} \\;";
			};
		}
	);
}
