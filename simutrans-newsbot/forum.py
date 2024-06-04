#
# Copyright (c) 2024 Roberto Michán Sánchez (Roboron) <roboron@simutrans.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
from rss_parser import Parser
from requests import get
from discord_webhook import DiscordWebhook

def list_read(name):
    try:
        file = open(name, 'r')
    except FileNotFoundError:
        file = open(name, 'x')
        file.close()
        return []
    else:
        list = file.read().splitlines()
        file.close()
        return list

def list_append(name, value):
    file = open(name, 'a')
    file.write(value + '\n')
    file.close()

rss_url = "https://forum.simutrans.com/index.php?PHPSESSID=aad6565167745cb27405b16c6607adf4&action=.xml;type=rss2"
response = get(rss_url)

rss = Parser.parse(response.text)
previous_ids = list_read('previous_ids')

for item in rss.channel.items:
    
    thread_id = item.link.split(",")[1].split(".")[0]
    print(thread_id)
    if thread_id in previous_ids:
        continue
    else:
        list_append('previous_ids', thread_id)

    webhook_url = list_read('webhook_url')[0]
    content = item.title.replace('&quot;', '"')
    content += "\n" + str(item.link)
    webhook = DiscordWebhook(url=webhook_url, content=content)
    response = webhook.execute(remove_embeds=True)
