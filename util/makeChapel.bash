#!/usr/bin/env bash

cd
git clone --depth=50 --branch=release/1.19 https://github.com/chapel-lang/chapel.git
cd chapel
./configure PREFIX='/build/'
source util/quickstart/setchplenv.bash
make -j 4 CHPL_REGEXP=re2
sudo make install
chpl -o hello examples/hello.chpl
