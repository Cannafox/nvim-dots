return {
  defaults = { lazy = false },
  install = { colorscheme = { "catppuccin" } },
  ui = {
    icons = {
      ft = "",
      lazy = "󰂠 ",
      loaded = "",
      not_loaded = "",
    },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "tohtml",
        "gzip",
        "netrw",
        "netrwPlugin",
        "matchit",
        "tarPlugin",
        "zipPlugin",
        "tutor",
      },
    },
  },
  checker = { enabled = true }
}
