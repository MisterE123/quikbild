local clearinv = function(p_name)
    local player = minetest.get_player_by_name(p_name)
    local inv = player:get_inventory()    
    for idx ,itemname in pairs(quikbild.items) do
        local stack = ItemStack(itemname)
        local taken = inv:remove_item("main", stack)
    end


end


arena_lib.on_load("quikbild", function(arena)



    arena_lib.HUD_send_msg_all("title", arena, 'QuikBild v 0.1', 3 ,nil,0xFF0000)


end)

--this is necessary beacuse it is required by arena_lib for timed games
arena_lib.on_time_tick('quikbild', function(arena)



    if arena.state == 'choose_artist' then
    
        --choose the artist
        local artist_canidates = {}
        for pl_name,stats in pairs(arena.players) do
            if stats.has_built == false then
                table.insert(artist_canidates,pl_name)
            end
        end
        if #artist_canidates == 0 then --we have reached game's end
            arena.state = 'game_over'
            local winning_score = 0
            local winners = {}

            for pl_name,stats in pairs(arena.players) do
                if stats.score == winning_score then 
                    table.insert(winners,pl_name)
                elseif stats.score > winning_score then
                    winning_score = stats.score
                    winners = {pl_name}
                end
            end





            -- for pl_name,stats in pairs(arena.players) do
            --     local edit = true
            --     if not winner_table[1] then 
            --         winner_table = {{pl_name,stats.score}}
            --         edit = false
            --     end
            --     if edit then
            --         local current_winner_stats = winner_table[1]
            --         minetest.chat_send_all('current_winner_stats:'..dump(current_winner_stats))
            --         local current_winner_score = current_winner_stats[2]
            --         if stats.score == current_winner_score then
            --             table.insert(winner_table,{pl_name,stats.score})
            --         elseif stats.score > current_winner_score then
            --             winner_table = {{pl_name,stats.score}}
            --         end
            --     end
            -- end
            -- local first_winner = winner_table[1]
            if winning_score == 0 then --if no one got any points, then eliminate everyone
                arena_lib.HUD_send_msg_all("broadcast", arena, 'No one got any points :(   Try again!', 3 ,'sumo_lose',0xFF0000)
                minetest.after(4,function(arena)
                    arena_lib.force_arena_ending('quikbild', arena,'Game')
                
                end,arena)
            else
                
                local winner_string = ''
                local pts = 0
                for _,pl_name in pairs(winners) do
                    
                    winner_string = winner_string..pl_name..", "
                    
                end
                arena_lib.HUD_send_msg_all("broadcast", arena, winner_string..' won with '..winning_score.. ' pts!', 3 ,'sumo_win',0x0000AA)
                minetest.log(dump(winners))
                minetest.after(4,function(arena) --cant use arena_lib.load celebration rn, doesnt recognize more than 1 winner
                    arena_lib.force_arena_ending('quikbild', arena,'Game')
                
                end,arena)
            end

            return
        end
        --game ist over, so we choose the artist




        local rand_art_idx = math.random(1,#artist_canidates)
        arena.artist = artist_canidates[rand_art_idx]
        arena.players[arena.artist].has_built = true --indicate that they were the artist
        arena.state = 'build_think' --change the arena state so we dont run this code again
        --send info messages
        arena_lib.HUD_send_msg("broadcast", arena.artist, 'You are the Artist. Build the word you see', 4 ,nil,0xFF0000)
        for pl_name,stats in pairs(arena.players) do 
            if pl_name ~= arena.artist then
                arena_lib.HUD_send_msg("broadcast", pl_name, arena.artist .. ' is the artist.', 2 ,nil,0xFF0000)
                minetest.after(2, function(arena,pl_name)
                    arena_lib.HUD_send_msg("hotbar", pl_name, 'Guess what they are building. Type it in chat (lowercase only)', 2 ,nil,0xFF0000)
                end,arena,pl_name)
            end
        end
        --choose the word
        arena.word = arena.word_list[math.random(1,#arena.word_list)]
        --clear the building area
        local pos1 = arena.build_area_pos_1
        local pos2 = arena.build_area_pos_2
        local x1 = pos1.x
        local x2 = pos2.x
        local y1 = pos1.y
        local y2 = pos2.y 
        local z1 = pos1.z 
        local z2 = pos2.z 
        if x1 > x2 then
            local temp = x2
            x2 = x1
            x1 = temp
        end
        if y1 > y2 then
            local temp = y2
            y2 = y1
            y1 = temp
        end
        if z1 > z2 then
            local temp = z2
            z2 = z1
            z1 = temp
        end

        for x = x1,x2 do
            for y = y1,y2 do
                for z = z1,z2 do
                    local nodename = minetest.get_node({x=x,y=y,z=z}).name 
                    if string.find(nodename,'quikbild') then

                    
                        minetest.set_node({x=x,y=y,z=z}, {name="air"})
                    end
                    
                    
                end
            end
        end
        ----minetest.chat_send_all('cleared!')

        
        
        
        
        
        -- teleport the artist in to the building area.


        local artist_pl = minetest.get_player_by_name(arena.artist)
        artist_pl:move_to(arena.artist_spawn_pos)

        
        



    end




    if arena.state == 'build_think' then
        arena.state_time = arena.state_time + 1 --increase the timer counter
        if arena.state_time == 4 then
            --send the word to the artist
            arena_lib.HUD_send_msg("title", arena.artist, arena.word, 4 ,nil,0xFF0000)
            arena_lib.HUD_send_msg_all("broadcast", arena, 'Round begins in 5', 1 ,nil,0xFF0000)
        end
        if arena.state_time == 5 then
            arena_lib.HUD_send_msg_all("broadcast", arena, 'Round begins in 4', 1 ,nil,0xFF0000)
        end
        if arena.state_time == 6 then
            arena_lib.HUD_send_msg_all("broadcast", arena, 'Round begins in 3', 1 ,nil,0xFF0000)
        end
        if arena.state_time == 7 then
            arena_lib.HUD_send_msg_all("broadcast", arena, 'Round begins in 2', 1 ,nil,0xFF0000)
        end
        if arena.state_time == 8 then
            arena_lib.HUD_send_msg_all("broadcast", arena, 'Round begins in 1', 1 ,nil,0xFF0000)
        end
        if arena.state_time == 9 then
            --give the artist his tools, send start to everyone, change state
            for pl_name, stats in pairs(arena.players) do
                if pl_name == arena.artist then
                    local player = minetest.get_player_by_name(pl_name)
                    for idx ,itemname in pairs(quikbild.items) do
                        local item = ItemStack(itemname)
                        player:get_inventory():set_stack("main", idx, item)
                    end
                    arena_lib.HUD_send_msg("title", pl_name, 'BUILD!', 1 ,nil,0x00FF00)
                    arena_lib.HUD_send_msg("title", pl_name, 'BUILD!', 1 ,nil,0x00FF00)
                else
                    arena_lib.HUD_send_msg("title", pl_name, 'BEGIN GUESSSING!', 1 ,nil,0x00FF00)
                end
                arena.state = 'build'
                arena.state_time = 0
            end
        end
    end





    if arena.state == 'build' then
        if not arena.stall then
            local time_left = arena.build_time - arena.state_time

            
            local art_is_in_game = false
            for pl_name,stats in pairs(arena.players) do
                if pl_name == arena.artist then
                    art_is_in_game = true
                end
            end

            if not(art_is_in_game) then --if arena.artist is no longer in the game, then send message to players, and change game state to choose artist, and return
                arena_lib.HUD_send_msg_all("Title", arena, "Oops! Looks like the artist left the game."..arena.word, 3 ,'sumo_elim',0xFFFFFF)
                arena.stall = true --stop gameplay for 3 sec
                minetest.after(3,function(arena)
                    if arena.in_game then
                        arena.stall = false
                        arena.state = 'choose_artist'
                        arena.state_time = 0
                        for pl_name,stats in pairs(arena.players) do
                            local pos = arena_lib.get_random_spawner(arena)
                            local pl_obj = minetest.get_player_by_name(pl_name)
                            pl_obj:move_to(pos)
                            clearinv(pl_name)
                        end
                    end
                
                end,arena)
                return

            end


            if time_left == 0 then


                --change game state
                arena_lib.HUD_send_msg_all("Title", arena, "TIME's UP! The word was: "..arena.word, 3 ,'sumo_lose',0xFFFFFF)
                arena.stall = true --stop gameplay for 3 sec
                minetest.after(3,function(arena)
                    if arena.in_game then
                        arena.stall = false
                        arena.state = 'choose_artist'
                        arena.state_time = 0
                        for pl_name,stats in pairs(arena.players) do
                            local pos = arena_lib.get_random_spawner(arena)
                            local pl_obj = minetest.get_player_by_name(pl_name)
                            pl_obj:move_to(pos)
                            clearinv(pl_name)
                        end

                    end
                
                end,arena)

                return
            end
        
            for pl_name,stats in pairs(arena.players) do
                if pl_name == arena.artist then
                    arena_lib.HUD_send_msg("hotbar", pl_name, "WORD: ".. arena.word .." TIME: "..time_left, 1 ,nil,0xFFFFFF)
                else
                    arena_lib.HUD_send_msg("hotbar", pl_name, " TIME LEFT IN ROUND: "..time_left, 1 ,nil,0xFFFFFF)
                end
            end

            arena.state_time = arena.state_time + 1

        end

    end
end)



table.insert(minetest.registered_on_chat_messages, 1, function(p_name, message)  --thanks rubenwardy, for giving this code snippet that works around Arena_libs's chat prevention!
    if message:sub(1, 1) == "/" then
        return false
    end

    ----minetest.chat_send_all('line 275')
    if arena_lib.is_player_in_arena(p_name,'quikbild') then
        ----minetest.chat_send_all('line 276')
        local arena = arena_lib.get_arena_by_player(p_name)
        if not(arena.in_queue) and not(arena.in_celebration) and not(arena.in_loading) then
            ----minetest.chat_send_all('line 279')

            if arena.state == 'build' then
                ----minetest.chat_send_all('line 283')

                if p_name == arena.artist then
                    return true -- prevent cheating!
                else
                    ----minetest.chat_send_all('line 285')

                    if string.find(message,arena.word) then -- if the word was said...
                        ----minetest.chat_send_all('line 288')

                        for pl_name, stats in pairs(arena.players) do
                            if pl_name == p_name then
                                local list = {'Correct!', 'You got it!','Way to go!', 'Outstanding!', 'Yay!'}
                                local msg = list[math.random(1,5)]..' +1 pt'
                                arena_lib.HUD_send_msg("title", pl_name, msg, 3 ,'sumo_win',0x00FF00)
                                arena.players[p_name].score = arena.players[p_name].score + 1
                            elseif pl_name == arena.artist then
                                local msg = 'Yay! '..p_name..' guessed your word. +1 pt'
                                arena_lib.HUD_send_msg("title", pl_name, msg, 3 ,'sumo_win',0x00FF00)
                                arena.players[pl_name].score = arena.players[pl_name].score + 1
                            else
                                local msg = p_name..' guessed the word. Round over!'
                                arena_lib.HUD_send_msg("title", pl_name, msg, 3 ,'sumo_elim',0x00FF00)
                            end
                        end


                        arena.stall = true --stop gameplay for 3 sec
                        minetest.after(3,function(arena)
                            if arena.in_game then
                                arena.stall = false
                                arena.state = 'choose_artist'
                                arena.state_time = 0
                                for pl_name,stats in pairs(arena.players) do
                                    local pos = arena_lib.get_random_spawner(arena)
                                    local pl_obj = minetest.get_player_by_name(pl_name)
                                    pl_obj:move_to(pos)
                                    clearinv(pl_name)
                                end
                            end
                            
                        end,arena)

                        
                    end
                end
            end
        end
    end

end)






arena_lib.on_celebration('quikbild', function(arena, winner_name)
    minetest.after(3,function(arena)
        arena_lib.HUD_hide('all', arena)
    end,arena)

end)

arena_lib.on_quit('quikbild', function(arena, p_name, is_forced)
    arena_lib.HUD_hide('all', p_name)
end)

--remove stick if in inv when joinplayer
minetest.register_on_joinplayer(function(player)
    local name = player:get_player_name()
    clearinv(name)

end)

