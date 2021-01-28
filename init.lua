-- local value settings
local player_speed = 2 -- when in the minigame
local player_jump = 1.3 -- when in the minigame

quikbild = {} --global table

  arena_lib.register_minigame("quikbild", {
      prefix = "[QuikBild] ",
      show_minimap = false,
      show_nametags = true,
      time_mode = 1,
      join_while_in_progress = true,
      keep_inventory = false,
      in_game_physics = {
        speed = player_speed,
        jump = player_jump,
        sneak = false,
      },
      properties = {
        build_area_pos_1 = {x = 0, y = 0, z = 0},
        build_area_pos_2 = {x = 0, y = 0, z = 0},
        word_list = {'dog','cat','house','wheel','bird','road','farm','bell','apple','pencil'},
        build_time = 60, --sec allowed to build
        artist_spawn_pos = {x = 0, y = 0, z = 0},
      },
      load_time = 4,
      celebration_time = 5,
      hotbar = {
        slots = #dye.dyes,
        background_image = "sumo_gui_hotbar.png",
      },
      temp_properties = {
        state = 'choose_artist', --game states: 'choose_artist', 'build_think','build','game_over'
        state_time = 0,
        artist = nil,
        word = '',
        answer_list = {},
        win_guesser = '',
        stall = false,
      },
      disabled_damage_types = {"punch","fall","node_damage","set_hp","drown"},

      player_properties = {
        role = "",
        has_built = false,
        score = 0,
      },
  })


if not minetest.get_modpath("lib_chatcmdbuilder") then
  dofile(minetest.get_modpath("quikbild") .. "/chatcmdbuilder.lua")
end

dofile(minetest.get_modpath("quikbild") .. "/commands.lua")
dofile(minetest.get_modpath("quikbild") .. "/items.lua")
dofile(minetest.get_modpath("quikbild") .. "/minigame_manager.lua")
dofile(minetest.get_modpath("quikbild") .. "/privs.lua")
