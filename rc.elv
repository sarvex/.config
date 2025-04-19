# Initialize Homebrew if available
if (test -f /opt/homebrew/bin/brew) {
  eval (</opt/homebrew/bin/brew shellenv)
}

# Homebrew environment
set-env HOMEBREW_PREFIX /opt/homebrew
set-env HOMEBREW_CELLAR /opt/homebrew/Cellar
set-env HOMEBREW_REPOSITORY /opt/homebrew

# Manual and info paths
if (not ?MANPATH) {
  set-env MANPATH ""
}
set-env MANPATH (replace-regexp '^:+' '' $MANPATH)
set-env INFOPATH "/opt/homebrew/share/info:"$INFOPATH

# Zsh site functions (note: not directly applicable in Elvish, skipping `fpath`)

# Add key tools to PATH
set-env PATHS = [
  /opt/homebrew/bin
  /opt/homebrew/sbin
  (eval (</opt/homebrew/bin/brew --prefix openjdk))/bin
  (eval (</opt/homebrew/bin/brew --prefix uutils-coreutils))/libexec/uubin
  (eval (</opt/homebrew/bin/brew --prefix uutils-diffutils))/libexec/uubin
  (eval (</opt/homebrew/bin/brew --prefix uutils-findutils))/libexec/uubin
  (eval (</opt/homebrew/bin/brew --prefix rustup))/bin
  (eval (</opt/homebrew/bin/brew --prefix postgresql@17))/bin
  $HOME/.cargo/bin
  /usr/local/bin
  /usr/bin
  /bin
  /usr/sbin
  /sbin
]
set-env PATH $PATHS

# Dev tools & build environment
set-env LLVM_CONFIG (eval (</opt/homebrew/bin/brew --prefix llvm))/bin/llvm-config
set-env RUSTC_WRAPPER sccache
set-env CC "sccache clang"
set-env CXX "sccache clang++"
set-env AIDER_CONFIG "$HOME/.config/aider/config.yml"

# PostgreSQL build flags
set-env LDFLAGS "-L"(eval (</opt/homebrew/bin/brew --prefix postgresql@17))"/lib"
set-env CPPFLAGS "-I"(eval (</opt/homebrew/bin/brew --prefix postgresql@17))"/include"
set-env PKG_CONFIG_PATH (eval (</opt/homebrew/bin/brew --prefix postgresql@17))/lib/pkgconfig

# Editors
if (has-env SSH_CONNECTION) {
  set-env EDITOR vim
} else {
  set-env EDITOR nvim
}
set-env VISUAL subl
set-env HOME_EDITOR mate

# Aliases (Elvish doesn't support traditional aliases, use functions instead)
fn ls { eza --color=always --group-directories-first --icons $@ }
fn la { eza -a --color=always --group-directories-first --icons $@ }
fn ll { eza -l --color=always --group-directories-first --icons $@ }
fn lla { eza -al --color=always --group-directories-first --icons $@ }
fn lt { eza -aT --color=always --group-directories-first --icons $@ }
fn l. { eza -a | grep -e '^\.' }
fn cat { bat --paging=never --theme=DarkNeon --style=plain $@ }
fn python { /usr/bin/python3 $@ }
fn pip { /usr/bin/pip3 $@ }

# Interactive-only commands
if (isatty) {
  thefuck --alias | eval
  fzf --elvish | eval
  zoxide init elvish | eval
  fastfetch
}

# Greeting
fn greeting { fortune }

# pnpm setup
set-env PNPM_HOME "$HOME/Library/pnpm"
if (not (has-element $PNPM_HOME $PATH)) {
  set-env PATH [(all $PNPM_HOME $PATH)]
}

# LM Studio CLI path
set-env PATH [(all $HOME/.lmstudio/bin $PATH)]
