return {
  "apple/pkl-neovim",
  ft = "pkl",
  build = function()
    require("pkl-neovim").init()
    vim.cmd("TSInstall pkl")
  end,
  init = function()
    vim.g.pkl_neovim = {
      start_command = { "pkl-lsp" },
      pkl_cli_path = "/opt/homebrew/bin/pkl",
    }
  end,
}
