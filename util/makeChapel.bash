#!/usr/bin/env bash

cd
git clone --depth=50 --branch=release/1.19 https://github.com/chapel-lang/chapel.git
./chapel/util/buildRelease/smokeTest CHPL_SMOKE_SKIP_DOC=true NIGHTLY_TEST_SETTING=true
CHPL_REGEXP=re2

