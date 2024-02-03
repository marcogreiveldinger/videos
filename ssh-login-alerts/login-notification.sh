#!/bin/bash

TOKEN="123456789:ABCDEFGHIJK-ABCDEFGHIJK"
ID="your-chat-id-or-group-id"
HOSTNAME=$(hostname -f)
DATE="$(date +"%d.%b.%Y -- %H:%M")"
MESSAGE="<b>$PAM_USER</b> did action: '<b>$PAM_TYPE</b>' at <u>$DATE</u> on $HOSTNAME from IP: <code>$PAM_RHOST</code> !"
URL="https://api.telegram.org/bot$TOKEN/sendMessage"

curl -s -X POST $URL -d chat_id=$ID -d text="$MESSAGE" -d parse_mode='HTML' 2>&1 /dev/null

exit 0