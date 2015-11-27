#!/bin/zsh -f
autoload colors
colors 

DEBUG=true

THEME_DEST_DIR="$HOME/.oh-my-zsh/themes/"
THEME_SRC_DIR=$0:A:h"/"

Function logInfo()  { print -P -- "%F{051}INFO  >>%f $1" }
Function logWarn()  { print -P -- "%F{226}WARN  >>%f $1" }
Function logError() { print -P -- "%F{196}ERROR >>%f $1" }
Function logDebug() { if $DEBUG; then print -P -- "%F{202}DEBUG >>%f $1"; fi }

logInfo "Destination Directory .... $THEME_DEST_DIR"
if [ ! -d $THEME_DEST_DIR ]; then
	logError "Failed to locate destination directory"
	exit 2
fi

logInfo "Source Direcrtory ........ $THEME_SRC_DIR"
if [ ! -d $THEME_SRC_DIR ]; then
	logError "Failed to locate source directory"
fi

while read line; do
	FILENAME=${(S)line##*\/}
	logDebug "File name: $FILENAME"

	THEME_NAME=${(S)FILENAME%%*.zsh-theme}
	logInfo "Installing theme: $THEME_NAME"

	if [ -f $THEME_DEST_DIR$FILENAME ]; then
		logWarn "File exists in destination directory with same name. Skipping."
	else
		CMD="ln \"$line\" \"$THEME_DEST_DIR$FILENAME\" 2>&1"
		logDebug "Running Command: $CMD"

		CMD_RESULT=`eval "$CMD"`
		if [ "$CMD_RESULT" != "" ]; then
			logDebug "Command Result: $CMD_RESULT"
		else
			logDebug "No output captured from command."
		fi

		if [ ! -f $THEME_DEST_DIR$FILENAME ]; then
			logWarn "Failed to create hard link."
		fi
	fi
done < <(ls -1 "$THEME_SRC_DIR/"*/*.zsh-theme 2>/dev/null)