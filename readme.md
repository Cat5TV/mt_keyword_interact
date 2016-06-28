TPS Keyword Interact (Based on *mt_keyword_interact* by CWz aka ChaosWormz)

License: MIT

<p>This mod automatically grants interact to player who enter a keyword in chat. Presumably they have "accepted the rules" or followed other steps laid out by the server admin before obtaining said keyword, which is provided to them by the tps_signs mod.</p>

The commands (many soon to be deprecated! Left for reference only ... for now):
<br>/setkeyword [new keyword]
<br>Required privs: server 
<br>Description: set a new keyword that will take effect after next restart.
<p>/getkeyword
<br>Description: Used to get the current keyword. this command is restricted to basic_privs and server</p>
<p>/send_spawn
<br>Description: Used to send all player who do not have interact back to spawn.
<br>Required privs: basic_privs </p>
<p>/yesinteract
<br>Description: manually grant a player interact and do what the keyword does.
<br>Required privs: basic_privs </p>

Supplements:
- cron.sh (Linux) - Call this script from cron to automatically change the server's keyword from the list in keywords.txt

A keyword can be manually set by adding interact_keyword = keyword to minetest.conf
<h4>For the keyword to work the "nointeract" priv must be granted by default</h4>
