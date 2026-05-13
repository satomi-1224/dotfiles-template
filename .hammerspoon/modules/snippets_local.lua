-- modules/snippets_local.lua: マシン固有スニペット

local snippets = require("modules.snippets")

local local_snippets = {
  -- TODO: マシン固有のスニペットを追加
  -- { title = "TwitterID", body = "@yourhandle" },
  -- { title = "mail", body = "your@email.com" },
}

for _, s in ipairs(local_snippets) do
  table.insert(snippets.list, s)
end
