#!/bin/bash

# Bash Options
# http://tldp.org/LDP/abs/html/options.html
# -a	allexport	Export all defined variables
# -e	errexit	Abort script at first error, when a command exits with non-zero status
# -f	noglob	Filename expansion (globbing) disabled
# -u	nounset	Attempt to use undefined variable outputs error message, and forces an exit
# -v	verbose	Print each command to stdout before executing it
# -x	xtrace	Similar to -v, but expands commands
# -n	noexec	Read commands in script, but do not execute them (syntax check)
# Eg: set -eux
set -eu

# Program name and directory.
# http://tldp.org/LDP/abs/html/internalvariables.html
prog="$0"
progdir=$(dirname "${prog}")


# Echo with color
# echo -e "\n\xF0\x9F\x8D\xBB  Hello \e[36mWorld\e[0m..."

# Check file exists
# http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html
jarfile="swagger-codegen-cli-2.3.0.jar"
if [ ! -r "$progdir/$jarfile" ]
then
    echo "Can't find $progdir/$jarfile"
    exit 1
fi

# Avoid subshell using exec
# http://tldp.org/LDP/abs/html/x17974.html
javaOpts=""
exec java $javaOpts -Djava.awt.headless=true -jar "$progdir/$jarfile" "$@"