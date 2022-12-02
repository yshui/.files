{
  description = "user profile";

  outputs = { self, nixpkgs }:
    let 
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in with pkgs; {
      packages.x86_64-linux.default = pkgs.buildEnv {
        name = "user-profile";
        paths = [
          nix
          oh-my-posh
          cachix
          nix-tree
          nix-diff
          sumneko-lua-language-server
        ];
      };
    };
}
