// Uzi.asm

// This file contains file inclusions, action edits, and assembly for Uzi.

scope Uzi {



    scope MODEL {

        scope WEAPON {
            constant RAILGUN(0xA0880000)
        }
    }

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
    insert SELECT, "moveset/SELECT.bin"
    insert IDLE, "moveset/IDLE.bin"
    insert DSMASH, "moveset/DSMASH.bin"
    insert FAIR, "moveset/FAIR.bin"
    insert JAB1, "moveset/JAB1.bin"
    insert JAB2, "moveset/JAB2.bin"

    NSP_BEGIN:; dw MODEL.WEAPON.RAILGUN; insert "moveset/NSP_BEGIN.bin"
    NSP_WAIT:; dw MODEL.WEAPON.RAILGUN; insert "moveset/NSP_WAIT.bin"
    NSP_END:; dw MODEL.WEAPON.RAILGUN; insert "moveset/NSP_END.bin"

    // @ Description
    // Uzi's Extra Actions
    scope Action {

    // strings!

    action_string_table:
    }

    // Modify Action Parameters           // Action                     // Animation                    // Moveset Data             // Flags
    Character.edit_action_parameters(UZI, 0xE1,                         File.UZI_LASER,                 RAILGUN,                     0)
    Character.edit_action_parameters(UZI, 0xE2,                         File.UZI_LASERA,                RAILGUN_AERIAL,              0)
    Character.edit_action_parameters(UZI, Action.Taunt,                 File.UZI_TAUNT,                 TAUNT,                      -1)
    Character.edit_action_parameters(UZI, Action.ReviveWait,            File.UZI_IDLE,                  -1,                         -1)
    Character.edit_action_parameters(UZI, Action.Idle,                  File.UZI_IDLE,                  IDLE,                         -1)
    Character.edit_action_parameters(UZI, Action.Run,                   File.UZI_RUN,                   RUN,                        -1)
    Character.edit_action_parameters(UZI, Action.Walk2,                 File.UZI_WALK2,                 -1,                         -1)
    Character.edit_action_parameters(UZI, Action.Walk3,                 File.UZI_WALK3,                 -1,                         -1)
    Character.edit_action_parameters(UZI, Action.ShieldBreak,           -1,                             BITCHDOWN,                  -1)
    Character.edit_action_parameters(UZI, Action.Stun,                  File.UZI_STUNSLEEP,             STUN,                       -1)
    Character.edit_action_parameters(UZI, Action.Sleep,                 File.UZI_STUNSLEEP,             SLEEP,                      -1) 
    Character.edit_action_parameters(UZI, Action.HeavyItemPickup,       -1,                             SHITHEAVY,                  -1)
    Character.edit_action_parameters(UZI, Action.JumpF,                 File.UZI_JUMPF,                 JUMP,                       -1)
    Character.edit_action_parameters(UZI, Action.JumpB,                 -1,                             JUMP,                       -1)
    Character.edit_action_parameters(UZI, Action.JumpAerialF,           -1,                             JUMP_2,                     -1)
    Character.edit_action_parameters(UZI, Action.JumpAerialB,           -1,                             JUMP_2,                     -1)
    Character.edit_action_parameters(UZI, Action.DSmash,                File.UZI_DSMASH,                DSMASH,                     -1)
    Character.edit_action_parameters(UZI, Action.AttackAirF,            File.UZI_FAIR,                  FAIR,                       -1)
    Character.edit_action_parameters(UZI, Action.Jab1,                  File.UZI_JAB1,                  JAB1,                       -1)
    Character.edit_action_parameters(UZI, Action.Jab2,                  File.UZI_JAB2,                  JAB2,                       -1)


    // Modify Menu Action Parameters           // Action    // Animation             // Moveset Data     // Flags
    Character.edit_menu_action_parameters(UZI, 0x0,         File.UZI_IDLE,              IDLE,                 -1)
    //Character.edit_menu_action_parameters(UZI, 0x1,         File.UZI_VICTORY_1,      VICTORY_1,          -1)
    //Character.edit_menu_action_parameters(UZI, 0x2,         File.UZI_VICTORY_2,      VICTORY_2,          -1)
    //Character.edit_menu_action_parameters(UZI, 0x3,         File.UZI_VICTORY_3,      VICTORY_3,          -1)
    Character.edit_menu_action_parameters(UZI, 0x4,         File.UZI_SELECT,         SELECT,             -1)
    Character.edit_menu_action_parameters(UZI, 0x5,         File.UZI_LOSE,           LOSE,               -1)
    //Character.edit_menu_action_parameters(UZI, 0x9,         File.UZI_GAME_OVER,      -1,                 -1)
    //Character.edit_menu_action_parameters(UZI, 0xA,         File.UZI_GAME_CONTINUE,  -1,                 -1)
    //Character.edit_menu_action_parameters(UZI, 0xD,         File.UZI_POSE_1P,        0x80000000,         -1)
    //Character.edit_menu_action_parameters(UZI, 0xE,         File.UZI_POSE_1P_CPU,    0x80000000,         -1)

    // Add Action Parameters                // Action Name      // Base Action  // Animation                // Moveset Data             // Flags
    Character.add_new_action_params(UZI, NSP_Ground_Begin,   -1,             File.UZI_NSP_PULL,     NSP_BEGIN,                  0)
    Character.add_new_action_params(UZI, NSP_Ground_Wait,    -1,             File.UZI_NSP_IDLE,      NSP_WAIT,                   0)
    Character.add_new_action_params(UZI, NSP_Ground_Walk1,   -1,             File.UZI_NSP_WALK,    NSP_WAIT,                   0)
    Character.add_new_action_params(UZI, NSP_Ground_Walk2,   -1,             File.UZI_NSP_WALK2,    NSP_WAIT,                   0)
    Character.add_new_action_params(UZI, NSP_Ground_BWalk1,  -1,             File.UZI_NSP_WALKR,   NSP_WAIT,                   0)
    Character.add_new_action_params(UZI, NSP_Ground_BWalk2,  -1,             File.UZI_NSP_WALK2R,   NSP_WAIT,                   0)
    Character.add_new_action_params(UZI, NSP_Ground_End,     -1,             File.UZI_NSP_SHOOT,       NSP_END,                    0)
    Character.add_new_action_params(UZI, NSP_Air_Begin,      -1,             File.UZI_NSP_PULL,     NSP_BEGIN,                  0)
    Character.add_new_action_params(UZI, NSP_Air_Wait,       -1,             File.UZI_NSP_IDLE,      NSP_WAIT,                   0)
    Character.add_new_action_params(UZI, NSP_Air_End,        -1,             File.UZI_NSP_SHOOT,       NSP_END,                    0)

    // Add Actions                   // Action Name     // Base Action  //Parameters                    // Staling ID   // Main ASM                     // Interrupt/Other ASM          // Movement/Physics ASM             // Collision ASM
    Character.add_new_action(UZI, NSP_Ground_Begin,  -1,             ActionParams.NSP_Ground_Begin,  0x12,           UziNSP.ground_begin_main_,   0,                              0x800D8BB4,                         UziNSP.ground_collision_)
    Character.add_new_action(UZI, NSP_Ground_Wait,   -1,             ActionParams.NSP_Ground_Wait,   0x12,           UziNSP.ground_wait_main_,    UziNSP.ground_interrupt_,    0x800D8BB4,                         UziNSP.ground_collision_)
    Character.add_new_action(UZI, NSP_Ground_Walk1,  -1,             ActionParams.NSP_Ground_Walk1,  0x12,           UziNSP.ground_wait_main_,    UziNSP.ground_interrupt_,    UziNSP.ground_walk_physics_,     UziNSP.ground_collision_)
    Character.add_new_action(UZI, NSP_Ground_Walk2,  -1,             ActionParams.NSP_Ground_Walk2,  0x12,           UziNSP.ground_wait_main_,    UziNSP.ground_interrupt_,    UziNSP.ground_walk_physics_,     UziNSP.ground_collision_)
    Character.add_new_action(UZI, NSP_Ground_BWalk1, -1,             ActionParams.NSP_Ground_BWalk1, 0x12,           UziNSP.ground_wait_main_,    UziNSP.ground_interrupt_,    UziNSP.ground_back_walk_physics_, UziNSP.ground_collision_)
    Character.add_new_action(UZI, NSP_Ground_BWalk2, -1,             ActionParams.NSP_Ground_BWalk2, 0x12,           UziNSP.ground_wait_main_,    UziNSP.ground_interrupt_,    UziNSP.ground_back_walk_physics_, UziNSP.ground_collision_)
    Character.add_new_action(UZI, NSP_Ground_End,    -1,             ActionParams.NSP_Ground_End,    0x12,           UziNSP.end_main_,            0,                           0x800D8BB4,                         UziNSP.ground_collision_)
    Character.add_new_action(UZI, NSP_Air_Begin,     -1,             ActionParams.NSP_Air_Begin,     0x12,           UziNSP.air_begin_main_,      0,                           UziNSP.air_physics_,             UziNSP.air_collision_)
    Character.add_new_action(UZI, NSP_Air_Wait,      -1,             ActionParams.NSP_Air_Wait,      0x12,           UziNSP.air_wait_main_,       0,                           UziNSP.air_physics_,             UziNSP.air_collision_)
    Character.add_new_action(UZI, NSP_Air_End,       -1,             ActionParams.NSP_Air_End,       0x12,           UziNSP.end_main_,            0,                           UziNSP.air_physics_,             UziNSP.air_collision_)


    Character.table_patch_start(ground_nsp, Character.id.UZI, 0x4)
    dw      UziNSP.ground_begin_initial_
    OS.patch_end()
    Character.table_patch_start(air_nsp, Character.id.UZI, 0x4)
    dw      UziNSP.air_begin_initial_
    OS.patch_end()

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

    // @ Description
    // s0 = item struct
    // s1 = player struct
    // Edits routine 800E3048 ;(known as ftMainUpdateShieldStatWeapon in decomp)
    scope ggun_reflect: {
        OS.patch_start(0x5E92C, 0x800E312C)
        sw      v1, 0x07C8(s1)      // og line 2
        j       ggun_reflect
        _return:
        OS.patch_end()

        addiu   t2, r0, Character.id.UZI             // t2 = Uzi char id
        addiu   t3, r0, Item.GoldenGun.PROJECTILE_ID // t3 = Golden Gun id

        lw      at, 0x0008(s1)      // at = current char id
        bne     at, t2, _regular    // stop if current char id != Uzi
        lw      at, 0x000C(s0)      // at = held item id
        bne     at, t3, _regular    // branch if held item id != golden gun

        addiu   t2, r0, 0x0005      // t2 = 5
        sw      t2, 0x07C8(s1)      // shield damage = t2
        lw      t3, 0x0054(sp)      // get gobj of player reflecting
        sw      t3, 0x0008(s0)      // set weapon owner to player reflecting

        OS.save_registers()
        jal     0x800269C0          // play fgm
        addiu   a0, r0, 0x058E      // fgm id = 0x58E (Shield Ricochet)
        OS.restore_registers()

        lwc1    f6, 0x0020(s0)      // f6 = bullet x vel
        neg.s   f4, f6              // f4 = -f6
        j       _return             // ~
        swc1    f4, 0x0020(s0)      // bullet x vel = f4

        _regular:
        j       _return
        sw      t6, 0x07CC(s1)      // og line 1
    }

}