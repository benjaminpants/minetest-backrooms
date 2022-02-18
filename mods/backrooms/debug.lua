minetest.register_chatcommand("returntozero",
    {
        params = "no params",
        description = "return to floor 0",
        func = function(name)
            local player = minetest.get_player_by_name(name)
            local meta = player:get_meta()
		    meta:set_int("floor",backrooms.get_floor_id("Floor 0"))
		    backrooms.teleport_to_floor(player, "Floor 0",2,2)
        end
    }

)


minetest.register_chatcommand("gotofloortwo",
    {
        params = "no params",
        description = "go to floor 2(placeholder command)",
        func = function(name)
            local player = minetest.get_player_by_name(name)
            local meta = player:get_meta()
		    meta:set_int("floor",backrooms.get_floor_id("Floor 2"))
		    backrooms.teleport_to_floor(player, "Floor 2",5,0)
        end
    }

)