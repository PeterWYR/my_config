# ---- P10K instant prompt (必须最顶部) ----
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi

# ==========================================
# 1. 环境变量与路径 (必须在 Zim 之前加载，让补全能找到软件)
# ==========================================
# Homebrew (macOS / Linux 通用)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif (( ${+commands[brew]} )); then
  eval "$(brew shellenv)"
fi

export PATH="$HOME/.config/emacs/bin:$PATH"
export PATH="$HOME/fvm/default/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
export PATH="/Users/wangyiran/.antigravity/antigravity/bin:$PATH"
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles

# ==========================================
# 2. Zim 框架初始化 (负责加载补全核心模块)
# ==========================================
setopt HIST_IGNORE_ALL_DUPS
WORDCHARS=${WORDCHARS//[\/]}
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi

# Install missing modules, and update init.zsh
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init
fi

# Initialize modules. (这一步会生成 compdef)
source ${ZIM_HOME}/init.zsh

# ==========================================
# 3. 终端 UI (Starship 必须在 Zim 之后！)
# ==========================================
eval "$(starship init zsh)"
#[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
#[[ -f ~/my_config/zsh/.p10k.zsh ]] && source ~/my_config/zsh/.p10k.zsh

# ==========================================
# 4. 终端按键绑定与光标设置
# ==========================================
bindkey -v
export KEYTIMEOUT=1

function _cursor_block() { print -n -- $'\e[2 q' }
function zle-line-init() { _cursor_block }
zle -N zle-line-init
function zle-keymap-select() { _cursor_block }
zle -N zle-keymap-select
function precmd() { _cursor_block }
function preexec() { _cursor_block }

# ==========================================
# 5. 别名与编辑器设置
# ==========================================
alias op='opencode'
alias v='nvim'
alias lg='lazygit'
alias t='tmux'
alias f='fastfetch'
alias y='yazi'
alias c='clear'
alias e='emacs'
alias o='orb'
alias cc='claude'
alias co='codex'
alias ge='gemini'

export EDITOR=nvim
export VISUAL=nvim

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
  eval "$(pyenv init -)"
fi

# ---- SDKMAN ----
export SDKMAN_DIR="/Users/wangyiran/.sdkman"
[[ -s "/Users/wangyiran/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/wangyiran/.sdkman/bin/sdkman-init.sh"

# -----NEOVIM------
export PATH="$HOME/nvim-macos-arm64/bin:$PATH"
export ENABLE_TOOL_SEARCH=false
export ANTHROPIC_BASE_URL=https://api.kimi.com/coding/
export ANTHROPIC_API_KEY=sk-kimi-dTduiCjGrSWxqYB800BgO7YfAagzF7RPIbjBQiqE5WZ6cei8TaWUPZwmakRSFFdq

# pnpm
export PNPM_HOME="/Users/wangyiran/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
