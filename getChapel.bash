#!/usr/bin/env bash


echo 'git clone --depth=10 --branch=release/1.19 https://github.com/chapel-lang/chapel.git'
cd chapel
echo 'source util/quickstart/setchplenv.bash'
echo 'make'
