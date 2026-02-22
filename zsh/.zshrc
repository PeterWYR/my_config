# ---- P10K instant prompt (必须最顶部) ----
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi


# ---- Zim init (保留你现在那段 install 添加的即可) ----
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
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init
fi
eval "$(starship init zsh)"
# Initialize modules.
source ${ZIM_HOME}/init.zsh

# Homebrew (macOS / Linux 通用：只要 brew 在就初始化)
if (( ${+commands[brew]} )); then
  eval "$(brew shellenv)"
fi


# ---- Prompt / P10K ----
#[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
#[[ -f ~/my_config/zsh/.p10k.zsh ]] && source ~/my_config/zsh/.p10k.zsh

# ---- Vi mode ----
bindkey -v
export KEYTIMEOUT=1

# ---- Cursor block (你的代码保留) ----
function _cursor_block() { print -n -- $'\e[2 q' }
function zle-line-init() { _cursor_block }
zle -N zle-line-init
function zle-keymap-select() { _cursor_block }
zle -N zle-keymap-select
function precmd() { _cursor_block }
function preexec() { _cursor_block }


# ---- Aliases ----
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

# ---- Editors ----
export EDITOR=nvim
export VISUAL=nvim

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

# ---- Antigravity / mirrors ----
export PATH="/Users/wangyiran/.antigravity/antigravity/bin:$PATH"
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles

# ---- SDKMAN ----
export SDKMAN_DIR="/Users/wangyiran/.sdkman"
[[ -s "/Users/wangyiran/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/wangyiran/.sdkman/bin/sdkman-init.sh"

export PATH="$HOME/.config/emacs/bin:$PATH"
export PATH="$HOME/fvm/default/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
