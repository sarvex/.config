# ~/.config/nushell/config.nu

# --- Environment Variables ---
# These seem correct, assuming /opt/homebrew is your desired Homebrew location.
$env.HOMEBREW_PREFIX = '/opt/homebrew'
$env.HOMEBREW_CELLAR = '/opt/homebrew/Cellar'
$env.HOMEBREW_REPOSITORY = '/opt/homebrew'

# --- PATH Configuration ---
def --env get-brew-prefix [package: string] {
  ^/opt/homebrew/bin/brew --prefix $package | str trim
}

let additional_paths = [
  $"($env.HOME)/.cargo/bin", # Use $"" for interpolation with $env.HOME
  (get-brew-prefix 'rustup' | path join 'bin'),
  (get-brew-prefix 'postgresql@17' | path join 'bin'),
  (get-brew-prefix 'uutils-findutils' | path join 'libexec/uubin'),
  (get-brew-prefix 'uutils-diffutils' | path join 'libexec/uubin'),
  (get-brew-prefix 'uutils-coreutils' | path join 'libexec/uubin'),
  '/opt/homebrew/sbin',
  '/opt/homebrew/bin',
]
let existing_paths = if $env.PATH? == null or ($env.PATH | is-empty) {
    [] # Start with an empty list if PATH is not set or empty
} else {
    $env.PATH | split row (char esep) # Split using the OS-specific path separator
}
$env.PATH = ($additional_paths ++ $existing_paths | uniq | str join (char esep))

# --- Development Environment Settings ---
let llvm_prefix = (get-brew-prefix 'llvm')
if not ($llvm_prefix | is-empty) {
    $env.LLVM_CONFIG = ($llvm_prefix | path join 'bin' 'llvm-config')
}

$env.RUSTC_WRAPPER = 'sccache'
$env.CC = 'sccache clang'
$env.CXX = 'sccache clang++'
$env.AIDER_CONFIG = $"($env.HOME)/.config/aider/config.yml"

# --- PostgreSQL Build Flags (using dynamic paths via brew) ---
let pg_prefix = (get-brew-prefix 'postgresql@17')
if not ($pg_prefix | is-empty) {
    let existing_ldflags = ($env.LDFLAGS? | default '')
    $env.LDFLAGS = $"(-L($pg_prefix)/lib) ($existing_ldflags)" | str trim

    let existing_cppflags = ($env.CPPFLAGS? | default '')
    $env.CPPFLAGS = $"(-I($pg_prefix)/include) ($existing_cppflags)" | str trim

    let pg_pkgconfig = ($pg_prefix | path join 'lib' 'pkgconfig')
    let existing_pkg_config = ($env.PKG_CONFIG_PATH? | default '')
    $env.PKG_CONFIG_PATH = if ($existing_pkg_config | is-empty) {
        $pg_pkgconfig
    } else {
        $"($pg_pkgconfig):($existing_pkg_config)"
    }
} else {
    print --stderr "Warning: postgresql@17 prefix not found. LDFLAGS, CPPFLAGS, PKG_CONFIG_PATH not set for pg."
}

# --- Aliases ---
alias ls = ^eza --color=always --group-directories-first --icons
alias la = ^eza -a --color=always --group-directories-first --icons
alias ll = ^eza -l --color=always --group-directories-first --icons
alias lla = ^eza -al --color=always --group-directories-first --icons
alias lt = ^eza -aT --color=always --group-directories-first --icons
alias l. = ^eza -a | where name =~ '^\.'
alias cat = ^bat --paging=never --theme=DarkNeon --style=plain
alias python = ^/usr/bin/python3
alias pip = ^/usr/bin/pip3

# --- Editor Configuration ---
let editor_to_use = try {
  if ($env.SSH_CONNECTION? | is-not-empty) { "vim" } else { "nvim" }
} catch {
  "nvim"
}
$env.EDITOR = $editor_to_use
$env.VISUAL = "subl" # Assumes 'subl' (Sublime Text) is in PATH
$env.HOME_EDITOR = "mate" # Non-standard, ensure you use this var yourself. Assumes 'mate' is in PATH

# pnpm
let pnpm_home = $"($env.HOME)/Library/pnpm"
$env.PNPM_HOME = $pnpm_home
let current_path_list = $env.PATH | split row (char esep)
if not ($pnpm_home in $current_path_list) {
    $env.PATH = ([$pnpm_home] ++ $current_path_list | str join (char esep))
}
# pnpm end

# --- Sourcing External Configurations ---
source ~/.config/nushell/zoxide.nu
# source ~/.config/nushell/fzf.nu

$env.config.show_banner = false
# --- Startup Commands ---
^fastfetch

