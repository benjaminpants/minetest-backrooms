minetest.register_node("backrooms:reusable_ceiling", {
description = "Invincible Ceiling",
tiles = {"backrooms_ceil.png"},
is_ground_content = true,
groups = {wool=1,requires_admin=1},
sounds = backrooms.node_sound_defaults()
})

minetest.register_node("backrooms:endless_abyss", {
	description = "Black Abyss",
	tiles = {"backrooms_abyss.png"},
	is_ground_content = true,
	groups = {wool=1,requires_admin=1},
	sounds = backrooms.node_sound_defaults()
})

colors.foreach(function(color)
	minetest.register_node("backrooms:wooden_planks_taped_" .. color.id, {
		description = "Taped Wooden Planks (" .. color.name .. ")",
		tiles = {"(backrooms_wooden_planks.png)^(backrooms_wood_tape.png^[multiply:#" .. color.rgb .. ")"},
		is_ground_content = false,
		groups = {wood=1,choppy=1,oddly_breakable_by_hand=2},
		sounds = backrooms.node_sound_defaults()
	})

	minetest.register_craft({
        output="backrooms:wooden_planks_taped_" .. color.id .. " 1",
        recipe={
            {"backrooms:wooden_plank","backrooms:wooden_plank","backrooms:wooden_plank"},
            {"backrooms:wooden_plank","tape:tape_roll_" .. color.id,"backrooms:wooden_plank"},
            {"backrooms:wooden_plank","backrooms:wooden_plank","backrooms:wooden_plank"}
        },
		replacements = {{"tape:tape_roll_" .. color.id, "tape:tapeless_roll"}}
    })
	end
)

local function formattext(text)
	return text:gsub("%(color%)", colors.chooserandom().id)
end

minetest.register_node("backrooms:crate", {
    description = "Crate",
    tiles = {"backrooms_crate.png"},
    groups = {wood=1,requires_admin=1},
    sounds = backrooms.node_sound_defaults(),
    on_rightclick = function(pos,node,player,itemstack)
		if (node.param1 == 0) then
			node.param1 = 1
		end
        node.param2 = node.param2 + 1
        if ((not (backrooms.rnghelpers.percentage(100 / (node.param2 / 2)))) and node.param2 ~= 6) then
            minetest.set_node(pos, {name="air"})
			for i=1, math.random(2,3) do
				minetest.add_item({x = pos.x + math.random(-0.5,0.5), y = pos.y, z = pos.z + math.random(-0.5,0.5)},"backrooms:wooden_plank")
			end
		else
			minetest.sound_play({name = "backrooms_open_crate", gain = 0.1},pos)
			minetest.set_node(pos, {name="backrooms:crate", param2 = node.param2, param1 = node.param1})
			minetest.add_item({x = pos.x, y = pos.y + 1, z = pos.z},formattext(backrooms.rnghelpers.choosechance(backrooms.cratetables[node.param1].values)))
		end
    end
})
