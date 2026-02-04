local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ==========================================
-- 1. 基础视觉配置 (主题、字体、窗口)
-- ==========================================
config.color_scheme = 'Dracula (Official)' -- 使用 Dracula 官方主题
config.font = wezterm.font('JetBrainsMono Nerd Font Mono') -- 你的字体族
config.font_size = 20.0
config.enable_csi_u_key_encoding = true

-- 隐藏标题栏，让界面更极简（类似 Ghostty 风格）
config.window_decorations = "RESIZE"
--config.window_background_opacity = 0.95 -- 稍微带点透明感
--config.macos_window_background_blur = 20 -- 背景模糊

-- ==========================================
-- 2. 核心快捷键 (Prefix + Ctrl 操作逻辑)
-- ==========================================
-- \x13 是 Ctrl+s 的代码
config.keys = {
  -- Ctrl + h -> 映射为 (Prefix) + Ctrl + h (向左切换面板)
  {
    key = 'h',
    mods = 'CTRL',
    action = wezterm.action.SendString '\x13\x08',
  },
  -- Ctrl + ; -> 映射为 (Prefix) + Ctrl + ; (向右切换面板)
  {
    key = ';',
    mods = 'CTRL',
    action = wezterm.action.SendString '\x13\x3b',
  },
  
  -- Ctrl + 1..9 -> 映射为 (Prefix) + 1..9 (快速切换窗口)
  { key = '1', mods = 'CTRL', action = wezterm.action.SendString '\x131' },
  { key = '2', mods = 'CTRL', action = wezterm.action.SendString '\x132' },
  { key = '3', mods = 'CTRL', action = wezterm.action.SendString '\x133' },
  { key = '4', mods = 'CTRL', action = wezterm.action.SendString '\x134' },
  { key = '5', mods = 'CTRL', action = wezterm.action.SendString '\x135' },
  { key = '6', mods = 'CTRL', action = wezterm.action.SendString '\x136' },
  { key = '7', mods = 'CTRL', action = wezterm.action.SendString '\x137' },
  { key = '8', mods = 'CTRL', action = wezterm.action.SendString '\x138' },
  { key = '9', mods = 'CTRL', action = wezterm.action.SendString '\x139' },
{ key = 'i', mods = 'CTRL', action = wezterm.action.SendKey { key = 'i', mods = 'CTRL' } },
  { key = 'j', mods = 'CTRL', action = wezterm.action.SendKey { key = 'j', mods = 'CTRL' } },
  { key = 'k', mods = 'CTRL', action = wezterm.action.SendKey { key = 'k', mods = 'CTRL' } },
  { key = 'l', mods = 'CTRL', action = wezterm.action.SendKey { key = 'l', mods = 'CTRL' } },
}
-- ==========================================
-- 3. 其他优化设置
-- ==========================================
config.scrollback_lines = 5000 -- 滚动回溯行数
config.hide_tab_bar_if_only_one_tab = true -- 只有一个标签时隐藏标签栏

return config
