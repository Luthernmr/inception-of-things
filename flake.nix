{
  outputs = { nixpkgs, ... } : let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
  in {
    devShells.${system}.default = pkgs.mkShell {
      name = "iot";
      buildInputs = with pkgs; [ vagrant ];
    };
  };
}
