# ==========================================
#              macOS 专属配置
# ==========================================
stty -ixon
if [[ "$(uname)" == "Darwin" ]]; then
    # 1. Homebrew 配置 (Linux 会自动跳过这里)
    if [ -f "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        export PATH="/opt/homebrew/bin:$PATH"
    fi

    # 2. 其他你只想在 Mac 上用的配置也可以放这里
    # alias ...
fi
ZSH_THEME="powerlevel10k/powerlevel10k"
# P10K instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

plugins=(
git
z
sudo
zsh-autosuggestions
zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Vi mode
bindkey -v
export KEYTIMEOUT=1

# Cursor shape
function _cursor_block() {
  # 2 = steady block
  print -n -- $'\e[2 q'
}

function zle-line-init() { _cursor_block }
zle -N zle-line-init

function zle-keymap-select() { _cursor_block }
zle -N zle-keymap-select

function precmd() { _cursor_block }
function preexec() { _cursor_block }

# Aliases
alias op='opencode'
alias v='nvim'
alias lg='lazygit'
alias t='tmux'
alias f='fastfetch'
alias y='yazi'
alias c='clear'
alias e='emacs'
alias q='exit'

# Editors
export EDITOR=nvim
export VISUAL=nvim

# Conda lazy load
conda() {
  unset -f conda
  source /Users/wangyiran/miniconda3/etc/profile.d/conda.sh
  conda "$@"
}

# P10K config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# pyenv
# 智能判断：只有当 pyenv 存在时才初始化
if command -v pyenv 1>/dev/null 2>&1; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

# Added by Antigravity
export PATH="/Users/wangyiran/.antigravity/antigravity/bin:$PATH"
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/wangyiran/.sdkman"
[[ -s "/Users/wangyiran/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/wangyiran/.sdkman/bin/sdkman-init.sh"
export PATH="$HOME/.config/emacs/bin:$PATH"

# To customize prompt, run `p10k configure` or edit ~/my_config/zsh/.p10k.zsh.
[[ ! -f ~/my_config/zsh/.p10k.zsh ]] || source ~/my_config/zsh/.p10k.zsh
