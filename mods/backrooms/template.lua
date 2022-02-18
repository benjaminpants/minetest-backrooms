--this is the backrooms template for various things, this should not be called ingame ever

--this is a "decoration", it's called occasionally when building a biome if enabled and can be whatever you want, like crates or tables
local decoration_template = function(biome,position,area,data,seed)
	--do setnode and stuff here, data is just for checking for air


end

--this is a "forced decoration", called a "biomegen" in the code
local forcedec_template = function(biome,minp,maxp,area,data,seed)
	data[area:index(minp.x,minp.y + 1,minp.z)] = minetest.get_content_id("backrooms:reusable_ceiling")

	--return values are structures
end


--and this is a floor, contains various data like height and other stuff, contains a list of biomes as well which are per mapchunk
backrooms.floordata[2] = {
	name = "Debug Floor", --floor name
	worldheight = 5,
	wallheight = 4,
	has_ceiling = true,
	floorheight = 1,
	unbreakable_ceiling_block = "backrooms:reusable_ceiling",
	unbreakable_floor_block = "backrooms:reusable_ceiling",
	floor_tic = nil,
	biomes = {
		{ 
			identifier = "debug",
			weight = 100,
			wallcarvechance = 30, --likelyhood of a wall being carved into as a percentage
			walldisxchance = 0, --likelyhood of an entire x wall being cut as a percentage(for a mapblock)
			walldiszchance = 0, --likelyhood of an entire z wall being cut as a percentage(for a mapblock)
			trimtype = 3, --0 is no trim, 1 is top trim, 2 is bottom trim, 3 is both
			lightpercent = 99,
			lightplacement = {-1,-1,2,1}, --offset x,offset z, size x, size z, starting from the center
			decorationchance = 5,
			decorations = {{decoration_template,100}},
			biomegenonly = false, --should it just be the biome gen and not run the normal generation code? (DECORATIONS WILL STILL BE PLACED)
            biomegen = forcedec_template, --a forced generator that will be called lol
            --wallgenx is an option paramater you can put here, its very technical but can be used to adjust how big chunks are in each axis, default is 10
            --wallgenz is the same as above but for the z axis, the default is 39
			wall_blocks = { --the blocks that the wall is primarily constructed out of
				{"debug:tile",110},
				{"debug:tile_alt",3}
			},
			floor_blocks = { --the blocks that the floor is primarily constructed out of
				{"debug:tile_alt",200}
			},
			ceil_blocks = { --the blocks that the ceiling is primarily constructed out of
				{"debug:tile_alt",100}
			},
			trim_bottom_blocks = { --the wall trims
				{"debug:tile_alt",100}
			},
			trim_top_blocks = { --the wall trims but for the top
				{"debug:tile_alt",100}
			},
			light_blocks = { --the blocks that the lights are primarily constructed out of
				{"backrooms:f0_light",100}
			}
		}
    }
}