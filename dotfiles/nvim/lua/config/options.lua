-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {
          cmd_env = {
            DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "1",
          },
        },
      },
    },
  },
}
