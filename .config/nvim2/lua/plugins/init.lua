for _, name in ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. "/lua/plugins")) do
  local mod = name:match("(.+)%.lua$")
  if mod and mod ~= "init" then
    require("plugins." .. mod)
  end
end
