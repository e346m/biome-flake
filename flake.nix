{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      version = "1.4.1";
    in
    with pkgs;
    {
      packages.${system}.biome = rustPlatform.buildRustPackage
        rec {
          pname = "biome";
          inherit version;

          src = fetchFromGitHub {
            owner = "biomejs";
            repo = "biome";
            rev = "cli/v${version}";
            hash = "sha256-lzY1Eh1jZixsKi+ObQlhzV4KSV7ZSGPBJtaO9ZiJjEk=";
          };

          cargoHash = "sha256-Hy5UH2VwqboRD+akl1FxBZoXr2+SmVH5Jx0lSAB/P7w=";

          nativeBuildInputs = [
            pkg-config
          ];

          buildInputs = [
            libgit2_1_6
            zlib
          ] ++ lib.optionals stdenv.isDarwin [
            darwin.apple_sdk.frameworks.Security
          ];

          nativeCheckInputs = [
            git
          ];

          useNextest = true;

          cargoBuildFlags = [ "-p=biome_cli" "--release" "--target=x86_64-unknown-linux-gnu" ];
          cargoTestFlags = [ "run" "--workspace" "--verbose" ];

          env = {
            BIOME_VERSION = version;
          };

          preCheck = ''
            # tests assume git repository
            git init

            # tests assume $BIOME_VERSION is unset
            unset BIOME_VERSION
          '';

          meta = with lib; {
            description = "Toolchain of the web";
            homepage = "https://biomejs.dev/";
            changelog = "https://github.com/biomejs/biome/blob/${src.rev}/CHANGELOG.md";
            license = licenses.mit;
            maintainers = with maintainers; [ e346m ];
            mainProgram = "biome";
          };
        };

      defaultPackage.${system} = self.packages.${system}.biome;
    };
}
