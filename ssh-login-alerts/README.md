In this guide you will learn how to modify the ssh config with pam to call any script when logging in into your server via ssh.
We use the messenger telegram to do that, but you can adapt the script to you program of choice.



[Link to the youtube video](https://youtu.be/VzH4NfJMiQc)
```
.
├── README.md
└── login-notification.sh
```

## Step 1 - Installing Telegram (or any app of your choice supporting to send messages)
Install Telegram and open the app.

## Step 2  Creating the bot
Search for the user "botfather". https://t.me/BotFather

We create a new bot by sending "botfather" the following message:

`/newbot`

"botfather" will ask for the name of the bot.

"botfather" will now create the bot and generate a token. We will need this later, so write down the token.

Here is an example of how the token looks:

`123456789:ABCDEFGHIJK-ABCDEFGHIJK`

## Step 3 Configuring the bot

Now, search for the newly created bot in your Telegram contacts. Next, start the bot by clicking on start or sending the message:

`/start`

Next, open Postman or your Browser to the address shown below. Replace "TOKEN" with the token you got from "botfather" in the previous step:

`https://api.telegram.org/bot"TOKEN"/getUpdates`

Write down the row of numbers coming after "id". This is our "Telegram_id" and will be needed in the next step.

## Step 4 - create the script

```bash
sudo mkdir /etc/pam.scripts
```

Place this script in `/etc/pam.scripts/login-notification.sh` (or elsewhere)

```bash
#!/bin/bash

TOKEN="123456789:ABCDEFGHIJK-ABCDEFGHIJK"
ID="your-chat-id-or-group-id"
HOSTNAME=$(hostname -f)
DATE="$(date +"%d.%b.%Y -- %H:%M")"
MESSAGE="<b>$PAM_USER</b> did action: '<b>$PAM_TYPE</b>' at <u>$DATE</u> on $HOSTNAME from IP: <code>$PAM_RHOST</code> !"
URL="https://api.telegram.org/bot$TOKEN/sendMessage"

curl -s -X POST $URL -d chat_id=$ID -d text="$MESSAGE" -d parse_mode='HTML' 2>&1 /dev/null

exit 0
```
Make the script executable:
```bash
sudo chmod +x /etc/pam.scripts/login-notification.sh
```

Edit the file `sudo vi /etc/pam.d/sshd` and add the following to the end:

```bash
...
# SSH Alert script
session required pam_exec.so /etc/pam.scripts/login-notification.sh
```

This will trigger the script every login and every logout and you will get notified by telegram about ssh logins.