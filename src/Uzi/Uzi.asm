// Uzi.asm

// This file contains file inclusions, action edits, and assembly for Uzi.

scope Uzi {

	// Insert Moveset files
	insert TAUNT, "moveset/TAUNT.bin"
	insert RUN, "moveset/RUN.bin"
	insert RAILGUN, "moveset/RAILGUN.bin"
	insert BITCHDOWN, "moveset/DOORMAN_BROKE.bin"
	insert SHITHEAVY, "moveset/HEAVYPICK.bin"
	insert JUMP, "moveset/JUMP1.bin"
	insert JUMP_2, "moveset/JUMP2.bin"

	// @ Description
	// Uzi's Extra Actions
    scope Action {

	// strings!

	action_string_table:
	}

	// Modify Action Parameters           // Action                  // Animation                   // Moveset Data           // Flags
    Character.edit_action_parameters(UZI, 0xE1,                      -1,                            RAILGUN,                  0)
 	Character.edit_action_parameters(UZI, 0xE2,                      -1,                            RAILGUN,                  0)
	Character.edit_action_parameters(UZI, Action.Taunt,              File.UZI_TAUNT,                TAUNT,                   -1)
	Character.edit_action_parameters(UZI, Action.Idle,               File.UZI_IDLE,                 -1,                      -1)
	Character.edit_action_parameters(UZI, Action.Run,                File.UZI_RUN,                  RUN,                     -1)
	Character.edit_action_parameters(UZI, Action.Walk2,              File.UZI_WALK2,                -1,                      -1)
	Character.edit_action_parameters(UZI, Action.Walk3,              File.UZI_WALK3,                -1,                      -1)
    Character.edit_action_parameters(UZI, Action.ShieldBreak,        File.UZI_SHIELD_BREAK,         BITCHDOWN,               -1)
	Character.edit_action_parameters(UZI, Action.HeavyItemPickup,    File.UZI_HEAVYITEMPICK,        SHITHEAVY,               -1)
	Character.edit_action_parameters(UZI, Action.JumpF,              File.UZI_JUMP_F,               JUMP,                    -1)
    Character.edit_action_parameters(UZI, Action.JumpB,              File.UZI_JUMP_B,               JUMP,                    -1)
    Character.edit_action_parameters(UZI, Action.JumpAerialF,        File.UZI_JUMP_AF,              JUMP_2,                  -1)
    Character.edit_action_parameters(UZI, Action.JumpAerialB,        File.UZI_JUMP_AB,              JUMP_2,                  -1)

	// Modify Menu Action Parameters           // Action         // Animation                  // Moveset Data           // Flags
	Character.edit_menu_action_parameters(UZI, 0x0,              File.UZI_IDLE,                -1,                       -1)

    // Modify Actions                     // Action              // Staling ID   // Main ASM                // Interrupt/Other ASM        // Movement/Physics ASM         // Collision ASM
    Character.edit_action(UZI,            0xE1,                  -1,             UziNSP.main_,              -1,                           -1,                             -1)
    Character.edit_action(UZI,            0xE2,                  -1,             UziNSP.main_,              -1,                           -1,                             UziNSP.air_collision_)

	// Add Action Parameters                  // Action Name       // Base Action   // Animation                // Moveset Data       // Flags

	// Add Actions                     // Action Name     // Base Action  //Parameters                    // Staling ID   // Main ASM                       // Interrupt/Other ASM           // Movement/Physics ASM  	          // Collision ASM


	// Set default costumes
    Character.set_default_costumes(Character.id.UZI, 0, 1, 2, 3, 1, 0, 2)
    Teams.add_team_costume(YELLOW, UZI, 0x3)

	// Set default costume shield colors
	Character.set_costume_shield_colors(UZI, AZURE, RED, GREEN, YELLOW, BLACK, WHITE, GREEN, YELLOW)

}