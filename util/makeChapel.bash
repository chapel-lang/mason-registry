#!/usr/bin/env bash

cd
git clone --depth=50 --branch=release/1.19 https://github.com/chapel-lang/chapel.git
cd chapel
source util/quickstart/setchplenv.bash
./configure
export CHPL_REGEXP=re2
make -j 4
sudo make install
chpl -o hello examples/hello.chpl
