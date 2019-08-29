#!/usr/bin/env bash

git clone --depth=50 --branch=release/1.19 https://github.com/chapel-lang/chapel.git
cd chapel
source util/quickstart/setchplenv.bash
export CHPL_REGEXP=re2
make -j 4
make check
cd tools/mason
make install
cd ../../..


package=$(git log -m -1 --name-only --pretty="format:")
awk -F= '/source/ { source=$2 }' $package
echo $source
git clone $source


