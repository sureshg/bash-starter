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
# printf "Print\nWith\nNewLine"

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
javaOpts="-Dio.swagger.parser.util.RemoteUrl.trustAll=true -Djava.awt.headless=true"
exec java $javaOpts -jar "$progdir/$jarfile" "$@"

# Checks if the command exists.
command_exists() {
	command -v "$@" > /dev/null 2>&1
}

# Negating multiple conditions
# https://stackoverflow.com/a/33010770/416868
if ! ( command_exists docker && [ -e /var/run/docker.sock ] ); then
	echo "Docker doesn't exists on the system. Install docker and run again!!"
    exit 1
fi

# Run docker 
echo -e "\n Using Docker $(docker version)"
echo -e "\nRunning bundle install using '$PWD/Gemfile'...\n"
docker run --rm -v "$PWD":/usr/src/app -w /usr/src/app ruby:2.0.0 /bin/bash -c 'echo $(ruby -v) ; echo "RubyGems: $(gem --version)" ; time bundle install'