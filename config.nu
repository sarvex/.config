# config.nu - Using `path add` for PATH configuration
# Date: 2025-04-09
#
# Nushell Configuration File
# Loaded after env.nu and before login.nu

# --- Configuration & Early PATH Setup ---

# Ensure brew command is available for subsequent dynamic path lookups.
# Add the directory containing the brew executable to the PATH first.
# Adjust '/opt/homebrew/bin' if your Homebrew is installed elsewhere (e.g., /usr/local/bin for Intel Macs).
use std 'path add'
path add '/opt/homebrew/bin'

# --- Environment Variables (Non-PATH) ---

# Homebrew Environment (Manually set based on common locations)
$env.HOMEBREW_PREFIX = '/opt/homebrew'
$env.HOMEBREW_CELLAR = '/opt/homebrew/Cellar'
$env.HOMEBREW_REPOSITORY = '/opt/homebrew'

# Standard system paths (lowest precedence)
path add '/sbin'
path add '/usr/sbin'
path add '/opt/homebrew/sbin'
path add '/bin'
path add '/usr/bin'
path add '/opt/homebrew/bin'

path add $"($env.HOME)/Library/Python/3.9/bin" # Check if this Python version is intended
path add $"($env.HOME)/.cargo/bin"
path add $"(brew --prefix postgresql@17)/bin"
path add $"(brew --prefix rustup)/bin"
path add $"(brew --prefix uutils-findutils)/libexec/uubin"
path add $"(brew --prefix uutils-diffutils)libexec/uubin"
path add $"(brew --prefix uutils-coreutils)libexec/uubin"

# Development environment settings
# Using string interpolation for path construction
$env.LLVM_CONFIG = $"(brew --prefix llvm)/bin/llvm-config"
$env.RUSTC_WRAPPER = 'sccache'
$env.CC = 'sccache clang'
$env.CXX = 'sccache clang++'
$env.AIDER_CONFIG = $"($env.HOME)/.config/aider/config.yml"

# PostgreSQL configuration (using dynamic paths via `brew`)
# Define prefix once for clarity
let pg_prefix = (brew --prefix postgresql@17 | str trim)
$env.LDFLAGS = $"-L($pg_prefix)/lib"
$env.CPPFLAGS = $"-I($pg_prefix)/include"
$env.PKG_CONFIG_PATH = $"($pg_prefix)/lib/pkgconfig"

# --- Aliases ---
alias python = /usr/bin/python3
# alias ls = 'ls --color'
alias ls = eza --git --no-user --no-time
alias ll = eza --long --all --git --no-user --no-time
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
