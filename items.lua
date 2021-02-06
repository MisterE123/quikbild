quikbild.items = {}
local dyes = dye.dyes

for i = 1, #dyes do
    
	local name, desc = unpack(dyes[i])

	minetest.register_node("quikbild:" .. name, {
		description = "Minigame ".. desc .. " Wool ",
		tiles = {"wool_" .. name .. ".png"},
		is_ground_content = false,
        groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 3,
				flammable = 3, wool = 1},
		sounds = default.node_sound_defaults(),
        on_place = function(itemstack, placer, pointed_thing)
            if arena_lib.is_player_in_arena(placer:get_player_name(), "quikbild") then
                --minetest.chat_send_all('ln17')
                local pos = pointed_thing.above
                if pos then
                    if minetest.get_node(pos).name == 'air' or string.find(minetest.get_node(pos).name,'quikbild') then  
                        --minetest.chat_send_all('ln20')
                        minetest.set_node(pos, {name="quikbild:" .. name})

                        return ItemStack("quikbild:" .. name), pos
                    end
                end
            end
            
            
            
        end,
        drop = {},

        on_use = function(itemstack, user, pointed_thing)
            if arena_lib.is_player_in_arena(user:get_player_name(), "quikbild") then
                local pos = pointed_thing.under 
                if pos then
                    if string.find(minetest.get_node(pos).name,'quikbild') then  

                        minetest.set_node(pos, {name="air"})
                    end
                end
            end
            return nil
        
        end,
		
    })
    table.insert(quikbild.items,"quikbild:" .. name)
end

