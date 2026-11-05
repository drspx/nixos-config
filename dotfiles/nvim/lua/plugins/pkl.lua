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
      pkl_cli_path = vim.fn.exepath("pkl"), -- works on mac (brew) and nixos
    }
  end,
}
