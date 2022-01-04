#!/usr/bin/env bash

## See:
## https://unix.stackexchange.com/questions/105958/terminal-prompt-not-wrapping-correctly
## https://wiki.archlinux.org/index.php/Bash/Prompt_customization#PROMPT_COMMAND
## https://www.cyberciti.biz/tips/howto-linux-unix-bash-shell-setup-prompt.html
## https://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x405.html
## https://misc.flogisoft.com/bash/tip_colors_and_formatting

function yabpc()
{
    declare  ExitCode="$?"
    declare     Title="\001\e]2;\w\a\002"
    ## Formatting
    declare     Blink="\001\e[5m\002"
    declare      Bold="\001\e[1m\002"
    declare       Dim="\001\e[2m\002"
    declare    Hidden="\001\e[8m\002"
    declare    Invert="\001\e[7m\002"
    declare    Italic="\001\e[3m\002"
    declare     Reset="\001\e[0m\002"
    # declare ResetBold="\001\e[21m\002"
    declare ResetBold="\\033[2m"
    declare    Strike="\001\e[9m\002"
    declare Underline="\001\e[4m\002"
    ## Colors
    declare     Black="\001\e[30m\002"
    declare      Blue="\001\e[34m\002"
    declare      Cyan="\001\e[36m\002"
    declare  DarkGray="\001\e[90m\002"
    declare     Green="\001\e[32m\002"
    declare LightCyan="\001\e[96m\002"
    declare LightGray="\001\e[37m\002"
    declare   Magenta="\001\e[35m\002"
    declare       Red="\001\e[31m\002"
    declare     White="\001\e[97m\002"
    declare    Yellow="\001\e[33m\002"
    ## Symbols
    declare     Cloud=$'\uf0c2'
    declare DevPython=$'\ue235'
    declare      Edit=$'\uf044'
    declare     Error=$'\ue009'
    declare    Folder=$'\ue5fe'
    declare       Git=$'\uf1d3'
    declare GitBranch=$'\ue725'
    declare       New=$'\uf893'
    declare      Plus=$'\uf067'
    declare    Python=$'\uf820'
    declare   VertBar=$'\u2503'
    declare   Warning=$'\uf071'
    declare   YinYang=$'\ufb7e'
    ## Segments
    declare  Segments=(
        "${White}${Folder}${Bold} \w${Reset}"
    )

    ## Git
    [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ] && {
        declare SegmentGit="${Blue}${Bold}${Invert}" \
                git_status="" \
                git_status_mod="" \
                git_status_new="" \
                git_status_del=""
        SegmentGit+=" $(__git_ps1 | tr -d '( )')"
        git_status="$(git status --porcelain)"
        git_status_mod="$(grep -c -E '^ M' <<< "$git_status")"
        git_status_new="$(grep -c -E '^\?\?' <<< "$git_status")"
        git_status_del="$(grep -c -E '^ D' <<< "$git_status")"
        [ "$git_status_mod" -gt "0" ] &&
            SegmentGit+=" *${git_status_mod}"
        [ "$git_status_new" -gt "0" ] &&
            SegmentGit+=" +${git_status_new}"
        [ "$git_status_del" -gt "0" ] &&
            SegmentGit+=" -${git_status_del}"
        Segments+=("$SegmentGit ${Reset}")
    }

    ## Python venv
	[ -n "$VIRTUAL_ENV" ] && {
        Segments+=("${Cyan}${Bold}${Invert} ${Python} $(basename "$VIRTUAL_ENV") ${Reset}")
    }

    ## Conda
    [ -n "$CONDA_PROMPT_MODIFIER" ] && {
        Segments+=("${Cyan}${Bold}${Invert} ${DevPython} $CONDA_PROMPT_MODIFIER${Reset}")
    }

    PS1="$Title"
    if [ "$ExitCode" -ne "0" ]; then
        PS1+="${Red}${Bold}${Invert} exit code $ExitCode $Reset\n\n"
    else
        PS1+="\n"
    fi
    PS1+="${VertBar} ${Segments[*]}\n"
    PS1+="${VertBar}${Reset} "

    PS2="${VertBar} "
}
