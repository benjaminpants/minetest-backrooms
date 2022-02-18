local c_air = minetest.get_content_id("air")
local c_reusable_ceil = minetest.get_content_id("backrooms:reusable_ceiling")


minetest.register_node("floor2:concrete_floor", {
    description = "Concrete Floor",
    tiles = {"floor2_floor.png"},
    is_ground_content = true,
    groups = {stone=1,requires_admin=1},
    sounds = backrooms.node_sound_defaults()
})

minetest.register_node("floor2:concrete_wall", {
    description = "Concrete Wall",
    tiles = {"floor2_wall.png"},
    is_ground_content = false,
    groups = {stone=1,requires_admin=1},
    sounds = backrooms.node_sound_defaults()
})

minetest.register_node("floor2:wire_ceil", { --tbh i have no idea what the ceiling is supposed to be-
    description = "Wire Collection",
    tiles = {"floor2_wire_bundle.png"},
	drop = "backrooms:wires 3",
    is_ground_content = false,
    groups = {papery=1,requires_admin=1},
    sounds = backrooms.node_sound_defaults()
})

minetest.register_node("floor2:wall_light", { --the light being flat is a placeholder
    description = "Wall Light",
    drawtype = "signlike",
    paramtype = "light",
    paramtype2 = "wallmounted",
    selection_box = {
        type = "wallmounted",
        wall_top    = {-0.5, 0.4375, -0.5, 0.5, 0.5, 0.5},
        wall_bottom = {-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
        wall_side   = {-0.5, -0.5, -0.5, -0.4375, 0.5, 0.5},
    },
    walkable = false,
    light_source = 6,
    sunlight_propagates = true,
    tiles = {"floor2_light_node.png"},
    is_ground_content = false,
    groups = {near_instant=2},
    sounds = backrooms.node_sound_defaults()
})

local add_light = function(tab,biome,minp,maxp,area,data,seed,z_offset)
	table.insert(tab,{vector.new(minp.x - 44,minp.y + 2, minp.z + z_offset), minetest.get_modpath("floor2") .. "/schematics/just_a_light.mts", "0", nil, true})

end


local hall_gen = function(biome,minp,maxp,area,data,seed)
    local cached_floor = minetest.get_content_id(biome.floor_blocks[1][1])
    local cached_wall = minetest.get_content_id(biome.wall_blocks[1][1])
    local cached_ceiling = minetest.get_content_id(biome.ceil_blocks[1][1])
	math.randomseed(seed)
    for i in area:iter( minp.x, minp.y, minp.z, maxp.x, minp.y, maxp.z ) do 
		if data[i] == c_air then
			data[i] = cached_floor
		end 
	end
    for i in area:iter( maxp.x - 40, minp.y + 1, minp.z, maxp.x - 40, minp.y + 2, maxp.z ) do 
		if data[i] == c_air then
			data[i] = cached_wall
		end 
	end

    for i in area:iter( maxp.x - 44, minp.y + 1, minp.z, maxp.x - 44, minp.y + 2, maxp.z ) do 
		if data[i] == c_air then
			data[i] = cached_wall
		end 
	end

    for i in area:iter( minp.x, minp.y + 3, minp.z, maxp.x, minp.y + 3, maxp.z ) do 
		if data[i] == c_air then
			data[i] = cached_ceiling
		end 
	end

	for i in area:iter( minp.x, minp.y + 4, minp.z, maxp.x, minp.y + 4, maxp.z ) do 
		data[i] = c_reusable_ceil
	end

	--minetest.place_node(vector.new(minp.x - 44,minp.y + 3, minp.z), {name="floor2:wall_light", param2=3})
	local all_lights = {}

	for i=1, 10 do
		if (math.random(1,2) == 2) then
			add_light(all_lights,biome,minp,maxp,area,data,seed,i * 8)
		end
	end

	return all_lights
end

local teleport_two_specific = function(player,floorname, fx, fz)
	local floor_id = backrooms.get_floor_id(floorname)
	player:set_pos({x = 5, y = backrooms.get_floor_y(floor_id) + 0.5, z = fz or math.random(-8000,8000)})
end


backrooms.add_floor({ --floor 2 doesn't use the default terrain generation code
	name = "Floor 2", --floor name
	worldheight = 6,
	wallheight = 2,
	has_ceiling = true,
	floorheight = 1,
	floor_teleport = teleport_two_specific,
	unbreakable_ceiling_block = "backrooms:reusable_ceiling",
	unbreakable_floor_block = "backrooms:reusable_ceiling",
	floor_tic = nil,
	biomes = {
		{ 
			identifier = "main",
			weight = 100,
			wallcarvechance = 30, --likelyhood of a wall being carved into as a percentage
			walldisxchance = 0, --likelyhood of an entire x wall being cut as a percentage(for a mapblock)
			walldiszchance = 0, --likelyhood of an entire z wall being cut as a percentage(for a mapblock)
			trimtype = 0, --0 is no trim, 1 is top trim, 2 is bottom trim, 3 is both
			lightpercent = 99,
			lightplacement = {-1,-1,2,1}, --offset x,offset z, size x, size z, starting from the center
			decorationchance = 0,
			decorations = {},
			biomegenonly = true, --should it just be the biome gen and not run the normal generation code? (DECORATIONS WILL STILL BE PLACED)
            biomegen = hall_gen, --a forced generator that will be called lol
            --wallgenx is an option paramater you can put here, its very technical but can be used to adjust how big chunks are in each axis, default is 10
            --wallgenz is the same as above but for the z axis, the default is 39
			wall_blocks = { --the blocks that the wall is primarily constructed out of
				{"floor2:concrete_wall",100}
			},
			floor_blocks = { --the blocks that the floor is primarily constructed out of
				{"floor2:concrete_floor",200}
			},
			ceil_blocks = { --the blocks that the ceiling is primarily constructed out of
				{"floor2:wire_ceil",100}
			},
			trim_bottom_blocks = { --the wall trims
				{"debug:tile_alt",100}
			},
			trim_top_blocks = { --the wall trims but for the top
				{"debug:tile_alt",100}
			},
			light_blocks = { --the blocks that the lights are primarily constructed out of
				{"floor1:light",100}
			}
		}
    }
})