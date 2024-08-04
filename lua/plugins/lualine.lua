local utils = require("lualine.utils.utils")
local highlight = require("lualine.highlight")
local diagnostics_message = require("lualine.component"):extend()

diagnostics_message.default = {
  colors = {
    error = utils.extract_color_from_hllist(
      { "fg", "sp" },
      { "DiagnosticError", "LspDiagnosticsDefaultError", "DiffDelete" },
      "#e32636"
    ),
    warning = utils.extract_color_from_hllist(
      { "fg", "sp" },
      { "DiagnosticWarn", "LspDiagnosticsDefaultWarning", "DiffText" },
      "#ffa500"
    ),
    info = utils.extract_color_from_hllist(
      { "fg", "sp" },
      { "DiagnosticInfo", "LspDiagnosticsDefaultInformation", "DiffChange" },
      "#ffffff"
    ),
    hint = utils.extract_color_from_hllist(
      { "fg", "sp" },
      { "DiagnosticHint", "LspDiagnosticsDefaultHint", "DiffAdd" },
      "#273faf"
    ),
  },
}

function diagnostics_message:init(options)
  diagnostics_message.super:init(options)
  self.options.colors = vim.tbl_extend("force", diagnostics_message.default.colors, self.options.colors or {})
  self.highlights = { error = "", warn = "", info = "", hint = "" }
  self.highlights.error = highlight.create_component_highlight_group(
    { fg = self.options.colors.error },
    "diagnostics_message_error",
    self.options
  )
  self.highlights.warn = highlight.create_component_highlight_group(
    { fg = self.options.colors.warn },
    "diagnostics_message_warn",
    self.options
  )
  self.highlights.info = highlight.create_component_highlight_group(
    { fg = self.options.colors.info },
    "diagnostics_message_info",
    self.options
  )
  self.highlights.hint = highlight.create_component_highlight_group(
    { fg = self.options.colors.hint },
    "diagnostics_message_hint",
    self.options
  )
end

function diagnostics_message:update_status(is_focused)
  local r, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local diagnostics = vim.diagnostic.get(0, { lnum = r - 1 })
  if #diagnostics > 0 then
    local diag = diagnostics[1]
    for _, d in ipairs(diagnostics) do
      if d.severity < diag.severity then
        diagnostics = d
      end
    end
    local icons = { "! ", " ", " ", "? " }
    local hl = { self.highlights.error, self.highlights.warn, self.highlights.info, self.highlights.hint }
    return highlight.component_format_highlight(hl[diag.severity]) .. icons[diag.severity] .. " " .. diag.message
  else
    return ""
  end
end

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function()
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      local icons = LazyVim.config.icons

      vim.o.laststatus = vim.g.lualine_laststatus

      local opts = {
        options = {
          theme = "auto",
          globalstatus = vim.o.laststatus == 3,
          disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },

          lualine_c = {
            LazyVim.lualine.root_dir(),
            {
              "diagnostics",
            },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { LazyVim.lualine.pretty_path() },
          },
          lualine_x = {
            -- stylua: ignore
            {
              diagnostics_message,
              colors = { error = "#BF616A", warn = "#EBCB8B", info = "#A3BE8C", hint = "#88C0D0" },
            },
            {
              function()
                return require("noice").api.status.command.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.command.has()
              end,
              color = function()
                return LazyVim.ui.fg("Statement")
              end,
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = function() return LazyVim.ui.fg("Constant") end,
            },
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = function() return LazyVim.ui.fg("Debug") end,
            },
            -- stylua: ignore
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = function() return LazyVim.ui.fg("Special") end,
            },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            function()
              return " " .. os.date("%R")
            end,
          },
        },
        extensions = { "neo-tree", "lazy" },
      }

      -- do not add trouble symbols if aerial is enabled
      -- And allow it to be overriden for some buffer types (see autocmds)
      if vim.g.trouble_lualine and LazyVim.has("trouble.nvim") then
        local trouble = require("trouble")
        local symbols = trouble.statusline({
          mode = "symbols",
          groups = {},
          title = false,
          filter = { range = true },
          format = "{kind_icon}{symbol.name:Normal}",
          hl_group = "lualine_c_normal",
        })
        table.insert(opts.sections.lualine_c, {
          symbols and symbols.get,
          cond = function()
            return vim.b.trouble_lualine ~= false and symbols.has()
          end,
        })
      end

      return opts
    end,
  },
}
