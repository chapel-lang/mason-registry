#!/usr/bin/env bash

cd Bricks

func() {
    DIR=$1
    if [[ $DIR != "." && $DIR != '..' ]]; then
        if ls $DIR/*.toml &>/dev/null
        then
            echo "Found toml for $DIR"
        else
            echo "Could not find toml for $DIR"
            exit 1
        fi
    fi
}


ls -f  | while read -r file; do func $file; done

