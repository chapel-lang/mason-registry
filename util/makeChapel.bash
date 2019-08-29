#!/usr/bin/env bash

git clone --depth=50 --branch=release/1.19 https://github.com/chapel-lang/chapel.git
cd chapel
source util/quickstart/setchplenv.bash
export CHPL_REGEXP=re2
make -j 4
make check
cd tools/mason
make install
cd ../..
chpl ../compileCHPL.chpl -M chapel/tools/mason
./compileCHPL


package=$(git log -m -1 --name-only --pretty="format:")
cd $package

awk -F= '/source/ { print $2 }' $package


