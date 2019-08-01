#!/bin/sh -eu

HAMMERSPEEN_CONFIG_PATH_KEY="HAMMERSPEEN_CONFIG_PATH="
HAMMERSPEEN_CONFIG_PATH=$(grep --color=always -E "^$HAMMERSPEEN_CONFIG_PATH_KEY" .env | sed "s/$HAMMERSPEEN_CONFIG_PATH_KEY//")

ls -1 scripts \
| xargs -I v -P 1 cp scripts/v $HAMMERSPEEN_CONFIG_PATH/scripts/v
