# dotfiles

マシン固有の dotfiles。共通設定は [dotfiles-global](https://github.com/satomi-1224/dotfiles-global) を Flake input として参照。

## 構成

```
flake.nix                          dotfiles-global を input で参照し darwinConfigurations を定義
nix/
  darwin/default.nix               マシン固有の homebrew casks 等
  home/git.nix                     マシン固有の git user.name / user.email
  home/packages.nix                マシン固有の追加パッケージ
.hammerspoon/
  modules/command_launcher_local.lua   マシン固有のコマンドランチャー
  modules/snippets_local.lua           マシン固有のスニペット
.config/
  aerospace/wallpaper_config.sh    マシン固有の壁紙マッピング
```

各ファイルは `flake.nix` の `home.file` で Home Manager がシンボリックリンクを作成する。

## セットアップ

### 1. Nix のインストール

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 2. このリポジトリをクローン

```bash
git clone <this-repo> ~/Work/dotfiles
cd ~/Work/dotfiles
```

### 3. マシン固有設定の編集

以下のファイルを自分のマシンに合わせて編集する（`TODO` コメントを検索）:

- `flake.nix` — `hostname`, `username`, `system` を変更
- `nix/home/git.nix` — git の `user.name`, `user.email` を設定
- `nix/darwin/default.nix` — マシン固有の homebrew casks を追加
- `nix/home/packages.nix` — マシン固有の追加パッケージ
- `.hammerspoon/modules/command_launcher_local.lua` — コマンドランチャーのキー割当
- `.hammerspoon/modules/snippets_local.lua` — スニペット
- `.config/aerospace/wallpaper_config.sh` — 壁紙のパス

### 4. ビルド & 適用

```bash
darwin-rebuild switch --flake .
```

dotfiles-global は Flake input (`github:satomi-1224/dotfiles-global`) として自動取得されるため、手動クローンは不要。

### 5. シークレットの設定

```bash
# ~/.secrets に環境変数を記述（zsh 起動時に読み込まれる）
touch ~/.secrets
```

## 更新

```bash
cd ~/Work/dotfiles

# 共通設定 (dotfiles-global) の最新を取り込み
nix flake update dotfiles-global
darwin-rebuild switch --flake .

# 全 input を更新
nix flake update
darwin-rebuild switch --flake .
```

## 共通設定をローカルで編集したい場合

```bash
cd ~/Work/dotfiles

# dotfiles-global をローカルにクローン
git clone git@github.com:satomi-1224/dotfiles-global.git dotfiles-global

# flake.nix の input を一時的にローカルパスに変更
#   url = "github:satomi-1224/dotfiles-global";
#   ↓
#   url = "path:./dotfiles-global";

# 編集 → テスト
darwin-rebuild switch --flake .

# 確認OK → dotfiles-global を push → flake.nix の input を github: に戻す
```

`dotfiles-global/` は `.gitignore` で除外されているため、このリポジトリには含まれない。

## 固有設定の追加方法

- **homebrew cask**: `nix/darwin/default.nix` の `homebrew.casks` に追加
- **git 設定**: `nix/home/git.nix` を編集
- **パッケージ追加**: `nix/home/packages.nix` を編集
- **Hammerspoon コマンド**: `.hammerspoon/modules/command_launcher_local.lua` の `local_commands` テーブルに追加
- **スニペット**: `.hammerspoon/modules/snippets_local.lua` の `local_snippets` テーブルに追加
- **壁紙**: `.config/aerospace/wallpaper_config.sh` を編集
