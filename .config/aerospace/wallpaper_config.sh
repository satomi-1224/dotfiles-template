#!/bin/bash
# マシン固有の壁紙マッピング
# TODO: 壁紙ファイルのパスを設定

get_wallpaper() {
  case "$1" in
    1) echo "$HOME/Pictures/wallpapers/wallpaper1.jpg" ;;
    2) echo "$HOME/Pictures/wallpapers/wallpaper2.jpg" ;;
    3) echo "$HOME/Pictures/wallpapers/wallpaper3.jpg" ;;
    4) echo "$HOME/Pictures/wallpapers/wallpaper4.jpg" ;;
    5) echo "$HOME/Pictures/wallpapers/wallpaper5.jpg" ;;
  esac
}
