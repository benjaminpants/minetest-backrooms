minetest.register_tool("backrooms:stone_hammer", {
	description = "Stone Hammer",
	inventory_image = "backrooms_stone_hammer.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=0,
		groupcaps={
			requires_blunt={times={[1]=2.0, [2]=1, [3]=0.6}, uses=8, maxlevel=1}
		},
		damage_groups = {fleshy=2},
	},
})


minetest.register_craft({
	output = "backrooms:stone_hammer 1",
	recipe = {
		{"","backrooms:stone",""},
		{"","group:stick",""},
		{"","group:stick",""}
	}
})