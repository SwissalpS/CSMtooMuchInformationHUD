-- module v2 --
-- by SwissalpS --
-- displays combined velocity. vXZ and vXYZ
local function update(index)

	local tV = tmi.player:get_velocity()
	if not tV then return '-' end

	local iP = tmi.conf.precision
	local x, y, z = math.abs(tV.x), math.abs(tV.y), math.abs(tV.z)
	local tVabs = { x = x, y = y, z = z }

	return 'vXZ: ' .. tostring(math.hypot(x, z)):sub(1, iP)
			.. ' vXYZ: ' .. tostring(vector.length(tVabs)):sub(1, iP)

end -- update


tmi.addModule({
	id = 'v2',
	title = 'v2',
	value = 'v2 module',
	onUpdate = update,
})

--print('module v2 loaded')

