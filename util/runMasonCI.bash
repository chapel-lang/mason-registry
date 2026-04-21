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

  # Parses the source from the toml
  source="$(grep source "$package" | cut -d= -f2)"
  echo "source value: $source"
  # Strips the quotes off of the source and adjusts the format if necessary
  fixed=$(echo "$source" | tr -d '"' | awk '{$1=$1};1' | sed 's|git@github.com:|https://github.com/|')
  echo "adjusted source to 'fixed' value: $fixed"
  # Clones the source
  git clone "$fixed" newPackage
  if [ $? -ne 0 ]; then
    echo "Failed to clone source: $fixed. Exiting."
    exit 1
  fi

  version="$(grep version "$package" | cut -d= -f2 | tr -d '"' | awk '{$1=$1};1')"
  echo "version value: $version"
  versionTag="v$version"
  echo "version tag: $versionTag"

  # make sure version matches the filename
  filename=$(basename "$package")
  expectedFilename="$version.toml"
  if [ "$filename" != "$expectedFilename" ]; then
    echo "The toml specifies version $version, but the filename is $filename. Expected filename: $expectedFilename. Exiting."
    exit 1
  fi

  # checkout the proper version
  cd newPackage || exit 1
  git checkout "$versionTag"
  if [ $? -ne 0 ]; then
    echo "Failed to checkout version tag: $versionTag. Exiting."
    exit 1
  fi
}

checkPackage "$1"

# adds mason-registry to MASON_HOME
mason update

mason publish --ci-check
exit $?
