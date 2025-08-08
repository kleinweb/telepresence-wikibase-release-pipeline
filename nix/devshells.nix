{
  perSystem =
    {
      config,
      inputs',
      pkgs,
      ...
    }:
    let
      commonPkgs = [
        pkgs.biome
        pkgs.dotenv-linter
        pkgs.fd
        pkgs.gnused
        pkgs.jq
        pkgs.just
        pkgs.moreutils # provides `sponge`
        pkgs.ripgrep
        pkgs.rsync
      ];

      deploymentPkgs = [
        pkgs.awscli2
        pkgs.copilot-cli # https://aws.github.io/copilot-cli/
        pkgs.docker-client
        pkgs.docker-compose
      ];

      developmentPkgs =
        commonPkgs
        ++ deploymentPkgs
        ++ [
          pkgs.csvkit

          config.pre-commit.settings.hooks.markdownlint.package
          config.pre-commit.settings.hooks.yamllint.package

          pkgs.nixfmt-rfc-style # pkgs.nixfmt-rfc-style via overlay
          pkgs.nodePackages.prettier
          pkgs.taplo
          pkgs.treefmt # pkgs.treefmt2 via overlay
        ];
    in
    {
      devShells.default = pkgs.mkShellNoCC {
        shellHook = ''
          : "''${PRJ_BIN_HOME:=''${PRJ_PATH:-''${PRJ_ROOT}/.bin}}"

          export PRJ_BIN_HOME

          ${config.pre-commit.installationScript}
        '';
        nativeBuildInputs = developmentPkgs;
      };

      devShells.ci = pkgs.mkShellNoCC { nativeBuildInputs = commonPkgs; };
    };
}
