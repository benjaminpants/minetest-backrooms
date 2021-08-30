local c_air = minetest.get_content_id("air")
local c_replaceable = minetest.get_content_id("backrooms:replaceme")

local selectedroom = backrooms.floordata[1]




local function ifnegativeoutputminus(num)
	if (num > 0) then
		return 1
	else
		return -1
	end
end

local function chooseweight(weightedlist)
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

local function chooseweightedbiome(biomes)
	local biomez = {}
	for i=1,#biomes do
		biomez[i] = { i, biomes[i].weight }
	end
	return chooseweight(biomez)
end


local function rng_percentage(value)
	local yes = math.random(1,100)
	return (value >= yes)
end


local function createbox(startx,starty,startz,endx,endy,endz,area,data,block)
	for i in area:iter( startx, starty, startz, endx, endy, endz ) do
		if data[i] == c_air then
			data[i] = block
		else
			data[i] = c_air
			data[i] = block
		end
	end
end

local function createwall(startx,starty,startz,axis,size,height,area,data,block)
	for j=0, (height - 1) do
		for i=0, (size - 1) do
			if (axis == "x") then
				if (area:contains(startx + i,starty + j,startz) == false) then
					return
				end
				if (data[area:index(startx + i,starty + j,startz)] == c_air) then
					data[area:index(startx + i,starty + j,startz)] = block
				end
			else
				if (area:contains(startx,starty + j,startz + i) == false) then
					return
				end
				if (data[area:index(startx,starty + j,startz + i)] == c_air) then
					data[area:index(startx,starty + j,startz + i)] = block
				end
			end
		end
	end
end

local function createbiomewall(startx,starty,startz,axis,size,height,area,data,biome)
	local block = minetest.get_content_id(chooseweight(biome.wall_blocks))
	if (rng_percentage(biome.wallcarvechance)) then
		return
	end
	for j=0, (height - 1) do
		for i=0, (size - 1) do
			if (axis == "x") then
				if (area:contains(startx + i,starty + j,startz) == false) then
					return
				end
				if (j == 0 and (biome.trimtype == 2 or biome.trimtype == 3)) then
					block = minetest.get_content_id(chooseweight(biome.trim_bottom_blocks))
				elseif (j == (height - 1) and (biome.trimtype == 1 or biome.trimtype == 3)) then
					block = minetest.get_content_id(chooseweight(biome.trim_top_blocks))
				else
					block = minetest.get_content_id(chooseweight(biome.wall_blocks))
				end
				if (data[area:index(startx + i,starty + j,startz)] == c_air) then
					data[area:index(startx + i,starty + j,startz)] = block
				end
			else
				if (area:contains(startx,starty + j,startz + i) == false) then
					return
				end
				if (j == 0 and (biome.trimtype == 2 or biome.trimtype == 3)) then
					block = minetest.get_content_id(chooseweight(biome.trim_bottom_blocks))
				elseif (j == (height - 1) and (biome.trimtype == 1 or biome.trimtype == 3)) then
					block = minetest.get_content_id(chooseweight(biome.trim_top_blocks))
				else
					block = minetest.get_content_id(chooseweight(biome.wall_blocks))
				end
				if (data[area:index(startx,starty + j,startz + i)] == c_air) then
					data[area:index(startx,starty + j,startz + i)] = block
				end
			end
		end
	end
end


local function GetFloorAtY(y)
	for i=1, #backrooms.floordata do
		if (y == 48 + (backrooms.floordata[i].worldheight * 80)) then
			return i
		end
	end	
	return -1
end



minetest.register_on_generated(function(minp, maxp, seed) -- Do nothing if the area is above 30 
local selectionvar = GetFloorAtY(minp.y)
if selectionvar == -1 then 
return 
end
selectedroom = backrooms.floordata[selectionvar]

math.randomseed(seed)

local biomechosen = chooseweightedbiome(selectedroom.biomes)



local vm, emin, emax = minetest.get_mapgen_object("voxelmanip") 
local data = vm:get_data() 
local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}

for i in area:iter( minp.x, minp.y, minp.z, maxp.x, minp.y, maxp.z ) do 
	if data[i] == c_air then
		data[i] = c_replaceable 
	end 
