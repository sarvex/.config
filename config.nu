$env.HOMEBREW_PREFIX = '/opt/homebrew'
$env.HOMEBREW_CELLAR = '/opt/homebrew/Cellar'
$env.HOMEBREW_REPOSITORY = '/opt/homebrew'

# Standard system paths (lowest precedence)
use std 'path add'
path add '/sbin'
path add '/usr/sbin'
path add '/opt/homebrew/sbin'
path add '/bin'
path add '/usr/bin'
path add '/opt/homebrew/bin'

path add $"($env.HOME)/.cargo/bin"
path add $"(brew --prefix rustup)/bin"
path add $"(brew --prefix postgresql@17)/bin"
path add $"(brew --prefix uutils-findutils)/libexec/uubin"
path add $"(brew --prefix uutils-diffutils)libexec/uubin"
path add $"(brew --prefix uutils-coreutils)libexec/uubin"

# Development environment settings
$env.LLVM_CONFIG = $"(brew --prefix llvm)/bin/llvm-config"
$env.RUSTC_WRAPPER = 'sccache'
$env.CC = 'sccache clang'
$env.CXX = 'sccache clang++'
$env.AIDER_CONFIG = $"($env.HOME)/.config/aider/config.yml"

# PostgreSQL configuration (using dynamic paths via `brew`)
let pg_prefix = (brew --prefix postgresql@17 | str trim)
$env.LDFLAGS = $"-L($pg_prefix)/lib"
$env.CPPFLAGS = $"-I($pg_prefix)/include"
$env.PKG_CONFIG_PATH = $"($pg_prefix)/lib/pkgconfig"

# --- Aliases ---
alias python = /usr/bin/python3
# alias ls = 'ls --color'
# alias ls = eza --git --no-user --no-time
# alias ll = eza --long --all --git --no-user --no-time
alias cat = bat --paging=never --theme=DarkNeon --style=plain

if ($env | get SSH_CONNECTION | is-not-empty) {
  let-env EDITOR = "vim"
} else {
  let-env EDITOR = "nvim"
}
let-env VISUAL = "subl"
let-env HOME_EDITOR = "mate"

alias fuck = thefuck $in
source ~/.config/nushell/zoxide.nu
source ~/.config/nushell/fzf.nu

# Add other Nushell-specific configurations or custom commands below
fastfetch
