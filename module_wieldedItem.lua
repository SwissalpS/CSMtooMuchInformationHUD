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
	local iMax = 65535
	-- invert wear amount
	local iRemaining = iMax - iWear
	local fRemainingPercent = .01 * math.floor(
			10000 * iRemaining / iMax)
	local sWear
	if 0 == iWear then
		sWear = 'None'
	else
		sWear = tmi.niceNaturalString(iRemaining)
	end

	local sAux = ''
	local sPos = oMeta:get_string('target_pos')
	if '' ~= sPos then
		sAux = 'Target: ' .. sPos
	else
		-- yes, it should be "Remaining wear" but that's
		-- just too long on smaller screens
		sAux = 'Wear: ' .. sWear
				.. '  ' .. fRemainingPercent .. '%'
	end

	---------------------------------------------------------------
	-- here you can comment out lines you don't want or add more --
	-- depending on what you are interested in seeing in HUD     --
	---------------------------------------------------------------
	return (sDescription or sItemstring)
			.. '\n' .. iCount .. ' ' .. sItemstring
			.. '\n' .. sAux
			.. '\n'

end -- update


tmi.addModule({
	id = 'wieldedItem',
	title = 'wieldedItem',
	onUpdate = update,
	value = 'wieldedItem',
})

--print('module wieldedItem loaded')

