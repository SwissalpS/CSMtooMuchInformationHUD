-- module v1 --
-- by SwissalpS --
-- displays velocity per axis. vX, vY and vZ
local function update(index)

	local tV = tmi.player:get_velocity()
	if not tV then return '-' end

	local iP = tmi.conf.precision
	local x, y, z = math.abs(tV.x), math.abs(tV.y), math.abs(tV.z)

	return 'vX: ' .. tostring(x):sub(1, iP)
			.. ' vY: ' .. tostring(y):sub(1, iP)
			.. ' vZ: ' .. tostring(z):sub(1, iP)

end -- update


tmi.addModule({
	id = 'v1',
	title = 'v1',
	value = 'v1 module',
	onUpdate = update,
})

--print('module v1 loaded')

