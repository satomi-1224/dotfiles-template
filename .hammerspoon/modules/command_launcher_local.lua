-- modules/command_launcher_local.lua: マシン固有コマンド

local launcher = require("modules.command_launcher")
local home = os.getenv("HOME")

-- TODO: マシン固有のキー→コマンド対応を追加
local local_commands = {
  -- a = "open -a 'SomeApp'",
  -- c = "open '" .. home .. "/Applications/Chrome Apps.localized/SomeApp.app'",
}

for key, cmd in pairs(local_commands) do
  launcher.commands[key] = cmd
end

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
