-- module elapsed time --
-- by SwissalpS --
-- displays IRL time passed in session. Can be reset.
local joined = core.get_us_time()


local function clear(index) joined = core.get_us_time() end -- clear


local function update(index)

	local iE = (core.get_us_time() - joined) * .000001
	local sE = string.format('%02i:%02i:%02i', iE / 3600, iE / 60 % 60, iE % 60)

	return 'Elapsed: ' .. sE

end -- update


tmi.addModule({
	id = 'timeElapsed',
	title = 'timE',
	value = 'time elapsed module',
	onClear = clear,
	onUpdate = update,
})

--print('module elapsed time loaded')

