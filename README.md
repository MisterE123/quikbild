# QuikBild

![](screenshot.png)

Contributors: MisterE, Zughy (hotbar background)

Code snippets from https://gitlab.com/zughy-friends-minetest/arena_lib/-/blob/master/DOCS.md and from Zughy's minigames


License: GPL 3
sounds: CC0


Description: Each player will get a turn to be the artist. In each round, the artist is given a word to build a representation of, and the tools to build it. THey have a time limit.

Other players try to be the first to guess the word by sending it in chat (this does not spam global chat)

the artist gets a point, and the guesser gets a point, if they guess correctly.

If no one guesses correctly, then no one gets points that round. Send chat messages with keywords lowercase only, and spell them correctly!


Basic setup:

1) type /quikbild create <arena_name>
2) type /quikbild edit <arena_name>
3) use the editor to place a minigame sign, assign it to your minigame.
4) while in the editor, move to where your arena will be.
5) Make your arena. There should be a central cage, for the artist to build in, made from glass, and a viewing area around it. The entire thing should prevent escape. use walls or fullclip.
6) using the editor tools, mark player spawner locations. These should be placed in the viewing area. Protect the arena.
7) go to minigame settings, and open the settings editor.
8) set the build_area_pos_1 and 2 to be locations that fully encompass the central build area. THis will allow the arena to clear builds between rounds.
9) edit the word list. Only a short example word list is given, but you can make your own, and set your arena to a theme! Make sure to use the proper lua table syntax!
10) Set the build time. This is the time allowed for the artist to build, and the time allowed for other players to guess. IF this runs out, no one gets any points
11) Set the artist spawn position. This should be a location inside the build area.
12) exit the editor mode
13) type /minigamesettings quikbild 
14) change the hub spawnpoint to be next to the signs, and adjust the queuing time as desired.

