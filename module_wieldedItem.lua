-- module wieldedItem --
-- by SwissalpS --
-- shows some info about wielded item. Updating
-- frequently so you can E.g. watch your dig count
-- of tool or level continuesly.
local function update(index)

	local oWI = tmi.player:get_wielded_item()
	local oMeta = oWI:get_meta()
	local sItemstring = oWI:get_name()
	if '' == sItemstring then return 'Empty Hand\n' end

	local iCount = oWI:get_count()
	local sDescription = oWI:get_description()
	local iWear = oWI:get_wear()
	local sWear
	if 0 == iWear then
		sWear = 'None'
	else
		sWear = tmi.niceNaturalString(65535 - iWear)
	end

	local sPos = oMeta:get_string('target_pos')
	if '' ~= sPos then sWear = sPos end

	return iCount .. ' ' .. (sDescription or sItemstring)
			.. '\nItemstr: ' .. sItemstring
			.. '\nWear: ' .. sWear
			.. '\n'

end -- update


tmi.addModule({
	id = 'wieldedItem',
	title = 'wieldedItem',
	onUpdate = update,
	value = 'wieldedItem',
})

--print('module wieldedItem loaded')

