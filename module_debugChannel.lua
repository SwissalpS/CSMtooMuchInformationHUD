-- module debugChannel --
-- by SwissalpS --
-- shows whatever is sent over a modchannel
--[[ in your server-side-mod, you need to
	-- join channel
	oC = core.mod_channel_join('tmi_debugChannel')
	-- best also register for channel signals to
	-- make sure join was successful
	-- at minimum check that channel is write-able
	if oC:is_writeable() then oC:send_all('your max 65k long message') end
	-- keep in mind that messages are async and also tmi has a delay between updates.
--]]
-- well, in theory that is how it should work. Did not work
-- on minetest 5.5.0 dev 46f42e15c
module = {
	oChannel = nil,
	sChannel = 'tmi_debugChannel',
}


local function onInit(index)

	module.m = tmi.modules[index]
	if not module.m then return end

	module.oChannel = core.mod_channel_join(module.sChannel)
	core.register_on_modchannel_message(module.onMessage)

end -- onInit


function module.onMessage(channel, sender, message)

	if channel ~= module.sChannel then return false end

	module.m.value = message or ''

	return true

end -- onMessage


tmi.addModule({
	id = 'debugChannel',
	title = 'debugChannel',
	value = 'debugChannel',
	onInit = onInit,
})

--print('module debugChannel loaded')

