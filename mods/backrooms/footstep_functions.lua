function backrooms.node_sound_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_footstep", gain = 1.0}
	table.dug = table.dug or
			{name = "default_dug_node", gain = 0.25}
	table.place = table.place or
			{name = "default_dug_node", gain = 0.1}
	return table
end


function backrooms.node_sound_carpet_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_carpet_footstep", gain = 0.1}
	table.dug = table.dug or
			{name = "default_carpet_footstep", gain = 1.0}
    backrooms.node_sound_defaults(table)
	return table
end

function backrooms.node_sound_wet_carpet_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_wet_carpet_footstep", gain = 0.1}
	table.dug = table.dug or
			{name = "default_wet_carpet_footstep", gain = 1.0}
    backrooms.node_sound_defaults(table)
	return table
end



