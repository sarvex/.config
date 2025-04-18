### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
  command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
    print -P "%F{33} %F{34}Installation successful.%f%b" || \
    print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
  zdharma-continuum/zinit-annex-as-monitor \
  zdharma-continuum/zinit-annex-bin-gem-node \
  zdharma-continuum/zinit-annex-patch-dl \
  zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# pnpm
export PNPM_HOME="/Users/sarvex/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

if [[ -f "/opt/homebrew/bin/brew" ]] then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  autoload -Uz compinit
  compinit
fi

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::brew
zinit snippet OMZP::vscode
zinit snippet OMZP::mise
zinit snippet OMZP::rust
zinit snippet OMZP::golang
zinit snippet OMZP::python
zinit snippet OMZP::docker
zinit snippet OMZP::fzf
zinit snippet OMZP::terraform
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-history-substring-search
zinit ice wait atload'_history_substring_search_config'

# Load completions
autoload -Uz compinit && compinit

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=9999
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

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi
export VISUAL='subl'
export HOMEBREW_EDITOR='mate'
export AIDER_CONFIG='$HOME/.config/aider/config.yml'

# Development environment settings
export LLVM_CONFIG="$(brew --prefix llvm)/bin/llvm-config"
export RUSTC_WRAPPER="sccache"
export CC="sccache clang"
export CXX="sccache clang++"

# PostgreSQL configuration
export LDFLAGS="-L$(brew --prefix postgresql@17)/lib"
export CPPFLAGS="-I$(brew --prefix postgresql@17)/include"
export PKG_CONFIG_PATH="$(brew --prefix postgresql@17)/lib/pkgconfig"

# PATH modifications
export PATH="/usr/bin:/bin:/usr/sbin:/opt/homebrew/bin:/opt/homebrew/sbin:/Users/sarvex/.cargo/bin:/Users/sarvex/Library/Python/3.9/bin:$(brew --prefix uutils-coreutils)/libexec/uubin:$(brew --prefix uutils-diffutils)/libexec/uubin:$(brew --prefix uutils-findutils)/libexec/uubin:$(brew --prefix rustup)/bin:$HOME/.cargo/bin:$(brew --prefix postgresql@17)/bin:$PATH"

# Aliases
# alias ls='ls --color'
alias ls='eza --git --no-user --no-time'
alias ll='eza --long --all --git --no-time'
alias cat='bat --paging never --theme DarkNeon --style plain'
alias python='/usr/bin/python3'
alias pip='/usr/bin/pip3'

if [[ -o interactive ]]; then
  # Shell integrations
  source <(zoxide init --cmd cd zsh)
  source <(fzf --zsh)
  source <(thefuck --alias)
  source <(starship init zsh)
  fastfetch
fi
