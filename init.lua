minetest.register_privilege("nointeract", "Can enter keyword to get interact")

-- load from config 
mki_interact_keyword = minetest.setting_get("interact_keyword") or "iaccept"
mki_interact_keyword_spanish = minetest.setting_get("interact_keyword_spanish") or "iaccept"
mki_interact_keyword_french = minetest.setting_get("interact_keyword_french") or "iaccept"
mki_interact_keyword_german = minetest.setting_get("interact_keyword_german") or "iaccept"
local keyword_privs = minetest.string_to_privs(minetest.setting_get("keyword_interact_privs") or "interact,shout")
local keyword_liveupdate = minetest.setting_getbool("interact_keyword_live_changing") or nil
local teleport_msg = minetest.setting_get("mki_send_teleport_msg") or "You've been teleported back to spawn due to lacking interact." 
local mki_notice_enable = minetest.setting_getbool("keyword_notice_on") or true


minetest.register_on_chat_message(function(name, message)
	if string.gsub(message, " ", ""):lower() == mki_interact_keyword
	or string.gsub(message, " ", ""):lower() == mki_interact_keyword_spanish
	or string.gsub(message, " ", ""):lower() == mki_interact_keyword_french
	or string.gsub(message, " ", ""):lower() == mki_interact_keyword_german
	then
		if minetest.get_player_privs(name).nointeract then
			local privs = minetest.get_player_privs(name)
				for priv, state in pairs(keyword_privs,privs) do
					privs[priv] = state
				end
				privs.nointeract = nil
			minetest.set_player_privs(name, privs)

			minetest.chat_send_all("<Server> player, "..name.." read the rules and has been granted interact!")
			minetest.log("action", "[autogranter] Player, " .. name .. " Was granted interact for keyword")
			if minetest.get_modpath("irc") then
				irc:say(("* %s%s"):format("", "player, "..name.." Read the rules and has been granted interact!"))
			end

			if minetest.setting_get_pos("tps_keyword_interact_spawnpoint") then minetest.get_player_by_name(name):setpos(minetest.setting_get_pos("tps_keyword_interact_spawnpoint")) end
		else
			if minetest.get_player_privs(name).interact then
				minetest.chat_send_player(name,"You already have interact! It is only necessary to say the keyword once.")
				
				if minetest.get_modpath("notice") and mki_notice_enable == true then
					notice.send(name, "You already have interact! It is only necessary to say the keyword once.")
				end
				
			else
				minetest.chat_send_player(name,"You have been prevented from obtaining the interact privilege. Contact a server administrator if you believe this to be in error.")
				if minetest.get_modpath("notice") and mki_notice_enable == true then
					notice.send(name, "You have been prevented from obtaining the interact privilege. Contact a server administrator if you believe this to be in error.")
				end
			end
		end
		return true
	else
		if not message then return end
		local msg = message:lower()
		if msg:find(mki_interact_keyword)
		or msg:find(mki_interact_keyword_spanish)
		or msg:find(mki_interact_keyword_french)
		or msg:find(mki_interact_keyword_german) then
			message = 'Read the signs for help on how to gain interact.'
			return message
		end
	end
end)



minetest.register_chatcommand("setkeyword", {
	params = "<keyword>",
	description = "set the keyword",
	privs = {server = true},
	func = function(name, param)
		minetest.setting_set("interact_keyword", param)
		minetest.setting_save()
		minetest.log("action", "[autogranter] Admin, " .. name .. " has set a new keyward "..param)
		if keyword_liveupdate == true then
			mki_interact_keyword = param
			minetest.chat_send_player(name,"keyword has been set and will take effect immediately")
		else
			minetest.chat_send_player(name,"keyword has been set but will take effect after reboot")
		end
	end,
})

minetest.register_chatcommand("getkeyword", {
	params = "",
	description = "get the keyword",
	privs = {},
	func = function(name, param)
		if minetest.get_player_privs(name).basic_privs or minetest.get_player_privs(name).moderator or minetest.get_player_privs(name).server then
			minetest.chat_send_player(name,"Keyword is: " ..mki_interact_keyword)
			return true, "Success"
		else
			return false, "Your are not allowed to view the keyword this way. (Required privs: basic_privs, modarator or server.)"
		end
	end,
})

minetest.register_chatcommand("send_spawn", {
	params = "",
	description = "Sends all interactless players to spawn",
	privs = {basic_privs = true},
	func = function(name, player)

		for _,player in ipairs(minetest.get_connected_players()) do
			local target = player:get_player_name()
			if minetest.setting_get_pos("static_spawnpoint") and not minetest.get_player_privs(target).interact then 
				minetest.get_player_by_name(target):setpos(minetest.setting_get_pos("static_spawnpoint"))
				minetest.chat_send_player(target,teleport_msg)
				if minetest.get_modpath("notice") and mki_notice_enable == true then
					notice.send(target, teleport_msg)
				end
			end
		end
		minetest.chat_send_player(name,"Teleporting all interactless back to spawn...")
	end,
})

minetest.register_chatcommand("yesinteract", {
	params = "<playername>",
	description = "Manually does what the keyword does",
	privs = {basic_privs = true},
	func = function(name, player)
		if not minetest.get_player_privs(player).interact and minetest.auth_table[player] then
			local privs = minetest.get_player_privs(player)
				for priv, state in pairs(keyword_privs,privs) do
					privs[priv] = state
				end
				privs.nointeract = nil
			minetest.set_player_privs(player, privs)

			minetest.chat_send_all("<Server> player, "..player.." Read the rules and has been granted interact!")
			minetest.log("action", "[autogranter] Player, " .. player .. " Was granted interact by "..name)
			if minetest.get_modpath("irc") then
				irc:say(("* %s%s"):format("", "player, "..player.." Read the rules and has been granted interact(Manuelly)!"))
			end

			if minetest.setting_get_pos("alt_spawnpoint") and minetest.get_player_by_name(player) then minetest.get_player_by_name(player):setpos(minetest.setting_get_pos("alt_spawnpoint")) end
		else
			if minetest.get_player_privs(player).interact then
				minetest.chat_send_player(name,"This player("..player..") already has interact.")
			end
			
			if not minetest.auth_table[player] then
				minetest.chat_send_player(name,"This player("..player..") does not exist.")
			end
		end
	end,
})
