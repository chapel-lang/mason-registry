#!/usr/bin/env bash


# Parses the last merge commit, getting the most recent package added to the registry
checkPackage () {
  package=$(git diff --name-only HEAD HEAD~1 | grep -E '.*\.toml')
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
  echo "source value: $source"
  # Strips the quotes off of the source
  fixed=$(echo "$source" | tr -d '"' | awk '{$1=$1};1')
  fixed="${fixed/git@github.com:/"https://github.com/"}"
  echo "adjusted source to 'fixed' value: $fixed"
  # Clones the source
  git clone "$fixed" newPackage
  cd newPackage || exit 1
}

checkPackage

# adds mason-registry to MASON_HOME
mason update

mason publish --ci-check
exit $?
