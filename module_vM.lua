-- module vM --
-- by SwissalpS --
-- keeps track of max velocity. Value can be reset
-- and is persistant over sessions.
local vM = { iMaxX = 0, iMaxY = 0, iMaxZ = 0, iMaxXZ = 0, iMaxXYZ = 0 }

-- when clear button on formspec is pressed
function vM.clear(index)

	vM.iMaxX = 0
	vM.iMaxY = 0
	vM.iMaxZ = 0
	vM.iMaxXZ = 0
	vM.iMaxXYZ = 0

	vM.save()

end -- clear


-- read from datastore
function vM.init(index)

	if tmi.modules[index].bInitDone then return end

	vM.iMaxX = tmi.store:get_float('vM_X')
	vM.iMaxY = tmi.store:get_float('vM_Y')
	vM.iMaxZ = tmi.store:get_float('vM_Z')
	vM.iMaxXZ = tmi.store:get_float('vM_XZ')
	vM.iMaxXYZ = tmi.store:get_float('vM_XYZ')

end -- init


-- write to datastore
function vM.save(index)

	tmi.store:set_float('vM_X', vM.iMaxX)
	tmi.store:set_float('vM_Y', vM.iMaxY)
	tmi.store:set_float('vM_Z', vM.iMaxZ)
	tmi.store:set_float('vM_XZ', vM.iMaxXZ)
	tmi.store:set_float('vM_XYZ', vM.iMaxXYZ)

end -- save


function vM.update(index)

	local tV = tmi.player:get_velocity()
	if not tV then return '-' end

	local iP = tmi.conf.precision
	local x, y, z = math.abs(tV.x), math.abs(tV.y), math.abs(tV.z)
	local xz = math.hypot(x, z)
	local xyz = vector.length({ x = x, y = y, z = z })
	-- check and cache max
	if x > vM.iMaxX then vM.iMaxX = x end
	if y > vM.iMaxY then vM.iMaxY = y end
	if z > vM.iMaxZ then vM.iMaxZ = z end
	if xz > vM.iMaxXZ then vM.iMaxXZ = xz end
	if xyz > vM.iMaxXYZ then vM.iMaxXYZ = xyz end

	return 'vmX: ' .. tostring(vM.iMaxX):sub(1, iP)
			.. ' vmY: ' .. tostring(vM.iMaxY):sub(1, iP)
			.. ' vmZ: ' .. tostring(vM.iMaxZ):sub(1, iP) .. '\n'
			.. 'vmXZ: ' .. tostring(vM.iMaxXZ):sub(1, iP)
			.. ' vmXYZ: ' .. tostring(vM.iMaxXYZ):sub(1, iP) .. '\n'

end -- update


tmi.addModule({
	id = 'vM',
	title = 'vMax',
	updateWhenHidden = true,
	value = 'vM module',
	onClear = vM.clear,
	onDealoc = vM.save,
	onInit = vM.init,
	onUpdate = vM.update,
})

--print('module vM loaded')

