--register super important stuff

minetest.register_node("backrooms:replaceme", {
description = "REPLACE ME",
tiles = {"backrooms_replaceme.png"},
is_ground_content = true,
groups = {wood=1}
})

minetest.register_item(":", {
	type = "none",
	wield_image = "backrooms_hand.png",
	wield_scale = {x=1,y=1,z=2.5},
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level = 0,
		groupcaps = {
			fleshy = {times={[2]=2.00, [3]=1.00}, uses=0, maxlevel=1},
			oddly_breakable_by_hand = {times={[1]=7.00,[2]=4.00,[3]=1.40}, uses=0, maxlevel=3},
			near_instant = {times={[1]=0.6,[2]=0.3,[3]=0.1}}
		},
		damage_groups = {fleshy=1},
	}
})




--register stuff

local default_path = minetest.get_modpath("backrooms")

dofile(default_path .. "/define_cool_stuff.lua")

dofile(default_path .. "/footstep_functions.lua")

dofile(default_path .. "/items.lua")

dofile(default_path .. "/tools.lua")

dofile(default_path .. "/nodes.lua")

dofile(default_path .. "/cusmapgen.lua")

dofile(default_path .. "/timers.lua")

dofile(default_path .. "/debug.lua") --only run this when testing

hb.register_hudbar("br_thirst", 0xFFFFFF, "Thirst", { icon = "backrooms_icon_thrist.png", bgicon = "backrooms_bgicon_thrist.png", bar = "backrooms_bar_thirst.png"}, 50, 50, false)

hb.register_hudbar("br_hunger", 0xFFFFFF, "Hunger", { icon = "backrooms_icon_hunger.png", bgicon = "backrooms_bgicon_hunger.png", bar = "backrooms_bar_hunger.png"}, 100, 100, false)

hb.register_hudbar("br_sanity", 0xFFFFFF, "Sanity", { icon = "backrooms_icon_sanity.png", bgicon = "backrooms_bgicon_sanity.png", bar = "backrooms_bar_sanity.png"}, 100, 100, false)

minetest.register_on_newplayer(function(player)
	local meta = player:get_meta()
	meta:set_int("last_connected_ver",1)
	meta:set_int("floor",backrooms.get_floor_id("Floor 0"))
	meta:set_int("thirst",50)
	meta:set_int("hunger",100)
	meta:set_int("sanity",100)
	backrooms.teleport_to_floor(player,"Floor 0")
end)

minetest.register_on_joinplayer(function(player)
	local meta = player:get_meta()
	hb.init_hudbar(player, "br_hunger", meta:get_int("hunger"), 100, false)
	hb.init_hudbar(player, "br_thirst", meta:get_int("thirst"), 50, false)
	hb.init_hudbar(player, "br_sanity", meta:get_int("sanity"), 100, false)
end)

minetest.register_on_dieplayer(function(player)
	local meta = player:get_meta()
	meta:set_int("thirst",50)
	meta:set_int("floor",backrooms.get_floor_id("Floor 0"))
	meta:set_int("hunger",100)
	meta:set_int("sanity",100)
	--minetest.chat_send_all(player:get_player_name() .. " died.")
end)


minetest.register_on_respawnplayer(function(player)
	local meta = player:get_meta()
	backrooms.teleport_to_floor(player,backrooms.floordata[meta:get_int("floor")].name)
	return true
end)