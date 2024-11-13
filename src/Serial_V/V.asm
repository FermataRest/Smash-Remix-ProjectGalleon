// V.asm

// This file contains file inclusions, action edits, and assembly for V.

scope V {

    // Insert Moveset files
    insert RUN, "moveset/RUN.bin"; Moveset.GO_TO(RUN) // loops
    insert SPARKLE, "moveset/SPARKLE.bin"; Moveset.GO_TO(SPARKLE) // loops
    insert BITCHDOWN, "moveset/SERIALLY_BROKE.bin"; Moveset.GO_TO(SPARKLE) // loops
    insert STUN, "moveset/STUN.bin"; Moveset.GO_TO(STUN2) // loops
    insert STUN2, "moveset/STUN2.bin"; Moveset.GO_TO(STUN2) // loops
    insert SLEEP, "moveset/SLEEP.bin"; Moveset.GO_TO(SLEEP) // loops

    // @ Description
    // V's Extra Actions
    scope Action {

    // strings!

    action_string_table:
    }

    // Modify Action Parameters         // Action                       // Animation                    // Moveset Data             // Flags
    Character.edit_action_parameters(V, Action.ShieldBreak,             -1,                             BITCHDOWN,                  -1)
    Character.edit_action_parameters(V, Action.Stun,                    -1,                             STUN,                       -1)
    Character.edit_action_parameters(V, Action.Sleep,                   -1,                             SLEEP,                      -1) 

    // Modify Actions                     // Action              // Staling ID   // Main ASM                // Interrupt/Other ASM        // Movement/Physics ASM         // Collision ASM

    // Modify Menu Action Parameters         // Action    // Animation           // Moveset Data     // Flags
    //Character.edit_menu_action_parameters(V, 0x0,         File.V_IDLE,           -1,                 -1)
    //Character.edit_menu_action_parameters(V, 0x1,         File.V_VICTORY_1,      VICTORY_1,          -1)
    //Character.edit_menu_action_parameters(V, 0x2,         File.V_VICTORY_2,      VICTORY_2,          -1)
    //Character.edit_menu_action_parameters(V, 0x3,         File.V_VICTORY_3,      VICTORY_3,          -1)
    //Character.edit_menu_action_parameters(V, 0x4,         File.V_SELECT,         SELECT,             -1)
    //Character.edit_menu_action_parameters(V, 0x5,         File.V_LOSE,           LOSE,               -1)
    //Character.edit_menu_action_parameters(V, 0x9,         File.V_GAME_OVER,      -1,                 -1)
    //Character.edit_menu_action_parameters(V, 0xA,         File.V_GAME_CONTINUE,  -1,                 -1)
    //Character.edit_menu_action_parameters(V, 0xD,         File.V_POSE_1P,        0x80000000,         -1)
    //Character.edit_menu_action_parameters(V, 0xE,         File.V_POSE_1P_CPU,    0x80000000,         -1)

    // Set default costumes
    Character.set_default_costumes(Character.id.V, 0, 1, 2, 3, 1, 0, 2)
    Teams.add_team_costume(YELLOW, V, 0x3)

    // Set default costume shield colors
    Character.set_costume_shield_colors(V, YELLOW, RED, AZURE, GREEN, BLACK, WHITE, GREEN, YELLOW)
    
    // Use Mario's initial/grounded script.
    Character.table_patch_start(initial_script, Character.id.V, 0x4)
    dw 0x800D7DCC
    OS.patch_end()
    Character.table_patch_start(grounded_script, Character.id.V, 0x4)
    dw 0x800DE428
    OS.patch_end()
    
    // Set menu zoom size.
    Character.table_patch_start(menu_zoom, Character.id.V, 0x4)
    float32 1.2
    OS.patch_end()
}