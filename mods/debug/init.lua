minetest.register_node("debug:tile", {
description = "Debug Tile",
tiles = {"debug_tile.png"},
is_ground_content = true,
groups = {oddly_breakable_by_hand=1}
})

minetest.register_node("debug:tile_alt", {
description = "Debug Tile",
tiles = {"debug_tile_gray.png"},
is_ground_content = true,
groups = {oddly_breakable_by_hand=1}
})

minetest.register_node("debug:wet", {
description = "Debug Water",
tiles = {"debug_wet.png"},
walkable = false,
pointable = false,
diggable = false,
buildable_to = true,
is_ground_content = false,
paramtype = "light",
drop = "",
drowning = 1,
liquidtype = "source",
drawtype = "liquid",
liquid_alternative_flowing = "debug:wet_flow",
	liquid_alternative_source = "debug:wet",
	liquid_viscosity = 1
})

minetest.register_node("debug:wet_flow", {
description = "Debug Water",
tiles = {"debug_wet.png"},
walkable = false,
pointable = false,
diggable = false,
buildable_to = true,
is_ground_content = false,
paramtype = "light",
drop = "",
drowning = 1,
liquidtype = "flowing",
drawtype = "flowingliquid",
liquid_alternative_flowing = "debug:wet_flow",
	liquid_alternative_source = "debug:wet",
	liquid_viscosity = 1
})

minetest.register_tool("debug:pick", {
	description = "Debug Pickaxe",
	inventory_image = "debug_pick.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=6,
		groupcaps={
			cracky={times={[1]=2.0, [2]=1.0, [3]=0.5}, uses=20, maxlevel=3},
			crumbly={times={[1]=2.0, [2]=1.0, [3]=0.5}, uses=20, maxlevel=3},
			snappy={times={[1]=2.0, [2]=1.0, [3]=0.5}, uses=20, maxlevel=3},
			requires_admin = {times={[3]=1,[2]=1,[1]=1}, uses=0, maxlevel=1}
		},
		damage_groups = {fleshy=4},
	},
})