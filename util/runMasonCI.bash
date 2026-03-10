#!/usr/bin/env bash


checkPackage () {
  package=$1
  if [ -z "$package" ]; then
    echo "No package path provided. Exiting."
    exit 1
  fi
  if [ ! -f "$package" ]; then
    echo "Provided package path does not exist: $package. Exiting."
    exit 1
  fi
  echo "package detected from git diff: ${package}"
  echo "package path: ${path}"

  # Parses the source from the toml
  source="$(grep source "$package" | cut -d= -f2)"
  echo "source value: $source"
  # Strips the quotes off of the source
  fixed=$(echo "$source" | tr -d '"' | awk '{$1=$1};1')
  fixed="${fixed/git@github.com:/"https://github.com/"}"
  echo "adjusted source to 'fixed' value: $fixed"
  # Clones the source
  git clone "$fixed" newPackage
  cd newPackage || exit 1
}

checkPackage "$1"

# adds mason-registry to MASON_HOME
mason update

mason publish --ci-check
exit $?
