PROMPT_CHAR='>'

GIT_STATUS_ICON_DIRTY="❗"
GIT_STATUS_ICON_CLEAN="✔"

Function BuildPrompt() {
    LAST_EXIT_CODE=$?

    SHORT_PWD=${PWD/$HOME/"~"}
    PROMPT_STRING="$FG[027]$USERNAME@$FG[039]$HOST:$FG[051]$SHORT_PWD"

    (( TOTAL_CHAR_COUNT = ${#USERNAME} \
                        + ${#HOST} \
                        + ${#SHORT_PWD} \
                        + 2 ))

    if HasGitBranch; then
        GIT_PREFIX="git:"
        GIT_SUFIX=""
        GIT_BRANCH=$(current_branch)
        GIT_OPEN_BRACKET="{ "
        GIT_CLOSE_BRACKET=" }"
        GIT_STATUS_ICON=$(GitStatusIcon)

        (( TOTAL_CHAR_COUNT = $TOTAL_CHAR_COUNT \
                            + ${#GIT_PREFIX} \
                            + ${#GIT_SUFIX} \
                            + ${#GIT_BRANCH} \
                            + ${#GIT_OPEN_BRACKET} \
                            + ${#GIT_CLOSE_BRACKET} \
                            + ${#GIT_STATUS_ICON} ))

        PROMPT_STRING="$PROMPT_STRING$(SpaceFiller " " $TOTAL_CHAR_COUNT)$(ColoredGitStatusIcon $GIT_STATUS_ICON)$FG[027]$GIT_OPEN_BRACKET$FG[039]$GIT_PREFIX$FG[051]$GIT_BRANCH$FG[027]$GIT_CLOSE_BRACKET"
    fi
    PROMPT_STRING="$PROMPT_STRING\n$(ColoredArrow $LAST_EXIT_CODE)"

    echo $PROMPT_STRING
}

Function ColoredArrow() {
    if [[ $1 -eq 0 ]]; then
        echo "$FG[021]$PROMPT_CHAR$FG[033]$PROMPT_CHAR$FG[045]$PROMPT_CHAR$FG[051]$PROMPT_CHAR$reset_color"
    else
        echo "$FG[051]$PROMPT_CHAR$FG[045]$PROMPT_CHAR$FG[033]$PROMPT_CHAR$FG[021]$PROMPT_CHAR$reset_color"
    fi
}

Function HasGitBranch() {
    if [ -z $(current_branch) ]; then
        return 1
    else
        return 0
    fi
}
Function GitStatusIcon() {
    if $(git status 2>/dev/null | tail -n1 | grep -iq "nothing to commit"); then
        echo "$GIT_STATUS_ICON_CLEAN"
    else
        echo "$GIT_STATUS_ICON_DIRTY"
    fi
}
Function ColoredGitStatusIcon() {
    if [[ "$1" == "$GIT_STATUS_ICON_CLEAN" ]]; then
        echo "$FG[082]$1"
    else
        echo "$FG[196]$1"
    fi
}

Function SpaceFiller() {
    fillChar=$1
    fillOffset=$2

    while [ $fillOffset -gt $COLUMNS ]; do
        (( fillOffset = $fillOffset - $COLUMNS ))
    done
    (( fillLength = $COLUMNS - $fillOffset ))

    for i in {1..$fillLength}; do
        filler="$filler$fillChar"
    done

    echo $filler
}

PROMPT='$(BuildPrompt) '