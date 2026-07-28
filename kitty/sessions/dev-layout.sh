#!/bin/bash
# Dev layout: 在当前 kitty 窗口中创建分屏
#
#  ┌──────────┬──────────┐
#  │          │          │
#  │          │   右上    │
#  │          │          │
#  │   左侧   ├──────────┤
#  │          │          │
#  │          │   右下    │
#  │          │          │
#  └──────────┴──────────┘

# 切换到 splits 布局
kitty @ goto-layout splits

# 右上窗格（对当前窗格做垂直分割，右侧占 30%）
right_top_window=$(kitty @ launch --location=vsplit --bias=30 --cwd=current)

# 右下窗格（对右上窗格做水平分割，上下各占 50%）
kitty @ launch \
  --location=hsplit \
  --bias=50 \
  --source-window "id:${right_top_window}" \
  --next-to "id:${right_top_window}" \
  --cwd=current

# 焦点回到左侧主窗格
kitty @ focus-window --match num:0
