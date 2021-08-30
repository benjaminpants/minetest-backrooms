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