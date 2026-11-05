-- marksman is .NET; NixOS has no system ICU, so run it without globalization
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
