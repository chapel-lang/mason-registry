#!/usr/bin/env bash

# Clones master of chapel and quickstarts with CHPL_REGEXP=re2
git clone --depth=1 --branch=master https://github.com/chapel-lang/chapel.git
cd chapel

buildChapel {
  cd chapel
  source util/quickstart/setchplenv.bash
  export CHPL_REGEXP=re2
  make }

# Runs a make check, and if it passes then makes mason
makeCheckAndMason {
  make check
  output=$?
  if [ '$output' -eq 0 ]; then
    make mason
  else
    exit 1
  fi }

# Parses the last merge commit, getting the most recent package added to the registry
checkPackage {
  package=$(git log -m -1 --name-only --pretty="format:")
  end=".end"
  path="$package$end"
  cd $(dirname $path)

  # Parses the source from the toml
  FILE=$package
  basename "$FILE"
  f="$(basename -- $FILE)"
  source="$(grep source "$f" | cut -d= -f2)"

  # Strips the quotes off of the source
  fixed=$(echo "$source" | tr -d '"')

  # Clones the source
  git clone $fixed newPackage
  cd newPackage }

buildChapel

makeCheckAndMason

checkPackage

mason publish --ci-check
exit $?
