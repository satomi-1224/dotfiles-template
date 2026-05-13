{ pkgs, ... }:
{
  # TODO: マシン固有の追加パッケージ
  home.packages = with pkgs; [
    # uv
    # nodejs
  ];
}
