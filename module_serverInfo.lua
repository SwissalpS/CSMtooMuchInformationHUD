-- module serverInfo
-- by SwissalpS --
-- displays too much information about server
local function init(index)

	if tmi.modules[index].bInitDone then return end

	local function restrictionString(b) return b and '0' or '1' end
	local rs = restrictionString

	local tCSM = core.get_csm_restrictions()
	local oSI = core.get_server_info()
	local sLocal, sLanguage = core.get_language()
	local sOut = oSI.address .. '/' .. oSI.ip .. ':' .. oSI.port
		.. 'v' .. oSI.protocol_version .. '-' .. sLocal .. '/' .. sLanguage
		.. '\nCSM: ' .. rs(tCSM.read_playerinfo) .. rs(tCSM.lookup_nodes)
		.. rs(tCSM.read_nodedefs) .. rs(tCSM.read_itemdefs)
		.. rs(tCSM.chat_messages) .. rs(tCSM.load_client_mods)

	tmi.modules[index].value = sOut

end -- init


tmi.addModule({
	id = 'serverInfo',
	title = 'server info',
	value = 'serverInfo module',
	onInit = init,
})

--print('module serverInfo loaded')

