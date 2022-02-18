backrooms = {floordata = {}, rnghelpers = {}, cratetables = {}}

backrooms.add_crate_table = function(ident, weightedlist)
	backrooms.cratetables[#backrooms.cratetables + 1] = {name = ident, values = weightedlist}
	return #backrooms.cratetables
end

backrooms.teleport_to_floor = function(player,floorname, fx, fz)
	local floor_id = backrooms.get_floor_id(floorname)
	if (backrooms.floordata[floor_id] ~= nil) then
		if (backrooms.floordata[floor_id].floor_teleport ~= nil) then
			backrooms.floordata[floor_id].floor_teleport(player, floorname, fx, fz)
		else
			player:set_pos({x = fx or math.random(-8000,8000), y = backrooms.get_floor_y(floor_id) + 1, z = fz or math.random(-8000,8000)})
		end
	end
end



backrooms.add_floor = function(floortoadd)
	backrooms.floordata[#backrooms.floordata + 1] = floortoadd
	return #backrooms.floordata
end

backrooms.get_crate_table_id = function(ident)
	for i=1, #backrooms.cratetables do
		if (backrooms.cratetables[i].name == ident) then
			return i
		end
	end
	return 1
end

backrooms.get_floor_id = function(name)
	for i=1, #backrooms.floordata do
		if (backrooms.floordata[i].name == name) then
			return i
		end
	end
	return 1
end


backrooms.get_floor_y = function(y)
    return 48 + backrooms.floordata[y].worldheight * 80
end

backrooms.rnghelpers.choosechance = function(weightedlist) --incase anyone asks why this isn't used in cusmapgen.lua its because idk how minetest randomseed works and i'm not willing to risk screwing things up
	local currentweight = 0
	local maxweight = 0
	local currentoutcome = weightedlist[1][1]
	for i=1, #weightedlist do
		maxweight = maxweight + weightedlist[i][2]
	end
	currentweight = math.random(0,maxweight)
	for i=1, #weightedlist do
		if (weightedlist[i][2] > currentweight) then
			currentoutcome = weightedlist[i][1]
			break
		else
			currentweight = currentweight - weightedlist[i][2]
		end
	end
	return currentoutcome
end

backrooms.rnghelpers.percentage = function(value)
	local yes = math.random(1,100)
	return (value >= yes)
end


backrooms.change_player_stat = function(player,stat,statmax,val) --the return value for this is whether or not it was able to actually use it
	local isneg = val < 0
	local meta = player:get_meta()
	local value = meta:get_int(stat)
	local increase = val
	if (not isneg) then
	if (value + val >= statmax) then 
		increase = statmax - value
	end
	else
		if (value + val < 0) then
			increase = -value
		end
	end
	if (increase <= 0 and not isneg) then return false end
	meta:set_int(stat,value + increase)
	hb.change_hudbar(player, "br_" .. stat, meta:get_int(stat))
    return true
end