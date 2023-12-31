## Biome

[website](https://biomejs.dev/)

Biome is a performant toolchain for web projects, it aims to provide developer tools to maintain the health of said projects.

Biome is a fast formatter for JavaScript, TypeScript, JSX, and JSON that scores 97% compatibility with Prettier.

Biome is a performant linter for JavaScript, TypeScript, and JSX that features more than 170 rules from ESLint, TypeScript ESLint, and other sources. It outputs detailed and contextualized diagnostics that help you to improve your code and become a better programmer!

Biome is designed from the start to be used interactively within an editor. It can format and lint malformed code as you are writing it.


## Example usage
```nix
# This example is only for x86_64-linux; adjust for your own platform
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    biome-flake.url = "github:e346m/biome-flake";
  };

  outputs = { self, nixpkgs, biome-flake }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    with pkgs;
    {
      devShell.x86_64-linux = mkShell
        {
          buildInputs = [
            nodejs_18
            yarn
            biome-flake.packages.${system}.biome
          ];
        };
    };
}
```
