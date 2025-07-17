-- local wezterm = require('wezterm')
local gpu_adapters = require('utils.gpu_adapter')
-- local colors = require('colors.custom')
local tundra = require('colors.tundra')

return {
   animation_fps = 120,
   max_fps = 120,
   front_end = 'WebGpu',
   webgpu_power_preference = 'HighPerformance',
   webgpu_preferred_adapter = gpu_adapters:pick_best(),

   -- color scheme
   colors = tundra,
   -- color_scheme = "Catppuccin Mocha",
   -- color_scheme = 'Everforest Dark (Gogh)',
   -- color_scheme = tundra,

   -- background
   -- background = {
   --    {
   --       source = { File = wezterm.GLOBAL.background },
   --       horizontal_align = 'Center',
   --    },
   --    {
   --       source = { Color = colors.background },
   --       height = '120%',
   --       width = '120%',
   --       vertical_offset = '-10%',
   --       horizontal_offset = '-10%',
   --       opacity = 0.98,
   --    },
   -- },

   -- scrollbar
   enable_scroll_bar = true,

   -- tab bar
   enable_tab_bar = true,
   hide_tab_bar_if_only_one_tab = false,
   use_fancy_tab_bar = false,
   tab_max_width = 25,
   show_tab_index_in_tab_bar = false,
   switch_to_last_active_tab_when_closing_tab = true,

   -- window
   initial_cols = 120,
   initial_rows = 40,
   adjust_window_size_when_changing_font_size = false,
   window_decorations = 'INTEGRATED_BUTTONS|RESIZE',
   integrated_title_button_style = 'MacOsNative',
   integrated_title_button_color = 'auto',
   integrated_title_button_alignment = 'Right',
   window_padding = {
      left = 0,
      right = 0,
      top = 10,
      bottom = 7.5,
   },
   window_close_confirmation = 'AlwaysPrompt',
   window_frame = {
      active_titlebar_bg = '#090909',
      -- font = fonts.font,
      -- font_size = fonts.font_size,
      border_top_height = '0.35cell',
   },
   inactive_pane_hsb = {
      saturation = 0.9,
      brightness = 0.65,
   },
}
