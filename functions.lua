--[[ tModule is something like this
tModule = {
	id = 'moduleID', -- Unique module identifier. (String) {IDs beginning with '__' are reserved}
	title = 'Module Name', -- Title to show on toggle formspec. (String)
	updateWhenHidden = false, -- run update() even if hidden (but main HUD is on)
	value = '---', -- current/default valuestring to display if onUpdate is not a function. (String)
	onClear = nil, -- function to clear/reset or nil. When set, adds a button
				-- to formspec. This hook is called when button is pressed.
	onDealoc = nil, -- function to run on shutdown or nil. E.g. to save data.
	onHide = nil -- function or nil. Called when module is deactivated in formspec
	onInit = nil, -- function to run on startup or nil.
				-- E.g. to read values from datastore.
				-- Can be called multiple times per session.
				-- Check tmi.modules[index].bInitDone field to detect repeated call
				-- or manipulate it in another hook to request a re-init
	onReveal = nil -- function or nil. Called when module is activated in formspec
	onUpdate = nil, -- function to, update and return value, Is called at interval
				-- or nil --> value field is used
}) --]]
-- your module script needs to call this at load to register in the order
-- you want the info snippets to show up in
function tmi.addModule(tModule)

	-- no id, no registration
	if not tModule.id then return false end
	-- already got a module with that id
	if tmi.moduleLookup[tModule.id] then return false end

	tModule.index = #tmi.modules + 1
	tmi.modules[tModule.index] = tModule
	tmi.moduleLookup[tModule.id] = tModule.index

	return tModule.index

end -- addModule


function tmi.formInput(formname, fields)

	if tmi.formname ~= formname then return false end

	local index, m
	for k, v in pairs(fields) do
		index = tonumber(k)
		if index then
			tmi.toggleModule(index)
		elseif 'b_' == k:sub(1, 2) then
			-- a button was pressed
			index = tonumber(k:sub(3, -1))
			if index then
				m = tmi.modules[index]
				if m and 'function' == type(m.onClear) then
					m.onClear(index)
				end
			end
		elseif 'quit' == k then
			--return true
		else
			print(dump(fields))
		end
	end -- loop all fields. With our formspec there should only be one

	return true

end -- formInput


function tmi.formShow()

	local iMax = #tmi.modules
	if 0 == iMax then return end

	local iX = .5
	local iY = .25
	local sOut = 'size[5,' .. tostring(iMax * .5 + 1.5) .. ']'
		.. 'checkbox[' .. tostring(iX) .. ',' .. tostring(iY) .. ';'
		.. '0;Main;' .. tostring(tmi.isOn('__tmi__')) .. ']'


	local index, m
	for index = 1, iMax do
		iY = iY + .5
		m = tmi.modules[index]
		if 'function' == type(m.onClear) then
			-- add clear button
			sOut = sOut .. 'button[0,' .. tostring(iY) .. ';.5,1;'
				.. 'b_' .. tostring(index) .. ';X]'
		end
		sOut = sOut .. 'checkbox[' .. tostring(iX) .. ',' .. tostring(iY) .. ';'
		.. tostring(index) .. ';' .. m.title .. ';' .. tostring(tmi.isOn(m.id)) .. ']'

	end -- loop modules

	core.show_formspec(tmi.formname, sOut)

end -- formShow


function tmi.init()

	tmi.player = assert(core.localplayer)

	-- don't do anything else if there is already a hud id stored
	if tmi.hudID then return end

	local tHud = {
		hud_elem_type = 'text',
		name = 'tmiHUD',
		number = tmi.conf.colour,
		position = { x = 0.002, y = 0.77 },
		offset = { x = 8, y = -8 },
		text = 'Too Much Info HUD',
		scale = { x = 200, y = 60 },
		alignment = { x = 1, y = -1 },
	}
	tmi.hudID = tmi.player:hud_add(tHud)

	local iMax = #tmi.modules
	if 0 == iMax then return end
	local index, m
	for index = 1, iMax do
		m = tmi.modules[index]
		if (not m.bInitDone) and ('function' == type(m.onInit)) then
			m.onInit(index)
			-- modules can change it to request another init when main is turned on
			m.bInitDone = true
		end
		-- TODO: onReveal should be called here, no?
	end -- loop modules

	print('[TMI modules initialized]')

