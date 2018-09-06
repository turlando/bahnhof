## PATH
export PATH="$PATH:$HOME/.local/bin"

## Useful environment variables
export PAGER='less'
export EDITOR='nvim'
export BROWSER='firefox'

## ssh-agent
eval $(systemctl --user show-environment | grep SSH_AUTH_SOCK)
export SSH_AUTH_SOCK

## Sway
export XKB_DEFAULT_LAYOUT='it'
export SWAY_CURSOR_THEME='Neutral'

## Fix Java on Sway
_JAVA_AWT_WM_NONREPARENTING=1
