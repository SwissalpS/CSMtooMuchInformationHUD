-- module countDig --
-- by SwissalpS --
-- Displays dig-count since reset.
local module = {}

function module.clear(index)

	tmi.modules[index].iCount = 0
	module.save(index)

end -- clear


function module.init(index)

	if tmi.modules[index].bInitDone then return end

	module.m = tmi.modules[index]
	if not module.m then return end

	module.m.iCount = tmi.store:get_int('countDig_i')
	core.register_on_dignode(module.onDig)

end -- init


function module.onDig(pos, node)

	module.m.iCount = module.m.iCount + 1
	return false

end -- onDig


function module.save(index)

	tmi.store:set_int('countDig_i', tmi.modules[index].iCount)

end -- save


function module.update(index)

	return 'D: ' .. tmi.niceNaturalString(tmi.modules[index].iCount)

end -- update


tmi.addModule({
	id = 'countDig',
	title = 'count dig',
	value = 'countDig module',
	onClear = module.clear,
	onDealoc = module.save,
	onInit = module.init,
	onUpdate = module.update,
})

--print('module countDig loaded')

