# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

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
function zle-keymap-select {
  [[ $KEYMAP == vicmd ]] && echo -ne '\e[1 q' || echo -ne '\e[5 q'
}
zle -N zle-keymap-select
precmd() { echo -ne '\e[5 q' }

# Aliases
alias op='opencode'
alias v='nvim'
alias lg='lazygit'
alias t='tmux'
alias f='fastfetch'
alias y='yazi'
alias c='clear'
alias e='exit'

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
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


# Added by Antigravity
export PATH="/Users/wangyiran/.antigravity/antigravity/bin:$PATH"
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/wangyiran/.sdkman"
[[ -s "/Users/wangyiran/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/wangyiran/.sdkman/bin/sdkman-init.sh"