end -- init


-- query CSM-datastore for toggle setting of module
function tmi.isOn(id) return '' == tmi.store:get_string(id .. '_disabled') end -- isOn


-- clumsy name for a clumsy way of inserting grouping characters
function tmi.niceNaturalString(iN)

	local sOut = tostring(iN)
	if 3 < #sOut then
		sOut = sOut:sub(1, -4) .. "'" .. sOut:sub(-3, -1)
	end
	if 7 < #sOut then
		sOut = sOut:sub(1, -8) .. "'" .. sOut:sub(-7, -1)
	end
	if 11 < #sOut then
		sOut = sOut:sub(1, -12) .. "'" .. sOut:sub(-11, -1)
	end

	return sOut

end -- niceNaturalString


function tmi.removeHUD()

	-- no hud yet?
	if not tmi.hudID then return end

	tmi.player:hud_remove(tmi.hudID)
	tmi.hudID = nil

end -- removeHUD


-- called when logging off
function tmi.shutdown()

	local iMax = #tmi.modules
	if 0 == iMax then return end
	local index, m
	for index = 1, iMax do
		m = tmi.modules[index]
		if 'function' == type(m.onDealoc) then m.onDealoc(index) end
	end -- loop modules

	print('[TMI shutdown]')

end -- shutdown


-- to toggle visibility of a module by index
function tmi.toggleModule(index)

	local id, m
	-- main switch is inexistant index 0
	local bIsMain = 0 == index
	if bIsMain then
		id = '__tmi__'
	-- kinda check if index could be out of range
	--elseif #tmi.modules < index then
	--	return
	-- better check that also checks if an id is actually set
	elseif tmi.modules[index] and tmi.modules[index].id then
		m = tmi.modules[index]
		id = m.id
	else
		-- abbort
		return
	end

	-- get new value by inverting current value
	local bIsTurningOn = not tmi.isOn(id)
	local sNew = bIsTurningOn and '' or '-'
	tmi.store:set_string(id .. '_disabled', sNew)

	-- if m then
	if not bIsMain then
		if bIsTurningOn then
			if 'function' == type(m.onReveal) then
				m.onReveal(index)
			end
		else
			if 'function' == type(m.onHide) then
				m.onHide(index)
			end
		end
		return
	end -- if a submodule was toggled

	-- main module toggeled, need to destroy or remake HUD
	-- turn on?
	if bIsTurningOn then
		-- some modules might get init() called
		tmi.update()
	end

	-- call module hooks for reveal and hide
	-- we recycle index variable as we know it is 0 and don't need it anymore
	for index = 1, #tmi.modules do
		m = tmi.modules[index]
		if bIsTurningOn then
			if 'function' == type(m.onReveal) then
				m.onReveal(index)
			end
		else
			if 'function' == type(m.onHide) then
				m.onHide(index)
			end
		end -- if turning on or off
	end -- loop all modules

	-- turnig off, need to remove HUD
	if not bIsTurningOn then
		tmi.removeHUD()
	end

end -- toggleModule


function tmi.twoDigitNumberString(iN) return string.format('%02i', iN) end -- twoDigitNumberString


function tmi.update()

	local bMain = tmi.isOn('__tmi__')

	core.after(tmi.conf.interval, tmi.update)

	-- if main switch is on but no HUD-ID, then we need to init HUD and
	-- possibly re-run module's init-hook
	if bMain and not tmi.hudID then return tmi.init() end

	local sOut = ''
	local iMax = #tmi.modules
	if 0 == iMax then return end

	local b, index, m, s
	for index = 1, iMax do
		s = ''
		m = tmi.modules[index]
		b = tmi.isOn(m.id)
		if b or m.updateWhenHidden then
			if 'function' == type(m.onUpdate) then
				s = m.onUpdate(index)
			else
				s = m.value or ''
			end
		end
		if b and '' ~= s then sOut = sOut .. s .. '\n' end
	end -- loop modules

	--if not bMain then return end
	if not tmi.hudID then return end

	tmi.player:hud_change(tmi.hudID, 'text', sOut)

end -- update


--print('loaded functions.lua')

