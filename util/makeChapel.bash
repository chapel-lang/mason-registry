#!/usr/bin/env bash

cd
git clone --depth=50 --branch=release/1.19 https://github.com/chapel-lang/chapel.git
./chapel/util/buildRelease/smokeTest CHPL_SMOKE_SKIP_DOC=true NIGHTLY_TEST_SETTING=true CHPL_REGEXP=re2
cd chapel
CHPL_BIN_SUBDIR=`"$CHPL_HOME"/util/chplenv/chpl_bin_subdir.py`
export PATH="$PATH":"$CHPL_HOME/bin/$CHPL_BIN_SUBDIR"
export MANPATH="$MANPATH":"$CHPL_HOME"/man
make install
