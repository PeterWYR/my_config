local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action
-- ==========================================
-- 1. 基础视觉配置 (主题、字体、窗口)
-- ==========================================
config.color_scheme = "Dracula (Official)" -- 使用 Dracula 官方主题
config.font = wezterm.font("Iosevka") -- 你的字体族
config.font_size = 22.0
config.enable_csi_u_key_encoding = true

-- 隐藏标题栏，让界面更极简（类似 Ghostty 风格）
config.window_decorations = "RESIZE"
--config.window_background_opacity = 0.95 -- 稍微带点透明感
--config.macos_window_background_blur = 20 -- 背景模糊

-- ==========================================
-- 2. 核心快捷键 (Prefix + Ctrl 操作逻辑)
-- ==========================================

config.keys = config.keys or {}
local function add(k)
	table.insert(config.keys, k)
end

-- ===========================================================
-- 1. Tmux 分屏导航 (伪装 Cmd+ijkl 为 Alt+ijkl)
-- 对应 Tmux 配置: bind -n M-i select-pane -U
-- ===========================================================
table.insert(config.keys, {
	key = "i",
	mods = "CMD",
	action = act.SendString("\x1bi"), -- 发送 ESC + i (即 Alt-i)
})
table.insert(config.keys, {
	key = "j",
	mods = "CMD",
	action = act.SendString("\x1bj"),
})
table.insert(config.keys, {
	key = "k",
	mods = "CMD",
	action = act.SendString("\x1bk"), -- 注意：这会覆盖 WezTerm 默认的清屏快捷键
})
table.insert(config.keys, {
	key = "l",
	mods = "CMD",
	action = act.SendString("\x1bl"),
})

-- ===========================================================
-- 2. Tmux 窗口切换 (伪装 Cmd+1~9 为 Alt+1~9)
-- 对应 Tmux 配置: bind -n M-1 select-window -t 1
-- ===========================================================

for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "CMD",
		action = act.SendString("\x1b" .. tostring(i)),
	})
end

-- ===========================================================
-- 3. 确保 Option 键行为正确 (给 Neovim/Emacs 用)
-- ===========================================================
-- 让 Option 键发送 Meta 信号，而不是输出特殊字符 (如 ©, ® 等)
-- 这对你的 Ctrl+Option+ijkl 在 Neovim 里生效非常重要
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- ==========================================
-- 3. 其他优化设置
-- ==========================================
config.scrollback_lines = 5000 -- 滚动回溯行数
config.hide_tab_bar_if_only_one_tab = true -- 只有一个标签时隐藏标签栏

config.font_size = 22.0
config.default_cursor_style = "SteadyBlock"
config.cursor_blink_rate = 500
config.enable_csi_u_key_encoding = true
return config
