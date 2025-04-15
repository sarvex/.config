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
alias python="/usr/bin/eython3"
# alias ls='ls --color'
alias ls='eza --git --no-user --no-time' 
alias ll='eza --long --all --git --no-user --no-time' 
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
