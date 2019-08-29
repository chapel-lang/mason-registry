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


package=$(git log -m -1 --name-only --pretty="format:")
echo $package
source=$(grep source $package | cut -d= -f2)
echo $source
git clone https://github.com/marcoscleison/chapel-gnuplot.git
git clone $source newPackage
cd newPackage
mason publish --check --travis



