-- module countDig --
-- by SwissalpS --
-- Displays dig-count since reset. Also dig speed indicator.
local module = {
	speedClearDelay = 7, -- seconds after last dig that speed stays displayed
	speedMax = 0
}

function module.clear(index)

	module.speedMax = 0
	tmi.modules[index].iCount = 0
	module.save(index)

end -- clear


function module.init(index)

	if tmi.modules[index].bInitDone then return end

	module.m = tmi.modules[index]
	if not module.m then return end

	module.m.iCount = tmi.store:get_int('countDig_i')
	core.register_on_dignode(module.onDig)

	module.lastDig = core.get_us_time()
	module.speed = 0
	-- multiply now so we don't have to on every update itteration
	module.speedClearDelay = module.speedClearDelay * 1000000

end -- init


function module.onDig(pos, node)

	module.m.iCount = module.m.iCount + 1

	-- this speed analysis is not as informative as doing it on update,
	-- that is, with bigger sample, but it's more precise and the code
	-- is more elegant.
	now = core.get_us_time()
	local diffSeconds = (now - module.lastDig) * .000001
	module.lastDig = now
	module.speed = 1 / diffSeconds
	if module.speed > module.speedMax then module.speedMax = module.speed end

	return false

end -- onDig


function module.save(index)

	tmi.store:set_int('countDig_i', tmi.modules[index].iCount)

end -- save


function module.update(index)

	local digs = tmi.modules[index].iCount

	-- clear speed if no digging has been going on
	if module.speedClearDelay < core.get_us_time() - module.lastDig then
		module.speed = 0
	end

	return 'D: ' .. tmi.niceNaturalString(digs) .. '   '
			.. tostring(module.speed):sub(1, tmi.conf.precision) .. 'n/s '
			.. tostring(module.speedMax):sub(1, tmi.conf.precision) .. 'n/s max'

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
