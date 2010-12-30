#!/bin/bash

#textureAtlas [prefix] [size] [files ...]

./textureAtlas menu_ 512 title.png bar.png title2.png button.png back.png  
./textureAtlas iPadMenu_ 512 ipad/title.png ipad/bar.png title2.png button.png back.png

./textureAtlas play1_ 512 dove.png bomb.png gameover.png panel_twitter.png pause.png paused.png gameover_new_record_a.png gameover_new_record_b.png gameover_exit_on.png gameover_exit_off.png wall1-left.png wall2-left.png wall3-left.png wall4-left.png wall1-middle.png wall2-middle.png wall3-middle.png wall4-middle.png wall1-right.png wall2-right.png wall3-right.png wall4-right.png roof1-left.png roof2-left.png roof3-left.png roof4-left.png roof5-left.png roof6-left.png roof1-middle.png roof2-middle.png roof3-middle.png roof4-middle.png roof5-middle.png roof6-middle.png roof1-right.png roof2-right.png roof3-right.png roof4-right.png roof5-right.png roof6-right.png wall1-left-cracked.png wall2-left-cracked.png wall3-left-cracked.png wall4-left-cracked.png wall1-middle-cracked.png wall2-middle-cracked.png wall3-middle-cracked.png wall4-middle-cracked.png wall1-right-cracked.png wall2-right-cracked.png wall3-right-cracked.png wall4-right-cracked.png roof1-left-cracked.png roof2-left-cracked.png roof3-left-cracked.png roof4-left-cracked.png roof5-left-cracked.png roof6-left-cracked.png roof1-middle-cracked.png roof2-middle-cracked.png roof3-middle-cracked.png roof4-middle-cracked.png roof5-middle-cracked.png roof6-middle-cracked.png roof1-right-cracked.png roof2-right-cracked.png roof3-right-cracked.png roof4-right-cracked.png roof5-right-cracked.png roof6-right-cracked.png floor1-left.png floor2-left.png floor1-middle.png floor2-middle.png floor1-right.png floor2-right.png hall1.png hall2.png window1.png window2.png window3.png window4.png doors.png antenna-left.png antenna-right.png antenna2-trimmed.png antenna3-trimmed.png antenna4-trimmed.png antenna5-trimmed.png antenna6-trimmed.png dishes-trimmed.png ac-trimmed.png skylight.png reservoir-trimmed.png pipe1-left.png pipe1-right.png pipe2-left.png pipe2-middle.png pipe2-right.png demo_gibs.png escape-trimmed-filled.png access.png fence-trimmed.png crane1.png crane2-filled.png crane3.png crane4.png crane5.png billboard_top-middle.png billboard_top-left.png billboard_top-right.png billboard_middle-middle.png billboard_middle-left.png billboard_middle-right.png billboard_bottom-left.png billboard_bottom-right.png billboard_bottom-middle.png billboard_catwalk-left.png billboard_catwalk-right.png billboard_catwalk-middle.png billboard_post2.png billboard_dmg1-filled.png billboard_dmg2-filled.png billboard_dmg3-filled.png obstacles.png obstacles2.png

./textureAtlas play2_ 512 midground1-trimmed.png midground2-trimmed.png background-trimmed.png jet.png smoke.png mothership-filled.png dark_tower-filled.png
./textureAtlas iPadPlay2_ 512 ipad/midground1-trimmed.png ipad/midground2-trimmed.png ipad/background-trimmed.png jet.png smoke.png mothership-filled.png dark_tower-filled.png

./textureAtlas play3_ 512 giant_leg_bottom.png giant_leg_top.png girder-tall.png

./joinPlists menu_atlas.plist play1_atlas.plist play2_atlas.plist play3_atlas.plist
mv joined.plist textureAtlas.plist
./joinPlists iPadMenu_atlas.plist play1_atlas.plist iPadPlay2_atlas.plist play3_atlas.plist
mv joined.plist iPadTextureAtlas.plist
