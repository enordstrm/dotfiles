#!/usr/bin/env bash

if command -v diff-so-fancy > /dev/null; then
    diff-so-fancy <&0 | less --tabs=4 -RFX
else
    less --tabs=4 -RFX <&0
fi
