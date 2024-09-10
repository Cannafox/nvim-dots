local M = {
  "norcalli/nvim-colorizer.lua",
  event = "User FilePost",
  opts = {
    RGB = true,
    RRGGBB = true,
    names = true,
    RRGGBBAA = true,
    rgb_fn = true,
    mode = "background"
  },
  config = function(_, opts)
    require("colorizer").setup({'*'}, opts)
  end
}

return { M }
