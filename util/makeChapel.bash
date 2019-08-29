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
cd ../../..

# Parses the last merge commit, getting the most recent package added to the registry
package=$(git log -m -1 --name-only --pretty="format:")
cd $package
# grabs the source from the toml
source="$(grep source "$package" | cut -d= -f2)"
temp="${source%\"}"
temp="${temp#\"}"
#clones the source
git clone $temp newPackage
cd newPackage
#runs mason publish --check --travis on the package
mason publish --check --travis



