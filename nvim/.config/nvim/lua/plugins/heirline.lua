return {
  { "rebelot/heirline.nvim", enabled = false },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local auto = require "lualine.themes.auto"
      local lualine_modes = { "insert", "normal", "visual", "command", "replace", "inactive", "terminal" }
      
      for _, mode in ipairs(lualine_modes) do
        if auto[mode] and auto[mode].c then
          auto[mode].c.bg = "NONE"
        end
      end
      
      return {
        options = {
          theme = auto,
          globalstatus = true,
        },
      }
    end,
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        mode = "buffers",
        show_tab_indicators = true,
        show_buffer_close_icons = true,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "NeoTreeFileName",
            separator = true,
            text_align = "center",
          },
        },
        close_command = "bdelete! %d",
      },
    },
  }
}
