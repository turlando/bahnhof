## PATH
export PATH="$PATH:$HOME/.local/bin"

## Compilers
export FC='gfortran'

## Useful environment variables
export PAGER='less'
export EDITOR='nvim'
export BROWSER='firefox'

## ssh-agent
export $(systemctl --user show-environment | grep SSH_AUTH_SOCK)

## Fix Java on Sway
export _JAVA_AWT_WM_NONREPARENTING=1
