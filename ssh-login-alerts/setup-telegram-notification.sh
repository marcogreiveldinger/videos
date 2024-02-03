#!/bin/bash

# Set your Telegram bot token and chat ID
TOKEN="123456789:ABCDEFGHIJK-ABCDEFGHIJK"
ID="your-chat-id-or-group-id"

# Create the PAM script directory
sudo mkdir /etc/pam.scripts

# Create the login notification script
cat <<EOL | sudo tee /etc/pam.scripts/login-notification.sh >/dev/null
#!/bin/bash

TOKEN="$TOKEN"
ID="$ID"
HOSTNAME=\$(hostname -f)
DATE="\$(date +"%d.%b.%Y -- %H:%M")"
MESSAGE="<b>\$PAM_USER</b> did action: '<b>\$PAM_TYPE</b>' at <u>\$DATE</u> on \$HOSTNAME from IP: <code>\$PAM_RHOST</code> !"
URL="https://api.telegram.org/bot\$TOKEN/sendMessage"

curl -s -X POST \$URL -d chat_id=\$ID -d text="\$MESSAGE" -d parse_mode='HTML' 2>&1 /dev/null

exit 0
EOL

# Make the script executable
sudo chmod +x /etc/pam.scripts/login-notification.sh

# Edit the sshd PAM configuration file
echo "session required pam_exec.so /etc/pam.scripts/login-notification.sh" | sudo tee -a /etc/pam.d/sshd >/dev/null

echo "Setup complete. You will now receive Telegram notifications for SSH logins and logouts."
