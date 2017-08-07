Zabbix Slack AlertScript
========================

fork of [zabbix-slack-alertscript](https://github.com/ericoc) 

About
-----
This is simply a Bash script that uses the custom alert script functionality within [Zabbix](http://www.zabbix.com/) along with the incoming web-hook feature of [Slack](https://slack.com/) that I got a chance to write since I could not find any already existing/similar scripts.

It's based on [zabbix-slack-alertscript](https://github.com/ericoc) from [ericoc](https://github.com/ericoc) for the bash script and [zabbix-notify](https://github.com/v-zhuravlev/zabbix-notify) from [v-zhuravlev](https://github.com/v-zhuravlev) for the slack's attachments used in Zabbix actions templates with a slight touch of [bash-slack](https://github.com/sulhome/bash-slack) from [sulhome](https://github.com/sulhome)

#### Versions
This works with version 3.x - should works with 2.x and maybe with 1.8+

Installation
------------

### The script itself

This [`slack.sh` script](https://github.com/jraigneau/zabbix-slack-alertscript/raw/master/slack.sh) needs to be placed in the `AlertScriptsPath` directory that is specified within the Zabbix servers' configuration file (`zabbix_server.conf`) and must be executable by the user running the zabbix_server binary (usually "zabbix") on the Zabbix server:

	[root@zabbix ~]# grep AlertScriptsPath /etc/zabbix/zabbix_server.conf
	### Option: AlertScriptsPath
	AlertScriptsPath=/usr/local/share/zabbix/alertscripts

	[root@zabbix ~]# ls -lh /usr/local/share/zabbix/alertscripts/slack.sh
	-rwxr-xr-x 1 root root 1.4K Dec 27 13:48 /usr/local/share/zabbix/alertscripts/slack.sh

If you do change `AlertScriptsPath` (or any other values) within `zabbix_server.conf`, a restart of the Zabbix server software is required.

Configuration
-------------

### Slack.com web-hook

An incoming web-hook integration must be created within your Slack.com account which can be done at [https://my.slack.com/services/new/incoming-webhook](https://my.slack.com/services/new/incoming-webhook) as shown below:

![Slack.com Incoming Web-hook Integration](https://pictures.ericoc.com/github/newapi/slack-integration.png "Slack.com Incoming Web-hook Integration")

Given the above screenshot, the incoming web-hook URL would be:

	https://hooks.slack.com/services/QW3R7Y/D34DC0D3/BCADFGabcDEF123
	
Make sure that you specify your correct Slack.com incoming web-hook URL and feel free to edit the sender user name at the top of the script:

	# Slack incoming web-hook URL and user name
	url='https://hooks.slack.com/services/QW3R7Y/D34DC0D3/BCADFGabcDEF123'
	username='Zabbix'


### Within the Zabbix web interface

When logged in to the Zabbix servers web interface with super-administrator privileges, navigate to the "Administration" tab, access the "Media Types" sub-tab, and click the "Create media type" button.

You need to create a media type as follows:

* **Name**: Slack
* **Type**: Script
* **Script name**: slack.sh

...and ensure that it is enabled before clicking "Save", like so:

![Zabbix Media Type](https://pictures.ericoc.com/github/zabbix-mediatype.png "Zabbix Media Type")

However, on Zabbix 3.x and greater, media types are configured slightly differently and you must explicity define the parameters sent to the `slack.sh` script. On Zabbix 3.x, three script parameters should be added as follows:

* `{ALERT.SENDTO}`
* `{ALERT.SUBJECT}`
* `{ALERT.MESSAGE}`

...as shown here:

![Zabbix 3.x Media Type](https://pictures.ericoc.com/github/zabbix3-mediatype.png "Zabbix 3.x Media Type")

Then, create a "Slack" user on the "Users" sub-tab of the "Administration" tab within the Zabbix servers web interface and specify this users "Media" as the "Slack" media type that was just created with the Slack.com channel ("alerts" in the example)

Finally, an action can then be created on the "Actions" sub-tab of the "Configuration" tab within the Zabbix servers web interface to notify the Zabbix "Slack" user ensuring that the "Subject" is "PROBLEM" for "Default message" and "RECOVERY" should you choose to send a "Recovery message".

Default subject
	{TRIGGER.STATUS}

Default Message for operations
	{
	            "fallback": "[[{HOST.NAME}:{TRIGGER.NAME}:{STATUS}]]",
	            "pretext": "New Alarm",
	"color":"danger",
	            "author_name": "{HOST.NAME}",
	  "title": "{TRIGGER.NAME}",
	            "title_link": "http://supervision.zeneffy.fr/tr_events.php?triggerid={TRIGGER.ID}&eventid={EVENT.ID}",
	            "fields": [         
	              {
	                    "title": "Status",
	                    "value": "{STATUS}",
	                    "short": true
	                },
	                {
	                    "title": "Severity",
	                    "value": "{TRIGGER.SEVERITY}",
	                    "short": true
	                },
	                {
	                    "title": "Start Time",
	                    "value": "{EVENT.DATE} {EVENT.TIME}",
	                    "short": true
	                }  
	            ]
	        }

Default Message for Recovery operations
	{
	            "fallback": "[[{HOST.NAME}:{TRIGGER.NAME}:{STATUS}]]",
	            "pretext": "Cleared",
	"color":"good",
	            "author_name": "{HOST.NAME}",
	            "title": "{TRIGGER.NAME}",
	            "title_link": "http://supervision.zeneffy.fr/tr_events.php?triggerid={TRIGGER.ID}&eventid={EVENT.RECOVERY.ID}",
	            "fields": [
	                {
	                    "title": "Status",
	                    "value": "{STATUS}",
	                    "short": true
	                },
	                {
	                    "title": "Severity",
	                    "value": "{TRIGGER.SEVERITY}",
	                    "short": true
	                },
	                {
	                    "title": "Recovery Time",
	                    "value": "{EVENT.RECOVERY.DATE} {EVENT.RECOVERY.TIME}",
	                    "short": true
	                }                
	            ]
	        }


More Information
----------------
* [Slack incoming web-hook functionality](https://my.slack.com/services/new/incoming-webhook)
* [Zabbix 2.2 custom alertscripts documentation](https://www.zabbix.com/documentation/2.2/manual/config/notifications/media/script)
* [Zabbix 2.4 custom alertscripts documentation](https://www.zabbix.com/documentation/2.4/manual/config/notifications/media/script)
* [Zabbix 3.x custom alertscripts documentation](https://www.zabbix.com/documentation/3.0/manual/config/notifications/media/script)
