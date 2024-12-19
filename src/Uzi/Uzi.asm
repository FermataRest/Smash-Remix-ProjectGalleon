// Uzi.asm

// This file contains file inclusions, action edits, and assembly for Uzi.

scope Uzi {

    // Insert Moveset files
    insert TAUNT, "moveset/TAUNT.bin"
    insert RUN, "moveset/RUN.bin"; Moveset.GO_TO(RUN) // loops
    insert RAILGUN, "moveset/RAILGUN.bin"
    insert RAILGUN_AERIAL, "moveset/RAILGUN_AERIAL.bin"
    insert SPARKLE, "moveset/SPARKLE.bin"; Moveset.GO_TO(SPARKLE) // loops
    insert BITCHDOWN, "moveset/DOORMAN_BROKE.bin"; Moveset.GO_TO(SPARKLE) // loops
    insert SHITHEAVY, "moveset/HEAVYPICK.bin"
    insert JUMP, "moveset/JUMP1.bin"
    insert JUMP_2, "moveset/JUMP2.bin"
    insert STUN, "moveset/STUN.bin"; Moveset.GO_TO(STUN2) // loops
    insert STUN2, "moveset/STUN2.bin"; Moveset.GO_TO(STUN2) // loops
    insert SLEEP, "moveset/SLEEP.bin"; Moveset.GO_TO(SLEEP) // loops
    insert LOSE, "moveset/LOSE.bin"

    // @ Description
    // Uzi's Extra Actions
    scope Action {

    // strings!

    action_string_table:
    }

    // Modify Action Parameters           // Action                     // Animation                    // Moveset Data             // Flags
    Character.edit_action_parameters(UZI, 0xE1,                         -1,                             RAILGUN,                     0)
    Character.edit_action_parameters(UZI, 0xE2,                         -1,                             RAILGUN_AERIAL,              0)
    Character.edit_action_parameters(UZI, Action.Taunt,                 File.UZI_TAUNT,                 TAUNT,                      -1)
    Character.edit_action_parameters(UZI, Action.ReviveWait,            File.UZI_IDLE,                  -1,                         -1)
    Character.edit_action_parameters(UZI, Action.Idle,                  File.UZI_IDLE,                  -1,                         -1)
    Character.edit_action_parameters(UZI, Action.Run,                   File.UZI_RUN,                   RUN,                        -1)
    Character.edit_action_parameters(UZI, Action.Walk2,                 File.UZI_WALK2,                 -1,                         -1)
    Character.edit_action_parameters(UZI, Action.Walk3,                 File.UZI_WALK3,                 -1,                         -1)
    Character.edit_action_parameters(UZI, Action.ShieldBreak,           -1,                             BITCHDOWN,                  -1)
    Character.edit_action_parameters(UZI, Action.Stun,                  File.UZI_STUNSLEEP,             STUN,                       -1)
    Character.edit_action_parameters(UZI, Action.Sleep,                 File.UZI_STUNSLEEP,             SLEEP,                      -1) 
    Character.edit_action_parameters(UZI, Action.HeavyItemPickup,       -1,                             SHITHEAVY,                  -1)
    Character.edit_action_parameters(UZI, Action.JumpF,                 -1,                             JUMP,                       -1)
    Character.edit_action_parameters(UZI, Action.JumpB,                 -1,                             JUMP,                       -1)
    Character.edit_action_parameters(UZI, Action.JumpAerialF,           -1,                             JUMP_2,                     -1)
    Character.edit_action_parameters(UZI, Action.JumpAerialB,           -1,                             JUMP_2,                     -1)

    // Modify Actions                     // Action              // Staling ID   // Main ASM                // Interrupt/Other ASM        // Movement/Physics ASM         // Collision ASM
    Character.edit_action(UZI,            0xE1,                  -1,             UziNSP.main_,              -1,                           -1,                             -1)
    Character.edit_action(UZI,            0xE2,                  -1,             UziNSP.main_,              -1,                           -1,                             UziNSP.air_collision_)

    // Modify Menu Action Parameters           // Action    // Animation             // Moveset Data     // Flags
    Character.edit_menu_action_parameters(UZI, 0x0,         File.UZI_IDLE,           -1,                 -1)
    //Character.edit_menu_action_parameters(UZI, 0x1,         File.UZI_VICTORY_1,      VICTORY_1,          -1)
    //Character.edit_menu_action_parameters(UZI, 0x2,         File.UZI_VICTORY_2,      VICTORY_2,          -1)
    //Character.edit_menu_action_parameters(UZI, 0x3,         File.UZI_VICTORY_3,      VICTORY_3,          -1)
    //Character.edit_menu_action_parameters(UZI, 0x4,         File.UZI_SELECT,         SELECT,             -1)
    Character.edit_menu_action_parameters(UZI, 0x5,         File.UZI_LOSE,           LOSE,               -1)
    //Character.edit_menu_action_parameters(UZI, 0x9,         File.UZI_GAME_OVER,      -1,                 -1)
    //Character.edit_menu_action_parameters(UZI, 0xA,         File.UZI_GAME_CONTINUE,  -1,                 -1)
    //Character.edit_menu_action_parameters(UZI, 0xD,         File.UZI_POSE_1P,        0x80000000,         -1)
    //Character.edit_menu_action_parameters(UZI, 0xE,         File.UZI_POSE_1P_CPU,    0x80000000,         -1)

    // Add Action Parameters             // Action Name       // Base Action   // Animation                // Moveset Data       // Flags
    //Character.add_new_action_params(UZI, USP_Ground,          -1,              File.UZI_USPG,              USPG,                 0)
    // ^ placeholder stuff ^
    // Add Actions                // Action Name      // Base Action      //Parameters                  // Staling ID   // Main ASM                // Interrupt/Other ASM         // Movement/Physics ASM  	        // Collision ASM
    //Character.add_new_action(UZI, USP_Ground,         -1,                 ActionParams.USP_Ground,      0x1E,           UziUSP.main_,              0,                             UziUSP.ground_physics_,           UziUSP.ground_collision_)
    // ^ placeholder stuff ^

    // Set default costumes
    Character.set_default_costumes(Character.id.UZI, 0, 1, 2, 3, 1, 0, 2)
    Teams.add_team_costume(YELLOW, UZI, 0x3)

    // Set default costume shield colors
    Character.set_costume_shield_colors(UZI, AZURE, RED, GREEN, YELLOW, BLACK, WHITE, GREEN, YELLOW)
    
    // Use Mario's initial/grounded script.
    Character.table_patch_start(initial_script, Character.id.UZI, 0x4)
    dw 0x800D7DCC
    OS.patch_end()
    Character.table_patch_start(grounded_script, Character.id.UZI, 0x4)
    dw 0x800DE428
    OS.patch_end()

    // Set crowd chant FGM.
    Character.table_patch_start(crowd_chant_fgm, Character.id.UZI, 0x2)
    dh  0x058B
    OS.patch_end()

    // Set menu zoom size.
    Character.table_patch_start(menu_zoom, Character.id.UZI, 0x4)
    float32 1.125
    OS.patch_end()

}