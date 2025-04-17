from pathlib import Path
from os import path, environ
if path.isfile('/opt/homebrew/bin/brew'):
    execx('$({}/bin/brew shellenv)'.format('/opt/homebrew'))

# Set Homebrew-related environment variables
$HOMEBREW_PREFIX = '/opt/homebrew'
$HOMEBREW_CELLAR = '/opt/homebrew/Cellar'
$HOMEBREW_REPOSITORY = '/opt/homebrew'
if 'MANPATH' not in environ or not $MANPATH:
    $MANPATH = ''
$MANPATH = ':' + str($MANPATH).lstrip(':')
$INFOPATH = '/opt/homebrew/share/info:' + environ.get('INFOPATH', '')

# PATH modifications
$PATH.append('/opt/homebrew/bin')
$PATH.append('/opt/homebrew/sbin')
$PATH.append(str($(brew --prefix openjdk)) + '/bin')
$PATH.append(str($(brew --prefix postgresql@17)) + '/bin')
$PATH.append(str($(brew --prefix rustup)) + '/bin')
$PATH.append(str($(brew --prefix uutils-coreutils)) + '/libexec/uubin')
$PATH.append(str($(brew --prefix uutils-diffutils)) + '/libexec/uubin')
$PATH.append(str($(brew --prefix uutils-findutils)) + '/libexec/uubin')
$PATH.append(path.expanduser('~/.cargo/bin'))
$PATH.append(path.expanduser('~/Library/pnpm'))
$PATH.append('/usr/local/bin')
$PATH.append('/usr/bin')
$PATH.append('/bin')
$PATH.append('/usr/sbin')
$PATH.append('/sbin')

# Development environment settings
$LLVM_CONFIG = str($(brew --prefix llvm)) + '/bin/llvm-config'
$RUSTC_WRAPPER = 'sccache'
$CC = 'sccache clang'
$CXX = 'sccache clang++'
$AIDER_CONFIG = path.expanduser('~/.config/aider/config.yml')

# PostgreSQL configuration - use string concatenation with explicit conversion
$LDFLAGS = '-L' + str($(brew --prefix postgresql@17)) + '/lib'
$CPPFLAGS = '-I' + str($(brew --prefix postgresql@17)) + '/include'
$PKG_CONFIG_PATH = str($(brew --prefix postgresql@17)) + '/lib/pkgconfig'
$EDITOR = 'vim' if environ.get('SSH_CONNECTION', '') else 'nvim'
$VISUAL = 'subl'
$HOMEBREW_EDITOR = 'mate'

# Aliases
aliases['ls'] = 'eza --color=always --group-directories-first --icons'  # preferred listing
aliases['la'] = 'eza -a --color=always --group-directories-first --icons'  # all files and dirs
aliases['ll'] = 'eza -l --color=always --group-directories-first --icons'  # long format
aliases['lla'] = 'eza -al --color=always --group-directories-first --icons'  # long format
aliases['lt'] = 'eza -aT --color=always --group-directories-first --icons'  # tree listing
aliases['l.'] = "eza -a | grep -e '^\\.'"  # show only dotfiles
aliases['cat'] = 'bat --paging never --theme DarkNeon --style plain'
aliases['python'] = '/usr/bin/python3'
aliases['pip'] = '/usr/bin/pip3'

# FZF
from xonsh.built_ins import XSH
XSH.env['fzf_history_binding'] = "c-r"  # Ctrl+R
XSH.env['fzf_ssh_binding'] = "c-s"  # Ctrl+S
XSH.env['fzf_file_binding'] = "c-t"  # Ctrl+T
XSH.env['fzf_dir_binding'] = "c-g"  # Ctrl+G

# # Commands to run in interactive sessions
# if $XONSH_INTERACTIVE:
#     # thefuck --alias | source  # This is fish-specific, might need xonsh equivalent
#     # fzf --fish | source      # This is fish-specific, might need xonsh equivalent
#     # Fixed zoxide initialization
#     # execx($(zoxide init xonsh), 'exec')
execx($(zoxide init xonsh), 'exec', __xonsh__.ctx, filename='zoxide')
fastfetch
