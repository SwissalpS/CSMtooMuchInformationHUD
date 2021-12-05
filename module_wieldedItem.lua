-- module wieldedItem --
-- by SwissalpS --
-- shows some info about wielded item. Updating
-- frequently so you can E.g. watch your dig count
-- of tool or level continuesly.
local function update(index)

	local oWI = tmi.player:get_wielded_item()
	local sItemstring = oWI:get_name()
	local iCount = oWI:get_count()
	local sDescription = oWI:get_description()

	return iCount .. ' ' .. (sDescription or sItemstring) .. '\n\n'

end -- update


tmi.addModule({
	id = 'wieldedItem',
	title = 'wieldedItem',
	onUpdate = update,
	value = 'wieldedItem',
})

--print('module wieldedItem loaded')

