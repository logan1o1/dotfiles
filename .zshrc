# Init omz
export ZSH="/usr/share/oh-my-zsh"
[[ -z "${plugins[*]}" ]] && plugins=(git fzf extract)
source $ZSH/oh-my-zsh.sh

# Key binding
function zvm_after_init() {
    zvm_bindkey viins '^y' autosuggest-accept
    zvm_bindkey viins '^p' history-search-backward
    zvm_bindkey viins '^n' history-search-forward
    zvm_bindkey viins '^h' backward-delete-char
}

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# emit OSC 7
if [[ -n "$NVIM" ]]; then
  function print_osc7() {
    printf '\033]7;file://%s\033\\' "$PWD"
  }
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd print_osc7
fi

# Paths
export AUTH_CLIENT_ID=a765f971fbe94ccb9ba7b7c2d5d5e7bd
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" 
export STARSHIP_CONFIG=~/.config/starship.toml
export PATH="$PATH:~/.spicetify"
export PATH="$PATH:/home/lucifer/.local/bin"
export LS_COLORS="di=1;34:ln=1;36:so=1;35:pi=1;33:ex=1;32:bd=1;33;40:cd=1;33;40:su=37;41:sg=30;43:tw=30;42:ow=1;34"

# Aliases
alias cd='z'
alias ff='fastfetch'

# Initialization
eval "$(starship init zsh)"
eval "$(rbenv init -)"
eval "$(zoxide init zsh)"
eval $(ssh-agent -s) > /dev/null

# loading plugins
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
source /usr/share/nvm/init-nvm.sh

# Configuring zsh-syntax-highlighting using matugen
if [[ -f ~/.cache/matugen-zsh-colors.zsh ]]; then
    source ~/.cache/matugen-zsh-colors.zsh
fi

ssh-add ~/.ssh/github_key > /dev/null 2>&1
ssh-add ~/.ssh/codeberg_key > /dev/null 2>&1
