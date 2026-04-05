-- modules/command_launcher_local.lua: マシン固有コマンド

local launcher = require("modules.command_launcher")
local home = os.getenv("HOME")

-- TODO: マシン固有のコマンドランチャーを設定
-- キーとアプリの対応を定義する
-- launcher.commands.a = "open -a 'SomeApp'"
-- launcher.commands.c = "open '" .. home .. "/Applications/Chrome Apps.localized/SomeApp.app'"

-- 修飾キー+Enter: MagicBoard トグル
hs.hotkey.bind(launcher.mods, "return", function()
  local output = hs.execute("pgrep -f MagicBoard", true)
  if output and output:match("%d+") then
    hs.execute("pkill -f MagicBoard", true)
  else
    local path = home .. "/Work/dotfiles/magicboard/MagicBoard"
    hs.task.new(path, nil):start()
  end
end)
