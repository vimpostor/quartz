{
	description = "A modern Qt Quick library";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
	};

	outputs = { self, nixpkgs }:
	let eachSystem = with nixpkgs.lib; f: foldAttrs mergeAttrs {} (map (s: mapAttrs (_: v: { ${s} = v; }) (f s)) systems.flakeExposed);
	iconResource = p: s: t: p.stdenv.mkDerivation rec {
		name = "quartzIcons" + t;
		fetchurl = builtins.head (builtins.match ".*set\\(QUARTZ_ICONS_ARCHIVE \"([[:alnum:]:/\.-]+)\"\\).*" (builtins.readFile ./src/Quartz/CMakeLists.txt)) + "/MaterialSymbols" + s + "%5BFILL,GRAD,opsz,wght%5D." + t;
		src = builtins.fetchurl {
			url = fetchurl;
			name = "fetchurl";
			sha256 = builtins.head (builtins.match (".*set\\(QUARTZ_ICONS[[:alpha:]_]*_HASH \"([[:alnum:]]{64})\"\\) # " + (if t == "woff2" then s else t) + ".*") (builtins.readFile ./src/Quartz/CMakeLists.txt));
		};
		dontUnpack = true;
		installPhase = "install -D $src $out/" + builtins.baseNameOf fetchurl;
	};
	in {
		lib = rec {
			inherit eachSystem;
			cmakeFlags = { pkgs, icons ? true, iconStyle ? "Outlined"}: nixpkgs.lib.take (if icons then 3 else 1) [("-DFETCHCONTENT_SOURCE_DIR_QUARTZ=" + ./.) ("-DFETCHCONTENT_SOURCE_DIR_QUARTZ_ICONS=" + iconResource pkgs iconStyle "woff2") ("-DFETCHCONTENT_SOURCE_DIR_QUARTZ_CODEPOINTS=" + iconResource pkgs iconStyle "codepoints")]; # patch fetchcontent to work with Nix
			cmakeWrapper = { pkgs, cmakeFile }: cmakeFlags { inherit pkgs; icons = isNull (builtins.match ".*quartz_link\\([^\n]*NO_ICONS.*" (builtins.readFile cmakeFile)); iconStyle = let m = builtins.match ".*quartz_link\\([^\n]*ICON_STYLE \"?(Outlined|Rounded|Sharp).*" (builtins.readFile cmakeFile); in if isNull m then "Outlined" else builtins.head (m ++ ["Outlined"]); };
		};
	} // eachSystem (system:
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
