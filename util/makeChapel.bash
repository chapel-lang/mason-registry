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
cd $(dirname $package + .end)
# grabs the source from the toml
source="$(grep source "$package" | cut -d= -f2)"
fixed=$(sed -e 's/^"//' -e 's/"$//' <<<"$source")
#clones the source
git clone $fixed newPackage
cd newPackage
#runs mason publish --check --travis on the package
mason publish --check --travis



