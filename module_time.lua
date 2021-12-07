-- module time --
-- by SwissalpS --
-- displays in-game-time.
local function update(index)

	local fT = core.get_timeofday()
	local iH = math.floor(24 * fT)
	local iM = (fT * 24 - iH) * 60

	return 'Time: ' .. string.format('%02i', iH)
		.. ':' .. string.format('%02i', iM)

end -- update


tmi.addModule({
	id = 'time',
	title = 'time',
	value = 'time module',
	onUpdate = update,
})

--print('module time loaded')
