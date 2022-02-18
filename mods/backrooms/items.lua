minetest.register_craftitem("backrooms:glass_shard", {
    description = "Glass Shard",
    inventory_image = "backrooms_glass_shards.png"
})

minetest.register_craftitem("backrooms:empty_bottle", {
    description = "Empty Water Bottle",
    inventory_image = "backrooms_empty_bottle.png"
})

minetest.register_craftitem("backrooms:wooden_plank", {
    description = "Wooden Plank",
    inventory_image = "backrooms_wooden_plank.png"
})

minetest.register_craftitem("backrooms:stick", {
    description = "Stick",
    inventory_image = "backrooms_stick.png",
    groups = {stick=1}
})

minetest.register_craftitem("backrooms:stone", {
    description = "Stone",
    inventory_image = "backrooms_stone.png"
})

minetest.register_craftitem("backrooms:wires", {
    description = "Wires",
    inventory_image = "backrooms_wires.png"
})

minetest.register_craft({
	output = "backrooms:stick 2",
	type = "shapeless",
	recipe = {
		"backrooms:wooden_plank"
	}
})

minetest.register_craftitem("backrooms:almond_water", {
    description = "Almond Water",
    inventory_image = "backrooms_almond_water.png",
	on_use = function(itemstack, player, pointed_thing)
		if (backrooms.change_player_stat(player,"thirst",50,10)) then
			itemstack:take_item(1)
			local stack = ItemStack("backrooms:empty_bottle")
			player:get_inventory():add_item("main",stack)
		end
		return itemstack
	end
})

minetest.register_craftitem("backrooms:questionable_water", {
    description = "Questionable Water\nHm, this water... is questionable.",
    inventory_image = "backrooms_questionable_bottle.png",
	on_use = function(itemstack, player, pointed_thing)
		if (backrooms.change_player_stat(player,"thirst",50,6)) then
			backrooms.change_player_stat(player,"sanity",100,-5)
			itemstack:take_item(1)
			local stack = ItemStack("backrooms:empty_bottle")
			player:get_inventory():add_item("main",stack)
		end
		return itemstack
	end
})

minetest.register_craftitem("backrooms:crisps", {
    description = "\"Crisps\"\nAn odd bag of chips with no special properties.",
    inventory_image = "backrooms_crisps.png",
	on_use = function(itemstack, player, pointed_thing)
		if (backrooms.change_player_stat(player,"hunger",100,6)) then
			itemstack:take_item(1)
		end
		return itemstack
	end
})

minetest.register_tool("backrooms:sharp_glass_shard", {
	description = "Sharpened Glass Shard",
	inventory_image = "backrooms_glass_shard_sharp.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=0,
		groupcaps={
			papery={times={[1]=1.0, [2]=0.5, [3]=0.3}, uses=6, maxlevel=1}
		},
		damage_groups = {fleshy=1},
	},
})

minetest.register_craft({
	output = "backrooms:sharp_glass_shard 1",
	type = "shapeless",
	recipe = {
		"backrooms:glass_shard","backrooms:glass_shard"
	}
})
