{
  perSystem =
    { config, pkgs, ... }:
    {
      pre-commit.settings = {
        hooks = { };
        default_stages = [
          "pre-commit"
          "pre-push"
        ];

        excludes = [ ];
      };
    };
}
