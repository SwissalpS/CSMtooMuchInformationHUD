-- module countUse --
-- by SwissalpS --
-- displays a counter of item uses since reset.
-- Value can be kept persistant over sessions.
local module = {}

function module.clear(index)

	tmi.modules[index].iCount = 0
	module.save(index)

end -- clear


function module.init(index)

	if tmi.modules[index].bInitDone then return end

	module.m = tmi.modules[index]
	if not module.m then return end

	module.m.iCount = tmi.store:get_int('countUse_i')
	core.register_on_item_use(module.onUse)

end -- init


function module.onUse(item, pointed_thing)

	module.m.iCount = module.m.iCount + 1
	return false

end -- onUse


function module.save(index)

	tmi.store:set_int('countUse_i', tmi.modules[index].iCount)

end -- save


function module.update(index)

	return 'U: ' .. tmi.niceNaturalString(tmi.modules[index].iCount)

end -- update


tmi.addModule({
	id = 'countUse',
	title = 'count use',
	value = 'countUse module',
	onClear = module.clear,
	onDealoc = module.save,
	onInit = module.init,
	onUpdate = module.update,
})

--print('module countUse loaded')

