#!/bin/bash

# Streaming download and extract
# curl -sSL https://jdk.java.net/loom | grep -m1 -Eioh "https:.*osx-x64_bin.tar.gz" | xargs curl | tar xvz -

set -eu

jdk_version=${1:-loom}
case "$OSTYPE" in
darwin*)
  os=osx
  ;;
msys*)
  os=windows
  ;;
*)
  os=linux
  ;;
esac

echo "Using OS: $os"
download_url=$(curl -sSL "https://jdk.java.net/$jdk_version" | grep -m1 -Eioh "https:.*($os-).*.(tar.gz|zip)")
openjdk_file="${download_url##*/}"

echo "$jdk_version openjdk file: $openjdk_file"
echo "Downloading openjdk: $download_url..."
# echo $download_url | xargs curl -O
curl -O "$download_url"
# shellcheck disable=SC2002
cat "$openjdk_file" | tar xv -

jdk_dir=$(tar -tzf "$openjdk_file" | head -3 | tail -1 | cut -f2 -d"/")
echo "$jdk_version openjdk dir: $jdk_dir"

# $ sdk i java jdk-16-loom ./jdk-16.jdk
# $ sdk u java jdk-16-loom
