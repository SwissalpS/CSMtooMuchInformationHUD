-- module elapsed time since last mesecons_clear_penalty --
-- by SwissalpS --
-- displays IRL time passed in since mesecons_clear_penalty command
-- was issued.
local timeOfReset = core.get_us_time()
local hasChatCSM = not core.get_csm_restrictions().chat_messages


local function clear(index) timeOfReset = core.get_us_time() end -- clear


local function update(index)

	local iE = (core.get_us_time() - timeOfReset) * .000001
	local sE = string.format('%02i:%02i:%02i', iE / 3600, iE / 60 % 60, iE % 60)

	-- auto-clear on servers that allow sending commands
	if hasChatCSM and 121 < iE then
		core.run_server_chatcommand('mesecons_clear_penalty', '')
		--clear(index)
	end

	return 'mcp: ' .. sE

end -- update


local function inspectOutgoingChat(sMessage)

	if '/mesecons_clear_penalty' == sMessage then clear() end

	return false

end -- inspectOutgoingChat


local function inspectChat(sMessage)

	if 'penalty reset' == sMessage then clear() end

	return false

end -- inspectChat


--core.register_on_sending_chat_message(inspectOutgoingChat)
core.register_on_receiving_chat_message(inspectChat)

tmi.addModule({
	id = 'timeMeseconsClear',
	title = 'mcp',
	value = 'mesecons penalty module',
	onClear = clear,
	onUpdate = update,
})

--print('module timeMeseconsClear loaded')

