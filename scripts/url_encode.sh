#!/bin/sh -eu

echo "$1" | python -c 'import sys,urllib;print urllib.quote(sys.stdin.read().strip())'
