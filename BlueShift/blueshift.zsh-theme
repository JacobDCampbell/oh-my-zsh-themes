PROMPT_CHAR='>'

Function BuildPrompt() {
	LAST_EXIT_CODE=$?

	GIT_PREFIX="git:"
	GIT_SUFIX=""
	GIT_BRANCH=$(GitBranch)
	GIT_OPEN_BRACKET="{ "
	GIT_CLOSE_BRACKET=" }"

	(( TOTAL_CHAR_COUNT = ${#GIT_PREFIX} \
	                    + ${#GIT_SUFIX} \
	                    + ${#GIT_BRANCH} \
	                    + ${#GIT_OPEN_BRACKET} \
	                    + ${#GIT_CLOSE_BRACKET} ))

	PROMPT_STRING="$(SpaceFiller " " $TOTAL_CHAR_COUNT)$FG[027]$GIT_OPEN_BRACKET$FG[039]$GIT_PREFIX$FG[051]$GIT_BRANCH$FG[027]$GIT_CLOSE_BRACKET\n$(ColoredArrow $LAST_EXIT_CODE)"

	echo $PROMPT_STRING
}

Function ColoredArrow() {
	if [[ $1 -eq 0 ]]; then
		echo "$FG[021]$PROMPT_CHAR$FG[033]$PROMPT_CHAR$FG[045]$PROMPT_CHAR$FG[051]$PROMPT_CHAR$reset_color"
	else
		echo "$FG[051]$PROMPT_CHAR$FG[045]$PROMPT_CHAR$FG[033]$PROMPT_CHAR$FG[021]$PROMPT_CHAR$reset_color"
	fi
}

Function GitBranch() {
	GIT_BRANCH=$(current_branch)

	if [[ ${#GIT_BRANCH} < 1 ]]; then
		GIT_BRANCH="n/a"
	fi

	echo "$GIT_BRANCH"
}

Function SpaceFiller() {
	fillChar=$1
	fillOffset=$2

	(( fillLength = ${COLUMNS} - $fillOffset ))

	for i in {1..$fillLength}; do
		filler="$filler$fillChar"
	done

	echo $filler
}

PROMPT='$(BuildPrompt) '