-- module countPlace --
-- by SwissalpS --
-- displays a counter of items placed since reset.
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

	module.m.iCount = tmi.store:get_int('countPlace_i')
	core.register_on_placenode(module.onPlace)

end -- init


function module.onPlace(pointed_thing, node)

	module.m.iCount = module.m.iCount + 1
	return false

end -- onPlace


function module.save(index)

	tmi.store:set_int('countPlace_i', tmi.modules[index].iCount)

end -- save


function module.update(index)

	return 'P: ' .. tmi.niceNaturalString(tmi.modules[index].iCount)

end -- update


tmi.addModule({
	id = 'countPlace',
	title = 'count place',
	value = 'countPlace module',
	onClear = module.clear,
	onDealoc = module.save,
	onInit = module.init,
	onUpdate = module.update,
})

--print('module countPlace loaded')

