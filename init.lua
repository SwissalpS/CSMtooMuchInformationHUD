-- Minetest Client-Side-Mod by SwissalpS
-- Modular rearangeable manager for a single
-- text based HUD element.
-- Allows you to easily order and select only
-- the information you want. Then at runtime
-- you can blend, the loaded modules, in or out of the HUD
-- by invoking a formspec with .tmi command.
tmi = {
	version = 20211211.1957,
}
-- some values for users to configure
tmi.conf = {
	-- seconds between updates
	interval = 0.5,
	-- how many characters to show per vector
	precision = 4,
	-- rrggbb colour of text
	colour = 0xfffddc,
}

-- don't modify this, holds the HUD-ID when initialized
tmi.hudID = nil
tmi.formname = '__TMI_form__'
-- table to hold module definitions
tmi.modules = {}
-- tabel to look-up index for an module id
tmi.moduleLookup = {}
-- make sure modules can access datastore from get-go
tmi.store = assert(core.get_mod_storage())

-- this is too early, we do it in tmi.init()
--tmi.player = assert(core.localplayer)

-- make sure path is ok
local modname = assert(core.get_current_modname())
tmi.pathMod = assert(core.get_modpath(modname))
-- load 'API' functions
dofile(tmi.pathMod .. 'functions.lua')
local p = tmi.pathMod .. 'module_'

-----------------------------------------------------
-- comment out modules you don't want and reorder  --
-- first loaded go on top in HUD and others bellow --
-----------------------------------------------------
--dofile(p .. 'debugChannel.lua') -- have not yet been able to use this
--
dofile(p .. 'serverInfo.lua') -- server ip, protocol version etc.
--
dofile(p .. 'wieldedItem.lua') -- description, wear and other info about wielded item
--
dofile(p .. 'v1.lua') -- velocity: vX, vY, vZ
--
dofile(p .. 'v2.lua') -- velocity: vXZ, vXYZ
--
dofile(p .. 'vM.lua') -- max velocity: vX, vY, vZ, vXZ, vXYZ
--
dofile(p .. 'countDig.lua') -- dig counter with speed and max
--
dofile(p .. 'countPlace.lua') -- build counter with speed and max
--
dofile(p .. 'countUse.lua') -- use counter
--
dofile(p .. 'countDigAndPlace.lua') -- added count of digs and builds
--
dofile(p .. 'time.lua') -- in-game time in 24h format
--
dofile(p .. 'timeElapsed.lua') -- real time passed
--
dofile(p .. 'pos.lua') -- current positon in nodes and mapblocks
--dofile(p .. 'timeMeseconsClear.lua') -- time since last penalty clear command
-----------------------------------------------------
-----------------------------------------------------

-- hook in to core shutdown callback
core.register_on_shutdown(tmi.shutdown)
-- hook in to formspec signals
core.register_on_formspec_input(tmi.formInput)
-- register chat command
core.register_chatcommand('tmi', {
	description = 'Invokes formspec to toggle display of modules.',
	func = tmi.formShow,
	params = '<none>',
})

-- start init and display of modules delayed
core.after(1, tmi.startupLoop)

--print('[CSM, Too Much Info, Loaded]')
print('[TMI Loaded]')

