#!/bin/sh -eu

sleep 2

# https://api.slack.com/methods/chat.postMessage
curl \
-X GET \
-H 'Content-type: application/json' \
'https://slack.com/api/chat.postMessage?token=$1&channel=$2&text=$3&as_user=true&pretty=1'
