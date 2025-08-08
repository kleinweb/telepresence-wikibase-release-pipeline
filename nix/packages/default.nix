{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        wikibase-cli = pkgs.callPackage ./by-name/wikibase-cli/package.nix { };
      };
    };
}
