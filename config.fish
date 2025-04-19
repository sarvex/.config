# Initialize Homebrew if available
if test -f /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
end

# Homebrew environment
set -gx HOMEBREW_PREFIX /opt/homebrew
set -gx HOMEBREW_CELLAR /opt/homebrew/Cellar
set -gx HOMEBREW_REPOSITORY /opt/homebrew

# Manual and info paths
if not set -q MANPATH
    set -gx MANPATH ""
end
set -gx MANPATH (string replace -r '^:+' '' $MANPATH)
set -gx INFOPATH "/opt/homebrew/share/info:"$INFOPATH

# Add Homebrew's Zsh site functions (even if you're using fish, this can help certain tools)
set -g fpath "/opt/homebrew/share/zsh/site-functions" $fpath

# Add key tools to PATH
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin
fish_add_path (brew --prefix openjdk)/bin
fish_add_path (brew --prefix uutils-coreutils)/libexec/uubin
fish_add_path (brew --prefix uutils-diffutils)/libexec/uubin
fish_add_path (brew --prefix uutils-findutils)/libexec/uubin
fish_add_path (brew --prefix rustup)/bin
fish_add_path (brew --prefix postgresql@17)/bin
fish_add_path $HOME/.cargo/bin
fish_add_path /usr/local/bin
fish_add_path /usr/bin
fish_add_path /bin
fish_add_path /usr/sbin
fish_add_path /sbin

# Dev tools & build environment
set -gx LLVM_CONFIG (brew --prefix llvm)/bin/llvm-config
set -gx RUSTC_WRAPPER sccache
set -gx CC "sccache clang"
set -gx CXX "sccache clang++"
set -gx AIDER_CONFIG $HOME/.config/aider/config.yml

# PostgreSQL build flags
set -gx LDFLAGS "-L"(brew --prefix postgresql@17)"/lib"
set -gx CPPFLAGS "-I"(brew --prefix postgresql@17)"/include"
set -gx PKG_CONFIG_PATH (brew --prefix postgresql@17)/lib/pkgconfig

# Editors
if test -n "$SSH_CONNECTION"
  set -gx EDITOR vim
else
  set -gx EDITOR nvim
end
set -gx VISUAL subl
set -gx HOME_EDITOR mate

# Aliases
alias ls='eza --color=always --group-directories-first --icons'
alias la='eza -a --color=always --group-directories-first --icons'
alias ll='eza -l --color=always --group-directories-first --icons'
alias lla='eza -al --color=always --group-directories-first --icons'
alias lt='eza -aT --color=always --group-directories-first --icons'
alias l.='eza -a | grep -e "^\."'
alias cat='bat --paging=never --theme=DarkNeon --style=plain'
alias python='/usr/bin/python3'
alias pip='/usr/bin/pip3'

# Interactive-only commands
if status is-interactive
  thefuck --alias | source
  fzf --fish | source
  zoxide init fish | source
  fastfetch
end

function fish_greeting
  fortune
end

# pnpm setup
set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    fish_add_path $PNPM_HOME $PATH
end

# LM Studio CLI path
fish_add_path $HOME/.lmstudio/bin
