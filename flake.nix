{
  description = "Machine-local dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Global (shared) dotfiles
    dotfiles-global = {
      url = "github:satomi-1224/dotfiles-global";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = inputs@{
    self, nixpkgs, nix-darwin, home-manager,
    nix-homebrew, dotfiles-global, ...
  }:
  let
    system   = "aarch64-darwin";       # TODO: マシンに合わせて変更
    hostname = "HOSTNAME";             # TODO: マシンのホスト名に変更
    username = "USERNAME";             # TODO: ユーザー名に変更
  in
  {
    darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit username; };
      modules = [
        # Global Darwin modules
        dotfiles-global.darwinModules.default

        # Home Manager
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "bak";
          home-manager.users.${username} = {
            imports = [
              dotfiles-global.homeManagerModules.default
              ./nix/home/git.nix
              ./nix/home/packages.nix
            ];
            # マシン固有ファイルを追加配置
            home.file.".hammerspoon/modules/command_launcher_local.lua".source =
              ./files/command_launcher_local.lua;
            home.file.".hammerspoon/modules/snippets_local.lua".source =
              ./files/snippets_local.lua;
            home.file.".config/aerospace/wallpaper_config.sh".source =
              ./files/wallpaper_config.sh;
          };
          nixpkgs.overlays = [
            dotfiles-global.overlays.claude-code
            dotfiles-global.overlays.apm-cli
          ];
          nixpkgs.config.allowUnfreePredicate = pkg:
            builtins.elem (nixpkgs.lib.getName pkg) [ "claude-code" ];
        }

        # nix-homebrew
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            user = username;
            autoMigrate = true;
          };
        }

        # Machine-local Darwin overrides
        ./nix/darwin
      ];
    };
  };
}
