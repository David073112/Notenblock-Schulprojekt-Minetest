local on_digiline_receive = function (pos, _, channel, msg)
	local setchan = minetest.get_meta(pos):get_string("channel")
	if channel == setchan then
		local meta = minetest.get_meta(pos)
		local heardistance = tonumber(meta:get_string("heardistance")) or 10
		local gain = tonumber(meta:get_string("gain")) or 1
		
		minetest.sound_play(
			msg, { 
				pos = pos,
				max_hear_distance = heardistance,
				gain = gain,
			})
	end
end

minetest.register_node("soundblock:block", {
	description = "soundblock",
	tiles = {
		"soundblock.jpg",
		"soundblock.jpg",
		"soundblock.jpg",
		"soundblock.jpg",
		"soundblock.jpg",
		"soundblockoffen.jpg"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.4375, 0.5, 0.5, 0.5}, -- NodeBox1
			{-0.5, -0.5, -0.5, 0.5, -0.375, -0.3125}, -- NodeBox2
			{-0.5, 0.375, -0.5, 0.5, 0.5, -0.3125}, -- NodeBox4
			{0.3125, -0.5, -0.5, 0.5, 0.5, -0.3125}, -- NodeBox5
			{-0.5, -0.5, -0.5, -0.3125, 0.5, -0.3125}, -- NodeBox6
			{-0.5, 0.25, -0.5, -0.1875, 0.5, -0.3125}, -- NodeBox7
			{0.1875, 0.25, -0.5, 0.5, 0.5, -0.3125}, -- NodeBox8
			{-0.125, -0.25, -0.5, -0.5, -0.5, -0.3125}, -- NodeBox9
			{0.5, -0.25, -0.5, 0.125, -0.5, -0.3125}, -- NodeBox10
		}
	},	
	is_ground_content = false,
	groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2},
	digiline =
	{
		receptor = {},
		effector = {
			action = on_digiline_receive
		},
	},

on_rightclick = function(pos, node, player, itemstack, pointed_thing)
	local node = minetest.get_node(pos)
	local meta = minetest.get_meta(pos)
	local channel = meta:get_string("channel")	
	local heardistance = tonumber(meta:get_string("heardistance")) or 10	
	local gain = tonumber(meta:get_string("gain")) or 1	

	minetest.show_formspec(player:get_player_name(),"fs",
			"size[6,5;]"..
			"bgcolor[#0000;fullscreen]"..
			"field[1,1;4.5,1;channel;Channel;"..channel.."]"..
			"field[1,2;4.5,1;heardistance;Hearing distance;"..heardistance.."]"..
			"field[1,3;4.5,1;gain;Volume;"..gain.."]"..
			"button_exit[2,4;1.5,1;save;Save]"
			)

	minetest.register_on_player_receive_fields(function(player, formname, fields)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local channel = fields["channel"]
		local heardistance = fields["heardistance"]
		local gain = fields["gain"]
		
		if fields["save"] then
			meta:set_string("channel", channel)	
			meta:set_string("heardistance", heardistance)	
			meta:set_string("gain", gain)			
		end
	end)

end		
})


minetest.register_craft({
	output = "soundblockmesecon:soundblock",
	recipe = {
		{
			"",
			"dye.blue",
			""
		},
		{
			"dye:orange",
			"",
			"dye:orange"
		},
		{
			"",
			"dye:blue",
			""
		}
	}
})
