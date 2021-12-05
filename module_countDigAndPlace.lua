-- module countDaP --
-- by SwissalpS --
-- Displays a combined count of item placed and dug since reset.
-- Does not keep track itself uses module_countDig and/or module_countPlace
local module = {}


function module.init(index)

	local m = tmi.modules[index]
	if m.bInitDone then return end

	module.indexDig = tmi.moduleLookup['countDig']
	module.indexPlace = tmi.moduleLookup['countPlace']

end -- init


function module.update(index)

	local iD = module.indexDig and tmi.modules[module.indexDig].iCount or 0
	local iP = module.indexPlace and tmi.modules[module.indexPlace].iCount or 0

	return 'D&P: ' .. tmi.niceNaturalString(iD + iP)

end -- update


tmi.addModule({
	id = 'countDaP',
	title = 'count dig+place',
	value = 'countDaP module',
	onInit = module.init,
	onUpdate = module.update,
})

--print('module countDaP loaded')

