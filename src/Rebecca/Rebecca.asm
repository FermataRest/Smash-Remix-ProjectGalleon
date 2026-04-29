// JFox.asm

// This file contains file inclusions, action edits, and assembly for JFox.

scope Rebecca {
    // Insert Moveset files
    insert USP_GROUND_MOVE,"moveset/UP_SPECIAL_GROUND_MOVE.bin" // no end command, transitions into USP_LOOP
    insert USP_LOOP,"moveset/UP_SPECIAL_LOOP.bin"; Moveset.GO_TO(USP_LOOP)
    insert USP_AIR_MOVE,"moveset/UP_SPECIAL_AIR_MOVE.bin"; Moveset.GO_TO(USP_LOOP)
    insert DSMASH,"moveset/DSMASH.bin"
    UPSPECIALMID:; Moveset.CONCURRENT_STREAM(UPSPECIALMIDCONCURRENT); insert "moveset/UPSPECIALMID.bin"
    insert UPSPECIALMIDCONCURRENT,"moveset/UPSPECIALMIDCONCURRENT.bin"

    insert VICTORY1, "moveset/VICTORY_POSE_1.bin"
    insert VICTORY2, "moveset/VICTORY_POSE_2.bin"
    insert SPARKLE,"moveset/SPARKLE.bin"; Moveset.GO_TO(SPARKLE)                    // loops
    insert SHIELDBREAK, "moveset/SHIELDBREAK.bin"; Moveset.GO_TO(SPARKLE)                     // loops
    insert STUN, "moveset/STUN.bin"; Moveset.GO_TO(STUN)                    // loops
    insert SLEEP, "moveset/SLEEP.bin"; Moveset.GO_TO(SLEEP)                    // loops
    insert TAUNT, "moveset/TAUNT.bin"
    insert ROLLB, "moveset/ROLLB.bin"
    insert ROLLF, "moveset/ROLLF.bin"
    insert TECHF, "moveset/TECHF.bin"
    insert TECH, "moveset/TECH.bin"
    insert JUMPF, "moveset/JUMPF.bin"
    insert THROWFDATA,"moveset/THROWFDATA.bin"
    THROWF:; Moveset.THROW_DATA(THROWFDATA); insert "moveset/THROWF.bin"
    insert THROWBDATA,"moveset/THROWBDATA.bin"
    THROWB:; Moveset.THROW_DATA(THROWBDATA); insert "moveset/THROWB.bin"
    insert TEETER, "moveset/TEETER.bin"


    // Modify Action Parameters             // Action               // Animation                // Moveset Data             // Flags
    Character.edit_action_parameters(REBECCA, 0xE7,                   -1,                         USP_GROUND_MOVE,            -1)
    Character.edit_action_parameters(REBECCA, 0xE8,                   -1,                         USP_AIR_MOVE,               -1)
    Character.edit_action_parameters(REBECCA, Action.DSmash,          -1,                         DSMASH,                     -1)
    Character.edit_action_parameters(REBECCA, 0xE5,                   -1,                         UPSPECIALMID,               -1)
    Character.edit_action_parameters(REBECCA, 0xE6,                   -1,                         UPSPECIALMID,               -1)

    Character.edit_action_parameters(REBECCA, Action.Stun,            -1,                         STUN,                     -1)
    Character.edit_action_parameters(REBECCA, Action.Sleep,           -1,                          SLEEP,                     -1)
    Character.edit_action_parameters(REBECCA, Action.ShieldBreak,     -1,                    SHIELDBREAK,                     -1)
    Character.edit_action_parameters(REBECCA, Action.Taunt,          -1,                         TAUNT,                     -1)
    Character.edit_action_parameters(REBECCA, Action.RollB,          -1,                         ROLLB,                     -1)
    Character.edit_action_parameters(REBECCA, Action.RollF,          -1,                         ROLLF,                     -1)
    Character.edit_action_parameters(REBECCA, Action.TechF,          -1,                         TECHF,                     -1)
    Character.edit_action_parameters(REBECCA, Action.TechB,          -1,                         TECHF,                     -1)
    Character.edit_action_parameters(REBECCA, Action.Tech,          -1,                          TECH,                     -1)
    Character.edit_action_parameters(REBECCA, Action.JumpAerialF,          -1,                   JUMPF,                     -1)
    Character.edit_action_parameters(REBECCA, Action.JumpAerialB,          -1,                   JUMPF,                     -1)
    Character.edit_action_parameters(REBECCA, Action.ThrowF,          -1,                   THROWF,                     -1)
    Character.edit_action_parameters(REBECCA, Action.ThrowB,          -1,                   THROWB,                     -1)
    Character.edit_action_parameters(REBECCA, Action.Teeter,          -1,                   TEETER,                     -1)


    // Modify Menu Action Parameters              // Action // Animation                // Moveset Data             // Flags
    Character.edit_menu_action_parameters(REBECCA, 0x1,          -1,      VICTORY1,                        -1)
    Character.edit_menu_action_parameters(REBECCA, 0x2,          -1,      VICTORY1,                        -1)
    Character.edit_menu_action_parameters(REBECCA, 0x3,          -1,      VICTORY2,                        -1)
    Character.edit_menu_action_parameters(REBECCA, 0x4,          -1,      VICTORY2,                        -1)





    // Set action strings
    Character.table_patch_start(action_string, Character.id.JFOX, 0x4)
    dw  Action.FOX.action_string_table
    OS.patch_end()

    // Set Remix 1P ending music
    Character.table_patch_start(remix_1p_end_bgm, Character.id.JFOX, 0x2)
    dh {MIDI.id.STARFOX_MEDLEY}
    OS.patch_end()

    // Set crowd chant FGM.
    Character.table_patch_start(crowd_chant_fgm, Character.id.REBECCA, 0x2)
    dh  0x06DD
    OS.patch_end()

    // Set default costumes
    Character.set_default_costumes(Character.id.REBECCA, 0, 1, 2, 3, 0, 1, 2)
    Teams.add_team_costume(YELLOW, REBECCA, 0x5)


}


