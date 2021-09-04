
minetest.register_node("floor0:carpet", {
description = "Brown Carpet(Unplacable)",
tiles = {"floor0_carpet.png"},
is_ground_content = true,
on_punch = function(pos, node, player)
	if (node ~= nil and player ~= nil and pos ~= nil) then
		minetest.set_node(pos, {name="floor0:carpet_pulled"})
		local stack = ItemStack("floor0:carpet_fabric")
		player:get_inventory():add_item("main",stack)
	end
end,
groups = {wool=1,requires_admin=1},
sounds = backrooms.node_sound_carpet_defaults()
})

minetest.register_node("floor0:carpet_placeable", {
description = "Brown Carpet",
tiles = {"floor0_carpet.png"},
is_ground_content = true,
groups = {wool=1,oddly_breakable_by_hand=1},
sounds = backrooms.node_sound_carpet_defaults()
})

minetest.register_node("floor0:carpet_pulled", {
description = "Brown Carpet Pulled",
tiles = {"floor0_carpet_pulled.png"},
is_ground_content = true,
groups = {wool=1,requires_admin=1},
sounds = backrooms.node_sound_carpet_defaults()
})

minetest.register_node("floor0:moss_block", {
description = "Block of Moss",
tiles = {"floor0_moss_block.png"},
is_ground_content = true,
groups = {foliage=1,oddly_breakable_by_hand=3},
sounds = backrooms.node_sound_wet_carpet_defaults()
})

minetest.register_node("floor0:carpet_moist", {
description = "Moist Brown Carpet",
tiles = {"floor0_carpet.png^floor0_moisture.png","floor0_carpet.png","floor0_carpet.png","floor0_carpet.png","floor0_carpet.png","floor0_carpet.png"},
is_ground_content = true,
on_rightclick = function(pos,node,player,itemstack)
	minetest.set_node(pos, {name="floor0:carpet"})
	backrooms.change_player_stat(player,"thirst",100,6)
	backrooms.change_player_stat(player,"sanity",100,-7)
end,
groups = {wool=1,requires_admin=1},
sounds = backrooms.node_sound_wet_carpet_defaults()
})

minetest.register_node("floor0:carpet_bloody", {
description = "\"Red\" Moist Brown Carpet",
tiles = {"floor0_carpet.png^floor0_blood.png","floor0_carpet.png","floor0_carpet.png","floor0_carpet.png","floor0_carpet.png","floor0_carpet.png"},
is_ground_content = true,
groups = {wool=1,requires_admin=1},
sounds = backrooms.node_sound_carpet_defaults()
})


minetest.register_node("floor0:light", {
description = "Light",
tiles = {"floor0_light.png"},
is_ground_content = true,
paramtype = "light",
light_source = 14,
groups = {glass=1,oddly_breakable_by_hand=1},
drop = "backrooms:glass_shard 3",
on_dig = function(pos,node,player)
	player:set_hp(player:get_hp() - 2)
	minetest.node_dig(pos,node,player)
end
})

minetest.register_node("floor0:wall", {
description = "Wall Papered Wall",
tiles = {"floor0_wall.png"},
is_ground_content = true,
groups = {papery=1},
sounds = backrooms.node_sound_defaults()
})



