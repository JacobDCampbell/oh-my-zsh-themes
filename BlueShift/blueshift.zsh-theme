PROMPT_CHAR='>'

Function ColoredArrow() {
	LAST_EXIT_CODE=$?
	if [[ $LAST_EXIT_CODE -eq 0 ]]; then
		echo "$FG[021]$PROMPT_CHAR$FG[033]$PROMPT_CHAR$FG[045]$PROMPT_CHAR$FG[051]$PROMPT_CHAR$reset_color"
	else
		echo "$FG[051]$PROMPT_CHAR$FG[045]$PROMPT_CHAR$FG[033]$PROMPT_CHAR$FG[021]$PROMPT_CHAR$reset_color"
	fi
}

PROMPT='$(ColoredArrow) '