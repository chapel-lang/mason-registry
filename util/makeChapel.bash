#!/usr/bin/env bash

git clone --depth=50 --branch=master https://github.com/chapel-lang/chapel.git
cd chapel
source util/quickstart/setchplenv.bash
export CHPL_REGEXP=re2
make -j 4
make check
cd tools/mason
make install
cd ../../..


package=$(git log -m -1 --name-only --pretty="format:")
echo $package
source=$(grep source $package | cut -d= -f2)
echo $source
packageReg=$(cat $source)
cd $package
echo $packageReg
git clone $packageReg newPackage
cd newPackage
mason publish --check --travis



