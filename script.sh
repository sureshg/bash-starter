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
# Get the absolute path
abs_path=$(realpath ${prog})

## Set mydir to the directory containing the script
## The ${var%pattern} format will remove the shortest match of
## pattern from the end of the string. Here, it will remove the
## script's name,. leaving only the directory.
mydir="${0%/*}"

# Default value
jdk_version=${1:-loom}

# Echo with color
# https://stackoverflow.com/a/28938235/416868
echo -e "\n\xF0\x9F\x8D\xBB  Hello \e[36mWorld\e[0m..."
echo -e "\033[1;32m BOLD GREEN \033[0m"
echo -e "\n\033[1;37mNative binary is: \033[1;32m$(realpath ${bin_name})\033[0m"
# Newlines.
printf "Print\nWith\nNewLine"
echo -e "Hello\nworld"
echo

# Prevent printing dir stack.
pushd ${project_dir} >/dev/null
popd >/dev/null

# File size
size_in_bytes=$(stat -f%z ${file})
size_str=$(du -sh $filename)
file_type=$(file ${bin_name})

# Check file exists
# http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html
jarfile="swagger-codegen-cli-2.3.0.jar"
if [ ! -r "$progdir/$jarfile" ]; then
  echo "Can't find $progdir/$jarfile"
  exit 1
fi

# Avoid subshell using exec
# http://tldp.org/LDP/abs/html/x17974.html
javaOpts="-Dio.swagger.parser.util.RemoteUrl.trustAll=true -Djava.awt.headless=true"
exec java $javaOpts -jar "$progdir/$jarfile" "$@"

# Checks if the command exists.
command_exists() {
  command -v "$@" >/dev/null 2>&1
}

# Negating multiple conditions
# https://stackoverflow.com/a/33010770/416868
if ! (command_exists docker && [ -e /var/run/docker.sock ]); then
  echo "Docker doesn't exists on the system. Install docker and run again!!"
  exit 1
fi

# Run docker
echo -e "\n Using Docker $(docker version)"
echo -e "\nRunning bundle install using '$PWD/Gemfile'...\n"
docker run --rm -v "$PWD":/usr/src/app -w /usr/src/app ruby:2.0.0 /bin/bash -c 'echo $(ruby -v) ; echo "RubyGems: $(gem --version)" ; time bundle install'

# Multiline echo
# --------------
cat <<'EOF'
Seems like GraalVM is not installed or setup properly on this machine.
Download GraalVM from https://www.graalvm.org/downloads/ and set the
path variable,

 export GRAAL_HOME=/graalvm/install/path/
 export JAVA_HOME=$GRAAL_HOME
 export PATH=$JAVA_HOME/bin:$PATH
EOF

# Multiline echo without cat & without needing to escape the quotes.
# Putting quotes around the sentinel (EOF) prevents the text from
# undergoing parameter expansion.
# -----------------------------------------------------------------

IFS='' read -r -d '' content <<"EOF"
#!/usr/bin/env ruby

require 'rubygems'
require 'open-uri'

hostname = `hostname`
ip_address = `hostname -i`

puts "From Ruby >> Hostname: #{hostname}, IP Address: #{ip_address}"
EOF

# Print without line breaks
echo ${content}

# Print without line breaks
echo "$content"

# Hashtable using array
# ---------------------
hash=(
  'k1::v1'
  'k2::v2'
  'k3::v3'
)

for index in "${hash[@]}"; do
  key="${index%%::*}"
  value="${index##*::}"
  echo -e "\033[36m$key\033[0m => \033[36m$value\033[0m"
done

# SSH Local Port forwarding (https://git.io/fFY85)
local_port=1443
if lsof -Pi :${local_port} -sTCP:LISTEN -t >/dev/null; then
  echo "SSH tunnel is already established!"
else
  echo "SSH local port forwarding."
  nohup ssh -Cfo ExitOnForwardFailure=yes -N user@remotehost -L ${local_port}:${apihost}:443
  sleep 6s
fi

# Extract tar.gz from a file/URL
curl -L https://github.com/istio/fortio/releases/download/v1.1.0/fortio-linux_x64-1.1.0.tgz |
  sudo tar -C / -xvzpf -

# Search download and extract
curl -sSL https://jdk.java.net/loom | grep -m1 -Eioh "https:.*osx-x64_bin.tar.gz" | xargs curl | tar xvz -

# Traverse through directories and run some command
# -------------------------------------------------

success=0
failures=0
# for all dir ~/test/**/
for d in ~/test/*/; do
  echo -n "$(basename "$d")… "
  diff=$(diff -U 0 "$d""expected.txt" <(./dependency-tree-diff.main.kts "$d""old.txt" "$d""new.txt"))
  if [[ $? == 0 ]]; then
    echo "✅"
    success=$((success + 1))
  else
    echo "🚫"
    echo "$diff"
    echo
    failures=$((failures + 1))
  fi
done

echo
echo "$((success + failures)) tests, $success pass, $failures fail"
if [[ $failures != 0 ]]; then
  exit 1
fi

# Print text in a box
function box() {
  local s="$*"
  tput setaf 3
  echo
  echo
  echo
  echo " -${s//?/-}-
| ${s//?/ } |
| $(tput setaf 4)$s$(tput setaf 3) |
| ${s//?/ } |
 -${s//?/-}-"
  tput sgr 0
}
