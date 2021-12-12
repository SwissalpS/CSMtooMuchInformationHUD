-- module pos --
-- by SwissalpS --
-- displays player position in nodes and block coordinates
-- taken from [PosTool]
local getPositionTablesForPos = function(tPos)

	local x = math.floor(tPos.x + 0.5)
	local y = math.floor(tPos.y + 0.5)
	local z = math.floor(tPos.z + 0.5)

	return { x = x, y = y, z = z },
		{
			x = math.floor(x / 16),
			y = math.floor(y / 16),
			z = math.floor(z / 16)
		}

end -- getPositionTablesForPos


local function update(index)

	local hudPosSeparator = ' | '
	local tNode, tBlock = getPositionTablesForPos(tmi.player:get_pos())
	local sNode = 'Node: '
		.. tostring(tNode.x) .. hudPosSeparator
		.. tostring(tNode.y) .. hudPosSeparator
		.. tostring(tNode.z)
	local sBlock = 'Block: '
		.. tostring(tBlock.x) .. hudPosSeparator
		.. tostring(tBlock.y) .. hudPosSeparator
		.. tostring(tBlock.z)

	return sNode .. '\n' .. sBlock

end -- update


tmi.addModule({
	id = 'pos',
	title = 'pos',
	value = 'pos module',
	onUpdate = update,
})

--print('module pos loaded')

