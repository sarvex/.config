if test -f /opt/homebrew/bin/brew
  eval (/opt/homebrew/bin/brew shellenv)
end

# PATH modifications
set -gx PATH (brew --prefix uutils-coreutils)/libexec/uubin \
  (brew --prefix uutils-diffutils)/libexec/uubin \
  (brew --prefix uutils-findutils)/libexec/uubin \
  (brew --prefix rustup)/bin \
  $HOME/.cargo/bin \
  (brew --prefix postgresql@17)/bin \
  $HOME/Library/Python/3.9/bin \
  /usr/local/bin:/usr/bin:/bin:/opt/homebrew/bin:/usr/sbin:/opt/homebrew/sbin \
  $PATH

# Development environment settings
set -gx LLVM_CONFIG (brew --prefix llvm)/bin/llvm-config
set -gx RUSTC_WRAPPER sccache
set -gx CC "sccache clang"
set -gx CXX "sccache clang++"

# PostgreSQL configuration
set -gx LDFLAGS "-L"(brew --prefix postgresql@17)"/lib"
set -gx CPPFLAGS "-I"(brew --prefix postgresql@17)"/include"
set -gx PKG_CONFIG_PATH (brew --prefix postgresql@17)/lib/pkgconfig

# Other configurations
set -gx AIDER_CONFIG ~/.config/aider/config.yml

# Editors
if test -n "$SSH_CONNECTION"
  set -gx EDITOR vim
else
  set -gx EDITOR nvim
end
set -gx VISUAL subl
set -gx HOME_EDITOR mate

# Aliases
# Replace ls with eza
alias ls='eza --color=always --group-directories-first --icons' # preferred listing
alias la='eza -a --color=always --group-directories-first --icons'  # all files and dirs
alias ll='eza -l --color=always --group-directories-first --icons'  # long format
alias lla='eza -al --color=always --group-directories-first --icons'  # long format
alias lt='eza -aT --color=always --group-directories-first --icons' # tree listing
alias l.="eza -a | grep -e '^\.'"                                     # show only dotfiles
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias cat='bat --paging never --theme DarkNeon --style plain'
alias python='/usr/bin/python3'
alias pip='/usr/bin/pip3'

if status is-interactive
  # Commands to run in interactive sessions can go here
  thefuck --alias | source
  fzf --fish | source
  zoxide init fish | source
  fastfetch
end
