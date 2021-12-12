
# CSM Too Much Information HUD

Minetest Client Side Mod HUD with rearrangeable modules. Choose which to load and at runtime, choose to hide or show them.

Targeted at developers and testers that like a bit more information.

Since the data you want to see, is different depending on what is being investigated, two methods of selection are offered:

  1. in ``init.lua`` by un-/commenting the modules you want loaded.
  2. during runtime, the ``.tmi`` command invokes a formspec from which the modules can be toggled. They can run in the background while not being displayed on HUD.

## Out-of-the-box-modules
```
|      Module      |                   Description                       |
--------------------------------------------------------------------------
| serverInfo       | server ip, protocol version etc.                    |
| wieldedItem      | description, wear and other info about wielded item |
| v1               | velocity: vX, vY, vZ                                |
| v2               | velocity: vXZ, vXYZ                                 |
| vM               | max velocity: vX, vY, vZ, vXZ, vXYZ                 |
| countDig         | dig counter with speed and max                      |
| countPlace       | build counter with speed and max                    |
| countUse         | use counter                                         |
| countDigAndPlace | combined count of digs and builds                   |
| time             | in-game time in 24h format                          |
| timeElapsed      | real time passed                                    |
| pos              | current positon in nodes and mapblocks              |
```

## Installing the CSM
Depending on your OS and build/install of Minetest the location is different. The folder you are looking for is called ``clientmods``.
  1. Inside the ``clientmods`` folder create one called something like ``tooMuchInfo``.
  2. Download and extract the mod files
  3. and move them into the folder you created in step 1.
  4. Optionally disable and/or re-order the modules you don't want in ``init.lua``, and change parameters like colour.
  5. Turn on client side mods in your minetest settings. From the menu go to settings > all settings > client > enable_client_modding.
  6. Join or start a session and log back out. (This adds a line to mods.conf: ``load_mod_toomuchinfo = false``)
  7. In ``clientmods/mods.conf`` change the line ``load_mod_toomuchinfo = false`` to ``load_mod_toomuchinfo = true``
  8. Join or start a session and enjoy
  
## Adding your own modules

Prepending the filename with ``module_`` is recomended. Add it to the load portion of ``init.lua``
You can use this module template:
```lua
tModule = {
	id = 'moduleID', -- Unique module identifier. (String) {IDs beginning with '__' are reserved}
	title = 'Module Name', -- Title to show on toggle formspec. (String)
	updateWhenHidden = false, -- run update() even if hidden
	value = '---', -- current/default valuestring to display if onUpdate is not a function. (String)
	onClear = nil, -- function to clear/reset or nil. When set, adds a button to formspec. This hook is called when button is pressed.
	onDealoc = nil, -- function to run on shutdown or nil. E.g. to save data.
	onHide = nil, -- function or nil. Called when module is deactivated in formspec
	onInit = nil, -- function to run on startup or nil.
				-- E.g. to read values from datastore.
				-- Can be called multiple times per session.
				-- Check tmi.modules[index].bInitDone field to detect repeated call
				-- or manipulate it in another hook to request a re-init
	onReveal = nil, -- function or nil. Called when module is activated in formspec
	onUpdate = nil, -- function to, update and return value, Is called at interval
				-- or nil --> value field is used
})
tmi.addModule(tModule)
```
Call ``tmi.addModule(tModule)`` to register your module.

If your module provides a function for the onClear field, that function will be called when button in formspec is pressed. Generally it is used to reset values but you could also use it to toggle between values or open another setting formspec.



