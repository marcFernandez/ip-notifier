#!/bin/bash

# Filename that will store the last known ip from the device
IP_FILEPATH="$(PWD)/current_ip.txt"
# Touch the file to create it if it does not exist yet
touch "$IP_FILEPATH"
# The telegram bot token obtained through @BotFather
BOT_TOKEN="<YOUR_BOT_TOKEN>"
# Telegram URL to perform actions with your bot (https://core.telegram.org/bots/api#making-requests)
BASE_URL="https://api.telegram.org/bot$BOT_TOKEN/"
# Method name (https://core.telegram.org/bots/api#available-methods)
COMMAND="sendMessage"
# The telegram chat id. The easiest way I've found to retrieve it is to start a new chat with your bot, sending a
# message and quickly checking the url: https://api.telegram.org/bot<bot_token>/getUpdates. This should show a JSON
# containing the following:
#     "chat":{"id":<THIS IS THE ID>,"first_name":"Alice","username":"Alice","type":"private"}
CHAT_ID="<YOUR_CHAT_ID>"

# Here we obtain our current ip using this amazing website https://ifconfig.me
CURR_IP=$(curl -s ifconfig.me/ip)
# Read the last stored IP
OLD_IP=$(cat "$IP_FILEPATH")

# Check if the IP has changed since last execution
if [[ "$CURR_IP" == "$OLD_IP" ]];
then
    exit 0
fi

# Write the new IP
printf $CURR_IP > "$IP_FILEPATH"

# Prepare the URL params
PARAMS="chat_id=$CHAT_ID&text=New%20ip:%20$CURR_IP"

# Perform the call that sends the message
curl -s "$BASE_URL$COMMAND?$PARAMS" > /dev/null