minetest.register_node("floor0:wall_mossy", {
description = "Mossy Wall Papered Wall",
tiles = {"floor0_wall.png^floor0_moss.png"},
is_ground_content = true,
drop = "floor0:wall",
on_punch = function(pos, node, player)
	if (node ~= nil and player ~= nil and pos ~= nil) then
		minetest.set_node(pos, {name="floor0:wall"})
		local stack = ItemStack("floor0:moss")
		player:get_inventory():add_item("main",stack)
	end
end,
groups = {papery=1},
sounds = backrooms.node_sound_defaults()
})
--[[
minetest.register_abm{
        label = "moss growing",
	nodenames = {"floor0:wall_mossy"},
	neighbors = {"floor0:wall"},
	interval = 120,
	chance = 0.20,
	action = function(pos, node)
	if (node.param1 ~= 0) then return end
	local positions, nodes_count = minetest.find_nodes_in_area(
		vector.add(pos, -1), vector.add(pos, 1), {"floor0:wall"})
	minetest.set_node(positions[math.random(1,#positions)],{name="floor0:wall_mossy"})
	minetest.set_node(pos,{name="floor0:wall_mossy",param1 = 1})
	end,
}
--]]
minetest.register_node("floor0:wall_trim", {
description = "Wall Papered Wall w/ Trim",
tiles = {"floor0_wall.png","floor0_trim_bottom.png","floor0_wall.png^floor0_trim.png","floor0_wall.png^floor0_trim.png","floor0_wall.png^floor0_trim.png","floor0_wall.png^floor0_trim.png"},
is_ground_content = true,
groups = {papery=1},
sounds = backrooms.node_sound_defaults()
})

minetest.register_node("floor0:ceiling", {
description = "Brown Ceiling Tile",
tiles = {"floor0_ceil.png"},
is_ground_content = true,
groups = {requires_blunt=1,requires_admin=1},
sounds = backrooms.node_sound_defaults()
})



--items

minetest.register_craftitem("floor0:carpet_fabric", {
    description = "Carpet Fabric",
    inventory_image = "floor0_carpet_thread.png",
	on_use = function(itemstack, player, pointed_thing)
	if (player ~= nil and pointed_thing.type == "node" and itemstack ~= null) then
		if (minetest.get_node(pointed_thing.under).name ~= "floor0:carpet_pulled") then return itemstack end
		minetest.set_node(pointed_thing.under, {name="floor0:carpet"})
		itemstack:take_item(1)
		return itemstack
	end
	end
})

minetest.register_craftitem("floor0:moss", {
    description = "Moss",
    inventory_image = "floor0_moss_item.png",
	on_use = function(itemstack, player, pointed_thing)
		if (backrooms.change_player_stat(player,"hunger",50,3)) then
			itemstack:take_item(1)
		end
		backrooms.change_player_stat(player,"sanity",100,-2)
		return itemstack
	end
})


--recipes

minetest.register_craft({
	output = "floor0:carpet_placeable 1",
	recipe = {
		{"floor0:carpet_fabric", "floor0:carpet_fabric", "floor0:carpet_fabric"},
		{"floor0:carpet_fabric", "floor0:carpet_fabric", "floor0:carpet_fabric"},
		{"floor0:carpet_fabric", "floor0:carpet_fabric", "floor0:carpet_fabric"},
	}
})

minetest.register_craft({
	output = "floor0:moss_block 1",
	recipe = {
		{"floor0:moss", "floor0:moss", "floor0:moss"},
		{"floor0:moss", "floor0:moss", "floor0:moss"},
		{"floor0:moss", "floor0:moss", "floor0:moss"},
	}
})

minetest.register_craft({
	output = "floor0:moss 9",
	type = "shapeless",
	recipe = {
		"floor0:moss_block"
	}
})





local exit_gen = function(biome,minp,maxp,area,data,seed)
	math.randomseed(seed)
	local entex = math.random(0,8)
	local entey = math.random(0,8)
	local startx = minp.x + (10 * entex)
	local startz = minp.z + (10 * entey)

	local ceil = minetest.get_content_id("backrooms:endless_abyss")

	local air =  minetest.get_content_id("air")

	for i in area:iter( startx, minp.y + 1, startz, startx + 8, minp.y + 6, startz + 8) do 
		data[i] = air
	end
	for i in area:iter( startx, minp.y + 7, startz - 1, startx + 8, minp.y + 11, startz - 1) do 
		data[i] = ceil
	end
	for i in area:iter( startx, minp.y + 7, startz + 9, startx + 8, minp.y + 11, startz + 9) do 
		data[i] = ceil
	end
	for i in area:iter( startx - 1, minp.y + 7, startz, startx - 1, minp.y + 11, startz + 8) do 
		data[i] = ceil
	end
	for i in area:iter( startx + 9, minp.y + 7, startz, startx + 9, minp.y + 11, startz + 9) do 
		data[i] = ceil
	end
	for i in area:iter( startx, minp.y + 12, startz, startx + 8, minp.y + 12, startz + 8) do 
		data[i] = ceil
	end

	--minetest.place_schematic({ x = startx, y = minp.y + 1, z = startz }, minetest.get_modpath("floor0") .. "/schematics/ staircase.mts", "0", nil, false)

	return {{{ x = startx, y = minp.y + 1, z = startz }, minetest.get_modpath("floor0") .. "/schematics/staircase.mts", "0", nil, false}} -- this pretty much tells the generator to "cache" the structures and place them after generic gen is done

end


local check_if_entry_to_floor_1 = function(player)
	local pos = player:get_pos()
	if pos.y >= 374.5 then
		local meta = player:get_meta()
		meta:set_int("floor",backrooms.get_floor_id("Floor 1"))
		backrooms.teleport_to_floor(player, "Floor 1",pos.x,pos.z)
	end
end


--register the actual floor itself
backrooms.add_floor({
	name = "Floor 0", --floor name
	worldheight = 4,
	wallheight = 4,
	has_ceiling = true,
	floorheight = 1,
	unbreakable_ceiling_block = "backrooms:reusable_ceiling",
	unbreakable_floor_block = "backrooms:reusable_ceiling",
	floor_tic = check_if_entry_to_floor_1,
	biomes = {
		{ --base floor 0 biome
			identifier = "base",
			weight = 100,
			wallcarvechance = 30, --likelyhood of a wall being carved into as a percentage
			walldisxchance = 0, --likelyhood of an entire x wall being cut as a percentage(for a mapblock)
			walldiszchance = 0, --likelyhood of an entire z wall being cut as a percentage(for a mapblock)
			trimtype = 2, --0 is no trim, 1 is top trim, 2 is bottom trim, 3 is both
			lightpercent = 99,
			lightplacement = {-1,-1,2,1}, --offset x,offset z, size x, size z
			decorationchance = 0,
			decorations = {},
			biomegen = exit_gen, --a forced generator that will be called
			wall_blocks = { --the blocks that the wall is primarily constructed out of
				{"floor0:wall",110},
				{"floor0:wall_mossy",3}
			},
			floor_blocks = { --the blocks that the floor is primarily constructed out of
				{"floor0:carpet",200},
				{"floor0:carpet_moist",4},
				{"floor0:carpet_bloody",1}
			},
			ceil_blocks = { --the blocks that the ceiling is primarily constructed out of
				{"floor0:ceiling",100}
			},
			trim_bottom_blocks = { --the wall trims
				{"floor0:wall_trim",100}
			},
			trim_top_blocks = { --the wall trims but for the top
				
			},
			light_blocks = { --the blocks that the wall is primarily constructed out of
				{"floor0:light",100}
			}
		},
		{ -- "sterile rooms/backrooms classic"
			identifier = "sterile",
			weight = 20,
			wallcarvechance = 28, --likelyhood of a wall being carved into as a percentage
			walldisxchance = 0, --likelyhood of an entire x wall being cut as a percentage(for a mapblock)
			walldiszchance = 0, --likelyhood of an entire z wall being cut as a percentage(for a mapblock)
			trimtype = 2, --0 is no trim, 1 is top trim, 2 is bottom trim, 3 is both
			lightpercent = 100,
			lightplacement = {-1,-1,2,1}, --offset x,offset z, size x, size z
			decorationchance = 0,
			decorations = {},
			biomegen = nil, --a forced generator that will be called
			wall_blocks = { --the blocks that the wall is primarily constructed out of
				{"floor0:wall",110}
			},
			floor_blocks = { --the blocks that the floor is primarily constructed out of
				{"floor0:carpet",200}
			},
			ceil_blocks = { --the blocks that the ceiling is primarily constructed out of
				{"floor0:ceiling",100}
			},
			trim_bottom_blocks = { --the wall trims
				{"floor0:wall_trim",100}
			},
			trim_top_blocks = { --the wall trims but for the top
				
			},
			light_blocks = { --the blocks that the wall is primarily constructed out of
				{"floor0:light",100}
			}
		},
		{ -- "the overgrowth"
			identifier = "overgrown",
			weight = 10,
			wallcarvechance = 40, --likelyhood of a wall being carved into as a percentage
			walldisxchance = 1, --likelyhood of an entire x wall being cut as a percentage(for a mapblock)
			walldiszchance = 1, --likelyhood of an entire z wall being cut as a percentage(for a mapblock)
			trimtype = 2, --0 is no trim, 1 is top trim, 2 is bottom trim, 3 is both
			lightpercent = 85,
			lightplacement = {-1,-1,2,1}, --offset x,offset z, size x, size z
			decorationchance = 0,
			decorations = {},
			biomegen = nil, --a forced generator that will be called
			wall_blocks = { --the blocks that the wall is primarily constructed out of
				{"floor0:wall",105},
				{"floor0:wall_mossy",15}
			},
			floor_blocks = { --the blocks that the floor is primarily constructed out of
				{"floor0:carpet",200},
				{"floor0:carpet_moist",15}
			},
			ceil_blocks = { --the blocks that the ceiling is primarily constructed out of
				{"floor0:ceiling",100},
				{"floor0:moss_block",5}
			},
			trim_bottom_blocks = { --the wall trims
				{"floor0:wall_trim",100}
			},
			trim_top_blocks = { --the wall trims but for the top
				
			},
			light_blocks = { --the blocks that the wall is primarily constructed out of
				{"floor0:light",100}
			}
		},
		{ --the bloodrooms
			identifier = "bloodrooms",
			weight = 8,
			wallcarvechance = 20, --likelyhood of a wall being carved into as a percentage
			walldisxchance = 0, --likelyhood of an entire x wall being cut as a percentage(for a mapblock)
			walldiszchance = 0, --likelyhood of an entire z wall being cut as a percentage(for a mapblock)
			trimtype = 2, --0 is no trim, 1 is top trim, 2 is bottom trim, 3 is both
			lightpercent = 1,
			lightplacement = {-1,-1,2,1}, --offset x,offset z, size x, size z
			decorationchance = 0,
			decorations = {},
			biomegen = nil, --a forced generator that will be called
			wall_blocks = { --the blocks that the wall is primarily constructed out of
				{"floor0:wall",100}
			},
			floor_blocks = { --the blocks that the floor is primarily constructed out of
				{"floor0:carpet",100},
				{"floor0:carpet_pulled",50},
				{"floor0:carpet_bloody",15}
			},
			ceil_blocks = { --the blocks that the ceiling is primarily constructed out of
				{"floor0:ceiling",100}
			},
			trim_bottom_blocks = { --the wall trims
				{"floor0:wall_trim",100}
			},
			trim_top_blocks = { --the wall trims but for the top
				
			},
			light_blocks = { --the blocks that the wall is primarily constructed out of
				{"floor0:light",100}
			}
		}
	}
})




