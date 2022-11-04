#!/usr/bin/env bash

# Clones master of chapel and quickstarts with CHPL_REGEXP=re2
git clone --depth=1 --branch=main https://github.com/chapel-lang/chapel.git

buildChapel () {
  cd chapel || exit 1
  source util/quickstart/setchplenv.bash
  export CHPL_REGEXP=re2
  export CHPL_RE2=bundled
  make
 }

# Runs a make check, and if it passes then makes mason
makeCheckAndMason () {
  make check
  output=$?
  if [ ${output} -eq 0 ]; then
    make mason
  else
    exit 1
  fi
 }

# Parses the last merge commit, getting the most recent package added to the registry
checkPackage () {
  cd ..
  package=$(git diff --name-only HEAD HEAD~1)
  end=".end"
  path="$package$end"
  cd "$(dirname "$path")" || exit 1
  echo "package detected from git diff: ${package}"
  echo "package path: ${path}"

  # Parses the source from the toml
  FILE=$package
  basename "$FILE"
  f="$(basename -- "$FILE")"
  source="$(grep source "$f" | cut -d= -f2)"
  echo $source
  # Strips the quotes off of the source
  fixed=$(echo "$source" | tr -d '"')
  echo "$fixed"
  # Clones the source
  git clone "$fixed" newPackage
  cd newPackage || exit 1
 }

buildChapel

makeCheckAndMason

checkPackage

# adds mason-registry to MASON_HOME
mason update

mason publish --ci-check
exit $?

