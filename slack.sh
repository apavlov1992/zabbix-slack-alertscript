#!/bin/bash

# Slack incoming web-hook URL and user name
url='WEBHOOK ZABBOX'		# example: https://hooks.slack.com/services/QW3R7Y/D34DC0D3/BCADFGabcDEF123
username='BOT ZABBIX'

## Values received by this script:
# To = $1 (Slack channel or user to send the message to, specified in the Zabbix web interface; "@username" or "#channel")
# Subject = $2 (usually either PROBLEM or RECOVERY) // not used in this version
# Message = $3 (whatever message the Zabbix action sends, preferably something like "Zabbix server is unreachable for 5 minutes - Zabbix server (127.0.0.1)")

# Get the Slack channel or user ($1) and Zabbix subject ($2 - hopefully either PROBLEM or RECOVERY)
to="$1"
subject="$2"

#  followed by the message that Zabbix actually sent us ($3)
message="[$3]"

# Build our JSON payload and send it as a POST request to the Slack incoming web-hook URL
read -d '' payload << EOF
{
        "channel": "${to}",
        "username": "${username}",
        "attachments": ${message}
    }
EOF

curl -m 5 --data "${payload}" -H 'Content-type: application/json' $url