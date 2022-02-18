minetest.register_node("floor1:stone_floor", {
    description = "Stone Floor",
    tiles = {"floor1_floor.png"},
    is_ground_content = true,
    groups = {stone=1,requires_admin=1},
    sounds = backrooms.node_sound_defaults()
})

minetest.register_node("floor1:stone_wall", {
    description = "Stone Wall",
    tiles = {"floor1_wall.png"},
    is_ground_content = true,
    groups = {stone=1,requires_admin=1,requires_blunt=1},
    sounds = backrooms.node_sound_defaults()
})

minetest.register_node("floor1:stone_wall_overgrown", {
    description = "Stone Wall (Overgrown)",
    tiles = {"floor1_wall.png","floor1_wall.png","floor1_wall.png^floor1_grime.png","floor1_wall.png^floor1_grime.png","floor1_wall.png^floor1_grime.png","floor1_wall.png^floor1_grime.png"},
    is_ground_content = true,
	drop = "floor1:stone_wall 1",
    groups = {stone=1,requires_admin=1,requires_blunt=1},
    sounds = backrooms.node_sound_defaults()
})

minetest.register_node("floor1:stone_wall_taped", {
    description = "Stone Wall (Taped)",
    tiles = {"floor1_wall.png","floor1_wall.png","floor1_wall.png^floor1_weird_tape.png","floor1_wall.png^floor1_weird_tape.png","floor1_wall.png^floor1_weird_tape.png","floor1_wall.png^floor1_weird_tape.png"},
    is_ground_content = true,
	drop = "floor1:stone_wall 1",
    groups = {stone=1,requires_admin=1,requires_blunt=1},
    sounds = backrooms.node_sound_defaults()
})

minetest.register_node("floor1:stone_ceiling", {
    description = "Stone Ceiling",
    tiles = {"floor1_ceiling.png"},
    is_ground_content = true,
    groups = {stone=1,requires_admin=1},
    sounds = backrooms.node_sound_defaults()
})

minetest.register_node("floor1:light", {
    description = "Small Light",
    tiles = {"floor1_light.png"},
    is_ground_content = true,
    paramtype = "light",
    light_source = 14,
    groups = {glass=1,oddly_breakable_by_hand=1},
    drop = "backrooms:glass_shard 1",
    on_dig = function(pos,node,player)
        player:set_hp(player:get_hp() - 1)
        minetest.node_dig(pos,node,player)
    end
})

local cratespawn = backrooms.add_crate_table(
"floor1_general",
{
	{"backrooms:glass_shard",90},
	{"backrooms:f0_moss",81},
	{"backrooms:crisps",83},
	{"backrooms:almond_water",80},
	{"backrooms:questionable_water",74},
	{"backrooms:stone",73},
	{"tape:tape_roll_(color)",72},
	{"tape:tapeless_roll",74}
}
)


minetest.register_node("floor1:stone_floor_stone", {
	description = "Wet Stone Floor",
	tiles = {"floor1_floor.png^floor1_moisture_strip.png","floor1_floor.png","floor1_floor.png","floor1_floor.png","floor1_floor.png","floor1_floor.png"},
	is_ground_content = true,
	on_rightclick = function(pos,node,player,itemstack)
		minetest.set_node(pos, {name="floor1:stone_floor"})
		backrooms.change_player_stat(player,"thirst",50,1)
		backrooms.change_player_stat(player,"sanity",100,-2)
	end,
	groups = {stone=1,requires_admin=1},
	sounds = backrooms.node_sound_defaults()
	})


local cafeteria_stream_gen = function(biome,minp,maxp,area,data,seed)
	math.randomseed(seed)
	for i=1,math.random(2,9) do
		local xpos = math.random(0,80)
		for i in area:iter( minp.x + xpos, minp.y, minp.z, minp.x + xpos, minp.y, maxp.z ) do 
			data[i] = minetest.get_content_id("floor1:stone_floor_stone")
		end
	end
end



local decoration_crate = function(biome,position,area,data,seed)
	math.randomseed(seed)
    if (math.random(1,3) == 1) then
	    minetest.set_node(position,{name="backrooms:crate",param1 = cratespawn})
    end

end




backrooms.add_floor({
	name = "Floor 1", --floor name
	worldheight = 5,
	wallheight = 4,
	has_ceiling = true,
	floorheight = 1,
	unbreakable_ceiling_block = "backrooms:reusable_ceiling",
	unbreakable_floor_block = "backrooms:reusable_ceiling",
	biomes = {
		{
			identifier = "main",
			weight = 100,
			wallcarvechance = 52, --likelyhood of a wall being carved into as a percentage
			walldisxchance = 1, --likelyhood of an entire x wall being cut as a percentage(for a mapblock)
			walldiszchance = 1, --likelyhood of an entire z wall being cut as a percentage(for a mapblock)
			trimtype = 1, --0 is no trim, 1 is top trim, 2 is bottom trim, 3 is both
			lightpercent = 80,
			lightplacement = {0,0,0,0}, --offset x,offset z, size x, size z, starting from the center
			decorationchance = 1,
			decorations = {{decoration_crate,100}},
            biomegen = nil, --a forced generator that will be called lol
            wallgenx = 10,
            wallgenz = 10,
            wallgens = 8,
			wall_blocks = { --the blocks that the wall is primarily constructed out of
				{"floor1:stone_wall",100},
			},
			floor_blocks = { --the blocks that the floor is primarily constructed out of
				{"floor1:stone_floor",200}
			},
			ceil_blocks = { --the blocks that the ceiling is primarily constructed out of
				{"floor1:stone_ceiling",100}
			},
			trim_bottom_blocks = { --the wall trims

			},
			trim_top_blocks = { --the wall trims but for the top
				{"floor1:stone_wall_overgrown",100}
			},
			light_blocks = { --the blocks that the lights are primarily constructed out of
				{"floor1:light",100}
			}
		},
        { 
			identifier = "cafeteria",
			weight = 50,
			wallcarvechance = 97, --likelyhood of a wall being carved into as a percentage
			walldisxchance = 0, --likelyhood of an entire x wall being cut as a percentage(for a mapblock)
			walldiszchance = 0, --likelyhood of an entire z wall being cut as a percentage(for a mapblock)
			trimtype = 3, --0 is no trim, 1 is top trim, 2 is bottom trim, 3 is both
			lightpercent = 100,
			lightplacement = {0,0,0,0}, --offset x,offset z, size x, size z, starting from the center
			decorationchance = 0,
			decorations = {},
            biomegen = cafeteria_stream_gen, --a forced generator that will be called lol
			wall_blocks = { --the blocks that the wall is primarily constructed out of
				{"floor1:stone_wall",100},
			},
			floor_blocks = { --the blocks that the floor is primarily constructed out of
				{"floor1:stone_floor",200}
			},
			ceil_blocks = { --the blocks that the ceiling is primarily constructed out of
				{"floor1:stone_ceiling",100}
			},
			trim_bottom_blocks = { --the wall trims
				{"floor1:stone_wall_taped",100}
			},
			trim_top_blocks = { --the wall trims but for the top
				{"floor1:stone_wall_overgrown",100}
			},
			light_blocks = { --the blocks that the lights are primarily constructed out of
				{"floor1:light",100}
			}
		}
    }
})