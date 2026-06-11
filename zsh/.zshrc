# ==========================================
# 1. 环境变量与路径 (必须在 Zim 之前加载，让补全能找到软件)
# ==========================================
# PATH 自动去重（无论 .zprofile/.profile 等何处重复添加）
typeset -U path PATH

# Homebrew (macOS / Linux 通用)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif (( ${+commands[brew]} )); then
  eval "$(brew shellenv)"
fi

export PATH="$HOME/.config/emacs/bin:$PATH"
export PATH="$HOME/fvm/default/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
export PATH="/Users/wangyiran/.antigravity/antigravity/bin:$PATH"
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles
export XDG_CONFIG_HOME="$HOME/.config"

# ==========================================
# 2. Zim 框架初始化 (负责加载补全核心模块)
# ==========================================
HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE SHARE_HISTORY INC_APPEND_HISTORY HIST_REDUCE_BLANKS
WORDCHARS=${WORDCHARS//[\/]}
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# zimfw 管理器脚本由 Homebrew 提供 (brew install zimfw)
ZIM_BIN=/opt/homebrew/opt/zimfw/share/zimfw.zsh

# Install missing modules, and update init.zsh
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_BIN} init
fi

# Initialize modules. (这一步会生成 compdef)
source ${ZIM_HOME}/init.zsh
source ~/my_config/zsh/fzf.zsh
# fzf 的 completion.zsh 会把 Tab 抢去（只做路径补全），这里把 Tab 交还给 fzf-tab。
# fzf 的 Ctrl-T / Ctrl-R / Alt-C 不受影响。
enable-fzf-tab

# ==========================================
# 3. 终端 UI (Starship 必须在 Zim 之后！)
# ==========================================
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
# ==========================================
# 4. 终端按键绑定与光标设置
# ==========================================
bindkey -v
export KEYTIMEOUT=1
# Let Ctrl-s reach tmux instead of terminal flow control.
[[ -t 0 ]] && stty -ixon 2>/dev/null

# ── Vi mode 光标形状 ──
function _cursor_block() { print -n -- $'\e[2 q' }  # normal：实心块
function _cursor_beam()  { print -n -- $'\e[6 q' }  # insert：竖线

function zle-keymap-select() {
  case $KEYMAP in
    vicmd)      _cursor_block ;;
    main|viins) _cursor_beam  ;;
  esac
}
zle -N zle-keymap-select

function zle-line-init() {
  zle -K viins
  _cursor_beam
}
zle -N zle-line-init

function preexec() { _cursor_block }
# ==========================================
# 5. 别名与编辑器设置
# ==========================================
alias ls='eza --icons --group-directories-first'
alias ll='eza -l --icons --group-directories-first --git'
alias la='eza -la --icons --group-directories-first --git'
alias lt='eza --tree --level=2 --icons'      # 树状，2 层
alias ltt='eza --tree --level=3 --icons'
alias op='opencode'
alias v='nvim'
alias lg='lazygit'
alias t='tmux'
alias f='fastfetch'
alias y='yazi'
alias e='emacs -nw'
alias o='orb'
alias cc='claude'
alias co='codex'
alias ge='gemini'
alias ag='agy'
alias n='node'
alias md='mkdir'
alias g='rg'
alias top='btop'
alias du='dust'
alias df='duf'
alias cl='clear'
alias cat='bat --paging=never'
export BAT_THEME="ansi"

export EDITOR=nvim
export VISUAL=nvim




fkill() {
  local pid
  pid=$(procs --no-header | fzf | awk '{print $1}')
  [[ -n "$pid" ]] && kill "${1:-TERM}" "$pid"  # 默认 TERM，需要时 fkill -9
}
# ==========================================
# 6. 开发环境懒加载与工具箱
# ==========================================
# ---- Conda lazy load ----
conda() {
  unset -f conda
  source /Users/wangyiran/miniconda3/etc/profile.d/conda.sh
  conda "$@"
}

# ---- pyenv ----
if command -v pyenv 1>/dev/null 2>&1; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init - zsh)"
fi

# ---- SDKMAN ----
export SDKMAN_DIR="/Users/wangyiran/.sdkman"
[[ -s "/Users/wangyiran/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/wangyiran/.sdkman/bin/sdkman-init.sh"

# -----NEOVIM------
export PATH="$HOME/nvim-macos-arm64/bin:$PATH"

export ENABLE_TOOL_SEARCH=false


# pnpm
export PNPM_HOME="/Users/wangyiran/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

# bun
export BUN_INSTALL="$HOME/.bun"
case ":$PATH:" in
  *":$BUN_INSTALL/bin:"*) ;;
  *) export PATH="$BUN_INSTALL/bin:$PATH" ;;
esac
# bun end


# Added by Antigravity CLI installer
export PATH="/Users/wangyiran/.local/bin:$PATH"
