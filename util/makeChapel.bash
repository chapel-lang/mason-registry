#!/usr/bin/env bash

#Clones master of chapel and quickstarts with CHPL_REGEXP=re2
git clone --depth=50 --branch=master https://github.com/chapel-lang/chapel.git
cd chapel
source util/quickstart/setchplenv.bash
export CHPL_REGEXP=re2
make -j 4

#Runs a make check and makes mason
make check
cd tools/mason
make install
cd ../../../
pwd

# Parses the last merge commit, getting the most recent package added to the registry
package=$(git log -m -1 --name-only --pretty="format:")
pwd
end=".end"
path="$package$end"
cd $(dirname $path)
# grabs the source from the toml
echo $package
pwd
FILE=$package
basename "$FILE"
f="$(basename -- $FILE)"
echo "$f"
source="$(grep source "$f" | cut -d= -f2)"
echo $source
#strips the quotes off of the source
fixed=$(echo "$source" | tr -d '"')
#clones the source
echo $fixed
git clone $fixed newPackage
cd newPackage
#runs mason publish --check --travis on the package
mason publish --ci-check



