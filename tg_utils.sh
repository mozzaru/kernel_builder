#!/bin/bash
#
# ...exists to not have ugly looking code blocks in ci lmao

case $1 in
  msg)
    curl -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
      -d chat_id="${CHAT_ID}" \
      -d "disable_web_page_preview=true" \
      -d "parse_mode=html" \
      -d text="$2"
  ;;
  up | upload)
    curl -F chat_id="${CHAT_ID}" \
      -F document=@"$2" \
      -F parse_mode=markdown https://api.telegram.org/bot${BOT_TOKEN}/sendDocument \
      -F caption="$3"
  ;;
esac
