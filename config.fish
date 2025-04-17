if test -f /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
end

# PATH modifications
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

# Development environment settings
set -gx LLVM_CONFIG (brew --prefix llvm)/bin/llvm-config
set -gx RUSTC_WRAPPER sccache
set -gx CC "sccache clang"
set -gx CXX "sccache clang++"
set -gx AIDER_CONFIG ~/.config/aider/config.yml

# PostgreSQL configuration
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
set -gx HOMEBREW_EDITOR mate

# Aliases
# Replace ls with eza
alias ls='eza --color=always --group-directories-first --icons' # preferred listing
alias la='eza -a --color=always --group-directories-first --icons' # all files and dirs
alias ll='eza -l --color=always --group-directories-first --icons' # long format
alias lla='eza -al --color=always --group-directories-first --icons' # long format
alias lt='eza -aT --color=always --group-directories-first --icons' # tree listing
alias l.="eza -a | grep -e '^\.'" # show only dotfiles
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

# pnpm
set -gx PNPM_HOME /Users/sarvex/Library/pnpm
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
