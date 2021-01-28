ChatCmdBuilder.new("quikbild", function(cmd)

  -- create arena
  cmd:sub("create :arena", function(name, arena_name)
      arena_lib.create_arena(name, "quikbild", arena_name)
  end)

  cmd:sub("create :arena :minplayers:int :maxplayers:int", function(name, arena_name, min_players, max_players)
      arena_lib.create_arena(name, "quikbild", arena_name, min_players, max_players)
  end)

  -- remove arena
  cmd:sub("remove :arena", function(name, arena_name)
      arena_lib.remove_arena(name, "quikbild", arena_name)
  end)

  -- list of the arenas
  cmd:sub("list", function(name)
      arena_lib.print_arenas(name, "quikbild")
  end)

  -- enter editor mode
  cmd:sub("edit :arena", function(sender, arena)
      arena_lib.enter_editor(sender, "quikbild", arena)
  end)

  -- enable and disable arenas
  cmd:sub("enable :arena", function(name, arena)
      arena_lib.enable_arena(name, "quikbild", arena)
  end)

  cmd:sub("disable :arena", function(name, arena)
      arena_lib.disable_arena(name, "quikbild", arena)
  end)

end, {
  description = [[

    (/help quikbild)

    Use this to configure your arena:
    - create <arena name> [min players] [max players]
    - edit <arena name>
    - enable <arena name>

    Other commands:
    - remove <arena name>
    - disable <arena>
    ]],
  privs = { quikbild_admin = true }
})
