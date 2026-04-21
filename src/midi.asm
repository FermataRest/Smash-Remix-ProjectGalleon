// MIDI.asm (Fray)
if !{defined __MIDI__} {
define __MIDI__()

// This file extends the music table and defines macros for including new MIDI files.
// It also extends the instrument table and defines macros for including new instruments.
// For converting MIDI files, it's recommended to use GE Editor.
// Tools > Extra Tools > MIDI Tools > Convert Midi to GE Format and Loop

include "OS.asm"

scope MIDI {
    read32 MUSIC_TABLE, "../roms/original.z64", 0x3D768
    variable MUSIC_TABLE_END(MUSIC_TABLE + 0x17C)   // variable containing the current end of the music table
    constant MIDI_BANK(0x3200000)                   // defines the start of the additional MIDI bank
    global variable MIDI_BANK_END(MIDI_BANK)        // variable containing the current end of the MIDI bank
    // These 2 variables will be used in FGM.asm to calculate the correct RAM offset for numerous pointers
    variable midi_count(0x2F)                       // variable containing total number of MIDIs
    variable largest_midi(0)                        // variable containing the largest MIDI size

    variable game_count(0)                          // variable counting the number of games represented by midis

    // @ Description
    // moves the Dream Land midi to our new MIDI bank to clear space for expanding MUSIC_TABLE
    macro move_dream_land_midi() {
        pushvar origin, base

        // define a new offset for the Dream Land MIDI
        origin  MUSIC_TABLE + 0x4
        dw      MIDI_BANK_END - MUSIC_TABLE

        // remove the previous Dream Land MIDI
        origin  MUSIC_TABLE_END
        fill    0x1F40, 0x00

        // insert the Dream Land MIDI and update MIDI_BANK_END
        origin  MIDI_BANK_END
        insert  MIDI_Dream_Land, "../roms/original.z64", MUSIC_TABLE + 0x17C, 0x1F40
        global variable MIDI_BANK_END(origin())

        pullvar base, origin
    }

    // @ Description
    // Defines a game so we can associate midis with games
    // @ Arguments
    // name - name/id
    // title - game title for display
    macro add_game(name, title) {
        evaluate n(game_count)

        global define GAME_{name}({n})
        game_{n}_title:; db {title}, 0x0

        global variable game_count(game_count + 0x1)
    }

    // @ Description
    // adds a MIDI to our new MIDI bank, and the music table
    // @ Arguments
    // file_name - Name of MIDI file
    // random_te - (bool) Default value for Tournament profile
    // random_ne - (bool) Default value for Netplay profile
    // can_toggle - (bool) indicates if this should be toggleable
    // has_title - (bool) indicates if this track has a title string
    // track_title - Name of track
    // track_game - Name of game of origin for track (from add_game)
    // order - Order of the track
    macro insert_midi(file_name, random_te, random_ne, can_toggle, has_title, track_title, track_game, order) {
        pushvar origin, base

        // defines
        define path_MIDI_{file_name}(../src/music/{file_name}.bin)
        evaluate offset_MIDI_{file_name}(MIDI_BANK_END)
        evaluate MIDI_{file_name}_ID((MUSIC_TABLE_END - MUSIC_TABLE) / 0x8)

        global variable midi_count({MIDI_{file_name}_ID} + 0x1)
        global define MIDI_{MIDI_{file_name}_ID}_TE({random_te})
        global define MIDI_{MIDI_{file_name}_ID}_NE({random_ne})
        global define MIDI_{MIDI_{file_name}_ID}_TOGGLE({can_toggle})
        global define MIDI_{MIDI_{file_name}_ID}_TITLE({has_title})
        global define MIDI_{MIDI_{file_name}_ID}_FILE_NAME({file_name})
        global define MIDI_{MIDI_{file_name}_ID}_NAME({track_title})
        global define MIDI_{MIDI_{file_name}_ID}_GAME({track_game})
        global define MIDI_{MIDI_{file_name}_ID}_ORDER({order})
        global define id.{file_name}({MIDI_{file_name}_ID})

        // print message
        print "Added MIDI_{file_name}({path_MIDI_{file_name}}): ", {MIDI_{MIDI_{file_name}_ID}_NAME}, "\n"
        print "ROM Offset: 0x"; OS.print_hex({offset_MIDI_{file_name}}); print "\n"
        print "MIDI_{file_name}_ID: 0x"; OS.print_hex({MIDI_{file_name}_ID}); print "\n"
        print "Sound Test Music ID: ", midi_count, "\n\n"

        // add the new midi to the music table and update MUSIC_TABLE_END
        origin  MUSIC_TABLE_END
        dw      origin_MIDI_{file_name} - MUSIC_TABLE
        dw      MIDI_{file_name}.size
        global variable MUSIC_TABLE_END(origin())

        // insert the MIDI file and update MIDI_BANK_END
        origin  MIDI_BANK_END
        constant origin_MIDI_{file_name}(origin())
        insert  MIDI_{file_name}, "{path_MIDI_{file_name}}"
        OS.align(4)
        global variable MIDI_BANK_END(origin())

        // set the number of songs in MUSIC_TABLE
        origin  MUSIC_TABLE + 0x2
        dh      midi_count

        // update largest MIDI size
        if MIDI_{file_name}.size > largest_midi {
            global variable largest_midi(MIDI_{file_name}.size)
        }

        pullvar base, origin
    }

    // same as insert_midi but from external paths
    macro insert_external_midi(midi_id, file_name, random_te, random_ne, can_toggle, has_title, track_title, track_game, order) {
        pushvar origin, base

        // defines
        define path_MIDI_{midi_id}({file_name}.bin)
        evaluate offset_MIDI_{midi_id}(MIDI_BANK_END)
        evaluate MIDI_{midi_id}_ID((MUSIC_TABLE_END - MUSIC_TABLE) / 0x8)

        global variable midi_count({MIDI_{midi_id}_ID} + 0x1)
        global define MIDI_{MIDI_{midi_id}_ID}_TE({random_te})
        global define MIDI_{MIDI_{midi_id}_ID}_NE({random_ne})
        global define MIDI_{MIDI_{midi_id}_ID}_TOGGLE({can_toggle})
        global define MIDI_{MIDI_{midi_id}_ID}_TITLE({has_title})
        global define MIDI_{MIDI_{midi_id}_ID}_FILE_NAME({midi_id})
        global define MIDI_{MIDI_{midi_id}_ID}_NAME({track_title})
        global define MIDI_{MIDI_{midi_id}_ID}_GAME({track_game})
        global define MIDI_{MIDI_{midi_id}_ID}_ORDER({order})
        global define id.{midi_id}({MIDI_{midi_id}_ID})

        // print message
        print "Added MIDI_{midi_id}({path_MIDI_{midi_id}}): ", {MIDI_{MIDI_{midi_id}_ID}_NAME}, "\n"
        print "ROM Offset: 0x"; OS.print_hex({offset_MIDI_{midi_id}}); print "\n"
        print "MIDI_{midi_id}_ID: 0x"; OS.print_hex({MIDI_{midi_id}_ID}); print "\n"
        print "Sound Test Music ID: ", midi_count, "\n\n"

        // add the new midi to the music table and update MUSIC_TABLE_END
        origin  MUSIC_TABLE_END
        dw      origin_MIDI_{midi_id} - MUSIC_TABLE
        dw      MIDI_{midi_id}.size
        global variable MUSIC_TABLE_END(origin())

        // insert the MIDI file and update MIDI_BANK_END
        origin  MIDI_BANK_END
        constant origin_MIDI_{midi_id}(origin())
        insert  MIDI_{midi_id}, "{path_MIDI_{midi_id}}"
        OS.align(4)
        global variable MIDI_BANK_END(origin())

        // set the number of songs in MUSIC_TABLE
        origin  MUSIC_TABLE + 0x2
        dh      midi_count

        // update largest MIDI size
        if MIDI_{midi_id}.size > largest_midi {
            global variable largest_midi(MIDI_{midi_id}.size)
        }

        pullvar base, origin
    }

    // @ Description
    // adds a toggleable MIDI to our new MIDI bank, and the music table
    // file_name - Name of MIDI file
    // random_te - Default value for Tournament profile
    // random_ne - Default value for Netplay profile
    // track_title - Name of track
    // track_game - Game of origin for track
    macro insert_midi(file_name, random_te, random_ne, track_title, track_game, order) {
        insert_midi({file_name}, {random_te}, {random_ne}, OS.TRUE, OS.TRUE, {track_title}, {track_game}, {order})
    }

    // @ Description
    // adds an extra, unnamed MIDI to our new MIDI bank, and the music table
    // file_name - Name of MIDI file
    macro insert_extra_midi(file_name) {
        insert_midi({file_name}, OS.FALSE, OS.FALSE, OS.FALSE, OS.FALSE, -1, -1, -1)
    }

    // @ Description
    // adds an extra, named MIDI to our new MIDI bank, and the music table
    // file_name - Name of MIDI file
    macro insert_named_extra_midi(file_name, track_title, track_game, order) {
        insert_midi({file_name}, OS.FALSE, OS.FALSE, OS.FALSE, OS.TRUE, {track_title}, {track_game}, {order})
    }

    // define new MIDI bank
    print "=============================== MIDI FILES =============================== \n"
    // print music table offset
    evaluate music_table_offset(MUSIC_TABLE)
    print "Music Table: 0x"; OS.print_hex({music_table_offset}); print "\n"

    // move dream land midi
    move_dream_land_midi()

    // define games
    add_game(smb, "Super Mario Bros.")
    add_game(smb2, "Super Mario Bros. 2")
    add_game(smb3, "Super Mario Bros. 3")
    add_game(sml, "Super Mario Land")
    add_game(smw, "Super Mario World")
    add_game(sm64, "Super Mario 64")
    add_game(sunshine, "Super Mario Sunshine")
    add_game(nsmb, "New Super Mario Bros.")
    add_game(drm, "Dr. Mario")
    add_game(drm64, "Dr. Mario 64")
    add_game(smk, "Super Mario Kart")
    add_game(mk64, "Mario Kart 64")
    add_game(mkds, "Mario Kart DS")
    add_game(marioparty, "Mario Party")
    add_game(marioparty2, "Mario Party 2")
    add_game(mariogolf, "Mario Golf")
    add_game(mariotennis, "Mario Tennis")
    add_game(smrpg, "Super Mario RPG: Legend of the Seven Stars")
    add_game(papermario, "Paper Mario")
    add_game(mariohoops, "Mario Hoops 3-on-3")
    add_game(talentstudio, "Mario Artist: Talent Studio")
    add_game(marioluigi_bis, "Mario and Luigi: Bowser's Inside Story")
    add_game(ddrmm, "Dance Dance Revolution: Mario Mix")
    add_game(yoshis_island, "Super Mario World 2: Yoshi's Island")
    add_game(yoshis_story, "Yoshi's Story")
    add_game(yoshis_island_ds, "Yoshi's Island DS")
    add_game(warioland, "Wario Land: Super Mario Land 3")
    add_game(warioland2, "Wario Land II")
    add_game(warioshake, "Wario Land - Shake It!")
    add_game(warioworld, "Wario World")
    add_game(warioware, "WarioWare, Inc.: Mega Microgame$!")
    add_game(wwtouched, "WarioWare: Touched!")
    add_game(dkarc, "Donkey Kong/Donkey Kong Jr.")
    add_game(dkl, "Donkey Kong Land")
    add_game(dkc, "Donkey Kong Country")
    add_game(dkc2, "Donkey Kong Country 2: Diddy's Kong Quest")
    add_game(dk64, "Donkey Kong 64")
    add_game(dkr, "Diddy Kong Racing")
    add_game(zelda, "The Legend of Zelda")
    add_game(zelda2, "Zelda II: The Adventure of Link")
    add_game(lttp, "The Legend of Zelda: A Link to the Past")
    add_game(awakening, "The Legend of Zelda: Link's Awakening")
    add_game(ocarina, "The Legend of Zelda: Ocarina of Time")
    add_game(majora, "The Legend of Zelda: Majora's Mask")
    add_game(skyward, "The Legend of Zelda: Skyward Sword")
    add_game(metroid, "Metroid")
    add_game(supermetroid, "Super Metroid")
    add_game(metroidprime3, "Metroid Prime 3: Corruption")
    add_game(starfox, "Star Fox")
    add_game(starfox2, "Star Fox 2")
    add_game(starfox64, "Star Fox 64")
    add_game(pokemonred, "Pokemon Red & Blue")
    add_game(pokemongold, "Pokemon Gold & Silver")
    add_game(pokemonruby, "Pokemon Ruby & Sapphire")
    add_game(stadium, "Pokemon Stadium")
    add_game(heypika, "Hey You, Pikachu!")
    add_game(kirbydreamland, "Kirby's Dream Land")
    add_game(kirbyadventure, "Kirby's Adventure")
    add_game(kirbysuperstar, "Kirby Super Star")
    add_game(kirby64, "Kirby 64: The Crystal Shards")
    add_game(kirbyair, "Kirby Air Ride")
    add_game(kirbyreturn, "Kirby's Return to Dream Land")
    add_game(fzero, "F-Zero")
    add_game(fzero_x, "F-Zero X")
    add_game(fzero_gx, "F-Zero GX")
    add_game(earthbound, "EarthBound")
    add_game(earthboundb, "EarthBound Beginnings")
    add_game(mother3, "Mother 3")
    add_game(ssb, "Super Smash Bros.")
    add_game(ssbr, "Smash Remix")
    add_game(brawl, "Super Smash Bros. Brawl")
    add_game(melee, "Super Smash Bros. Melee")
    add_game(animal_crossing, "Animal Crossing")
    add_game(acww, "Animal Crossing: Wild World")
    add_game(acnewleaf, "Animal Crossing: New Leaf")
    add_game(machrider, "Mach Rider")
    add_game(mischiefmakers, "Mischief Makers")
    add_game(conker, "Conker's Bad Fur Day")
    add_game(banjokazooie, "Banjo-Kazooie")
    add_game(banjo2, "Banjo-Tooie")
    add_game(pd, "Perfect Dark")
    add_game(jetforce, "Jet Force Gemini")
    add_game(goldeneye, "GoldenEye 007")
    add_game(mlb, "Major League Baseball Featuring Ken Griffey Jr.")
    add_game(nbajam, "NBA Jam")
    add_game(mvc, "Marvel vs. Capcom")
    add_game(mvc2, "Marvel vs. Capcom 2")
    add_game(toh, "Tower of Heaven")
    add_game(persona, "Revelations: Persona")
    add_game(persona5, "Persona 5")
    add_game(fire_emblem, "Fire Emblem")
    add_game(fe6, "Fire Emblem: The Binding Blade")
    add_game(fe_gaiden, "Fire Emblem Gaiden")
    add_game(sonic1, "Sonic the Hedgehog")
    add_game(sonic2, "Sonic the Hedgehog 2")
    add_game(soniccd, "Sonic CD")
    add_game(sonic3, "Sonic the Hedgehog 3")
    add_game(sonicfighters, "Sonic the Fighters")
    add_game(sonicr, "Sonic R")
    add_game(sonicadventure, "Sonic Adventure")
    add_game(sonicadventure2, "Sonic Adventure 2")
    add_game(rhfever, "Rhythm Heaven Fever")
    add_game(chrono, "Chrono Trigger")
    add_game(xenogears, "Xenogears")
    add_game(dragonking, "Dragon King: The Fighting Game")
    add_game(castlevania, "Castlevania")
    add_game(castlevania_2, "Castlevania II: Simon's Quest")
    add_game(castlevania_bloodlines, "Castlevania: Bloodlines")
    add_game(castlevania_sotn, "Castlevania: Symphony of the Night")
    add_game(castlevania_dos, "Castlevania: Dawn of Sorrow")
    add_game(castlevania_rob, "Castlevania: Rondo of Blood")
    add_game(isoccer, "International Superstar Soccer 64")
    add_game(goemon, "Ganbare Goemon")
    add_game(mysticalninja, "Mystical Ninja Starring Goemon")
    add_game(gga, "Goemon's Great Adventure")
    add_game(goepachisuro, "Ganbare Goemon Pachisuro")
    add_game(waverace, "Wave Race 64")
    add_game(quest64, "Quest 64")
    add_game(ogrebattle64, "Ogre Battle 64: Person of Lordly Caliber")
    add_game(ff4, "Final Fantasy IV")
    add_game(ff5, "Final Fantasy V")
    add_game(jackbros, "Jack Bros.")
    add_game(smtif, "Shin Megami Tensei If...")
    add_game(smtiv, "Shin Megami Tensei IV")
    add_game(shantae, "Shantae")
    add_game(blastcorps, "Blast Corps")
    add_game(megamanbc, "Megaman: Battle & Chase")
    add_game(megamanscr, "Mega Man Soccer")
    add_game(doom, "DOOM")
    add_game(doom2, "DOOM II: Hell on Earth")
    add_game(dukenukem3d, "Duke Nukem 3D")
    add_game(cavestory, "Cave Story")
    add_game(sbk, "Snowboard Kids")
    add_game(sbk2, "Snowboard Kids 2")
    add_game(2hu6, "Touhou 6: Embodiment of Scarlet Devil")
    add_game(crash, "Crash Bandicoot")
    add_game(crash2, "Crash Bandicoot 2: Cortex Strikes Back")
    add_game(crash3, "Crash Bandicoot: Warped")
    add_game(crash_xs, "Crash Bandicoot: The Huge Adventure")
    add_game(ctr, "Crash Team Racing")
    add_game(dinoplanet, "Dinosaur Planet")
    add_game(marathon2, "Marathon 2: Durandal")
    add_game(ut99, "Unreal Tournament")
    add_game(shovelknight, "Shovel Knight")
    add_game(deltarune, "Deltarune")
    add_game(snp, "Sin and Punishment")
    add_game(bomberman, "Bomberman 64")
    add_game(bombermanhero, "Bomberman Hero")
    add_game(kidicarus, "Kid Icarus")
    add_game(silversurfer, "Silver Surfer")
    add_game(balloonfight, "Balloon Fight")
    add_game(paneldepon, "Panel de Pon")
    add_game(crashbash, "Crash Bash")
	add_game(md, "Murder Drones")
	add_game(pgog, "Project Galleon Original Tracks")
	add_game(hl, "Half-Life")
	add_game(ki, "Killer Instinct")
	add_game(gkeys, "Genesis Keys Music")
	add_game(wwwonder, "WizzyWhipItWonderful Music")
    add_game(msh, "Marvel Super Heroes")
    add_game(sexdick, "The Fantastic Adventures of S.D")
    add_game(dbzub22, "Dragon Ball Z: Ultimate Battle 22")
	add_game(panicprk, "Panic Park (Namco Arcade)")
	add_game(prodbycircus, "Prod by Circus")
	add_game(batmangenesis, "The Adventures of Batman and Robin (GEN)")
	add_game(gfinger64, "Goldfinger 64 (GoldenEye 007 ROM Hack)")
	add_game(carrapicho, "Carrapicho")
	add_game(ssf2t, "Super Street Fighter 2 Turbo (CPS2)")
	add_game(ssf2x68k, "Super Street Fighter 2 (Sharp X68000)")
    add_game(dream, "Dream: Land of Giants")
    OS.align(4)

    // insert custom midi files
    insert_midi(GANONDORF_BATTLE, OS.TRUE, OS.TRUE, "Ganondorf Battle", ocarina, 129)
    insert_midi(CORNERIA, OS.TRUE, OS.TRUE, "Corneria", starfox, 61)
    insert_midi(KOKIRI_FOREST, OS.TRUE, OS.TRUE, "Kokiri Forest", ocarina, 162)
    insert_midi(DR_MARIO, OS.TRUE, OS.TRUE, "Fever", drm, 98)
    insert_midi(GAME_CORNER, OS.TRUE, OS.TRUE, "Game Corner", pokemongold, 126)
    insert_midi(SMASHVILLE, OS.TRUE, OS.TRUE, "Town Hall and Tom Nook's Store", acww, 303)
    insert_midi(STONECARVING_CITY, OS.TRUE, OS.TRUE, "Stonecarving City", warioshake, 279)
    insert_midi(FIRST_DESTINATION, OS.TRUE, OS.TRUE, "Final Destination (Melee)", melee, 106)
    insert_midi(COOLCOOLMOUNTAIN, OS.TRUE, OS.TRUE, "Snow Mountain", sm64, 263)
    insert_midi(GODDESSBALLAD, OS.TRUE, OS.TRUE, "Ballad of the Goddess", skyward, 12)
    insert_midi(SARIA, OS.TRUE, OS.TRUE, "Saria's Song", ocarina, 251)
    insert_midi(TOWEROFHEAVEN, OS.TRUE, OS.TRUE, "Luna Ascension", toh, 173)
    insert_midi(FOD, OS.TRUE, OS.TRUE, "Gourmet Race (Melee)", kirbysuperstar, 138)
    insert_midi(MUDA, OS.TRUE, OS.TRUE, "Muda Kingdom", sml, 196)
    insert_midi(MEMENTOS, OS.TRUE, OS.TRUE, "Last Surprise", persona5, 166)
    insert_midi(SPIRAL_MOUNTAIN, OS.TRUE, OS.TRUE, "Spiral Mountain (Ultimate)", banjokazooie, 269)
    insert_midi(N64, OS.TRUE, OS.TRUE, "Water Land", sm64, 326)
    insert_midi(MUTE_CITY, OS.TRUE, OS.TRUE, "Mute City (Brawl)", fzero, 200)
    insert_midi(BATTLEFIELD, OS.TRUE, OS.TRUE, "Battlefield", brawl, 19)
    insert_midi(MADMONSTER, OS.TRUE, OS.TRUE, "Mad Monster Mansion", banjokazooie, 177)
    insert_extra_midi(GANON_VICTORY)
    insert_extra_midi(YOUNGLINK_VICTORY)
    insert_extra_midi(FALCO_VICTORY)
    insert_extra_midi(DRMARIO_VICTORY)
    insert_midi(MELEE_MENU, OS.TRUE, OS.TRUE, "Melee Menu", melee, 184)
    insert_midi(GREEN_GREENS, OS.TRUE, OS.TRUE, "Green Greens", kirbydreamland, 142)
    insert_midi(NORFAIR, OS.TRUE, OS.TRUE, "Brinstar Depths", metroid, 38)
    insert_midi(BOWSERBOSS, OS.TRUE, OS.TRUE, "Koopa's Theme", sm64, 164)
    insert_midi(POKEMON_STADIUM, OS.TRUE, OS.TRUE, "Trainer Battle", pokemonred, 304)
    insert_midi(BOWSERROAD, OS.TRUE, OS.TRUE, "Koopa's Road", sm64, 163)
    insert_midi(BOWSERFINAL, OS.TRUE, OS.TRUE, "Ultimate Koopa", sm64, 311)
    insert_midi(SMB3OVERWORLD, OS.TRUE, OS.TRUE, "Super Mario Bros. 3 (Melee)", smb3, 284)
    insert_midi(DELFINO, OS.TRUE, OS.TRUE, "Delfino Plaza", sunshine, 79)
    insert_midi(VS_KLUNGO, OS.TRUE, OS.TRUE, "Vs. Klungo", banjo2, 320)
    insert_midi(BIG_BLUE, OS.TRUE, OS.TRUE, "Big Blue", fzero, 23)
    insert_extra_midi(DSAMUS_VICTORY)
    insert_midi(ONETT, OS.TRUE, OS.TRUE, "Onett", earthbound, 210)
    insert_midi(ZEBES_LANDING, OS.TRUE, OS.TRUE, "Upper Brinstar", supermetroid, 315)
    insert_midi(FROSTY_VILLAGE, OS.TRUE, OS.TRUE, "Frosty Village", dkr, 119)
    insert_midi(EASTON_KINGDOM, OS.TRUE, OS.TRUE, "Easton Kingdom", sml, 89)
    insert_midi(WING_CAP, OS.TRUE, OS.TRUE, "Powerful Mario", sm64, 230)
    insert_midi(RBY_GYMLEADER, OS.TRUE, OS.TRUE, "Gym Leader Battle", pokemonred, 146)
    insert_midi(KITCHEN_ISLAND, OS.TRUE, OS.TRUE, "Wario Land", warioland, 324)
    insert_midi(GLACIAL, OS.TRUE, OS.TRUE, "River Stage", mvc2, 243)
    insert_midi(DK_RAP, OS.TRUE, OS.TRUE, "DK Rap", dk64, 81)
    insert_extra_midi(WARIO_VICTORY)
    insert_midi(MACHRIDER, OS.TRUE, OS.TRUE, "Mach Rider (Melee)", machrider, 175)
    insert_midi(POKEFLOATS, OS.TRUE, OS.TRUE, "Red & Blue Medley", pokemonred, 238)
    insert_midi(GERUDO_VALLEY, OS.TRUE, OS.TRUE, "Gerudo Valley", ocarina, 130)
    insert_midi(POP_STAR, OS.TRUE, OS.TRUE, "Pop Star", kirby64, 228)
    insert_midi(STAR_WOLF, OS.TRUE, OS.TRUE, "Star Wolf", starfox64, 274)
    insert_midi(STARRING_WARIO, OS.TRUE, OS.TRUE, "Starring Wario!", ddrmm, 276)
    insert_extra_midi(LUCAS_VICTORY)
    insert_midi(POKEMON_CHAMPION, OS.TRUE, OS.TRUE, "Champion Battle", pokemonred, 47)
    insert_midi(ANIMAL_CROSSING, OS.TRUE, OS.TRUE, "Title Theme (Wild World)", acww, 300)
    insert_midi(HYRULE_TEMPLE, OS.TRUE, OS.TRUE, "Temple Theme (Melee)", zelda2, 290)
    insert_midi(POLLYANNA, OS.TRUE, OS.TRUE, "Pollyanna (Melee)", earthboundb, 227)
    insert_midi(SAMBA_DE_COMBO, OS.TRUE, OS.TRUE, "Samba de Combo", mother3, 250)
    insert_midi(PORKY_MEDLEY, OS.TRUE, OS.TRUE, "Master Porky Medley", mother3, 183)
    insert_midi(UNFOUNDED_REVENGE, OS.TRUE, OS.TRUE, "Unfounded Revenge", mother3, 314)
    insert_midi(THE_DAYS_WHEN_MY_MOTHER_WAS_THERE, OS.TRUE, OS.TRUE, "The Days When My Mother Was There", persona5, 292)
    insert_midi(BRAWL, OS.TRUE, OS.TRUE, "Brawl Menu", brawl, 37)
    insert_midi(NBA_JAM, OS.TRUE, OS.TRUE, "NBA Jam Medley", nbajam, 202)
    insert_midi(KENGJR, OS.TRUE, OS.TRUE, "Call Me Jr.", mlb, 44)
    insert_midi(CLOCKTOWER, OS.TRUE, OS.TRUE, "Clock Tower", mvc2, 55)
    insert_midi(BEIN_FRIENDS, OS.TRUE, OS.TRUE, "Bein' Friends", earthboundb, 21)
    insert_midi(KK_RIDER, OS.TRUE, OS.TRUE, "Go K.K. Rider!", animal_crossing, 133)
    insert_midi(SNAKEY_CHANTEY, OS.TRUE, OS.TRUE, "Snakey Chantey", dkc2, 261)
    insert_midi(TAZMILY, OS.TRUE, OS.TRUE, "Mom's Hometown", mother3, 193)
    insert_midi(FLAT_ZONE, OS.TRUE, OS.TRUE, "Flat Zone", melee, 108)
    insert_midi(FLAT_ZONE_2, OS.TRUE, OS.TRUE, "Flat Zone II", brawl, 109)
    insert_midi(YOSHI_GOLF, OS.TRUE, OS.TRUE, "Yoshi's Island (Mario Golf)", mariogolf, 333)
    insert_midi(FINALTEMPLE, OS.TRUE, OS.TRUE, "Great Temple/Dark Link", zelda2, 140)
    insert_midi(OBSTACLE, OS.TRUE, OS.TRUE, "Obstacle Course", yoshis_island, 205)
    insert_midi(EVEN_DRIER_GUYS, OS.TRUE, OS.TRUE, "Even Drier Guys", mother3, 95)
    insert_midi(FZERO_MEDLEY, OS.TRUE, OS.TRUE, "F-Zero Medley", fzero, 122)
    insert_midi(PEACH_CASTLE, OS.TRUE, OS.TRUE, "Princess Peach's Castle (Melee)", smb, 231)
    insert_midi(BANJO_MAIN, OS.TRUE, OS.TRUE, "Main Title (Banjo-Kazooie)", banjokazooie, 180)
    insert_extra_midi(BOWSER_VICTORY)
    insert_midi(MULTIMAN, OS.TRUE, OS.TRUE, "Multi-Man Melee", melee, 197)
    insert_midi(TABUU, OS.TRUE, OS.TRUE, "Boss Battle Song 2", brawl, 33)
    insert_midi(GANGPLANK, OS.TRUE, OS.TRUE, "Gang-Plank Galleon", dkc, 127)
    insert_midi(FD_BRAWL, OS.TRUE, OS.TRUE, "Final Destination (Brawl)", brawl, 105)
    insert_midi(ASTRAL_OBSERVATORY, OS.TRUE, OS.TRUE, "Astral Observatory", majora, 8)
    insert_midi(ARIA_OF_THE_SOUL, OS.TRUE, OS.TRUE, "Aria of the Soul", persona, 6)
    insert_midi(PAPER_MARIO_BATTLE, OS.TRUE, OS.TRUE, "Battle Fanfare", papermario, 17)
    insert_midi(KING_OF_THE_KOOPAS, OS.TRUE, OS.TRUE, "King of the Koopas", papermario, 160)
    insert_midi(MRPATCH, OS.TRUE, OS.TRUE, "Mr. Patch", banjo2, 195)
    insert_midi(SKERRIES, OS.TRUE, OS.TRUE, "Skerries", blastcorps, 258)
    insert_midi(BEWARE_THE_FORESTS_MUSHROOMS, OS.TRUE, OS.TRUE, "Beware the Forest's Mushrooms", smrpg, 22)
    insert_midi(FIGHT_AGAINST_BOWSER, OS.TRUE, OS.TRUE, "Fight Against Bowser", smrpg, 99)
    insert_midi(DKR_BOSS, OS.TRUE, OS.TRUE, "Boss Challenges", dkr, 34)
    insert_midi(CRESCENT_ISLAND, OS.TRUE, OS.TRUE, "Crescent Island", dkr, 67)
    insert_extra_midi(CONKER_VICTORY)
    insert_midi(RITH_ESSA, OS.TRUE, OS.TRUE, "Rith Essa", jetforce, 242)
    insert_midi(TARGET_TEST, OS.TRUE, OS.TRUE, "Targets!", melee, 289)
    insert_midi(VENOM, OS.TRUE, OS.TRUE, "Venom", starfox, 317)
    insert_midi(SURPRISE_ATTACK, OS.TRUE, OS.TRUE, "Surprise Attack", starfox2, 287)
    insert_midi(BK_FINALBATTLE, OS.TRUE, OS.TRUE, "Final Battle (Banjo-Kazooie)", banjokazooie, 103)
    insert_extra_midi(MEWTWO_VICTORY)
    insert_midi(OLE, OS.TRUE, OS.TRUE, "Ole!", conker, 209)
    insert_midi(WINDY, OS.TRUE, OS.TRUE, "Windy and Co.", conker, 330)
    insert_midi(STARFOX_MEDLEY, OS.TRUE, OS.TRUE, "Star Fox Medley (Melee)", starfox, 273)
    insert_midi(DATADYNE, OS.TRUE, OS.TRUE, "dataDyne Central: Defection", pd, 74)
    insert_midi(INVESTIGATION_X, OS.TRUE, OS.TRUE, "dataDyne Central: Investigation X", pd, 75)
    insert_midi(CRADLE, OS.TRUE, OS.TRUE, "Antenna Cradle", goldeneye, 4)
    insert_midi(MM_TITLE, OS.TRUE, OS.TRUE, "Opening Title (Mischief Makers)", mischiefmakers, 213)
    insert_midi(ESPERANCE, OS.TRUE, OS.TRUE, "Esperance", mischiefmakers, 94)
    insert_midi(SLOPRANO, OS.TRUE, OS.TRUE, "Sloprano", conker, 260)
    insert_extra_midi(WOLF_VICTORY)
    insert_midi(NSMB, OS.TRUE, OS.TRUE, "Overworld Theme", nsmb, 219)
    insert_midi(JUNGLEJAPES, OS.TRUE, OS.TRUE, "Jungle Japes (Melee)", dkc, 155)
    insert_midi(FOREST_INTERLUDE, OS.TRUE, OS.TRUE, "Forest Interlude", dkc2, 113)
    insert_midi(TOADS_TURNPIKE, OS.TRUE, OS.TRUE, "Toad's Turnpike", mk64, 301)
    insert_midi(GB_MEDLEY, OS.TRUE, OS.TRUE, "Game Boy Medley", ssbr, 125)
    insert_midi(BUBBLY, OS.TRUE, OS.TRUE, "Bubbly Clouds", kirbydreamland, 40)
    insert_midi(ROADTOCERULEANCITY, OS.TRUE, OS.TRUE, "Road to Cerulean City", pokemonred, 244)
    insert_midi(LEVEL1_WARIO, OS.TRUE, OS.TRUE, "Stage 1 (Wario Land)", warioland, 271)
    insert_midi(MABE, OS.TRUE, OS.TRUE, "Mabe Village", awakening, 174)
    insert_midi(REST, OS.TRUE, OS.TRUE, "Rest Area", ssbr, 240)
    insert_midi(FE_MEDLEY, OS.TRUE, OS.TRUE, "Fire Emblem Medley", fire_emblem, 107)
    insert_midi(YOSHI_TALE, OS.TRUE, OS.TRUE, "Yoshi's Tale", yoshis_story, 335)
    insert_midi(FLOWER_GARDEN, OS.TRUE, OS.TRUE, "Flower Garden", yoshis_island, 110)
    insert_midi(WILDLANDS, OS.TRUE, OS.FALSE, "Wildlands", yoshis_island_ds, 328)
    insert_midi(VS_MARX, OS.FALSE, OS.TRUE, "Vs. Marx", kirbysuperstar, 321)
    insert_extra_midi(MARTH_VICTORY)
    insert_midi(SS_AQUA, OS.TRUE, OS.TRUE, "S.S. Aqua", pokemongold, 249)
    insert_midi(METAL_BATTLE, OS.TRUE, OS.TRUE, "Metal Battle", melee, 188)
    insert_midi(SLIDER, OS.TRUE, OS.TRUE, "Slider", sm64, 259)
    insert_midi(MULTIMAN2, OS.TRUE, OS.TRUE, "Multi-Man Melee 2", melee, 198)
    insert_midi(FIRE_EMBLEM, OS.TRUE, OS.TRUE, "Together We Ride (Melee)", fire_emblem, 302)
    insert_midi(KANTO_WILD_BATTLE, OS.TRUE, OS.TRUE, "Kanto Wild Pokemon Battle", pokemongold, 157)
    insert_midi(SMB2OVERWORLD, OS.TRUE, OS.TRUE, "Super Mario Bros. 2 Overworld", smb2, 283)
    insert_midi(PIRATELAND, OS.TRUE, OS.TRUE, "Pirate Land", marioparty2, 223)
    insert_midi(TROPICALISLAND, OS.TRUE, OS.TRUE, "Yoshi's Tropical Island", marioparty, 336)
    insert_midi(FLYINGBATTERY, OS.TRUE, OS.TRUE, "Flying Battery", sonic3, 111)
    insert_midi(OPEN_YOUR_HEART, OS.TRUE, OS.TRUE, "Open Your Heart", sonicadventure, 211)
    insert_midi(SONIC2_BOSS, OS.TRUE, OS.TRUE, "Sonic 2 Boss", sonic2, 264)
    insert_extra_midi(SONIC_VICTORY)
    insert_midi(CASINO_NIGHT, OS.TRUE, OS.TRUE, "Casino Night Zone", sonic2, 46)
    insert_midi(MONKEY_WATCH, OS.TRUE, OS.TRUE, "Monkey Watch", rhfever, 194)
    insert_midi(SONIC2_SPECIAL, OS.TRUE, OS.TRUE, "Sonic 2 Special Stage", sonic2, 265)
    insert_midi(SONICCD_SPECIAL, OS.TRUE, OS.TRUE, "Sonic CD Special Stage", soniccd, 266)
    insert_midi(GIANTWING, OS.TRUE, OS.TRUE, "Giant Wing (Fire Stone)", sonicfighters, 132)
    insert_midi(EMERALDHILL, OS.TRUE, OS.TRUE, "Emerald Hill Zone", sonic2, 92)
    insert_midi(LIVE_AND_LEARN, OS.TRUE, OS.TRUE, "Live and Learn", sonicadventure2, 171)
    insert_midi(STARDUST, OS.TRUE, OS.TRUE, "Stardust Speedway B Mix", soniccd, 275)
    insert_midi(GREEN_HILL_ZONE, OS.TRUE, OS.TRUE, "Green Hill Zone", sonic1, 143)
    insert_midi(CHEMICAL_PLANT, OS.TRUE, OS.TRUE, "Chemical Plant Zone", sonic2, 51)
    insert_midi(BABY_BOWSER, OS.TRUE, OS.TRUE, "Baby Bowser", yoshis_island, 11)
    insert_midi(WIDE_UNDERWATER, OS.TRUE, OS.TRUE, "Ocean Medley", marioparty, 207)
    insert_midi(METALLIC_MADNESS, OS.TRUE, OS.TRUE, "Metallic Madness", soniccd, 189)
    insert_midi(EVERYTHING, OS.TRUE, OS.TRUE, "Everything (Super Sonic)", sonicfighters, 96)
    insert_midi(ROCKSOLID, OS.TRUE, OS.TRUE, "Rock Solid", conker, 245)
    insert_midi(RAINBOWROAD, OS.TRUE, OS.TRUE, "Rainbow Road", mk64, 236)
    insert_midi(MK64_CREDITS, OS.TRUE, OS.TRUE, "Victory Lap", mk64, 318)
    insert_midi(RACEWAYS, OS.TRUE, OS.TRUE, "Raceways/Wario Stadium", mk64, 234)
    insert_midi(LINKS_AWAKENING_MEDLEY, OS.TRUE, OS.TRUE, "Link's Awakening Medley", awakening, 168)
    insert_midi(CORRIDORS_OF_TIME, OS.TRUE, OS.TRUE, "Corridors of Time", chrono, 62)
    insert_midi(KIRBY_64_BOSS, OS.TRUE, OS.TRUE, "Kirby 64 Boss", kirby64, 161)
    insert_midi(WALUIGI_PINBALL, OS.TRUE, OS.TRUE, "Waluigi Pinball/Wario Stadium", mkds, 323)
    insert_extra_midi(MARINA_VICTORY)
    insert_extra_midi(SHEIK_VICTORY)
    insert_extra_midi(DEDEDE_VICTORY)
    insert_midi(SMB2_MEDLEY, OS.TRUE, OS.TRUE, "Super Mario Bros. 2 Medley", smb2, 282)
    insert_midi(SMW_TITLECREDITS, OS.TRUE, OS.TRUE, "Super Mario World Title/Credits", smw, 285)
    insert_midi(DRAGONKING, OS.TRUE, OS.TRUE, "Dragon King", dragonking, 87)
    insert_midi(DEDEDE, OS.TRUE, OS.TRUE, "King Dedede's Theme", kirbydreamland, 159)
    insert_midi(DRACULAS_CASTLE, OS.TRUE, OS.TRUE, "Dracula's Castle", castlevania_sotn, 85)
    insert_midi(IRON_BLUE_INTENTION, OS.TRUE, OS.TRUE, "Iron-Blue Intention", castlevania_bloodlines, 152)
    insert_midi(DRACULAS_TEARS, OS.TRUE, OS.TRUE, "Dracula's Tears", castlevania_dos, 86)
    insert_midi(WARIOWARE, OS.TRUE, OS.TRUE, "WarioWare, Inc.", warioware, 325)
    insert_midi(BLOODY_TEARS, OS.TRUE, OS.TRUE, "Bloody Tears", castlevania_2, 27)
    insert_midi(FROZEN_HILLSIDE, OS.TRUE, OS.TRUE, "Frozen Hillside", kirbyair, 120)
    insert_midi(MK_REVENGE, OS.TRUE, OS.TRUE, "Meta Knight's Revenge", kirbysuperstar, 187)
    insert_midi(SOCCER_MENU, OS.TRUE, OS.TRUE, "Main Menu (ISS64)", isoccer, 178)
    insert_midi(TROUBLE_MAKER, OS.TRUE, OS.TRUE, "Trouble Maker", mischiefmakers, 308)
    insert_midi(MAIN_MENU2, OS.TRUE, OS.TRUE, "Menu 2 (Melee)", melee, 186)
    insert_midi(WL2_PERFECT, OS.TRUE, OS.TRUE, "Perfect!", warioland2, 221)
    insert_midi(CONTROL, OS.TRUE, OS.TRUE, "Control Center", goldeneye, 59)
    insert_midi(OEDO_EDO, OS.TRUE, OS.TRUE, "Edo Castle Medley", goemon, 90)
    insert_midi(BIS_THEGRANDFINALE, OS.TRUE, OS.TRUE, "In The Final", marioluigi_bis, 151)
    insert_extra_midi(GOEMON_VICTORY)
    insert_midi(MAJORA_MIDBOSS, OS.TRUE, OS.TRUE, "Middle Boss Battle", majora, 192)
    insert_midi(WATCH_THEME, OS.TRUE, OS.TRUE, "Q Watch (Pause Menu)", goldeneye, 232)
    insert_midi(KAI_HIGHWAY, OS.TRUE, OS.TRUE, "Kai Highway", mysticalninja, 156)
    insert_midi(SMW_ATHLETIC, OS.TRUE, OS.TRUE, "Athletic Theme", smw, 9)
    insert_midi(CRATERIA_MAIN, OS.TRUE, OS.TRUE, "Crateria Surface", supermetroid, 65)
    insert_midi(SNES_RAINBOW, OS.TRUE, OS.TRUE, "Rainbow Road (SNES)", smk, 237)
    insert_midi(BRAWL_OOT, OS.TRUE, OS.TRUE, "Ocarina of Time Medley", ocarina, 206)
    insert_midi(BOSS_E, OS.TRUE, OS.TRUE, "Boss E", starfox64, 35)
    insert_midi(MARINE_FORTRESS, OS.TRUE, OS.TRUE, "Marine Fortress", waverace, 182)
    insert_midi(TWILIGHT_CITY, OS.TRUE, OS.TRUE, "Twilight City", waverace, 309)
    insert_midi(SOUTHERNISLAND, OS.TRUE, OS.TRUE, "Southern Island/Main Theme", waverace, 267)
    insert_midi(QUEST64_BATTLE, OS.TRUE, OS.TRUE, "Battle Theme (Quest 64)", quest64, 18)
    insert_midi(MUSICAL_CASTLE, OS.TRUE, OS.TRUE, "Gorgeous Musical Castle", mysticalninja, 136)
    insert_midi(DECISIVE, OS.TRUE, OS.TRUE, "Decisive", ogrebattle64, 78)
    insert_midi(BATTLEFIELDV2, OS.TRUE, OS.TRUE, "Battlefield Ver. 2", brawl, 20)
    insert_midi(BOB, OS.TRUE, OS.TRUE, "Main Theme (Super Mario 64)", sm64, 179)
    insert_midi(AREA6, OS.TRUE, OS.TRUE, "Area 6", starfox64, 5)
    insert_midi(HILLTOPCHASE, OS.TRUE, OS.TRUE, "Hilltop Chase", kirbysuperstar, 148)
    insert_midi(STATUS, OS.TRUE, OS.TRUE, "Status", mariotennis, 277)
    insert_midi(FF4BOSS, OS.TRUE, OS.TRUE, "Boss Encounter", ff4, 36)
    insert_midi(GRIMREAPERSCAVERN, OS.TRUE, OS.TRUE, "Grim Reaper's Cavern", jackbros, 144)
    insert_midi(WORLD_OF_ENVY, OS.TRUE, OS.TRUE, "Shitto Kai / World of Envy", smtif, 256)
    insert_midi(SHANTAEMEDLEY, OS.TRUE, OS.TRUE, "Day/Night Traveling", shantae, 76)
    insert_midi(BURNINGTOWN, OS.TRUE, OS.TRUE, "Burning Town", shantae, 42)
    insert_midi(SHANTAEBOSS, OS.TRUE, OS.TRUE, "Boss Battle (Shantae)", shantae, 31)
    insert_midi(FORTRESS_BOSS, OS.TRUE, OS.TRUE, "Fortress Boss", smw, 114)
    insert_midi(HORROR_LAND, OS.TRUE, OS.TRUE, "Horror Land", marioparty2, 150)
    insert_midi(AC_TITLE, OS.TRUE, OS.TRUE, "Animal Crossing Theme", animal_crossing, 3)
    insert_midi(DARKWORLD, OS.TRUE, OS.TRUE, "Dark World", lttp, 73)
    insert_midi(FILESELECT_SM64, OS.TRUE, OS.TRUE, "File Select", sm64, 101)
    insert_midi(ITSATRAP_SM64, OS.TRUE, OS.TRUE, "File Select (Alternate)", sm64, 102)
    insert_extra_midi(BANJO_VICTORY)
    insert_midi(BLASTCORPS_MENU, OS.TRUE, OS.TRUE, "Menu (Blast Corps)", blastcorps, 185)
    insert_midi(FRAPPE_SNOWLAND, OS.TRUE, OS.TRUE, "Frappe Snowland/Sherbet Land", mk64, 117)
    insert_midi(SMRPG_BATTLE, OS.TRUE, OS.TRUE, "Fight Against Monsters", smrpg, 100)
    insert_midi(TRAVELING, OS.TRUE, OS.TRUE, "Traveling", goepachisuro, 306)
    insert_midi(CHILL, OS.TRUE, OS.TRUE, "Chill", drm, 52)
    insert_midi(ROLL, OS.TRUE, OS.TRUE, "Roll's Theme", megamanbc, 246)
    insert_midi(STICKERBRUSH_SYMPHONY, OS.TRUE, OS.TRUE, "Stickerbrush Symphony", dkc2, 278)
    insert_midi(DOOM1, OS.TRUE, OS.TRUE, "DOOM Medley", doom, 83)
    insert_midi(RUNNING_FROM_EVIL, OS.TRUE, OS.TRUE, "Running From Evil", doom2, 247)
    insert_midi(CONKER_THE_KING, OS.TRUE, OS.TRUE, "Conker the King (Reprise)", conker, 58)
    insert_midi(GRABBAG, OS.TRUE, OS.TRUE, "Grabbag", dukenukem3d, 139)
    insert_midi(WITHMILASDIVINEPROTECTION, OS.TRUE, OS.TRUE, "With Mila's Divine Protection", fe_gaiden, 331)
    insert_midi(DKCTITLE, OS.TRUE, OS.TRUE, "Opening (Donkey Kong)", dkc, 212)
    insert_midi(PLANTATION, OS.TRUE, OS.TRUE, "Plantation", cavestory, 225)
    insert_midi(BATTLE_GOLD_SILVER, OS.TRUE, OS.TRUE, "Gold & Silver Medley", pokemongold, 134)
    insert_midi(BIG_BOO, OS.TRUE, OS.TRUE, "Haunted House", sm64, 147)
    insert_extra_midi(DKING_VICTORY)
    insert_midi(7AM, OS.TRUE, OS.TRUE, "7AM", animal_crossing, 1)
    insert_midi(DKROPTIONS, OS.TRUE, OS.TRUE, "Options (Diddy Kong Racing)", dkr, 214)
    insert_midi(GALLERY, OS.TRUE, OS.TRUE, "Gallery", ssbr, 124)
    insert_midi(QUEQUE, OS.TRUE, OS.TRUE, "Que Que", drm64, 233)
    insert_midi(MK64MENU, OS.TRUE, OS.TRUE, "Setup and Kart Select", mk64, 253)
    insert_midi(GOLDENROD_CITY, OS.TRUE, OS.TRUE, "Goldenrod City", pokemongold, 135)
    insert_midi(CLOCKTOWN, OS.TRUE, OS.TRUE, "Clock Town", majora, 56)
    insert_midi(BUMPERCROPBUMP, OS.TRUE, OS.TRUE, "Bumper Crop Bump", kirby64, 41)
    insert_midi(VSRIDLEY, OS.TRUE, OS.TRUE, "Vs. Ridley", supermetroid, 322)
    insert_midi(GANONMEDLEY, OS.TRUE, OS.TRUE, "Ganon Battle Medley", zelda, 128)
    insert_midi(FUGUE, OS.TRUE, OS.TRUE, "Little Fugue", ssbr, 170)
    insert_midi(NUTTY_NOON, OS.TRUE, OS.TRUE, "Nutty Noon", kirbyreturn, 204)
    insert_midi(GHOSTGULPING, OS.TRUE, OS.TRUE, "Ghost Gulping", papermario, 131)
    insert_midi(SMB2BOSS, OS.TRUE, OS.TRUE, "Super Mario Bros. 2 Boss", smb2, 281)
    insert_midi(FZERO_CLIMBUP, OS.TRUE, OS.TRUE, "Climb Up! And Get the Last Chance!", fzero_x, 54)
    insert_midi(JFG_SELECT, OS.TRUE, OS.TRUE, "Character Select (Jet Force Gemini)", jetforce, 49)
    insert_midi(YOSHI_SKA, OS.TRUE, OS.TRUE, "Yoshi's Song", yoshis_story, 334)
    insert_midi(BOARD_SHOP, OS.TRUE, OS.TRUE, "Board Shop", sbk, 29)
    insert_midi(FLANDRES_THEME, OS.TRUE, OS.TRUE, "U.N. Owen Was Her?", 2hu6, 310)
    insert_midi(NIGHTMARE, OS.TRUE, OS.TRUE, "Final Boss (Nightmare's Battle)", kirbyadventure, 104)
    insert_midi(THE_ALOOF_SOLDIER, OS.TRUE, OS.TRUE, "The Aloof Soldier", gga, 291)
    insert_midi(WENDYS_HOUSE, OS.TRUE, OS.TRUE, "Wendy's House", sbk2, 327)
    insert_midi(DANGEROUS_FOE, OS.TRUE, OS.TRUE, "Battle Against a Dangerous Foe", earthboundb, 14)
    insert_midi(BIG_SNOWMAN, OS.TRUE, OS.TRUE, "Big Snowman", sbk, 25)
    insert_midi(PIKA_CUP, OS.TRUE, OS.TRUE, "Pika Cup Battles 1-3", stadium, 222)
    insert_midi(ASHLEYS_THEME, OS.TRUE, OS.TRUE, "Ashley's Theme", wwtouched, 7)
    insert_midi(SILVER_MOUNTAIN, OS.TRUE, OS.TRUE, "Silver Mountain", sbk, 257)
    insert_midi(WIZPIG, OS.TRUE, OS.TRUE, "Wizpig Challenge", dkr, 332)
    insert_midi(TALENTSTUDIO, OS.TRUE, OS.TRUE, "Talent Studio Medley", talentstudio, 288)
    insert_midi(BATTLE_C1, OS.TRUE, OS.TRUE, "Battle C1", smtiv, 16)
    insert_midi(PLAY_A_MINIGAME, OS.TRUE, OS.TRUE, "Play a Mini-Game!", marioparty, 226)
    insert_midi(CREDITS_BRAWL, OS.TRUE, OS.TRUE, "Credits (Brawl)", ssb, 66)
    insert_extra_midi(CRASH_VICTORY)
    insert_midi(PD_PAUSE, OS.TRUE, OS.TRUE, "Pause Menu (Perfect Dark)", pd, 220)
    insert_extra_midi(PEACH_VICTORY)
    insert_midi(PORKY, OS.TRUE, OS.TRUE, "Porky Means Business!", earthbound, 229)
    insert_midi(UNDERGROUND, OS.TRUE, OS.TRUE, "Underground Theme", smb, 312)
    insert_midi(UNDERGROUND_HURRY, OS.TRUE, OS.TRUE, "Underground Theme (Hurry Up!)", smb, 313)
    insert_midi(CRASH3, OS.TRUE, OS.TRUE, "Time Twister", crash3, 298)
    insert_midi(NSANITYBEACH, OS.TRUE, OS.TRUE, "N. Sanity Beach", crash, 201)
    insert_midi(CTR_MENU, OS.TRUE, OS.TRUE, "Crash Team Racing Menu", ctr, 64)
    insert_midi(DISCOVERYFALLS, OS.TRUE, OS.TRUE, "Discovery Falls", dinoplanet, 80)
    insert_midi(CRASHBONUS, OS.TRUE, OS.TRUE, "Bonus (CB:THA)", crash_xs, 30)
    insert_midi(DK_MEDLEY, OS.TRUE, OS.TRUE, "Donkey Kong Medley", dkarc, 82)
    insert_midi(SM64STAFF, OS.TRUE, OS.TRUE, "Staff Roll (Super Mario 64)", sm64, 270)
    insert_midi(BIG_BRIDGE, OS.TRUE, OS.TRUE, "Clash on the Big Bridge", ff5, 53)
    insert_midi(HOGWILD, OS.TRUE, OS.TRUE, "Hog Wild", crash, 149)
    insert_midi(MARATHON, OS.TRUE, OS.TRUE, "Marathon 2 Title Theme", marathon2, 181)
    insert_midi(FORGONE, OS.TRUE, OS.TRUE, "Foregone Destruction", ut99, 112)
    insert_midi(MORRIGAN, OS.TRUE, OS.TRUE, "Theme of Morrigan", mvc, 296)
    insert_midi(ELADARD, OS.TRUE, OS.TRUE, "Eladard", starfox2, 91)
    insert_midi(MADMAZEMAUL, OS.TRUE, OS.TRUE, "Mad Maze Maul", dk64, 176)
    insert_midi(ORANGSPRINT, OS.TRUE, OS.TRUE, "OrangSprint", dk64, 217)
    insert_midi(DRAKE_LAKE, OS.TRUE, OS.TRUE, "Drake Lake", waverace, 88)
    insert_midi(BUBBLEGUM_KK, OS.TRUE, OS.TRUE, "Bubblegum K.K.", acnewleaf, 39)
    insert_midi(FZEROX_MEDLEY, OS.TRUE, OS.TRUE, "F-Zero X Medley", fzero_x, 123)
    insert_midi(FREEZE, OS.TRUE, OS.TRUE, "Freeze!", papermario, 118)
    insert_midi(TITANIA, OS.TRUE, OS.TRUE, "Titania", starfox, 299)
    insert_midi(THEATER, OS.TRUE, OS.TRUE, "Theater", kirby64, 294)
    insert_midi(ENEMYCARD, OS.TRUE, OS.TRUE, "Enemy Card Index", kirby64, 93)
    insert_midi(SHEVAT, OS.TRUE, OS.TRUE, "Shevat, the Wind is Calling", xenogears, 255)
    insert_midi(CORTEX, OS.TRUE, OS.TRUE, "Dr. Neo Cortex", crash2, 84)
    insert_midi(WILY_FIELD, OS.TRUE, OS.TRUE, "Wily's Field", megamanscr, 329)
    insert_midi(SMS_BOSS, OS.TRUE, OS.TRUE, "Boss Battle (Sunshine)", sunshine, 32)
    insert_midi(COBALT, OS.TRUE, OS.TRUE, "Cobalt Coast", heypika, 57)
    insert_midi(VS_DSAMUS, OS.TRUE, OS.TRUE, "Vs. Dark Samus", metroidprime3, 319)
    insert_midi(STRIKE_THE_EARTH, OS.TRUE, OS.TRUE, "Strike the Earth!", shovelknight, 280)
    insert_midi(VAMPIREKILLER, OS.TRUE, OS.TRUE, "Vampire Killer", castlevania, 316)
    insert_midi(KOOPA_BROS, OS.TRUE, OS.TRUE, "Attack of the Koopa Bros.", papermario, 10)
    insert_midi(REDIAL, OS.TRUE, OS.TRUE, "Redial", bombermanhero, 239)
    insert_midi(AGAVE, OS.TRUE, OS.TRUE, "Agave", snp, 2)
    insert_midi(RAIDBLUE, OS.TRUE, OS.TRUE, "Raid Blue", snp, 235)
    insert_midi(RISKNECK, OS.TRUE, OS.TRUE, "Risk One's Neck", snp, 241)
    insert_midi(SHERBETLAND, OS.TRUE, OS.TRUE, "Sherbet Land", mariohoops, 254)
    insert_midi(DEATH_MOUNTAIN, OS.TRUE, OS.TRUE, "Dark Mountain Forest", lttp, 72)
    insert_midi(BATTLE_AMONG_FRIENDS, OS.TRUE, OS.TRUE, "Battle Among Friends", kirby64, 15)
    insert_midi(BUTTER_BUILDING, OS.TRUE, OS.TRUE, "Butter Building", kirbyadventure, 43)
    insert_midi(MURASAKI, OS.TRUE, OS.TRUE, "Murasaki Forest", mother3, 199)
    insert_midi(SKYWORLD, OS.TRUE, OS.TRUE, "Overworld (Kid Icarus)", kidicarus, 218)
    insert_midi(FE6_MEDLEY, OS.TRUE, OS.TRUE, "Binding Blade Medley", fe6, 26)
    insert_midi(SNOWGO, OS.TRUE, OS.TRUE, "Snow Go", crash2, 262)
    insert_midi(FUTUREFRENZY, OS.TRUE, OS.TRUE, "Future Frenzy", crash3, 121)
    insert_extra_midi(LANKY_VICTORY)
    insert_midi(SILVERSURFER, OS.TRUE, OS.TRUE, "Level 1 (Silver Surfer)", silversurfer, 167)
    insert_midi(OPUS_13, OS.TRUE, OS.TRUE, "Opus 13", castlevania_rob, 216)
    insert_midi(FOURSIDE, OS.TRUE, OS.TRUE, "Fourside", earthbound, 116)
    insert_midi(BALLOONFIGHT, OS.TRUE, OS.TRUE, "Balloon Fight", balloonfight, 13)
    insert_midi(LIPS_THEME, OS.TRUE, OS.TRUE, "Lip's Theme", paneldepon, 169)
    insert_midi(CRASHBASH_LOADING, OS.TRUE, OS.TRUE, "Crash Bash Loading Screen", crashbash, 63)
    insert_midi(TREASURE_TROVE_COVE, OS.TRUE, OS.TRUE, "Treasure Trove Cove", banjokazooie, 307)
    insert_midi(STAGESELBM64, OS.TRUE, OS.TRUE, "Stage Select (Bomberman 64)", bomberman, 272)
    insert_midi(OLDKINGCOAL, OS.TRUE, OS.TRUE, "Old King Coal", banjo2, 208)
    insert_midi(SONIC_R, OS.TRUE, OS.TRUE, "Options (Sonic R)", sonicr, 215)
    insert_midi(GREENGARDEN, OS.TRUE, OS.TRUE, "Green Garden", bomberman, 141)
    insert_midi(BLUE_RESORT, OS.TRUE, OS.TRUE, "Blue Resort", bomberman, 28)
    insert_midi(DREAMLANDBETA, OS.TRUE, OS.TRUE, "Gourmet Race (Alternate)", kirbysuperstar, 137)
    insert_midi(CRUEL, OS.TRUE, OS.TRUE, "Cruel Multi-Man Mode", brawl, 69)
    insert_midi(FIRE_FIELD, OS.TRUE, OS.TRUE, "Feel Our Pain (Fire Field)", fzero_gx, 97)
    insert_midi(DCMC, OS.TRUE, OS.TRUE, "DCMC Performance", mother3, 77)
    insert_midi(DANGEROUS_GUYS, OS.TRUE, OS.TRUE, "Dangerous Guys", mother3, 71)
	insert_midi(COPPER9, OS.TRUE, OS.TRUE, "Copper-9", md, 60)
	insert_midi(SMWBOSSREMIX, OS.TRUE, OS.TRUE, "Fortress Boss (JillyJane Remix)", smw, 115)
	insert_midi(METALCAP, OS.TRUE, OS.TRUE, "Metallic Mario", sm64, 190)
	insert_midi(XFILES, OS.TRUE, OS.TRUE, "Ninety Nine X-Files", gkeys, 203)
	insert_midi(PGTRAINING, OS.TRUE, OS.TRUE, "Training (Project Galleon)", pgog, 305)
	insert_midi(LUCIATHEME, OS.TRUE, OS.TRUE, "KURON IJO NO MONO (Lucia Theme)", pgog, 165)
	insert_midi(UZITHEME, OS.TRUE, OS.TRUE, "Chaotic Goober (Uzi's Theme)", md, 48)
	insert_midi(DKC2KROOL, OS.TRUE, OS.TRUE, "Crocodile Cacophony", dkc2, 68)
	insert_midi(PROJECTGALLEONCSS, OS.TRUE, OS.TRUE, "Character Select (Project Galleon)", pgog, 50)
    insert_extra_midi(OLD_FALCO_VICTORY)
    insert_midi(BIG_SHOT, OS.TRUE, OS.TRUE, "BIG SHOT", deltarune, 24)
    insert_midi(SPIDERMANMSH, OS.TRUE, OS.TRUE, "Spider-Man's Theme (Marvel Super Heroes)", msh, 268)
    insert_midi(SEXDICK1, OS.TRUE, OS.TRUE, "D. Fury", sexdick, 70)
    insert_midi(SSJ3SONGOKU, OS.TRUE, OS.TRUE, "Super Saiyan 3 Son Goku", dbzub22, 286)
	insert_midi(PNPSELECTBGM, OS.TRUE, OS.TRUE, "Select BGM", panicprk, 252)
    insert_extra_midi(CLOUD_VICTORY)
    insert_midi(CAPTAINAMERICA_THEME, OS.TRUE, OS.TRUE, "Theme of Captain America", mvc, 295)
	insert_midi(SMASHTON, OS.TRUE, OS.TRUE, "The Smashton", pgog, 293)
	insert_midi(PIRATEBEAT_CIRCUS, OS.TRUE, OS.TRUE, "Pirate Swag x 2000 Type Beat", prodbycircus, 224)
	insert_midi(JOKERTAOBAR, OS.TRUE, OS.TRUE, "Joker's Theme (Genesis)", batmangenesis, 154)
	insert_midi(GF64MIAMI, OS.TRUE, OS.TRUE, "Miami", gfinger64, 191)
	insert_midi(PLAYGROUND, OS.TRUE, OS.TRUE, "JcJenson's Playground", md, 153)
	insert_midi(TICTICTAC, OS.TRUE, OS.TRUE, "Tic Tic Tac", carrapicho, 297)
	insert_midi(GUILEX68000, OS.TRUE, OS.TRUE, "Guile's Theme", ssf2x68k, 145)
	insert_midi(RYUSSF2T, OS.TRUE, OS.TRUE, "Ryu's Theme", ssf2t, 248)
	insert_midi(KENSSF2T, OS.TRUE, OS.TRUE, "Ken's Theme", ssf2t, 158)
	insert_midi(CAMMYSSF2T, OS.TRUE, OS.TRUE, "Cammy's Theme", ssf2t, 45)
	insert_extra_midi(SF2_VICTORY)
    insert_midi(LOST, OS.TRUE, OS.TRUE, "Lost", dream, 172)

    pushvar origin, base

    // Extend Sound Test Music numbers so we can test in game easier
    origin  0x1883BA
    dh      midi_count
    origin  0x188246
    dh      midi_count - 1
    origin  0x1883C2
    dh      midi_count - 1
    origin  0x1883CE
    dh      midi_count - 1

    pullvar base, origin

    // @ Description
    // Replaces the allocated space for loading music files with a fixed-size block in expansion ram.
    scope replace_midi_block_: {
        OS.patch_start(0x20304, 0x8001F704)
        // replaces a part of the memory allocation routine which calls subroutine 0x8001E5F4 to allocate a fixed-size block equivalent to the largest midi
        // instead of allocating a block of memory, we'll just set the address to midi_memory_block, which is our own fixed-size block that we allocated in expansion ram
        li      v0, midi_memory_block       // v0 = midi_memory_block, originally address of allocated block
        fill 0x8001F724 - pc()              // nop the original memory allocation
        OS.patch_end()
    }

    // @ Description
    // Modifies the routine that maps Sound Test screen choices to BGM IDs
    scope augment_sound_test_music_: {
        OS.patch_start(0x188530, 0x80132160)
        j       augment_sound_test_music_
        nop
        OS.patch_end()

        lui     t0, 0x8013                        // original line 1
        lw      t0, 0x4348(t0)                    // original line 2
        slti    a0, t0, 0x2D                      // check if this is one we added (so >= 0x2D)
        bnez    a0, _normal                       // if (original bgm_id) then skip to _normal
        nop
        // If we're here, then the music ID is > 0x2C which means it's
        // one we added. So we need to set up a1 as the extended music
        // table address and offset:
        li      a1, extended_music_map_table      // a1 = address of extended table
        addiu   t0, t0, -0x002D                   // t0 = slot in extended table
        sll     t1, t0, 0x2                       // t1 = offset for bgm_id in extended table
        addu    a1, a1, t1                        // a1 = adress for bgm_id
        lhu     a1, 0x0002(a1)                    // a1 = bgm_id
        jal     0x80020AB4                        // call play MIDI routine
        nop
        j       0x80132180                        // return
        nop

        _normal:
        j       0x80132168                        // continue with original line 3
        nop
    }

    extended_music_map_table:
    dw     0xA                                    // for some reason originally left of music test
    dw     0xB                                    // for some reason originally left of music test
    define n(0x2F)
    while {n} < midi_count {
        dw      {n}
        evaluate n({n}+1)
    }

    print "========================================================================== \n"

    print "=============================== INSTRUMENTS ============================== \n"

    // Constants and variables related to instruments
    read32 INST_CTL_TABLE, "../roms/original.z64", 0x3D75C                       // CTL_TABLE is the base for a lot of sound related offsets
    constant INST_CTL_TABLE_PC(0x800472D0)                                       // CTL_TABLE is loaded in RAM here
    read32 INST_BANK_MAP_OFFSET, "../roms/original.z64", INST_CTL_TABLE + 0x0004 // INST_BANK_MAP_OFFSET is the offset from CTL to the INST_BANK_MAP
    constant INST_BANK_MAP(INST_CTL_TABLE + INST_BANK_MAP_OFFSET)                // INST_BANK_MAP holds offsets to each instrument
    read32 INST_SAMPLE_DATA, "../roms/original.z64", 0x3D760                     // INST_SAMPLE_DATA is the raw sample data
    variable instrument_count(0x2A)                                              // variable containing the total number of added instruments
    variable current_instrument_sample_count(0)                                  // variable containing number of samples in the current instrument

    // @ Description
    // Adds an instrument sample to be used by the instrument created in the next add_instrument() call
    // name                        - Name of .aifc file of sample (and .bin of loop predictors file if present)
    // attack_time                 - (word) attack time
    // decay_time                  - (word) decay time
    // release_time                - (word) release time
    // attack_volume               - (byte) attack volume
    // decay_volume                - (byte) decay volume
    // vel_min                     - (byte) vel min
    // vel_max                     - (byte) vel max
    // key_min                     - (byte) key min
    // key_max                     - (byte) key max
    // key_base                    - (byte) key base
    // detune                      - (byte) detune
    // sample_pan                  - (byte) sample pan
    // sample_volume               - (byte) sample volume
    // loop_enabled                - (bool) if OS.FALSE, then loop is not enabled, if OS.TRUE then loop is enabled
    // loop_start                  - (word) loop start
    // loop_end                    - (word) loop end
    // loop_count                  - (word) loop count
    // loop_predictors_file_exists - (bool) if OS.TRUE, then loop predictors are in {name}.bin, if OS.FALSE then fill with 0
    macro add_instrument_sample(name, attack_time, decay_time, release_time, attack_volume, decay_volume, vel_min, vel_max, key_min, key_max, key_base, detune, sample_pan, sample_volume, loop_enabled, loop_start, loop_end, loop_count, loop_predictors_file_exists) {
        if current_instrument_sample_count == 0 {
            // increment instrument count
            global variable instrument_count(instrument_count + 1)
        }

        // increment current_instrument_sample_count
        global variable current_instrument_sample_count(current_instrument_sample_count + 1)
        evaluate inst_num(instrument_count)
        evaluate sample_num(current_instrument_sample_count)
        global define SAMPLE_NAME_{inst_num}_{sample_num}({name})
        // Sample length is 2 words too long
        read32 SAMPLE_LENGTH_{inst_num}_{sample_num}, "../src/music/instruments/{SAMPLE_NAME_{inst_num}_{sample_num}}.aifc", 0xF4

        attack_delay_params_{inst_num}_{sample_num}:
        dw      {attack_time}
        dw      {decay_time}
        dw      {release_time}
        db      {attack_volume}
        db      {decay_volume}
        dh      0x0000 // ?

        vel_key_params_{inst_num}_{sample_num}:
        db      {vel_min}
        db      {vel_max}
        db      {key_min}
        db      {key_max}
        db      {key_base}
        db      {detune}
        dh      0x0000 // ?

        instrument_block_{inst_num}_{sample_num}:
        dw      attack_delay_params_{inst_num}_{sample_num} - INST_CTL_TABLE_PC
        dw      vel_key_params_{inst_num}_{sample_num} - INST_CTL_TABLE_PC
        dw      pc() + 0x8 - INST_CTL_TABLE_PC

        db      {sample_pan}
        db      {sample_volume}
        dh      0x0000 // ?

        // insert raw data
        pushvar origin, base
        origin  MIDI_BANK_END
        // I believe loop predictors will be at the end of the file, so I intentionally read a specific length
        constant SAMPLE_RAW_{inst_num}_{sample_num}_origin(origin())
        insert SAMPLE_RAW_{inst_num}_{sample_num}, "../src/music/instruments/{SAMPLE_NAME_{inst_num}_{sample_num}}.aifc", 0x100, SAMPLE_LENGTH_{inst_num}_{sample_num} - 0x0008
        global variable MIDI_BANK_END(origin())
        pullvar base, origin

        dw      SAMPLE_RAW_{inst_num}_{sample_num}_origin - INST_SAMPLE_DATA // pointer to raw data
        dw      SAMPLE_LENGTH_{inst_num}_{sample_num} - 0x0008               // length of raw data
        dw      0x0000 // ?

        if {loop_enabled} == OS.TRUE {
            dw  loop_params_{inst_num}_{sample_num} - INST_CTL_TABLE_PC
        } else {
            dw  0x0000
        }

        dw      predictors_{inst_num}_{sample_num} - INST_CTL_TABLE_PC

        dw      0x0000

        if {loop_enabled} == OS.TRUE {
            loop_params_{inst_num}_{sample_num}:
            dw  {loop_start}
            dw  {loop_end}
            dw  {loop_count}
            // loop predictors - I believe they should be at the end of the .aifc file, but haven't been able to produce a valid one yet
            // ...but n64 sound tool produces them
            if {loop_predictors_file_exists} == OS.TRUE {
            } else {
                fill 0x20, 0x0
            }
            dw  0x0000
        }

        predictors_{inst_num}_{sample_num}:
        dw     0x00000002
        dw     0x00000004
        insert SAMPLE_PREDICTORS_{inst_num}_{sample_num}, "../src/music/instruments/{SAMPLE_NAME_{inst_num}_{sample_num}}.aifc", 0x70, 0x80
    }

    // @ Description
    // Adds an instrument consisting of all the instrument samples added since the last add_instrument() call
    // name       - Name of the instrument (for display purposes only)
    // volume     - (byte) volume
    // pan        - (byte) pan
    // priority   - (byte) priority
    // bend_range - (hw) bend range
    // trem_type  - (byte) trem type
    // trem_rate  - (byte) trem rate
    // trem_depth - (byte) trem depth
    // trem_delay - (byte) trem delay
    // vib_type   - (byte) vib type
    // vib_rate   - (byte) vib rate
    // vib_depth  - (byte) vib depth
    // vib_delay  - (byte) vid delay
    macro add_instrument(name, volume, pan, priority, bend_range, trem_type, trem_rate, trem_depth, trem_delay, vib_type, vib_rate, vib_depth, vib_delay) {
        evaluate inst_num(instrument_count)
        global define INST_NAME_{inst_num}({name})
        print "Added {INST_NAME_{inst_num}}\nINST_ID: 0x"; OS.print_hex({inst_num}); print " (", {inst_num},")\nSamples:\n"

        instrument_parameters_{inst_num}:
        db      {volume}
        db      {pan}
        db      {priority}
        db      0x00                               // Gets set to 1 when processed
        db      {trem_type}
        db      {trem_rate}
        db      {trem_depth}
        db      {trem_delay}
        db      {vib_type}
        db      {vib_rate}
        db      {vib_depth}
        db      {vib_delay}
        dh      {bend_range}                       // 0x0064 for most (2 semitones?)
        dh      current_instrument_sample_count

        // pointers to instrument blocks
        define n(1)
        while {n} <= current_instrument_sample_count {
            dw       instrument_block_{inst_num}_{n} - INST_CTL_TABLE_PC
            print " - {SAMPLE_NAME_{inst_num}_{n}}\n"
            evaluate n({n}+1)
        }

        // This is necessary so the next instrument doesn't get jarbled
        OS.align(16)

        // reset current_instrument_sample_count
        global variable current_instrument_sample_count(0)
    }

    // @ Description
    // Moves the instrument bank map so it can be extended
    macro move_instrument_bank_map() {
        evaluate inst_num(instrument_count)

        // Move INST_BANK_MAP so it can be extended
        moved_inst_bank_map:
        global variable moved_inst_bank_map_origin(origin())
        OS.move_segment(INST_BANK_MAP, 0xB8)

        // extend using instrument_count
        define n(0x2B)
        evaluate n({n})
        while {n} <= {inst_num} {
            dw       instrument_parameters_{n} - INST_CTL_TABLE_PC
            evaluate n({n}+1)
        }

        pushvar origin, base

        // Update instrument count
        origin moved_inst_bank_map_origin
        dh      instrument_count + 1

        // Update INST_BANK_MAP_OFFSET to point to new location
        origin INST_CTL_TABLE + 0x0004
        dw      moved_inst_bank_map - INST_CTL_TABLE_PC

        pullvar base, origin
    }

    // This is necessary so the first instrument doesn't get jarbled
    OS.align(16)

     // Add instrument samples, then call add_instrument
    // TODO: Rock out with this organ!
    add_instrument_sample(talent-organ-0, 0x0, 0x0, 66 * 250, 0x7F, 0x7F, 0x0, 0x7F, 0,  74,  69, 0x0, 0x3F, 0x7E, OS.TRUE, 3185,  7404, 0xFFFFFFFF, OS.TRUE)
    add_instrument_sample(talent-organ-1, 0x0, 0x0, 66 * 250, 0x7F, 0x7F, 0x0, 0x7F, 75, 83,  81, 0x0, 0x3F, 0x7E, OS.TRUE, 9768, 17877, 0xFFFFFFFF, OS.TRUE)
	add_instrument_sample(talent-organ-2, 0x0, 0x0, 66 * 250, 0x7F, 0x7F, 0x0, 0x7F, 83, 98,  87, 0x0, 0x3F, 0x7E, OS.TRUE, 5172,  9173, 0xFFFFFFFF, OS.TRUE)
    add_instrument(Talent Studio Organ, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: Make some cool omninus sounding music with this, or cool backing vocals
    add_instrument_sample(JV-CHOIR-1, 0x0, 0x0, 66 * 1754, 0x7F, 0x7F, 0x0, 0x7F,  0,  42,  42, 0x0, 0x3F, 0x7E, OS.TRUE,  1492, 13190, 0xFFFFFFFF, OS.TRUE)
	add_instrument_sample(JV-CHOIR-2, 0x0, 0x0, 66 * 1754, 0x7F, 0x7F, 0x0, 0x7F,  43, 48,  48, 0x0, 0x3F, 0x7E, OS.TRUE,  5222, 20714, 0xFFFFFFFF, OS.TRUE)
	add_instrument_sample(JV-CHOIR-3, 0x0, 0x0, 66 * 1754, 0x7F, 0x7F, 0x0, 0x7F,  49, 55,  55, 0x0, 0x3F, 0x7E, OS.TRUE,  7676, 22074, 0xFFFFFFFF, OS.TRUE)
	add_instrument_sample(JV-CHOIR-4, 0x0, 0x0, 66 * 1754, 0x7F, 0x7F, 0x0, 0x7F,  54, 60,  60, 0x0, 0x3F, 0x7E, OS.TRUE,  1532, 16142, 0xFFFFFFFF, OS.TRUE)
	add_instrument_sample(JV-CHOIR-5, 0x0, 0x0, 66 * 1754, 0x7F, 0x7F, 0x0, 0x7F,  61, 66,  66, 0x0, 0x3F, 0x7E, OS.TRUE,  3630, 13188, 0xFFFFFFFF, OS.TRUE)
	add_instrument_sample(JV-CHOIR-6, 0x0, 0x0, 66 * 1754, 0x7F, 0x7F, 0x0, 0x7F,  67, 72,  72, 0x0, 0x3F, 0x7E, OS.TRUE,  6626, 17734, 0xFFFFFFFF, OS.TRUE)
	add_instrument_sample(JV-CHOIR-7, 0x0, 0x0, 66 * 1754, 0x7F, 0x7F, 0x0, 0x7F,  73, 101, 78, 0x0, 0x3F, 0x7E, OS.TRUE, 14575, 22795, 0xFFFFFFFF, OS.TRUE)
	add_instrument_sample(JV-CHOIR-8, 0x0, 0x0, 66 * 1754, 0x7F, 0x7F, 0x0, 0x7F,  84, 101, 90, 0x0, 0x3F, 0x7E, OS.TRUE, 11639, 21705, 0xFFFFFFFF, OS.TRUE)
    add_instrument(JFG Choir, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: Make some cool omninus sounding music with this, or cool backing vocals
    add_instrument_sample(SRJV-Chr-1, 0x0, 0x0, 66 * 1754, 0x7F, 0x7F, 0x00, 0x7F, 0,  44, 40, 0x0, 0x3F, 0x7E, OS.TRUE,  1747, 19376, 0xFFFFFFFF, OS.TRUE)
	add_instrument_sample(SRJV-Chr-2, 0x0, 0x0, 66 * 1754, 0x7F, 0x7F, 0x00, 0x7F, 45, 55, 52, 0x0, 0x3F, 0x7E, OS.TRUE,  3563, 19419, 0xFFFFFFFF, OS.TRUE)
	add_instrument_sample(SRJV-Chr-3, 0x0, 0x0, 66 * 1754, 0x7F, 0x7F, 0x00, 0x7F, 56, 67, 64, 0x0, 0x3F, 0x7E, OS.TRUE,  4679, 20227, 0xFFFFFFFF, OS.TRUE)
	add_instrument_sample(SRJV-Chr-4, 0x0, 0x0, 66 * 1754, 0x7F, 0x7F, 0x00, 0x7F, 68, 78, 76, 0x0, 0x3F, 0x7E, OS.TRUE,  4438, 19475, 0xFFFFFFFF, OS.TRUE)
	add_instrument_sample(SRJV-Chr-5, 0x0, 0x0, 66 * 1754, 0x7F, 0x7F, 0x00, 0x7F, 79, 100, 88, 0x0, 0x3F, 0x7E, OS.TRUE, 5967, 18811, 0xFFFFFFFF, OS.TRUE)
    add_instrument(SRJV Choir, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: Do some tasty licks with this one, though preferably with the other one
    add_instrument_sample(slap_bass_alt-0, 0x0, 0x0, 30000, 0x7F, 0x7F, 0x00, 0x7F,  0,  59, 48, 0x0, 0x3F, 0x7E, OS.TRUE, 14767, 17457, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(slap_bass_alt-1, 0x0, 0x0, 30000, 0x7F, 0x7F, 0x00, 0x7F, 60,  71, 60, 0x0, 0x3F, 0x7E, OS.TRUE, 7384,   8729, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(slap_bass_alt-2, 0x0, 0x0, 30000, 0x7F, 0x7F, 0x00, 0x7F, 72,  84, 72, 0x0, 0x3F, 0x7E, OS.TRUE, 3692,   4365, 0xFFFFFFFF, OS.FALSE)
    add_instrument(Slap Bass Stock Alt, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: for these samples, make sure values are correct (assuming we keep this instrument)
    add_instrument_sample(church_organ-1, 0x0, 0x0, 66 * 750, 0x7F, 0x7F, 0x0, 0x7F, 0,  71,  60, 0x0, 0x3F, 0x7E, OS.TRUE, 15017, 71449, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(church_organ-2, 0x0, 0x0, 66 * 750, 0x7F, 0x7F, 0x0, 0x7F, 72, 127, 72, 0x0, 0x3F, 0x7E, OS.TRUE, 5648,  29648, 0xFFFFFFFF, OS.FALSE)
    add_instrument(Church Organ, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: for these samples, make sure values are correct (assuming we keep this instrument)
    add_instrument_sample(steel_drum-0, 0x0, 0x004C4B40, 66 * 1879, 0x7F, 0x0, 0x0, 0x7F,  0,  67,  67, 0x0, 0x3F, 0x7E, OS.TRUE, 16372, 23940, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(steel_drum-1, 0x0, 0x004C4B40, 66 * 1879, 0x7F, 0x0, 0x0, 0x7F, 68, 127,  73, 0x0, 0x3F, 0x7E, OS.TRUE, 25832, 26234, 0xFFFFFFFF, OS.FALSE)
    add_instrument(Steel Drum, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: Make any song that uses this instrument super awesome
    add_instrument_sample(distortion_guitar-1, 0x0, 0x004C4B40, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 0,   42, 40, 0x0, 0x3F, 0x7E, OS.TRUE, 0x3383, 0x677A, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(distortion_guitar-2, 0x0, 0x004C4B40, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 43,  48, 46, 0x0, 0x3F, 0x7E, OS.TRUE, 0x3333, 0x6686, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(distortion_guitar-3, 0x0, 0x004C4B40, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 49,  53, 52, 0x0, 0x3F, 0x7E, OS.TRUE, 0x3477, 0x684C, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(distortion_guitar-4, 0x0, 0x004C4B40, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 54,  56, 55, 0x0, 0x3F, 0x7E, OS.TRUE,  25728,  43833, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(distortion_guitar-5, 0x0, 0x004C4B40, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 57,  58, 57, 0x0, 0x3F, 0x7E, OS.TRUE,  18720,  32281, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(distortion_guitar-6, 0x0, 0x004C4B40, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 59,  63, 62, 0x0, 0x3F, 0x7E, OS.TRUE,  21316,  38963, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(distortion_guitar-7, 0x0, 0x004C4B40, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 64,  65, 64, 0x0, 0x3F, 0x7E, OS.TRUE,  19328,  33677, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(distortion_guitar-8, 0x0, 0x004C4B40, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 66,  70, 69, 0x0, 0x3F, 0x7E, OS.TRUE,  16440,  34582, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(distortion_guitar-9, 0x0, 0x004C4B40, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 71,  72, 71, 0x0, 0x3F, 0x7E, OS.TRUE,  18103,  34658, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(distortion_guitar-10, 0x0, 0x004C4B40, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 73, 77, 76, 0x0, 0x3F, 0x7E, OS.TRUE,  23267,  38174, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(distortion_guitar-11, 0x0, 0x004C4B40, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 78, 82, 81, 0x0, 0x3F, 0x7E, OS.TRUE,  23150,  41842, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(distortion_guitar-12, 0x0, 0x004C4B40, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 83, 95, 83, 0x0, 0x3F, 0x7E, OS.TRUE,  20992,  34624, 0xFFFFFFFF, OS.FALSE)
    add_instrument(Distortion Guitar, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x80, 0xF1, 0x64, 0x01)

    // TODO: Saxi boi.
    add_instrument_sample(PrtTenor-1, 0x0, 0x001E8480, 66 * 300, 0x7F, 0x0, 0x00, 0x7F, 21, 51, 45, 0x0, 0x3F, 0x7E, OS.TRUE, 7588, 14861, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(PrtTenor-2, 0x0, 0x001E8480, 66 * 300, 0x7F, 0x0, 0x00, 0x7F, 52, 54, 54, 0x0, 0x3F, 0x7E, OS.TRUE, 6734, 13653, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(PrtTenor-3, 0x0, 0x001E8480, 66 * 300, 0x7F, 0x0, 0x00, 0x7F, 55, 57, 57, 0x0, 0x3F, 0x7E, OS.TRUE, 7430, 12812, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(PrtTenor-4, 0x0, 0x001E8480, 66 * 300, 0x7F, 0x0, 0x00, 0x7F, 58, 59, 59, 0x0, 0x3F, 0x7E, OS.TRUE, 6548, 13286, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(PrtTenor-5, 0x0, 0x001E8480, 66 * 300, 0x7F, 0x0, 0x00, 0x7F, 60, 64, 64, 0x0, 0x3F, 0x7E, OS.TRUE, 2972, 10641, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(PrtTenor-6, 0x0, 0x001E8480, 66 * 300, 0x7F, 0x0, 0x00, 0x7F, 65, 68, 68, 0x0, 0x3F, 0x7E, OS.TRUE, 6735, 14671, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(PrtTenor-7, 0x0, 0x001E8480, 66 * 300, 0x7F, 0x0, 0x00, 0x7F, 69, 74, 74, 0x0, 0x3F, 0x7E, OS.TRUE, 6306, 14315, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(PrtTenor-8, 0x0, 0x001E8480, 66 * 300, 0x7F, 0x0, 0x00, 0x7F, 75, 81, 78, 0x0, 0x3F, 0x7E, OS.TRUE, 5858, 11566, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(PrtTenor-9, 0x0, 0x001E8480, 66 * 300, 0x7F, 0x0, 0x00, 0x7F, 82, 95, 84, 0x0, 0x3F, 0x7E, OS.TRUE, 7844, 16161, 0xFFFFFFFF, OS.FALSE)
    add_instrument(Tenor Sax, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: Make any song that uses this instrument super awesome
    add_instrument_sample(marshall-1, 0x0, 0x002DC6C0, 66 * 350, 0x7F, 0x0, 0x0, 0x7F, 0,  46,  45, 0x0, 0x3F, 0x7E, OS.TRUE, 20416, 35501, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(marshall-2, 0x0, 0x002DC6C0, 66 * 350, 0x7F, 0x0, 0x0, 0x7F, 47, 49,  48, 0x0, 0x3F, 0x7E, OS.TRUE, 20480, 34605, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(marshall-3, 0x0, 0x002DC6C0, 66 * 350, 0x7F, 0x0, 0x0, 0x7F, 50, 55,  53, 0x0, 0x3F, 0x7E, OS.TRUE, 19925, 34199, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(marshall-4, 0x0, 0x002DC6C0, 66 * 350, 0x7F, 0x0, 0x0, 0x7F, 56, 59,  59, 0x0, 0x3F, 0x7E, OS.TRUE, 25216, 40912, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(marshall-5, 0x0, 0x002DC6C0, 66 * 350, 0x7F, 0x0, 0x0, 0x7F, 60, 64,  65, 0x0, 0x3F, 0x7E, OS.TRUE, 19528, 32096, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(marshall-6, 0x0, 0x002DC6C0, 66 * 350, 0x7F, 0x0, 0x0, 0x7F, 65, 70,  69, 0x0, 0x3F, 0x7E, OS.TRUE, 15618, 28461, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(marshall-7, 0x0, 0x002DC6C0, 66 * 350, 0x7F, 0x0, 0x0, 0x7F, 71, 74,  73, 0x0, 0x3F, 0x7E, OS.TRUE, 20832, 33381, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(marshall-8, 0x0, 0x002DC6C0, 66 * 350, 0x7F, 0x0, 0x0, 0x7F, 75, 78,  77, 0x0, 0x3F, 0x7E, OS.TRUE, 19482, 31844, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(marshall-9, 0x0, 0x002DC6C0, 66 * 350, 0x7F, 0x0, 0x0, 0x7F, 79, 100, 88, 0x0, 0x3F, 0x7E, OS.TRUE, 11279, 19201, 0xFFFFFFFF, OS.FALSE)
    add_instrument(Overdriven Guitar, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: for these samples, make sure values are correct (assuming we keep this instrument)
    add_instrument_sample(jv_piano-1, 0x0, 800000, 66 * 1879, 0x7F, 0x20, 0x0, 0x7F, 0,  44,  40,  0x0, 0x3F, 0x7E, OS.TRUE, 9059,  18754, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(jv_piano-2, 0x0, 800000, 66 * 1879, 0x7F, 0x20, 0x0, 0x7F, 45, 57,  52,  0x0, 0x3F, 0x7E, OS.TRUE, 6457,  13248, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(jv_piano-3, 0x0, 800000, 66 * 1879, 0x7F, 0x20, 0x0, 0x7F, 58, 70,  64,  0x0, 0x3F, 0x7E, OS.TRUE, 6140,  12336, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(jv_piano-4, 0x0, 800000, 66 * 1879, 0x7F, 0x20, 0x0, 0x7F, 71, 81,  76,  0x0, 0x3F, 0x7E, OS.TRUE, 6441,  12929, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(jv_piano-5, 0x0, 800000, 66 * 1879, 0x7F, 0x20, 0x0, 0x7F, 82, 93,  88,  0x0, 0x3F, 0x7E, OS.TRUE, 9255,  13257, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(jv_piano-6, 0x0, 800000, 66 * 1879, 0x7F, 0x20, 0x0, 0x7F, 94, 112, 100, 0x0, 0x3F, 0x7E, OS.TRUE, 11103, 13872, 0xFFFFFFFF, OS.FALSE)
    add_instrument(Piano, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: Slap dat Bass!
    add_instrument_sample(xwire-1, 0x0, 0x008C3A2D, 66 * 50, 0x7F, 0x7F, 0x0, 0x7F, 0,  37, 28, 0x0, 0x3F, 0x7E, OS.TRUE, 4294, 6628, 0xFFFFFFFF, OS.TRUE)
	add_instrument_sample(xwire-2, 0x0, 0x008C3A2D, 66 * 50, 0x7F, 0x7F, 0x0, 0x7F, 38, 48, 40, 0x0, 0x3F, 0x7E, OS.TRUE, 7225, 8778, 0xFFFFFFFF, OS.TRUE)
	add_instrument_sample(xwire-3, 0x0, 0x008C3A2D, 66 * 50, 0x7F, 0x7F, 0x0, 0x7F, 49, 58, 52, 0x0, 0x3F, 0x7E, OS.TRUE, 8581, 9940, 0xFFFFFFFF, OS.TRUE)
	add_instrument_sample(xwire-4, 0x0, 0x008C3A2D, 66 * 50, 0x7F, 0x7F, 0x0, 0x7F, 59, 76, 64, 0x0, 0x3F, 0x7E, OS.TRUE, 3329, 4009, 0xFFFFFFFF, OS.TRUE)
    add_instrument(JV X-Wire Bass, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: for these samples, make sure values are correct (assuming we keep this instrument)
    add_instrument_sample(orchestra_hit-0, 0x0, 0x0, 66 * 4000, 0x7F, 0x7F, 0x0, 0x7F, 0,  80,  72, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(orchestra_hit-1, 0x0, 0x0, 66 * 4000, 0x7F, 0x7F, 0x0, 0x7F, 81, 95,  84, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0xFFFFFFFF, OS.FALSE)
    add_instrument(Orchestral Hit, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: i thought it was a Synth Brass....
    add_instrument_sample(SynthBrass-1, 0x0, 0x0, 66 * 350, 0x7F, 0x7F, 0x0, 0x7F, 0,  67,  60, 0x0, 0x3F, 0x7E, OS.TRUE, 14231, 46504, 0xFFFFFFFF, OS.TRUE)
	add_instrument_sample(SynthBrass-2, 0x0, 0x0, 66 * 350, 0x7F, 0x7F, 0x0, 0x7F, 68, 79,  72, 0x0, 0x3F, 0x7E, OS.TRUE,  8817, 40082, 0xFFFFFFFF, OS.TRUE)
	add_instrument_sample(SynthBrass-3, 0x0, 0x0, 66 * 350, 0x7F, 0x7F, 0x0, 0x7F, 80, 90,  84, 0x0, 0x3F, 0x7E, OS.TRUE,  7307, 14852, 0xFFFFFFFF, OS.TRUE)
	add_instrument_sample(SynthBrass-4, 0x0, 0x0, 66 * 350, 0x7F, 0x7F, 0x0, 0x7F, 91, 108, 96, 0x0, 0x3F, 0x7E, OS.TRUE,  6018,  9509, 0xFFFFFFFF, OS.TRUE)
    add_instrument(Synth Brass JV-1080, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: for these samples, make sure values are correct (assuming we keep this instrument)
    add_instrument_sample(square_25-1, 0x0, 0x0, 66 * 30, 0x7F, 0x7F, 0x0, 0x7F,  0,  45,  36, 0x0, 0x3F, 0x7E, OS.TRUE,  8474, 38310, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(square_25-2, 0x0, 0x0, 66 * 30, 0x7F, 0x7F, 0x0, 0x7F, 46,  57,  48, 0x0, 0x3F, 0x7E, OS.TRUE, 10667, 28738, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(square_25-3, 0x0, 0x0, 66 * 30, 0x7F, 0x7F, 0x0, 0x7F, 58,  69,  60, 0x0, 0x3F, 0x7E, OS.TRUE,  3933, 22004, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(square_25-4, 0x0, 0x0, 66 * 30, 0x7F, 0x7F, 0x0, 0x7F, 70,  81,  72, 0x0, 0x3F, 0x7E, OS.TRUE,  5321, 26994, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(square_25-5, 0x0, 0x0, 66 * 30, 0x7F, 0x7F, 0x0, 0x7F, 82,  93,  84, 0x0, 0x3F, 0x7E, OS.TRUE, 10505, 23112, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(square_25-6, 0x0, 0x0, 66 * 30, 0x7F, 0x7F, 0x0, 0x7F, 94, 127,  96, 0x0, 0x3F, 0x7E, OS.TRUE,  5252, 11556, 0xFFFFFFFF, OS.FALSE)
    add_instrument(NES Square Wave 25P, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
    
	// TODO: Worms.
    add_instrument_sample(Nylon_Gtr-1, 0x0, 0x0010C8E0, 25000, 0x7F, 0x00, 0x00, 0x7F,  0,  44, 43, 0x0, 0x3F, 0x7E, OS.TRUE, 20598, 29742, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(Nylon_Gtr-2, 0x0, 0x0010C8E0, 25000, 0x7F, 0x00, 0x00, 0x7F, 45,  49, 48, 0x0, 0x3F, 0x7E, OS.TRUE, 26289, 32896, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(Nylon_Gtr-3, 0x0, 0x0010C8E0, 25000, 0x7F, 0x00, 0x00, 0x7F, 50,  54, 53, 0x0, 0x3F, 0x7E, OS.TRUE, 25917, 29216, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Nylon_Gtr-4, 0x0, 0x0010C8E0, 25000, 0x7F, 0x00, 0x00, 0x7F, 55,  60, 60, 0x0, 0x3F, 0x7E, OS.TRUE, 23406, 25974, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Nylon_Gtr-5, 0x0, 0x0010C8E0, 25000, 0x7F, 0x00, 0x00, 0x7F, 61,  65, 64, 0x0, 0x3F, 0x7E, OS.TRUE, 21895, 23741, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Nylon_Gtr-6, 0x0, 0x0010C8E0, 25000, 0x7F, 0x00, 0x00, 0x7F, 66,  69, 68, 0x0, 0x3F, 0x7E, OS.TRUE, 23424, 26352, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Nylon_Gtr-7, 0x0, 0x0010C8E0, 25000, 0x7F, 0x00, 0x00, 0x7F, 70,  79, 78, 0x0, 0x3F, 0x7E, OS.TRUE, 12064, 13707, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Nylon_Gtr-8, 0x0, 0x0010C8E0, 25000, 0x7F, 0x00, 0x00, 0x7F, 80,  95, 84, 0x0, 0x3F, 0x7E, OS.TRUE, 11072, 12081, 0xFFFFFFFF, OS.FALSE)
    add_instrument(Nylon Guitar, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: Make some synthy sounding tracks, JillyJane's Take!
    add_instrument_sample(OBStr-1, 0x0, 0x0, 66 * 50, 0x7F, 0x7F, 0x00, 0x7F, 0,  42,  40, 0x0, 0x3F, 0x7E, OS.TRUE, 5815, 29891, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(OBStr-2, 0x0, 0x0, 66 * 50, 0x7F, 0x7F, 0x00, 0x7F, 42, 56,  52, 0x0, 0x3F, 0x7E, OS.TRUE, 6088, 30759, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(OBStr-3, 0x0, 0x0, 66 * 50, 0x7F, 0x7F, 0x00, 0x7F, 57, 62,  60, 0x0, 0x3F, 0x7E, OS.TRUE, 5690, 30806, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(OBStr-4, 0x0, 0x0, 66 * 50, 0x7F, 0x7F, 0x00, 0x7F, 63, 70,  64, 0x0, 0x3F, 0x7E, OS.TRUE, 3354, 29653, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(OBStr-5, 0x0, 0x0, 66 * 50, 0x7F, 0x7F, 0x00, 0x7F, 71, 77,  76, 0x0, 0x3F, 0x7E, OS.TRUE, 5029, 29555, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(OBStr-6, 0x0, 0x0, 66 * 50, 0x7F, 0x7F, 0x00, 0x7F, 78, 83,  79, 0x0, 0x3F, 0x7E, OS.TRUE, 4357, 29883, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(OBStr-7, 0x0, 0x0, 66 * 50, 0x7F, 0x7F, 0x00, 0x7F, 84, 89,  84, 0x0, 0x3F, 0x7E, OS.TRUE, 4846, 28066, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(OBStr-8, 0x0, 0x0, 66 * 50, 0x7F, 0x7F, 0x00, 0x7F, 90, 103, 91, 0x0, 0x3F, 0x7E, OS.TRUE, 5836, 29871, 0xFFFFFFFF, OS.FALSE)
	add_instrument(OB Sawtooth, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: For big moments with guitars
    add_instrument_sample(wow_scrape16, 0x0, 0x0, 66 * 300, 0x7F, 0x7F, 0x00, 0x7F, 0, 71, 60, 0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0xFFFFFFFF, OS.FALSE)
    add_instrument(Wow Scrape, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: i forgor loop predictors.
    add_instrument_sample(SRX_FG-1, 0x0, 0x002191C0,  32700, 0x7F, 0x50, 0x0, 0x7F, 0,  41, 41, 0x0, 0x3F, 0x7E, OS.TRUE, 38666, 44164, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(SRX_FG-2, 0x0, 0x002191C0,  32700, 0x7F, 0x50, 0x0, 0x7F, 42, 46, 46, 0x0, 0x3F, 0x7E, OS.TRUE, 31562, 36779, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(SRX_FG-3, 0x0, 0x002191C0,  32700, 0x7F, 0x50, 0x0, 0x7F, 47, 50, 50, 0x0, 0x3F, 0x7E, OS.TRUE, 26009, 31022, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(SRX_FG-4, 0x0, 0x002191C0,  32700, 0x7F, 0x50, 0x0, 0x7F, 51, 54, 54, 0x0, 0x3F, 0x7E, OS.TRUE, 26599, 31788, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(SRX_FG-5, 0x0, 0x002191C0,  32700, 0x7F, 0x50, 0x0, 0x7F, 55, 57, 57, 0x0, 0x3F, 0x7E, OS.TRUE, 28875, 33530, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(SRX_FG-6, 0x0, 0x002191C0,  32700, 0x7F, 0x50, 0x0, 0x7F, 58, 60, 60, 0x0, 0x3F, 0x7E, OS.TRUE, 30279, 33826, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(SRX_FG-7, 0x0, 0x002191C0,  32700, 0x7F, 0x50, 0x0, 0x7F, 61, 64, 64, 0x0, 0x3F, 0x7E, OS.TRUE, 28328, 34445, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(SRX_FG-8, 0x0, 0x002191C0,  32700, 0x7F, 0x50, 0x0, 0x7F, 65, 70, 70, 0x0, 0x3F, 0x7E, OS.TRUE, 25403, 30827, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(SRX_FG-9, 0x0, 0x002191C0,  32700, 0x7F, 0x50, 0x0, 0x7F, 71, 73, 73, 0x0, 0x3F, 0x7E, OS.TRUE, 29814, 36049, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(SRX_FG-10, 0x0, 0x002191C0, 32700, 0x7F, 0x50, 0x0, 0x7F, 74, 92, 81, 0x0, 0x3F, 0x7E, OS.TRUE, 16718, 22501, 0xFFFFFFFF, OS.FALSE)
    add_instrument(FlamencoGuitar, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: For invoking lots of emotion
    add_instrument_sample(pizzicato_ffxi-1, 0x0, 0x004C4B40, 66 * 1879, 0x7F, 0x0, 0x0, 0x7F,  0,  83,  72, 0x0, 0x3F, 0x7E, OS.TRUE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(pizzicato_ffxi-2, 0x0, 0x004C4B40, 66 * 1879, 0x7F, 0x0, 0x0, 0x7F, 84,  95,  84, 0x0, 0x3F, 0x7E, OS.TRUE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(pizzicato_ffxi-3, 0x0, 0x004C4B40, 66 * 1879, 0x7F, 0x0, 0x0, 0x7F, 96, 127,  96, 0x0, 0x3F, 0x7E, OS.TRUE, 0, 0, 0, OS.FALSE)
    add_instrument(Pizzicato FFXI, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: Rename to the "Jamie Jamieson"
    add_instrument_sample(jamisen-1, 0x0, 0x002625A0, 66 * 1879, 0x7F, 0x0, 0x0, 0x7F,  0,  73,  67, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(jamisen-2, 0x0, 0x00249F00, 66 * 1879, 0x7F, 0x0, 0x0, 0x7F, 74,  88,  79, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(jamisen-3, 0x0, 0x001B7740, 66 * 1879, 0x7F, 0x0, 0x0, 0x7F, 89,  103,  91, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument(Shamisen, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: Cry about the fact this takes up 1.1MB of ROM space
    add_instrument_sample(herewego,  0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  0,  0,  12, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0000, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  1,  1,  13, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0001, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  2,  2,  14, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0002, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  3,  3,  15, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0003, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  4,  4,  16, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0004, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  5,  5,  17, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0005, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  6,  6,  18, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0006, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  7,  7,  19, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0007, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  8,  8,  20, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0008, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  9,  9,  21, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0009, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 10, 10,  22, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0010, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 11, 11,  23, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0011, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 12, 12,  24, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0012, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 13, 13,  25, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0013, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 14, 14,  26, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0014, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 15, 15,  27, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0015, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 16, 16,  28, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0016, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 17, 17,  29, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0017, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 18, 18,  30, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0018, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 19, 19,  31, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0019, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 20, 20,  32, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0020, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 21, 21,  33, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0021, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 22, 22,  34, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0022, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 23, 23,  35, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0023, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 24, 24,  36, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0024, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 25, 25,  37, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0025, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 26, 26,  38, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0026, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 27, 27,  39, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0027, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 28, 28,  40, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0028, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 29, 29,  41, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0029, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 30, 30,  42, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0030, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 31, 31,  43, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0031, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 32, 32,  44, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0032, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 33, 33,  45, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0033, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 34, 34,  46, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0034, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 35, 35,  47, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0035, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 36, 36,  48, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0036, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 37, 37,  49, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0037, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 38, 38,  50, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0038, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 39, 39,  51, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0039, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 40, 40,  52, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0040, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 41, 41,  53, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0041, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 42, 42,  54, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0042, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 43, 43,  55, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0043, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 44, 44,  56, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0044, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 45, 45,  57, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0045, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 46, 46,  58, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0046, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 47, 47,  59, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0047, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 48, 48,  60, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0048, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 49, 49,  61, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0049, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 50, 50,  62, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0050, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 51, 51,  63, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0051, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 52, 52,  64, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0052, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 53, 53,  65, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0053, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 54, 54,  66, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0054, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 55, 55,  67, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0055, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 56, 56,  68, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0056, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 57, 57,  69, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0057, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 58, 58,  70, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0058, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 59, 59,  71, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0059, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 60, 60,  72, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0060, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 61, 61,  73, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0061, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 62, 62,  74, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0062, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 63, 63,  75, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0063, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 64, 64,  76, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0064, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 65, 65,  77, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0065, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 66, 66,  78, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0067, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 67, 67,  79, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0068, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 68, 68,  80, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0069, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 69, 69,  81, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0070, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 70, 70,  82, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0071, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 71, 71,  83, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0072, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 72, 72,  84, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0073, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 73, 73,  85, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0074, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 74, 74,  86, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0075, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 75, 75,  87, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0076, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 76, 76,  88, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0077, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 77, 77,  89, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0078, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 78, 78,  90, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0079, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 79, 79,  91, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0080, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 80, 80,  92, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0081, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 81, 81,  93, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0082, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 82, 82,  94, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0083, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 83, 83,  95, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(lyric0084, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 84, 84,  96, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(sfx1,      0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 85, 85,  97, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(sfx2,      0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 86, 86,  98, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(sfx3,      0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 87, 87,  99, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(sfx4,      0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 88, 88, 100, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument(DK_Rap, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)


    // TODO: be ecstatic its only 357k
    add_instrument_sample(roll-1, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  24,  24,  36, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(roll-2, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  25,  25,  37, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(roll-3, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  26,  26,  38, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(roll-4, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  27,  27,  39, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(roll-5, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  28,  28,  40, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(roll-6, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  29,  29,  41, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(roll-7, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  30,  30,  42, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(roll-8, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  31,  31,  43, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(roll-9, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  32,  32,  44, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(roll-10, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  33,  33,  45, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(roll-11, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  34,  34,  46, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(roll-12, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  35,  35,  47, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(roll-13, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  36,  36,  48, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(roll-14, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  37,  37,  49, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(roll-15, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  38,  38,  50, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(roll-16, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  39,  39,  51, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(roll-17, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  40,  40,  52, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(roll-18, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  41,  41,  53, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(roll-19, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  42,  42,  54, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(roll-20, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  43,  43,  55, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(roll-21, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  44,  44,  56, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(roll-22, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  45,  45,  57, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(roll-23, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  46,  46,  58, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(roll-24, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  47,  47,  59, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(roll-25, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  48,  48,  60, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(roll-26, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  49,  49,  61, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(roll-27, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  50,  50,  62, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(roll-28, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  51,  51,  63, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument(Roll, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: Eat Apples
    add_instrument_sample(yoshi1, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  0,  28,  36, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(yoshi2, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  29, 40,  48, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(yoshi3, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  41, 72,  60, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument(Yoshis, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: Marimba on these fools.
    add_instrument_sample(SY77Marimba-1, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,   0, 54,  52, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(SY77Marimba-2, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  55, 62,  60, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(SY77Marimba-3, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  63, 66,  64, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(SY77Marimba-4, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  67, 73,  71, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(SY77Marimba-5, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  74, 85,  83, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(SY77Marimba-6, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  86, 108, 96, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument(SY-77 Marimba, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: Use these samples for a single song and never touch them again
    add_instrument_sample(DFChant1, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 60,  60,  72, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(DFChant2, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 61,  61,  73, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(DFChant3, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 62,  62,  74, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(DFChant4, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 63,  75,  75, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument(DF_Chants, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

	// TODO: Oook ookie ook hoo hoo haa hoa and hoo ookie ook hoo
    add_instrument_sample(Monkey01, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 44,  44,  62, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(Monkey02, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 45,  45,  63, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(Monkey03, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 46,  50,  64, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(Monkey04, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 56,  56,  80, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(Monkey05, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 57,  57,  81, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(Monkey06, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 58,  58,  77, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(Monkey07, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 59,  59,  71, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(Monkey08, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 60,  60,  72, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(Monkey09, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 61,  61,  72, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(Monkey10, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 62,  80,  74, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument(Monkey, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: send John 1 million dollars
    add_instrument_sample(sine-1, 14000, 0x0, 7530, 0x7F, 0x7F, 0x0, 0x7F,  0, 95, 84, 0x0, 0x3F, 0x7E, OS.TRUE, 5199, 10000, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(sine-2, 14000, 0x0, 7530, 0x7F, 0x7F, 0x0, 0x7F,  96, 107, 96, 0x0, 0x3F, 0x7E, OS.TRUE, 4725, 11544, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(sine-3, 14000, 0x0, 7530, 0x7F, 0x7F, 0x0, 0x7F,  108, 120, 108, 0x0, 0x3F, 0x7E, OS.TRUE, 4511, 9090, 0xFFFFFFFF, OS.FALSE)
    add_instrument(Sine Wave, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: add a lil bit of blbldlldldldding to some bomberman music or something idk
    add_instrument_sample(harp-1, 0x0, 700000, 66 * 1879, 0x7F, 0x0, 0x0, 0x7F,  0,  83,  74, 0x0, 0x3F, 0x7E, OS.TRUE, 10276, 15524, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(harp-2, 0x0, 700000, 66 * 1879, 0x7F, 0x0, 0x0, 0x7F, 84,  95,  86, 0x0, 0x3F, 0x7E, OS.TRUE, 5209, 9803, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(harp-3, 0x0, 700000, 66 * 1879, 0x7F, 0x0, 0x0, 0x7F, 96, 127,  98, 0x0, 0x3F, 0x7E, OS.TRUE, 5100, 10312, 0xFFFFFFFF, OS.FALSE)
    add_instrument(Harp, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: Instrument Borrowed from GoldenEye 007
    add_instrument_sample(GE007-String-1, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  0,  59,  49, 0x0, 0x3F, 0x7E, OS.TRUE, 6494, 21739, 0xFFFFFFFF, OS.TRUE)
    add_instrument_sample(GE007-String-2, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  60, 73,  71, 0x0, 0x3F, 0x7E, OS.TRUE, 9469, 22002, 0xFFFFFFFF, OS.TRUE)
    add_instrument_sample(GE007-String-3, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F,  74, 91,  80, 0x0, 0x3F, 0x7E, OS.TRUE, 29, 14974, 0xFFFFFFFF, OS.TRUE)
    add_instrument(GoldenEye_Strings, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

	// TODO: RESPECT MAH AUTHORITAH 
	add_instrument_sample(sr_banjo-1, 0x0, 0x0, 66 * 350, 0x7F, 0x7F, 0x0, 0x7F,  0,  71,  67, 0x0, 0x3F, 0x7E, OS.TRUE, 10725, 12275, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(sr_banjo-2, 0x0, 0x0, 66 * 350, 0x7F, 0x7F, 0x0, 0x7F,  72, 76,  74, 0x0, 0x3F, 0x7E, OS.TRUE, 9472, 11268, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(sr_banjo-3, 0x0, 0x0, 66 * 350, 0x7F, 0x7F, 0x0, 0x7F,  77, 90,  79, 0x0, 0x3F, 0x7E, OS.TRUE, 8226, 10224, 0xFFFFFFFF, OS.FALSE)
	add_instrument(SR-JV Banjo, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	// TODO: i'm eepy
	add_instrument_sample(JV-1080_Brass_E4, 0x0, 0x0, 66 * 200, 0x7F, 0x7F, 0x0, 0x7F,  0,  67,  64, 0x0, 0x3F, 0x7E, OS.TRUE, 11839, 18335, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(JV-1080_Brass_B4, 0x0, 0x0, 66 * 200, 0x7F, 0x7F, 0x0, 0x7F,  68, 73,  71, 0x0, 0x3F, 0x7E, OS.TRUE, 9543,  14533, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(JV-1080_Brass_E5, 0x0, 0x0, 66 * 200, 0x7F, 0x7F, 0x0, 0x7F,  74, 82,  76, 0x0, 0x3F, 0x7E, OS.TRUE, 8694,  14978, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(JV-1080_Brass_C6, 0x0, 0x0, 66 * 200, 0x7F, 0x7F, 0x0, 0x7F,  83, 96,  84, 0x0, 0x3F, 0x7E, OS.TRUE, 9633,  16559, 0xFFFFFFFF, OS.FALSE)
	add_instrument(JV-1080 Brass, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	// TODO: Funney Rolly Night
	add_instrument_sample(RockLead1HIGH, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  0,  90,  79, 0x0, 0x3F, 0x7E, OS.TRUE, 10984, 12290, 0xFFFFFFFF, OS.FALSE)
	add_instrument(CPS2_Guitar, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	// TODO: For Techno Style Music :P
    add_instrument_sample(TR-kikclub, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  32, 32,  32, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(TR-kik, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  32, 36,  36, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(Zap, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F, 37, 37,  37, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(T2, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  38, 38,  38, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(TR-clap, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  39, 39,  39, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(TR-Hi1, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  42, 42,  42, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(TR-Hi2, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  44, 44,  44, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(TR-Hi3, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  46, 46,  46, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(T7, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  47, 50,  47, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(T8, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  51, 51,  51, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(T9, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  54, 54,  54, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(darren2, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  56, 56,  56, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(darren1, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  58, 58,  58, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument(TechnoDrums, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	// TODO: Don't Tell Brob2nd About this.
    add_instrument_sample(Tine_Piano-C4, 0x0, 0x002DC6C0, 66 * 500, 0x7F, 0x20, 0x0, 0x7F, 0,  70,  60, 0x0, 0x3F, 0x7E, OS.TRUE, 32934, 54044, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Tine_Piano-C5, 0x0, 0x002DC6C0, 66 * 500, 0x7F, 0x20, 0x0, 0x7F, 71,  82,  72, 0x0, 0x3F, 0x7E, OS.TRUE, 32306, 54179, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Tine_Piano-C6, 0x0, 0x002DC6C0, 66 * 500, 0x7F, 0x20, 0x0, 0x7F, 83,  95,  84, 0x0, 0x3F, 0x7E, OS.TRUE, 16153, 27090, 0xFFFFFFFF, OS.FALSE)
    add_instrument(TinePiano, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	// TODO: Take your pick buddy!
    add_instrument_sample(Fender-1, 0x0, 0x008C3A2D, 66 * 50, 0x7F, 0x7F, 0x0, 0x7F, 0,  39, 35, 0x0, 0x3F, 0x7E, OS.TRUE,  925, 3508, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Fender-2, 0x0, 0x008C3A2D, 66 * 50, 0x7F, 0x7F, 0x0, 0x7F, 40, 59, 47, 0x0, 0x3F, 0x7E, OS.TRUE, 775, 3100, 0xFFFFFFFF, OS.FALSE)
    add_instrument(Picked_Bass, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	// TODO: Coca Cola Espuma!!!
	add_instrument_sample(infinite_one, 0x0, 0x0, 66 * 1000, 0x7F, 0x7F, 0x0, 0x7F,  0, 107,  96, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument(GE_InfinteOne, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	//TODO: i'm gonna give you a SYNTHETIC SLAP!
	add_instrument_sample(marcato-1, 0x0, 0x0, 66 * 1000, 0x7F, 0x7F, 0x0, 0x7F,  0, 40, 36, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(marcato-2, 0x0, 0x0, 66 * 1000, 0x7F, 0x7F, 0x0, 0x7F, 41, 45, 42, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(marcato-3, 0x0, 0x0, 66 * 1000, 0x7F, 0x7F, 0x0, 0x7F, 46, 52, 48, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(marcato-4, 0x0, 0x0, 66 * 1000, 0x7F, 0x7F, 0x0, 0x7F, 53, 55, 56, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(marcato-5, 0x0, 0x0, 66 * 1000, 0x7F, 0x7F, 0x0, 0x7F, 56, 67, 60, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(marcato-6, 0x0, 0x0, 66 * 1000, 0x7F, 0x7F, 0x0, 0x7F, 68, 75, 72, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(marcato-7, 0x0, 0x0, 66 * 1000, 0x7F, 0x7F, 0x0, 0x7F, 76, 96, 84, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument(SynthSlap, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	// TODO: Thank You Graeme Norgate to make the most complicated sample
	add_instrument_sample(GE007_French-Hrn, 0x0, 0x0, 66 * 800, 0x7F, 0x7F, 0x0, 0x7F,  0,  78,  73, 0x0, 0x3F, 0x7E, OS.TRUE, 4169, 13537, 0xFFFFFFFF, OS.FALSE)
	add_instrument(GoldenEye_FrenchHorn, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	// TODO: Thank You Graeme Norgate to make the most complicated sample
	add_instrument_sample(GE007_Trumpet, 0x0, 0x0, 66 * 450, 0x7F, 0x7F, 0x0, 0x7F,  0,  91,  86, 0x0, 0x3F, 0x7E, OS.TRUE, 4059, 6698, 0xFFFFFFFF, OS.FALSE)
	add_instrument(GoldenEye_Trumpet, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	//TODO: Uzi's Best Friend
	add_instrument_sample(PDead-1, 0x0, 0x008C3A2D, 66 * 250, 0x7F, 0x7F, 0x0, 0x7F,  0,  40, 40, 0x0, 0x3F, 0x7E, OS.TRUE, 15732, 35216, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(PDead-2, 0x0, 0x008C3A2D, 66 * 250, 0x7F, 0x7F, 0x0, 0x7F,  41, 42, 42, 0x0, 0x3F, 0x7E, OS.TRUE, 15338, 35175, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(PDead-3, 0x0, 0x008C3A2D, 66 * 250, 0x7F, 0x7F, 0x0, 0x7F,  43, 44, 43, 0x0, 0x3F, 0x7E, OS.TRUE, 13205, 28749, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(PDead-4, 0x0, 0x008C3A2D, 66 * 250, 0x7F, 0x7F, 0x0, 0x7F,  45, 48, 46, 0x0, 0x3F, 0x7E, OS.TRUE, 14494, 32446, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(PDead-5, 0x0, 0x008C3A2D, 66 * 250, 0x7F, 0x7F, 0x0, 0x7F,  49, 50, 50, 0x0, 0x3F, 0x7E, OS.TRUE, 14583, 29536, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(PDead-6, 0x0, 0x008C3A2D, 66 * 250, 0x7F, 0x7F, 0x0, 0x7F,  51, 53, 52, 0x0, 0x3F, 0x7E, OS.TRUE, 17741, 32787, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(PDead-7, 0x0, 0x008C3A2D, 66 * 250, 0x7F, 0x7F, 0x0, 0x7F,  54, 57, 55, 0x0, 0x3F, 0x7E, OS.TRUE, 17927, 34087, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(PDead-8, 0x0, 0x008C3A2D, 66 * 250, 0x7F, 0x7F, 0x0, 0x7F,  58, 72, 60, 0x0, 0x3F, 0x7E, OS.TRUE, 17778, 31951, 0xFFFFFFFF, OS.FALSE)
	add_instrument(Power Guitar FLEX, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	//TODO: Uzi's Best Friend Part 2
    add_instrument_sample(PMute-1, 0x0, 0x0, 66 * 250, 0x7F, 0x7F, 0x0, 0x7F,  0,  40, 40, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(PMute-2, 0x0, 0x0, 66 * 250, 0x7F, 0x7F, 0x0, 0x7F,  41, 42, 42, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(PMute-3, 0x0, 0x0, 66 * 250, 0x7F, 0x7F, 0x0, 0x7F,  43, 44, 43, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(PMute-4, 0x0, 0x0, 66 * 250, 0x7F, 0x7F, 0x0, 0x7F,  45, 48, 46, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(PMute-5, 0x0, 0x0, 66 * 250, 0x7F, 0x7F, 0x0, 0x7F,  49, 50, 50, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(PMute-6, 0x0, 0x0, 66 * 250, 0x7F, 0x7F, 0x0, 0x7F,  51, 53, 52, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(PMute-7, 0x0, 0x0, 66 * 250, 0x7F, 0x7F, 0x0, 0x7F,  54, 57, 55, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(PMute-8, 0x0, 0x0, 66 * 250, 0x7F, 0x7F, 0x0, 0x7F,  58, 72, 60, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument(Thad_Part2, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	//TODO: Techno Companion Synthetizer
	add_instrument_sample(PowerLead-1, 0x0, 0x0, 66 * 90, 0x7F, 0x7F, 0x0, 0x7F, 0,  32,  31, 0x0, 0x3F, 0x7E, OS.TRUE, 12910, 32694, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(PowerLead-2, 0x0, 0x0, 66 * 90, 0x7F, 0x7F, 0x0, 0x7F, 33, 40,  36, 0x0, 0x3F, 0x7E, OS.TRUE, 16930, 38638, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(PowerLead-3, 0x0, 0x0, 66 * 90, 0x7F, 0x7F, 0x0, 0x7F, 41, 45,  43, 0x0, 0x3F, 0x7E, OS.TRUE, 15418, 39010, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(PowerLead-4, 0x0, 0x0, 66 * 90, 0x7F, 0x7F, 0x0, 0x7F, 46, 52,  48, 0x0, 0x3F, 0x7E, OS.TRUE, 14336, 33280, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(PowerLead-5, 0x0, 0x0, 66 * 90, 0x7F, 0x7F, 0x0, 0x7F, 53, 66,  55, 0x0, 0x3F, 0x7E, OS.TRUE, 17461, 36409, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(FatAss1, 0x0, 0x0, 66 * 90, 0x7F, 0x7F, 0x0, 0x7F,     67, 73,  72, 0x0, 0x3F, 0x7E, OS.TRUE, 13824, 28384, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(FatAss2, 0x0, 0x0, 66 * 90, 0x7F, 0x7F, 0x0, 0x7F,     74, 80,  79, 0x0, 0x3F, 0x7E, OS.TRUE, 13746, 28514, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(FatAss3, 0x0, 0x0, 66 * 90, 0x7F, 0x7F, 0x0, 0x7F,     81, 85,  84, 0x0, 0x3F, 0x7E, OS.TRUE, 12041, 28161, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(FatAss4, 0x0, 0x0, 66 * 90, 0x7F, 0x7F, 0x0, 0x7F,     86, 92,  91, 0x0, 0x3F, 0x7E, OS.TRUE, 12480, 28736, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(FatAss5, 0x0, 0x0, 66 * 90, 0x7F, 0x7F, 0x0, 0x7F,     93, 108, 96, 0x0, 0x3F, 0x7E, OS.TRUE, 11937, 28256, 0xFFFFFFFF, OS.FALSE)
	add_instrument(Power_Lead, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	// TODO: DAMN UZI YOU ROCK!
	add_instrument_sample(SnareProteus, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  30, 30,  30, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(reggae2, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  31, 31,  31, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(LUDWIG_TAMA_SNARE, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  32, 32,  32, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(GatedSnare, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  33, 33,  33, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(BOMBOS_DUROS_BARRIOF, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  34, 34,  34, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(MondoK, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  35, 35,  35, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(MetalSD1, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  36, 36,  36, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(MetalSD2, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  37, 37,  37, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument_sample(AttackS, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  38, 38,  38, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(Caco, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  39, 39,  39, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(MetalSD45, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  40, 40, 40, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(MetalSD3, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  41, 41, 41, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(HH1, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  42, 42, 42, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(MetalSD5, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  43, 43, 43, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(HH2, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  44, 44, 44, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(MetalSD7, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  45, 45, 45, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(HH3, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  46, 46, 46, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(MetalSD9, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  47, 48, 47, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(MetalSD10, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  49, 49, 49, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(KorgCrshCymbl, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  50, 50, 50, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(MetalSD11, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  51, 51, 51, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(MetalSD12, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  52, 52, 52, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(MetalSD13, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  53, 53, 53, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(MetalSD14, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  54, 54, 54, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(MetalSD15, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  55, 55, 55, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(cowcow, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  56, 56, 56, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(MetalSD16, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  57, 57, 57, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(TomCco, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  58, 78, 72, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(KickSSF2T, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  79, 79, 79, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(INTHH1, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  80, 80, 80, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(SnareSSF2T, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  81, 81, 81, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(INTHH2, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  82, 82, 82, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(AoFKick, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  83, 83, 83, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(jv_kick, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  84, 84, 84, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(jv_snare, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  86, 86, 86, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(AoFSnare, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  88, 88, 88, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(Toms2-Low, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  89, 89, 89, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(jv_closedhat, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  90, 90, 90, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(Toms2-Med, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  91, 91, 91, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(jv_openhat, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  94, 94, 94, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(Toms2-High, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  96, 96, 96, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument(MurderPowerDrums, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	// TODO: No Escape.. Big Brother.
    add_instrument_sample(NScape-1, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  60, 60, 60, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(NScape-2, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  62, 62, 62, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(NScape-3, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  64, 64, 64, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(NScape-4, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  65, 65, 65, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(NScape-5, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  67, 67, 67, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(NScape-6, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  69, 69, 69, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(Eriked1, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,   70, 70, 70, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(Eriked2, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,   71, 71, 71, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(Eriked3, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,   72, 72, 72, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(Freak1, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,    74, 74, 74, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(Freak2, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,    75, 75, 75, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(Freak3, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,    76, 76, 76, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(Freak4, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,    77, 77, 77, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
    add_instrument(TechnoNoEscapeBeat110BPM, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	// TODO: The Name's Bond... James Bond.
	add_instrument_sample(harpischord-1, 0x0, 0x002191C0, 66 * 450, 0x7F, 0x7F, 0x0, 0x7F,  0, 53, 53, 0x0, 0x3F, 0x7E, OS.TRUE, 24112, 25024, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(harpischord-2, 0x0, 0x002191C0, 66 * 450, 0x7F, 0x7F, 0x0, 0x7F, 54, 63, 60, 0x0, 0x3F, 0x7E, OS.TRUE, 21342, 22195, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(harpischord-3, 0x0, 0x002191C0, 66 * 450, 0x7F, 0x7F, 0x0, 0x7F, 64, 69, 67, 0x0, 0x3F, 0x7E, OS.TRUE, 24027, 25651, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(harpischord-4, 0x0, 0x002191C0, 66 * 450, 0x7F, 0x7F, 0x0, 0x7F, 70, 74, 72, 0x0, 0x3F, 0x7E, OS.TRUE, 21440, 23510, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(harpischord-5, 0x0, 0x002191C0, 66 * 450, 0x7F, 0x7F, 0x0, 0x7F, 75, 82, 79, 0x0, 0x3F, 0x7E, OS.TRUE, 20319, 21824, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(harpischord-6, 0x0, 0x002191C0, 66 * 450, 0x7F, 0x7F, 0x0, 0x7F, 83, 96, 84, 0x0, 0x3F, 0x7E, OS.TRUE, 20315, 22692, 0xFFFFFFFF, OS.FALSE)
	add_instrument(Harpischord, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	// TODO: Cacofonia del Cocodrilo :Y
    add_instrument_sample(KRoolBass-1, 0x0, 400000, 66 * 0x0, 0x7F, 0x20, 0x0, 0x7F, 0,  71,  60, 0x0, 0x3F, 0x7E, OS.TRUE, 6416, 15223, 0xFFFFFFFF, OS.FALSE)
	add_instrument(KRoolBass, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	// TODO: Righty-O, work to do. Eh, J...? Maintenance work.
	add_instrument_sample(tessa-1, 0x0, 0x0, 66 * 550, 0x7F, 0x7F, 0x0, 0x7F,  0,   57,  55, 0x0, 0x3F, 0x7E, OS.TRUE, 19124, 52756, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(tessa-2, 0x0, 0x0, 66 * 550, 0x7F, 0x7F, 0x0, 0x7F,  58,  61,  60, 0x0, 0x3F, 0x7E, OS.TRUE, 10855, 45814, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(tessa-3, 0x0, 0x0, 66 * 550, 0x7F, 0x7F, 0x0, 0x7F,  62,  69,  67, 0x0, 0x3F, 0x7E, OS.TRUE, 16815, 37802, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(tessa-4, 0x0, 0x0, 66 * 550, 0x7F, 0x7F, 0x0, 0x7F,  70,  78,  72, 0x0, 0x3F, 0x7E, OS.TRUE, 17207, 27239, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(tessa-5, 0x0, 0x0, 66 * 550, 0x7F, 0x7F, 0x0, 0x7F,  79,  81,  79, 0x0, 0x3F, 0x7E, OS.TRUE, 16859, 43833, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(tessa-6, 0x0, 0x0, 66 * 550, 0x7F, 0x7F, 0x0, 0x7F,  82,  87,  84, 0x0, 0x3F, 0x7E, OS.TRUE, 25852, 44680, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(tessa-7, 0x0, 0x0, 66 * 550, 0x7F, 0x7F, 0x0, 0x7F,  88,  93,  91, 0x0, 0x3F, 0x7E, OS.TRUE, 15239, 37194, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(tessa-8, 0x0, 0x0, 66 * 550, 0x7F, 0x7F, 0x0, 0x7F,  94,  107, 96, 0x0, 0x3F, 0x7E, OS.TRUE, 15036, 28746, 0xFFFFFFFF, OS.FALSE)
	add_instrument(Tessa_Violin, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	// TODO: Yamaha MU Moment
	add_instrument_sample(breis-1,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F,    0, 41, 40, 0x0, 0x3F, 0x7E, OS.TRUE, 22528, 44549, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(breis-2,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F,   42, 45, 45, 0x0, 0x3F, 0x7E, OS.TRUE, 25071, 42589, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(breis-3,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F,   46, 49, 48, 0x0, 0x3F, 0x7E, OS.TRUE, 34696, 45697, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(breis-4,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F,   50, 51, 50, 0x0, 0x3F, 0x7E, OS.TRUE, 26657, 43096, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(breis-5,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F,   52, 54, 52, 0x0, 0x3F, 0x7E, OS.TRUE, 25061, 41224, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(breis-6,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F,   55, 58, 57, 0x0, 0x3F, 0x7E, OS.TRUE, 20712, 36737, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(breis-7,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F,   59, 60, 60, 0x0, 0x3F, 0x7E, OS.TRUE, 23220, 41410, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(breis-8,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F,   61, 63, 62, 0x0, 0x3F, 0x7E, OS.TRUE, 21317, 38266, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(breis-9,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F,   64, 65, 64, 0x0, 0x3F, 0x7E, OS.TRUE, 23127, 39957, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(breis-10, 0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F,   66, 68, 67, 0x0, 0x3F, 0x7E, OS.TRUE, 21366, 38198, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(breis-11, 0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F,   69, 70, 69, 0x0, 0x3F, 0x7E, OS.TRUE, 22335, 28008, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(breis-12, 0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F,   71, 72, 72, 0x0, 0x3F, 0x7E, OS.TRUE, 17083, 22709, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(breis-13, 0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F,   73, 76, 76, 0x0, 0x3F, 0x7E, OS.TRUE, 18310, 23890, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(breis-14, 0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F,   77, 79, 79, 0x0, 0x3F, 0x7E, OS.TRUE, 16561, 22152, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(breis-15, 0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F,   80, 82, 81, 0x0, 0x3F, 0x7E, OS.TRUE, 16687, 22291, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(breis-16, 0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F,   83, 85, 84, 0x0, 0x3F, 0x7E, OS.TRUE, 19233, 24892, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(breis-17, 0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F,  86, 100, 88, 0x0, 0x3F, 0x7E, OS.TRUE, 16601, 22161, 0xFFFFFFFF, OS.FALSE)
	add_instrument(Breis Solo Guitar, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x80, 0xF1, 0x64, 0x01)
	
	// TODO: there was a mislabeled instrument in this so here's an actual shamisen
    add_instrument_sample(JVShamisen-1, 0x0, 800000, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 0,  50, 43, 0x0, 0x3F, 0x7E, OS.TRUE, 23296, 34172, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(JVShamisen-2, 0x0, 800000, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 51, 55, 55, 0x0, 0x3F, 0x7E, OS.TRUE, 15744, 23127, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(JVShamisen-3, 0x0, 800000, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 56, 59, 58, 0x0, 0x3F, 0x7E, OS.TRUE, 18279, 28143, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(JVShamisen-4, 0x0, 800000, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 60, 62, 60, 0x0, 0x3F, 0x7E, OS.TRUE, 12779, 21376, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(JVShamisen-5, 0x0, 800000, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 63, 67, 67, 0x0, 0x3F, 0x7E, OS.TRUE, 18443, 27585, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(JVShamisen-6, 0x0, 800000, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 68, 76, 72, 0x0, 0x3F, 0x7E, OS.TRUE, 12539, 18127, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(JVShamisen-7, 0x0, 800000, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 77, 90, 79, 0x0, 0x3F, 0x7E, OS.TRUE, 14954, 23684, 0xFFFFFFFF, OS.FALSE)
	add_instrument(JV Shamisen, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	// TODO: For Orchestral Music Type, Right Mikan?
	add_instrument_sample(OrchSnare7, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  36, 37, 36, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(OrchSnareRoll2, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  38,  38,  38, 0x0, 0x3F, 0x7E, OS.TRUE, 1884, 8464, 0xFFFFFFFF, OS.FALSE)
	add_instrument(Orchestra_Snares, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	//// TODO: JCJenson Branded Industrial Drums, J Approves!
	add_instrument_sample(WDKick01, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  35, 35, 35, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(WDKick02, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  36, 36, 36, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(WDSmack, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  37, 37, 37, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(WDSnare01, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  38, 38, 38, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(WDSnare02, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  40, 41, 40, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(WDClosedHat, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  42, 42, 42, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(WDOpenHat, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  46, 46, 46, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(WDCymbal01, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  47, 49, 49, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(WDCymbal02, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  50, 57, 52, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(orch_hit3, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  58, 96, 84, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument(Industrial_Kit, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	//// TODO: Thank you for shopping at (Amen Break Intensifies)
	add_instrument_sample(terror-1, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  48, 48, 48, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(terror-2, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  49, 49, 49, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(terror-3, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  50, 50, 50, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(terror-4, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  51, 51, 51, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(terror-5, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  52, 52, 52, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument(Terror DNB Loop, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	//// TODO: Special Thanks to Avizura
	add_instrument_sample(StringSynth, 0x0, 0x0, 66 * 1784, 0x7F, 0x7F, 0x0, 0x7F, 0,  89,  78, 0x0, 0x3F, 0x7E, OS.TRUE, 11371, 31636, 0xFFFFFFFF, OS.FALSE)
	add_instrument(Synth Strings, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	//// TODO: the vanilla muted trumpet is so ass lmao
	add_instrument_sample(mutedtrumpet2-1, 0x0, 0x0, 66 * 200, 0x7F, 0x7F, 0x0, 0x7F,  0, 76, 67, 0x0, 0x3F, 0x7E, OS.TRUE,  9173, 12365, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(mutedtrumpet2-2, 0x0, 0x0, 66 * 200, 0x7F, 0x7F, 0x0, 0x7F, 77, 81, 79, 0x0, 0x3F, 0x7E, OS.TRUE, 11973, 14464, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(mutedtrumpet2-3, 0x0, 0x0, 66 * 200, 0x7F, 0x7F, 0x0, 0x7F, 82, 94, 83, 0x0, 0x3F, 0x7E, OS.TRUE, 15151, 17554, 0xFFFFFFFF, OS.FALSE)
	add_instrument(Muted Trumpet 2, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	//// TODO: ele Spongibob
	add_instrument_sample(supersponge_accordion, 0x0, 0x0, 66 * 150, 0x7F, 0x7F, 0x0, 0x7F, 0,  83,  72, 0x0, 0x3F, 0x7E, OS.TRUE, 8582, 17890, 0xFFFFFFFF, OS.FALSE)
	add_instrument(SuperSponge Accordion, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	//// TODO: MAKE THE MUSIC LOSE CONTROL-
    add_instrument_sample(SC-55_Square_C6, 0x0, 0x0, 66 * 100, 0x7F, 0x7F, 0x0, 0x7F, 0,  96,  84, 0x0, 0x3F, 0x7E, OS.TRUE, 7850, 13225, 0xFFFFFFFF, OS.TRUE)
	add_instrument(SM64 Square Wave, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	//// TODO: Brob2nd wanted this instrument here so....
	add_instrument_sample(eb_overdrivenguitar, 0x0, 0x0, 66 * 50, 0x7F, 0x7F, 0x0, 0x7F, 0,  87,  76, 0x0, 0x3F, 0x7E, OS.TRUE, 7463, 9696, 0xFFFFFFFF, OS.FALSE)
	add_instrument(Earthbound SNES Overdriven, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	//// TODO: Borrowed from GoldenEye 007
	add_instrument_sample(GE_Vibraphone, 0x0, 800000, 66 * 1930, 0x7F, 0x20, 0x0, 0x7F, 0,  90,  79, 0x0, 0x3F, 0x7E, OS.TRUE, 4069, 7540, 0xFFFFFFFF, OS.FALSE)
	add_instrument(GoldenEye_Vibraphone, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	//// TODO: Forest :3
	add_instrument_sample(harmonica-1, 0x0, 0x0, 66 * 250, 0x7F, 0x7F, 0x0, 0x7F,  0, 53, 53, 0x0, 0x3F, 0x7E, OS.TRUE, 9455, 13866, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(harmonica-2, 0x0, 0x0, 66 * 250, 0x7F, 0x7F, 0x0, 0x7F, 54, 58, 58, 0x0, 0x3F, 0x7E, OS.TRUE, 9593, 14536, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(harmonica-3, 0x0, 0x0, 66 * 250, 0x7F, 0x7F, 0x0, 0x7F, 59, 63, 63, 0x0, 0x3F, 0x7E, OS.TRUE, 5113, 10260, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(harmonica-4, 0x0, 0x0, 66 * 250, 0x7F, 0x7F, 0x0, 0x7F, 64, 67, 67, 0x0, 0x3F, 0x7E, OS.TRUE, 6229, 12058, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(harmonica-5, 0x0, 0x0, 66 * 250, 0x7F, 0x7F, 0x0, 0x7F, 68, 70, 70, 0x0, 0x3F, 0x7E, OS.TRUE, 6526, 11691, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(harmonica-6, 0x0, 0x0, 66 * 250, 0x7F, 0x7F, 0x0, 0x7F, 71, 73, 73, 0x0, 0x3F, 0x7E, OS.TRUE, 5387, 10746, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(harmonica-7, 0x0, 0x0, 66 * 250, 0x7F, 0x7F, 0x0, 0x7F, 74, 77, 77, 0x0, 0x3F, 0x7E, OS.TRUE, 6177, 11235, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(harmonica-8, 0x0, 0x0, 66 * 250, 0x7F, 0x7F, 0x0, 0x7F, 78, 82, 82, 0x0, 0x3F, 0x7E, OS.TRUE, 7868, 13237, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(harmonica-9, 0x0, 0x0, 66 * 250, 0x7F, 0x7F, 0x0, 0x7F, 83, 98, 86, 0x0, 0x3F, 0x7E, OS.TRUE, 5371, 10232, 0xFFFFFFFF, OS.FALSE)
	add_instrument(Harmonica, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	//// TODO: YOOOOOOOOOOOOOOO-
	add_instrument_sample(Ethnic-1, 0x0, 800000, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F, 36, 36, 36, 0x0, 0x3F, 0x7E, OS.TRUE, 17933, 20786, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Ethnic-2, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F, 38, 38, 38, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(Ethnic-3, 0x0, 800000, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F, 39, 39, 39, 0x0, 0x3F, 0x7E, OS.TRUE, 10476, 12586, 0, OS.FALSE)
	add_instrument_sample(Ethnic-4, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F, 40, 40, 40, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(Ethnic-5, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F, 41, 41, 41, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(Ethnic-6, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F, 42, 42, 42, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(Ethnic-7, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F, 43, 43, 43, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(Ethnic-8, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F, 45, 45, 45, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(Ethnic-Taiko, 0x0, 800000, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F, 46, 72, 60, 0x0, 0x3F, 0x7E, OS.TRUE, 14190, 18021, 0xFFFFFFFF, OS.FALSE)
	add_instrument(Ethnic and Taiko Drum, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	//// TODO: Unreal.
	add_instrument_sample(OrchWorld-1, 0x0, 0x0, 66 * 100, 0x7F, 0x7F, 0x0, 0x7F, 0,  76,  69, 0x0, 0x3F, 0x7E, OS.TRUE, 22784, 47445, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(OrchWorld-2, 0x0, 0x0, 66 * 100, 0x7F, 0x7F, 0x0, 0x7F, 77, 92,  81, 0x0, 0x3F, 0x7E, OS.TRUE, 11392, 23723, 0xFFFFFFFF, OS.FALSE)
	add_instrument(Unreal Harp, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	// TODO: Synthy Flow...
    add_instrument_sample(JX-10_SynthBow-1, 0x0, 0x0, 66 * 450, 0x7F, 0x7F, 0x0, 0x7F, 0,  74, 64, 0x0, 0x3F, 0x7E, OS.TRUE, 11920, 28979, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(JX-10_SynthBow-2, 0x0, 0x0, 66 * 450, 0x7F, 0x7F, 0x0, 0x7F, 75, 90, 79, 0x0, 0x3F, 0x7E, OS.TRUE, 7059, 14272, 0xFFFFFFFF, OS.FALSE)
	add_instrument(JX-10 Synth Bow, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	// TODO: Combination Time!!!
	add_instrument_sample(PS1_LowSynth, 0x0, 0x0, 66 * 350, 0x7F, 0x7F, 0x0, 0x7F,  0, 55,  43, 0x0, 0x3F, 0x7E, OS.TRUE,  44780, 56604, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(SF_Hit-1, 0x0, 0x0, 66 * 350, 0x7F, 0x7F, 0x0, 0x7F,     56, 73,  68, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(SF_Hit-2, 0x0, 0x0, 66 * 350, 0x7F, 0x7F, 0x0, 0x7F,     74, 91,  80, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument(Combination 1, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	// TODO: Roland Moment
	add_instrument_sample(OverdriveU110-1,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 0,  44, 40, 0x0, 0x3F, 0x7E, OS.TRUE, 30601, 35259, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(OverdriveU110-2,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 45, 49, 45, 0x0, 0x3F, 0x7E, OS.TRUE, 25349, 27966, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(OverdriveU110-3,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 50, 53, 50, 0x0, 0x3F, 0x7E, OS.TRUE, 26294, 29998, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(OverdriveU110-4,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 54, 57, 54, 0x0, 0x3F, 0x7E, OS.TRUE, 21310, 24770, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(OverdriveU110-5,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 58, 60, 58, 0x0, 0x3F, 0x7E, OS.TRUE, 23169, 26464, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(OverdriveU110-6,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 61, 64, 61, 0x0, 0x3F, 0x7E, OS.TRUE, 23560, 28178, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(OverdriveU110-7,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 65, 68, 65, 0x0, 0x3F, 0x7E, OS.TRUE, 23343, 27742, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(OverdriveU110-8,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 69, 70, 69, 0x0, 0x3F, 0x7E, OS.TRUE, 16249, 19740, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(OverdriveU110-9,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 71, 72, 71, 0x0, 0x3F, 0x7E, OS.TRUE, 18909, 26101, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(OverdriveU110-10, 0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 73, 74, 73, 0x0, 0x3F, 0x7E, OS.TRUE, 19643, 23626, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(OverdriveU110-11, 0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 75, 77, 75, 0x0, 0x3F, 0x7E, OS.TRUE, 18587, 22136, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(OverdriveU110-12, 0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 76, 98, 86, 0x0, 0x3F, 0x7E, OS.TRUE, 14779, 21425, 0xFFFFFFFF, OS.FALSE)
	add_instrument(SN-U-110-07 ODG, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x80, 0xF1, 0x64, 0x01)
	
	//// TODO: no, is not the Ryu and Ken one.
	add_instrument_sample(Distortion_Strat-1,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 0,  43, 40, 0x0, 0x3F, 0x7E, OS.TRUE, 36383, 41818, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Distortion_Strat-2,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 44, 46, 45, 0x0, 0x3F, 0x7E, OS.TRUE, 32077, 37808, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(Distortion_Strat-3,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 47, 50, 48, 0x0, 0x3F, 0x7E, OS.TRUE, 28371, 34244, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Distortion_Strat-4,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 51, 54, 52, 0x0, 0x3F, 0x7E, OS.TRUE, 33733, 39559, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Distortion_Strat-5,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 55, 57, 57, 0x0, 0x3F, 0x7E, OS.TRUE, 33772, 39588, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Distortion_Strat-6,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 58, 60, 60, 0x0, 0x3F, 0x7E, OS.TRUE, 33235, 38863, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Distortion_Strat-7,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 61, 63, 62, 0x0, 0x3F, 0x7E, OS.TRUE, 32605, 38272, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Distortion_Strat-8,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 64, 65, 64, 0x0, 0x3F, 0x7E, OS.TRUE, 35039, 40863, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Distortion_Strat-9,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 66, 68, 67, 0x0, 0x3F, 0x7E, OS.TRUE, 26637, 32352, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Distortion_Strat-10, 0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 69, 73, 69, 0x0, 0x3F, 0x7E, OS.TRUE, 23543, 29071, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Distortion_Strat-11, 0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 74, 79, 76, 0x0, 0x3F, 0x7E, OS.TRUE, 31765, 37396, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Distortion_Strat-12, 0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 80, 82, 81, 0x0, 0x3F, 0x7E, OS.TRUE, 34737, 40590, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Distortion_Strat-13, 0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 83, 96, 84, 0x0, 0x3F, 0x7E, OS.TRUE, 31276, 37209, 0xFFFFFFFF, OS.FALSE)
	add_instrument(Distortion Strat, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x80, 0xF1, 0x64, 0x01)
	
	// TODO: I'M BOUTA BLOOOWWWWWWW
    add_instrument_sample(Combination32, 0x0, 800000, 66 * 1879, 0x7F, 0x20, 0x0, 0x7F, 0, 60, 48, 0x0, 0x3F, 0x7E, OS.TRUE, 11511, 19395, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(PS1Crystal, 0x0, 0x0, 66 * 50, 0x7F, 0x7F, 0x0, 0x7F,    61, 120, 108, 0x0, 0x3F, 0x7E, OS.TRUE,  6745, 34174, 0xFFFFFFFF, OS.FALSE)
	add_instrument(Stab+PS1, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	// TODO: Bassy Bones
    add_instrument_sample(bassbone-1, 0x0, 0x0, 66 * 450, 0x7F, 0x7F, 0x0, 0x7F,  0, 48, 43, 0x0, 0x3F, 0x7E, OS.TRUE, 12470, 31040, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(bassbone-2, 0x0, 0x0, 66 * 450, 0x7F, 0x7F, 0x0, 0x7F, 49, 67, 55, 0x0, 0x3F, 0x7E, OS.TRUE, 15511, 32415, 0xFFFFFFFF, OS.FALSE)
	add_instrument(BassBone Sect, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	// TODO: for these samples, make sure values are correct (assuming we keep this instrument)
    add_instrument_sample(square12-1, 0x0, 0x0, 66 * 30, 0x7F, 0x7F, 0x0, 0x7F,  0, 45, 36, 0x0, 0x3F, 0x7E, OS.TRUE, 7341, 15169,  0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(square12-2, 0x0, 0x0, 66 * 30, 0x7F, 0x7F, 0x0, 0x7F, 46, 57, 48, 0x0, 0x3F, 0x7E, OS.TRUE, 7588, 14682,  0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(square12-3, 0x0, 0x0, 66 * 30, 0x7F, 0x7F, 0x0, 0x7F, 58, 69, 60, 0x0, 0x3F, 0x7E, OS.TRUE, 3673,  8810,  0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(square12-4, 0x0, 0x0, 66 * 30, 0x7F, 0x7F, 0x0, 0x7F, 70, 81, 72, 0x0, 0x3F, 0x7E, OS.TRUE, 5508, 11746,  0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(square12-5, 0x0, 0x0, 66 * 30, 0x7F, 0x7F, 0x0, 0x7F, 82, 96, 84, 0x0, 0x3F, 0x7E, OS.TRUE, 4345,  9421,  0xFFFFFFFF, OS.FALSE)
    add_instrument(NES Square Wave 12P, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	// TODO: I'M BOUTA BLOOOWWWWWWW
    add_instrument_sample(Heavenals-G5, 0x0, 800000, 66 * 1879, 0x7F, 0x20, 0x0, 0x7F,  0, 74,  67, 0x0, 0x3F, 0x7E, OS.TRUE, 17791, 31630, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Heavenals-G6, 0x0, 800000, 66 * 1879, 0x7F, 0x20, 0x0, 0x7F, 75, 86,  79, 0x0, 0x3F, 0x7E, OS.TRUE, 18947, 35387, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Heavenals-G7, 0x0, 800000, 66 * 1879, 0x7F, 0x20, 0x0, 0x7F, 87, 103, 91, 0x0, 0x3F, 0x7E, OS.TRUE, 17792, 32746, 0xFFFFFFFF, OS.FALSE)
	add_instrument(JV Heavenals, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	//// TODO: Welcome to Panic Park....
	add_instrument_sample(SynthBass-1, 0x0, 0x0, 66 * 50, 0x7F, 0x7F, 0x0, 0x7F,   0, 44, 40, 0x0, 0x3F, 0x7E, OS.TRUE, 6689, 10565, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(SynthBass-2, 0x0, 0x0, 66 * 50, 0x7F, 0x7F, 0x0, 0x7F,  45, 56, 52, 0x0, 0x3F, 0x7E, OS.TRUE, 8384, 10709, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Kicks1, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,     60, 60, 60, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(Kicks2, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,     61, 61, 61, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(Kicks3, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,     62, 62, 62, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(LowHit1, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,    64, 64, 64, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(MetalHit1, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  65, 65, 65, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(MetalHit2, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  66, 66, 66, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(MetalHitSlide,   0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  67, 67, 67, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(MetalHitSlideUp, 0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  68, 68, 68, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument_sample(TrainLoop,       0x0, 0x0, 66 * 0x0, 0x7F, 0x7F, 0x0, 0x7F,  70, 70, 70, 0x0, 0x3F, 0x7E, OS.FALSE, 0, 0, 0, OS.FALSE)
	add_instrument(PNP BGM, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	// TODO: More Power Ride
	add_instrument_sample(HEAVYEG_001, 0x0, 0x0, 66 * 350, 0x7F, 0x7F, 0x0, 0x7F,  0,  46, 44, 0x0, 0x3F, 0x7E, OS.TRUE, 19231, 46339, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(HEAVYEG_002, 0x0, 0x0, 66 * 350, 0x7F, 0x7F, 0x0, 0x7F,  47, 52, 47, 0x0, 0x3F, 0x7E, OS.TRUE, 26326, 47345, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(HEAVYEG_003, 0x0, 0x0, 66 * 350, 0x7F, 0x7F, 0x0, 0x7F,  53, 65, 53, 0x0, 0x3F, 0x7E, OS.TRUE,  8356, 36966, 0xFFFFFFFF, OS.FALSE)
	add_instrument(U-110 Heavy Guitar, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x80, 0xF1, 0x64, 0x01)
	
	// TODO: GET SUM FUZZ FUZZ
	add_instrument_sample(Fuzz-1,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 0,  43,  40, 0x0, 0x3F, 0x7E, OS.TRUE, 17783, 41713, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Fuzz-2,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 44, 46,  45, 0x0, 0x3F, 0x7E, OS.TRUE, 23302, 43453, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Fuzz-3,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 47, 50,  48, 0x0, 0x3F, 0x7E, OS.TRUE, 27647, 47424, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Fuzz-4,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 51, 53,  52, 0x0, 0x3F, 0x7E, OS.TRUE, 24267, 41816, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Fuzz-5,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 54, 56,  55, 0x0, 0x3F, 0x7E, OS.TRUE, 21548, 41559, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Fuzz-6,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 57, 62,  60, 0x0, 0x3F, 0x7E, OS.TRUE, 15752, 32145, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Fuzz-7,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 63, 74,  69, 0x0, 0x3F, 0x7E, OS.TRUE, 18467, 39339, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Fuzz-8,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 75, 80,  76, 0x0, 0x3F, 0x7E, OS.TRUE, 15042, 36498, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Fuzz-9,  0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 81, 83,  81, 0x0, 0x3F, 0x7E, OS.TRUE, 14677, 40093, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(Fuzz-10, 0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 84, 100, 88, 0x0, 0x3F, 0x7E, OS.TRUE, 17084, 39265, 0xFFFFFFFF, OS.FALSE)
	add_instrument(Fuzz Strat, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x80, 0xF1, 0x64, 0x01)
	
	// TODO: Sampled Properly.
	add_instrument_sample(PowerTrip-1, 0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 0,  44, 40, 0x0, 0x3F, 0x7E, OS.TRUE, 24733, 67542, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(PowerTrip-2, 0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 45, 48, 45, 0x0, 0x3F, 0x7E, OS.TRUE,  7025, 50261, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(PowerTrip-3, 0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 49, 52, 52, 0x0, 0x3F, 0x7E, OS.TRUE, 21076, 68830, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(PowerTrip-4, 0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 53, 55, 55, 0x0, 0x3F, 0x7E, OS.TRUE, 24386, 52883, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(PowerTrip-5, 0x0, 0x008C3A2D, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 56, 69, 57, 0x0, 0x3F, 0x7E, OS.TRUE, 26887, 66744, 0xFFFFFFFF, OS.FALSE)
	add_instrument(JV-1080 Power Trip, 0x7E, 0x3F, 0x05, 1200, 0x0, 0x0, 0x0, 0x0, 0x80, 0xF1, 0x64, 0x01)
	
    move_instrument_bank_map()

    // @ Description
    // Loads the instrument bank map from ROM to RAM so that instrument data is properly processed at startup
    scope dmaCopy_moved_bank_map_: {
        OS.patch_start(0x20148, 0x8001F548)
        jal     dmaCopy_moved_bank_map_
        nop
        OS.patch_end()

        OS.save_registers()                             // save registers

        // reload bank table from ROM
        li      a0, moved_inst_bank_map_origin          // load rom address
        li      a1, moved_inst_bank_map                 // load ram address
        li      a2, 0x10 + (instrument_count * 4)       // load length of bank table
        jal     0x80002CA0                              // dmaCopy
        nop

        OS.restore_registers()                          // restore registers

        _end:
        j       0x8001E91C                              // original line 1
        or      a2, s0, r0                              // original line 2
    }

    print "========================================================================== \n"

    // @ Description
    // Adds a priority override for the given instrument/bgm combination.
    // Also creates a priority override array if it doesn't already exist.
    // bgm - id of bgm
    // instrument - id of instrument
    // priority - priority value to use for this track
    macro add_priority_override(bgm, instrument, priority) {
        evaluate bgm({bgm})

        // create an override array for this bgm if it doesn't exist
        if !{defined priority_override_{bgm}} {
            global define priority_override_{bgm}()

            priority_override_array_{bgm}:
            constant priority_override_array_{bgm}_origin(origin())
            fill instrument_count
            OS.align(16)

            pushvar origin, base
            origin priority_override_table_origin + ({bgm} * 0x4)
            dw  priority_override_array_{bgm}
            pullvar base, origin
        }

        // add the override value for this instrument
        pushvar origin, base
        origin priority_override_array_{bgm}_origin + {instrument}
        db  {priority}
        pullvar base, origin
    }

    // @ Description
    // Adds a bend range override for the given instrument/bgm combination.
    // Also creates a bend range override array if it doesn't already exist.
    // bgm - id of bgm
    // instrument - id of instrument
    // bend_range - bend_range value to use for this track
    macro add_bend_range_override(bgm, instrument, bend_range) {
        evaluate bgm({bgm})

        // create an override array for this bgm if it doesn't exist
        if !{defined bend_range_override_{bgm}} {
            global define bend_range_override_{bgm}()

            bend_range_override_array_{bgm}:
            constant bend_range_override_array_{bgm}_origin(origin())
            fill instrument_count * 2
            OS.align(16)

            pushvar origin, base
            origin bend_range_override_table_origin + ({bgm} * 0x4)
            dw  bend_range_override_array_{bgm}
            pullvar base, origin
        }

        // add the override value for this instrument
        pushvar origin, base
        origin bend_range_override_array_{bgm}_origin + ({instrument} * 2)
        dh  {bend_range}
        pullvar base, origin
    }

    // @ Description
    // Adds a master volume override for the given bgm.
    // bgm - id of bgm
    // volume - master volume value to use for this track
    macro add_master_volume_override(bgm, volume) {
        evaluate bgm({bgm})
        // add the override value for this bgm
        pushvar origin, base
        origin master_volume_override_table_origin + {bgm}
        if {volume} > 127 {
        print "WARNING: Max value for master volume override is 127 \n"
        db  127
        } else {
        db  {volume}
        }
        pullvar base, origin
    }

    // @ Description
    // Alternate version of subroutine 0x8002E2AC which seems to load instrument parameters.
    // Checks to see if the current BGM gives an alternate priority or bend range value for the given instrument.
    // a0 - unknown (original)
    // a1 - address of instrument parameters
    // a2 - unknown (original)
    scope override_instrument_parameters_: {
        OS.patch_start(0x2C820, 0x8002BC20)
        jal     override_instrument_parameters_
        OS.patch_end()

        lw      t6, 0x0068(a0)              // ~
        sll     v0, a2, 0x2                 // ~
        subu    v0, v0, a2                  // ~
        sll     v0, v0, 0x3                 // ~
        addu    t7, t6, v0                  // ~
        sw      a1, 0x0000(t7)              // ~
        lw      t9, 0x0068(a0)              // undocumented original logic

        _priority:
        li      t0, BGM.safe_id             // t0 = address of safe bgm_id
        lw      t0, 0x0000(t0)              // t0 = current bgm_id
        li      t1, priority_override_table // t1 = priority_override_table
        sll     t0, t0, 0x2                 // t0 = offset (bgm * 4)
        addu    t1, t1, t0                  // t1 = priority_override_table + offset
        lw      t1, 0x0000(t1)              // t1 = address of override array for current bgm
        beql    t1, r0, _bend_range         // skip if array pointer = NULL...
        lbu     t8, 0x0002(a1)              // ...and load original priority to t8

        // if there is a priority override array for the current bgm, check for an override value for the current instrument
        // fp/s8 is presumed to always contain the instrument id at this point, this is almost certainly safe because it's used for
        // a check for invalid instrument ids right before the function call we replace
        addu    t1, t1, s8                  // t1 = array pointer + offset(instrument id)
        lbu     t8, 0x0000(t1)              // t8 = priority override value
        beql    t8, r0, _bend_range         // if priority override = 0...
        lbu     t8, 0x0002(a1)              // ...load original priority to t8 instead

        _bend_range:
        // t0 = offset (bgm * 4)
        li      t1, bend_range_override_table // t1 = bend_range_override_table
        addu    t1, t1, t0                  // t1 = bend_range_override_table + offset
        lw      t1, 0x0000(t1)              // t1 = address of override array for current bgm
        beql    t1, r0, _continue           // skip if array pointer = NULL...
        lh      t1, 0x000C(a1)              // ...and load original bend range to t1 instead

        // if there is a bend range override array for the current bgm, check for an override value for the current instrument
        // fp/s8 is presumed to always contain the instrument id at this point, this is almost certainly safe because it's used for
        // a check for invalid instrument ids right before the function call we replace
        sll     t2, s8, 0x1                 // t2 = offset (instrument id * 2)
        addu    t1, t1, t2                  // t1 = array pointer + offset
        lh      t1, 0x0000(t1)              // t1 = bend range override value
        beql    t1, r0, _continue           // if bend rage override = 0...
        lh      t1, 0x000C(a1)              // ...load original bend range to t1 instead

        _continue:
        addu    t0, t9, v0                  // ~
        sb      t8, 0x0008(t0)              // store priority
        lw      t2, 0x0068(a0)              // ~
        addu    t3, t2, v0                  // ~
        sh      t1, 0x0004(t3)              // store bend range
        lw      t5, 0x0068(a0)              // ~
        lbu     t4, 0x0000(a1)              // ~
        addu    t6, t5, v0                  // ~
        jr      ra                          // ~
        sb      t4, 0x0011(t6)              // undocumented original logic
    }

    // @ Description
    // Overrides the vanilla master volume with a custom one if the track has it
    scope override_master_volume_: {
        OS.patch_start(0x302C0, 0x8002F6C0)
        j       override_master_volume_
        lbu     t7, 0x0078(a0)              // t7 = master volume (original line 2)
        _return:
        OS.patch_end()

        li      t0, BGM.safe_id             // t0 = address of safe bgm_id
        lw      t0, 0x0000(t0)              // t0 = current bgm_id
        li      t1, master_volume_override_table // t1 = master_volume_override_table
        addu    t1, t1, t0                  // t1 = master_volume_override_table + bgm_id
        lbu     t1, 0x0000(t1)              // t1 = master volume override for current bgm
        bnezl   t1, _end                    // if an override value is present...
        or      t7, t1, r0                  // t7 = new master volume value

        _end:
        j       _return
        lh      t6, 0x003A(a0)              // load other volume parameter (original line 2)
    }

    // @ Description
    // Can enable or disable MIDI channels. Bitflag located at 0x8003D31C
    // a0 = new channel bitflags to use (0x0000FFFF)
    scope toggle_channels: {
        lui     v0, 0x8004
        jr      ra
        sh      a0, 0xD31C(v0)              // v0 = current bitflags
    }

    OS.align(16)
    priority_override_table:
    constant priority_override_table_origin(origin())
    fill midi_count * 0x4
    OS.align(16)

    OS.align(16)
    bend_range_override_table:
    constant bend_range_override_table_origin(origin())
    fill midi_count * 0x4
    OS.align(16)

    OS.align(16)
    master_volume_override_table:
    constant master_volume_override_table_origin(origin())
    fill midi_count
    OS.align(16)

    // ADD PRIORITY OVERRIDES HERE
    // This can be used when MIDI cc16 fails to provide satisfactory results.
    // It should only be used in advanced cases and be used with care, as giving instruments extreme priority can cause FGMs to cut out or play back wrong.
    // bgm - id of bgm
    // instrument - id of instrument
    // priority - priority value to use for this track
    add_priority_override({MIDI.id.FOREST_INTERLUDE}, 7, 0x7F)
    add_priority_override({MIDI.id.FOREST_INTERLUDE}, 15, 0x7F)
    add_priority_override({MIDI.id.FOREST_INTERLUDE}, 28, 0x7F)
    add_priority_override({MIDI.id.FOREST_INTERLUDE}, 40, 0x7F)
    add_priority_override({MIDI.id.FOREST_INTERLUDE}, 55, 0x7F)

    add_priority_override({MIDI.id.DK_RAP}, 63, 0x7F)

    add_priority_override({MIDI.id.ROLL}, 64, 0x7F)

    add_priority_override({MIDI.id.YOSHI_TALE}, 65, 0x7F)

    add_priority_override({MIDI.id.TABUU}, 58, 0x7F)

    add_priority_override({MIDI.id.DISCOVERYFALLS}, 28, 0x7F)
    add_priority_override({MIDI.id.DISCOVERYFALLS}, 44, 0x7F)
    add_priority_override({MIDI.id.DISCOVERYFALLS}, 7, 0x7F)
    add_priority_override({MIDI.id.DISCOVERYFALLS}, 67, 0x7F)

    add_priority_override({MIDI.id.WIZPIG}, 58, 0x7F)
    add_priority_override({MIDI.id.WIZPIG}, 44, 0x7F)

    add_priority_override({MIDI.id.TOADS_TURNPIKE}, 2, 0x7F)
    add_priority_override({MIDI.id.TOADS_TURNPIKE}, 7, 0x7F)
    add_priority_override({MIDI.id.TOADS_TURNPIKE}, 44, 0x7F)

    add_priority_override({MIDI.id.FIRE_EMBLEM}, 34, 0x7F)

    add_priority_override({MIDI.id.ROCKSOLID}, 7, 0x7F)

    add_priority_override({MIDI.id.BIG_BRIDGE}, 34, 0x7F)

    add_priority_override({MIDI.id.TARGET_TEST}, 56, 0x7F)

    add_priority_override({MIDI.id.SS_AQUA}, 56, 0x7F)
    add_priority_override({MIDI.id.SS_AQUA}, 51, 0x7F)

    add_priority_override({MIDI.id.ELADARD}, 54, 0x7F)
    add_priority_override({MIDI.id.ELADARD}, 55, 0x7F)

    add_priority_override({MIDI.id.DRAKE_LAKE}, 1, 0x7F)

    add_priority_override({MIDI.id.BATTLE_AMONG_FRIENDS}, 28, 0x7F)

    add_priority_override({MIDI.id.MURASAKI}, 55, 0x7F)

    add_priority_override({MIDI.id.SKYWORLD}, 1, 0x7F)

    // ADD BEND RANGE OVERRIDES HERE
    // This can be used when default bend ranges fail to provide satisfactory results.
    // bgm - id of bgm
    // instrument - id of instrument
    // bend_range - bend_range value to use for this track

    add_bend_range_override({MIDI.id.YOSHI_TALE}, 2, 100) // sets vanilla organ to have a pitch bend of +/- 1 semitone instead of 0.1

    add_bend_range_override({MIDI.id.SLIDER}, 29, 1200)

    add_bend_range_override({MIDI.id.WILDLANDS}, 1, 200)

    add_bend_range_override({MIDI.id.OPUS_13}, 47, 100)

    add_bend_range_override({MIDI.id.FUTUREFRENZY}, 24, 1200)

    add_bend_range_override({MIDI.id.MUTE_CITY}, 41, 1200)

    add_bend_range_override({MIDI.id.SILVERSURFER}, 19, 1200)
    add_bend_range_override({MIDI.id.SILVERSURFER}, 20, 1200)

    add_bend_range_override({MIDI.id.TOWEROFHEAVEN}, 19, 1200)

    add_bend_range_override({MIDI.id.LIPS_THEME}, 19, 1200)
    add_bend_range_override({MIDI.id.LIPS_THEME}, 14, 1200)

    add_bend_range_override({MIDI.id.WALUIGI_PINBALL}, 12, 1200)
    add_bend_range_override({MIDI.id.WALUIGI_PINBALL}, 29, 1200)

    add_bend_range_override({MIDI.id.SONIC_R}, 13, 1200)

    add_bend_range_override({MIDI.id.RACEWAYS}, 11, 1200)

    add_bend_range_override({MIDI.id.BOWSERBOSS}, 5, 1200)

    add_bend_range_override({MIDI.id.BUBBLEGUM_KK}, 6, 1200)

    // ADD MASTER VOLUME OVERRIDES HERE
    // This can be used to adjust the overall volume of a track in-game.
    // bgm - id of bgm
    // volume - master volume to use for this track, 0-127, default is 100
    add_master_volume_override({MIDI.id.CORNERIA}, 93)
    add_master_volume_override({MIDI.id.DR_MARIO}, 90)
    add_master_volume_override({MIDI.id.GAME_CORNER}, 90)
    add_master_volume_override({MIDI.id.SMASHVILLE}, 110)
    add_master_volume_override({MIDI.id.STONECARVING_CITY}, 112)
    add_master_volume_override({MIDI.id.GODDESSBALLAD}, 115)
    add_master_volume_override({MIDI.id.TOWEROFHEAVEN}, 82)
    add_master_volume_override({MIDI.id.FOD}, 90)
    add_master_volume_override({MIDI.id.MEMENTOS}, 110)
    add_master_volume_override({MIDI.id.SPIRAL_MOUNTAIN}, 87)
    add_master_volume_override({MIDI.id.N64}, 104)
    add_master_volume_override({MIDI.id.BATTLEFIELD}, 95)
    add_master_volume_override({MIDI.id.MADMONSTER}, 90)
    add_master_volume_override({MIDI.id.GREEN_GREENS}, 95)
    add_master_volume_override({MIDI.id.POKEMON_STADIUM}, 83)
    add_master_volume_override({MIDI.id.SMB3OVERWORLD}, 90)
    add_master_volume_override({MIDI.id.DELFINO}, 110)
    add_master_volume_override({MIDI.id.ONETT}, 105)
    add_master_volume_override({MIDI.id.ZEBES_LANDING}, 95)
    add_master_volume_override({MIDI.id.EASTON_KINGDOM}, 83)
    add_master_volume_override({MIDI.id.WING_CAP}, 85)
    add_master_volume_override({MIDI.id.RBY_GYMLEADER}, 80)
    add_master_volume_override({MIDI.id.KITCHEN_ISLAND}, 90)
    add_master_volume_override({MIDI.id.DK_RAP}, 100)
    add_master_volume_override({MIDI.id.MACHRIDER}, 95)
    add_master_volume_override({MIDI.id.POKEFLOATS}, 82)
    add_master_volume_override({MIDI.id.GERUDO_VALLEY}, 90)
    add_master_volume_override({MIDI.id.POP_STAR}, 120)
    add_master_volume_override({MIDI.id.STAR_WOLF}, 83)
    add_master_volume_override({MIDI.id.POKEMON_CHAMPION}, 85)
    add_master_volume_override({MIDI.id.POLLYANNA}, 90)
    add_master_volume_override({MIDI.id.SAMBA_DE_COMBO}, 95)
    add_master_volume_override({MIDI.id.UNFOUNDED_REVENGE}, 90)
    add_master_volume_override({MIDI.id.KENGJR}, 86)
    add_master_volume_override({MIDI.id.BEIN_FRIENDS}, 90)
    add_master_volume_override({MIDI.id.KK_RIDER}, 95)
    add_master_volume_override({MIDI.id.SNAKEY_CHANTEY}, 95)
    add_master_volume_override({MIDI.id.TAZMILY}, 115)
    add_master_volume_override({MIDI.id.YOSHI_GOLF}, 88)
    add_master_volume_override({MIDI.id.FINALTEMPLE}, 88)
    add_master_volume_override({MIDI.id.OBSTACLE}, 90)
    add_master_volume_override({MIDI.id.EVEN_DRIER_GUYS}, 87)
    add_master_volume_override({MIDI.id.PEACH_CASTLE}, 105)
    add_master_volume_override({MIDI.id.BANJO_MAIN}, 95)
    add_master_volume_override({MIDI.id.GANGPLANK}, 108)
    add_master_volume_override({MIDI.id.FD_BRAWL}, 90)
    add_master_volume_override({MIDI.id.ARIA_OF_THE_SOUL}, 118)
    add_master_volume_override({MIDI.id.KING_OF_THE_KOOPAS}, 90)
    add_master_volume_override({MIDI.id.SKERRIES}, 95)
    add_master_volume_override({MIDI.id.BEWARE_THE_FORESTS_MUSHROOMS}, 95)
    add_master_volume_override({MIDI.id.TARGET_TEST}, 95)
    add_master_volume_override({MIDI.id.VENOM}, 80)
    add_master_volume_override({MIDI.id.BK_FINALBATTLE}, 107)
    add_master_volume_override({MIDI.id.OLE}, 92)
    add_master_volume_override({MIDI.id.WINDY}, 93)
    add_master_volume_override({MIDI.id.DATADYNE}, 90)
    add_master_volume_override({MIDI.id.INVESTIGATION_X}, 85)
    add_master_volume_override({MIDI.id.NSMB}, 105)
    add_master_volume_override({MIDI.id.JUNGLEJAPES}, 90)
    add_master_volume_override({MIDI.id.TOADS_TURNPIKE}, 92)
    add_master_volume_override({MIDI.id.GB_MEDLEY}, 90)
    add_master_volume_override({MIDI.id.FLOWER_GARDEN}, 110)
    add_master_volume_override({MIDI.id.WILDLANDS}, 125)
    add_master_volume_override({MIDI.id.VS_MARX}, 115)
    add_master_volume_override({MIDI.id.SS_AQUA}, 86)
    add_master_volume_override({MIDI.id.METAL_BATTLE}, 110)
    add_master_volume_override({MIDI.id.KANTO_WILD_BATTLE}, 85)
    add_master_volume_override({MIDI.id.PIRATELAND}, 90)
    add_master_volume_override({MIDI.id.FLYINGBATTERY}, 90)
    add_master_volume_override({MIDI.id.CASINO_NIGHT}, 90)
    add_master_volume_override({MIDI.id.SONIC2_SPECIAL}, 90)
    add_master_volume_override({MIDI.id.SONICCD_SPECIAL}, 95)
    add_master_volume_override({MIDI.id.GIANTWING}, 90)
    add_master_volume_override({MIDI.id.EMERALDHILL}, 90)
    add_master_volume_override({MIDI.id.LIVE_AND_LEARN}, 83)
    add_master_volume_override({MIDI.id.STARDUST}, 95)
    add_master_volume_override({MIDI.id.GREEN_HILL_ZONE}, 89)
    add_master_volume_override({MIDI.id.CHEMICAL_PLANT}, 87)
    add_master_volume_override({MIDI.id.BABY_BOWSER}, 85)
    add_master_volume_override({MIDI.id.METALLIC_MADNESS}, 85)
    add_master_volume_override({MIDI.id.EVERYTHING}, 80)
    add_master_volume_override({MIDI.id.RACEWAYS}, 90)
    add_master_volume_override({MIDI.id.KIRBY_64_BOSS}, 90)
    add_master_volume_override({MIDI.id.SMB2_MEDLEY}, 90)
    add_master_volume_override({MIDI.id.SMW_TITLECREDITS}, 90)
    add_master_volume_override({MIDI.id.DEDEDE}, 80)
    add_master_volume_override({MIDI.id.IRON_BLUE_INTENTION}, 90)
    add_master_volume_override({MIDI.id.DRACULAS_TEARS}, 80)
    add_master_volume_override({MIDI.id.WARIOWARE}, 110)
    add_master_volume_override({MIDI.id.FROZEN_HILLSIDE}, 95)
    add_master_volume_override({MIDI.id.SOCCER_MENU}, 90)
    add_master_volume_override({MIDI.id.TROUBLE_MAKER}, 90)
    add_master_volume_override({MIDI.id.WL2_PERFECT}, 85)
    add_master_volume_override({MIDI.id.CONTROL}, 90)
    add_master_volume_override({MIDI.id.OEDO_EDO}, 95)
    add_master_volume_override({MIDI.id.MAJORA_MIDBOSS}, 92)
    add_master_volume_override({MIDI.id.SMW_ATHLETIC}, 85)
    add_master_volume_override({MIDI.id.BRAWL_OOT}, 110)
    add_master_volume_override({MIDI.id.BOSS_E}, 80)
    add_master_volume_override({MIDI.id.MARINE_FORTRESS}, 75)
    add_master_volume_override({MIDI.id.TWILIGHT_CITY}, 95)
    add_master_volume_override({MIDI.id.SOUTHERNISLAND}, 90)
    add_master_volume_override({MIDI.id.QUEST64_BATTLE}, 83)
    add_master_volume_override({MIDI.id.DECISIVE}, 90)
    add_master_volume_override({MIDI.id.HILLTOPCHASE}, 110)
    add_master_volume_override({MIDI.id.FF4BOSS}, 89)
    add_master_volume_override({MIDI.id.GRIMREAPERSCAVERN}, 90)
    add_master_volume_override({MIDI.id.SHANTAEMEDLEY}, 91)
    add_master_volume_override({MIDI.id.BURNINGTOWN}, 87)
    add_master_volume_override({MIDI.id.SHANTAEBOSS}, 90)
    add_master_volume_override({MIDI.id.FORTRESS_BOSS}, 90)
    add_master_volume_override({MIDI.id.HORROR_LAND}, 94)
    add_master_volume_override({MIDI.id.DARKWORLD}, 88)
    add_master_volume_override({MIDI.id.FRAPPE_SNOWLAND}, 92)
    add_master_volume_override({MIDI.id.SMRPG_BATTLE}, 85)
    add_master_volume_override({MIDI.id.TRAVELING}, 90)
    add_master_volume_override({MIDI.id.CHILL}, 112)
    add_master_volume_override({MIDI.id.ROLL}, 90)
    add_master_volume_override({MIDI.id.STICKERBRUSH_SYMPHONY}, 93)
    add_master_volume_override({MIDI.id.DKCTITLE}, 93)
    add_master_volume_override({MIDI.id.PLANTATION}, 87)
    add_master_volume_override({MIDI.id.7AM}, 110)
    add_master_volume_override({MIDI.id.QUEQUE}, 87)
    add_master_volume_override({MIDI.id.VSRIDLEY}, 95)
    add_master_volume_override({MIDI.id.FLANDRES_THEME}, 90)
    add_master_volume_override({MIDI.id.THE_ALOOF_SOLDIER}, 90)
    add_master_volume_override({MIDI.id.WENDYS_HOUSE}, 90)
    add_master_volume_override({MIDI.id.DANGEROUS_FOE}, 90)
    add_master_volume_override({MIDI.id.PIKA_CUP}, 85)
    add_master_volume_override({MIDI.id.WIZPIG}, 90)
    add_master_volume_override({MIDI.id.BATTLE_C1}, 80)
    add_master_volume_override({MIDI.id.CREDITS_BRAWL}, 90)
    add_master_volume_override({MIDI.id.BATTLE_GOLD_SILVER}, 90)
    add_master_volume_override({MIDI.id.GOLDENROD_CITY}, 90)
    add_master_volume_override({MIDI.id.GANONMEDLEY}, 80)
    add_master_volume_override({MIDI.id.FUGUE}, 85)
    add_master_volume_override({MIDI.id.SILVER_MOUNTAIN}, 85)
    add_master_volume_override({MIDI.id.PORKY}, 80)
    add_master_volume_override({MIDI.id.NSANITYBEACH}, 93)
    add_master_volume_override({MIDI.id.DISCOVERYFALLS}, 90)
    add_master_volume_override({MIDI.id.DK_MEDLEY}, 90)
    add_master_volume_override({MIDI.id.BIG_BRIDGE}, 93)
    add_master_volume_override({MIDI.id.HOGWILD}, 88)
    add_master_volume_override({MIDI.id.MARATHON}, 91)
    add_master_volume_override({MIDI.id.FORGONE}, 95)
    add_master_volume_override({MIDI.id.ELADARD}, 90)
    add_master_volume_override({MIDI.id.FZEROX_MEDLEY}, 115)
    add_master_volume_override({MIDI.id.BUBBLEGUM_KK}, 93)
    add_master_volume_override({MIDI.id.MADMAZEMAUL}, 80)
    add_master_volume_override({MIDI.id.TITANIA}, 93)
    add_master_volume_override({MIDI.id.SHEVAT}, 115)
    add_master_volume_override({MIDI.id.CORTEX}, 115)
    add_master_volume_override({MIDI.id.WILY_FIELD}, 111)
    add_master_volume_override({MIDI.id.SMS_BOSS}, 87)
    add_master_volume_override({MIDI.id.VS_DSAMUS}, 85)
    add_master_volume_override({MIDI.id.STRIKE_THE_EARTH}, 80)
    add_master_volume_override({MIDI.id.VAMPIREKILLER}, 88)
    add_master_volume_override({MIDI.id.REDIAL}, 95)
    add_master_volume_override({MIDI.id.AGAVE}, 95)
    add_master_volume_override({MIDI.id.RAIDBLUE}, 111)
    add_master_volume_override({MIDI.id.RISKNECK}, 111)
    add_master_volume_override({MIDI.id.SHERBETLAND}, 86)
    add_master_volume_override({MIDI.id.DEATH_MOUNTAIN}, 95)
    add_master_volume_override({MIDI.id.BATTLE_AMONG_FRIENDS}, 95)
    add_master_volume_override({MIDI.id.NBA_JAM}, 106)
    add_master_volume_override({MIDI.id.MURASAKI}, 115)
    add_master_volume_override({MIDI.id.FE6_MEDLEY}, 111)
    add_master_volume_override({MIDI.id.FUTUREFRENZY}, 107)
    add_master_volume_override({MIDI.id.LANKY_VICTORY}, 127)
    add_master_volume_override({MIDI.id.LIPS_THEME}, 95)
    add_master_volume_override({MIDI.id.CRASHBASH_LOADING}, 95)
    add_master_volume_override({MIDI.id.TREASURE_TROVE_COVE}, 95)
    add_master_volume_override({MIDI.id.GREENGARDEN}, 105)
    add_master_volume_override({MIDI.id.BLUE_RESORT}, 127)
    add_master_volume_override({MIDI.id.DRMARIO_VICTORY}, 127)
    add_master_volume_override({MIDI.id.BOWSERBOSS}, 88)
    add_master_volume_override({MIDI.id.LOST}, 93)
}

} // __MIDI__
