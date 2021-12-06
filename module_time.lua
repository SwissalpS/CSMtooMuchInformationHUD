-- module time --
-- by SwissalpS --
-- displays in-game-time.
local joined = core.get_us_time()

local function update(index)

	local fT = core.get_timeofday()
	local iH = math.floor(24 * fT)
	local iM = (fT * 24 - iH) * 60

	local iE = (core.get_us_time() - joined) * .000001
	local sE = string.format('%02i:%02i:%02i', iE / 3600, iE / 60 % 60, iE % 60)

	return 'Time: ' .. string.format('%02i', iH)
		.. ':' .. string.format('%02i', iM)
		.. '\nElapsed: ' .. sE

end -- update


tmi.addModule({
	id = 'time',
	title = 'time',
	value = 'time module',
	onInit = init,
	onUpdate = update,
})

--print('module time loaded')