end

local wallgenk = selectedroom.biomes[biomechosen].wallgenx or 10

local wallgeno = selectedroom.biomes[biomechosen].wallgenz or 39

local wallgens = selectedroom.biomes[biomechosen].wallgens or 2


for k=0, wallgenk, 1 do
	if (not rng_percentage(selectedroom.biomes[biomechosen].walldiszchance)) then
		for o=0, wallgeno, 1 do
			createbiomewall(minp.x + (k * 8),minp.y + 1,minp.z + (o * wallgens),"z",wallgens,selectedroom.wallheight,area,data,selectedroom.biomes[biomechosen])
		end
	end
	if (not rng_percentage(selectedroom.biomes[biomechosen].walldisxchance)) then
		for o=0, wallgeno, 1 do
			createbiomewall(minp.x + (o * wallgens),minp.y + 1,minp.z + (k * 8),"x",wallgens,selectedroom.wallheight,area,data,selectedroom.biomes[biomechosen])
		end
	end
end

for k=0, 10, 1 do
	for o=0,10,1 do
		if (rng_percentage(selectedroom.biomes[biomechosen].lightpercent)) then
		createbox((minp.x + (k * 8) - 4) + selectedroom.biomes[biomechosen].lightplacement[1] + selectedroom.biomes[biomechosen].lightplacement[3], minp.y + selectedroom.wallheight + 1, minp.z + ((o * 8) - 4) + selectedroom.biomes[biomechosen].lightplacement[2],(minp.x + (k * 8) - 4) + selectedroom.biomes[biomechosen].lightplacement[1] + selectedroom.biomes[biomechosen].lightplacement[3], minp.y + selectedroom.wallheight + 1,minp.z + ((o * 8) - 4) + selectedroom.biomes[biomechosen].lightplacement[2] + selectedroom.biomes[biomechosen].lightplacement[4],area,data,minetest.get_content_id(chooseweight(selectedroom.biomes[biomechosen].light_blocks)))
		end
	end


end


for i in area:iter( minp.x, minp.y, minp.z, maxp.x, minp.y, maxp.z ) do 
	if data[i] == c_replaceable then
		data[i] = minetest.get_content_id(chooseweight(selectedroom.biomes[biomechosen].floor_blocks))
	end 
end

if (selectedroom.has_ceiling) then
	for i in area:iter( minp.x, minp.y + selectedroom.wallheight + 1, minp.z, maxp.x, minp.y + selectedroom.wallheight + 1, maxp.z ) do 
		if data[i] == c_air then
			data[i] = minetest.get_content_id(chooseweight(selectedroom.biomes[biomechosen].ceil_blocks))
		end 
	end
	
	for i in area:iter( minp.x, minp.y + selectedroom.wallheight + 1, minp.z, maxp.x, minp.y + selectedroom.wallheight + 2, maxp.z ) do 
		if data[i] == c_air then
			data[i] = minetest.get_content_id(selectedroom.unbreakable_ceiling_block)
		end 
	end
end

local structures_to_place = nil

if (selectedroom.biomes[biomechosen].biomegen ~= nil) then
	structures_to_place = selectedroom.biomes[biomechosen].biomegen(selectedroom.biomes[biomechosen],minp,maxp,area,data,seed)
end

--so much of this code is just work arounds to minetests bs seriously why is worldgen so cursed

vm:set_data(data)

vm:set_lighting{day=0, night=0} 

for i in area:iter( minp.x, minp.y + 1, minp.z, maxp.x, minp.y + 1, maxp.z ) do 
	if data[i] == c_air then
		if (rng_percentage(selectedroom.biomes[biomechosen].decorationchance)) then
			local func = chooseweight(selectedroom.biomes[biomechosen].decorations)
			func(selectedroom.biomes[biomechosen],area:position(i),area,data,seed + i)
		end
	end 
end

vm:calc_lighting() 

vm:write_to_map() 

if structures_to_place ~= nil then
	for i=1, #structures_to_place do
		minetest.place_schematic(structures_to_place[i][1],structures_to_place[i][2],structures_to_place[i][3],structures_to_place[i][4],structures_to_place[i][5])
	end
end


end)