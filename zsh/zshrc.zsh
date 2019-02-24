setopt vi

alias vi='nvim'
alias vim='nvim'

## Download entire webpage.
alias wdump='wget \
                --timestamping \
                --page-requisites \
                --no-parent \
                --adjust-extension \
                --convert-links \
                --no-cookies \
                --restrict-file-names=windows \
                --no-directories \
                -e robots=off'

## Download entire webpage including external files.
alias wdumpr='wdump --span-hosts'
