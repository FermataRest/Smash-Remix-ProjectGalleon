// Goku.asm

// This file contains file inclusions, action edits, and assembly for Goku.

scope Goku {
    // Insert Moveset files
    insert FSMASH, "moveset/FSMASH.bin"

    NSP_BEGIN:; insert "moveset/NSP_BEGIN.bin"
    NSP_WAIT:; insert "moveset/NSP_WAIT.bin"
    NSP_END:; insert "moveset/NSP_END.bin"
    JAB1:; insert "moveset/JAB1.bin"
    JAB2:; insert "moveset/JAB2.bin"
    JAB3:; insert "moveset/JAB3.bin"
    JABLSTART:; insert "moveset/JABLSTART.bin"
    JABLOOP:
    insert JAB_SUBROUTINE,"moveset/JAB_SUBROUTINE.bin"
    Moveset.GO_TO(JABLOOP)              // go to beginning
    insert JAB_LOOP_END,"moveset/JAB_LOOP_END.bin"
    insert NSP_CHARGE,"moveset/NSP_CHARGE.bin"
    insert NSP_MOVE,"moveset/NSP_MOVE.bin"

    insert TECH, "moveset/TECH.bin"
    insert TECHF, "moveset/TECHF.bin"
    insert JUMPAERIAL, "moveset/JUMPAERIALF.bin"
    insert JUMPF, "moveset/JUMPF.bin"

    insert DASHATTACK, "moveset/DASHATTACK.bin"

    insert NSPG_BEGIN,"moveset/NSPG_BEGIN.bin"
    insert NSPG_CHARGE, "moveset/NSPG_CHARGE.bin"
    insert NSP_CHARGE_LOOP, "moveset/NSP_CHARGE_LOOP.bin"; Moveset.GO_TO(NSP_CHARGE_LOOP) // loops
    insert NSPA_CHARGE, "moveset/NSPA_CHARGE.bin"; Moveset.GO_TO(NSP_CHARGE_LOOP) // go to loop
    insert NSPG_SHOOT,"moveset/NSPG_SHOOT.bin"
    insert NSPA_BEGIN,"moveset/NSPA_BEGIN.bin"
    insert NSPA_SHOOT,"moveset/NSPA_SHOOT.bin"

    NSP_BOUNCE:; insert "moveset/NSP_BOUNCE.bin"

    NSPG:
    dw 0x98004C00, 0x00000000, 0xFF4C0000, 0x00000000
    NSP:
    Moveset.HIDE_ITEM()
    Moveset.SFX(44)                                 // click
    Moveset.AFTER(4)
    Moveset.VOICE(1516)                             // YEH
    Moveset.AFTER(20)
    Moveset.SET_FLAG(0)                             // spawn projectile
    Moveset.SET_FLAG(1)                             // allow cancel
    Moveset.HURTBOXES(3)                            // intangible
    Moveset.CREATE_GFX(18, 31, 0, -300, 0, 20, 20, 20) // spark on grape shooter
    Moveset.SFX(1520)                               // grape shooter sound
    Moveset.SFX(42)                                 // whoosh sound
    Moveset.AFTER(22)
    Moveset.HURTBOXES(1)                            // vulnerable
    Moveset.AFTER(28)
    Moveset.AFTER(36)
    dw 0x58000000                                   // disallow cancel
    dw 0

    NSPA:
    dw 0x98004000, 0x00000000, 0xFF6A0000, 0x00000000
    Moveset.GO_TO(NSP)



    // Modify Action Parameters             // Action               // Animation                // Moveset Data             // Flags
    Character.edit_action_parameters(GOKU, Action.Idle,              File.GOKU_IDLE,                 -1,                       -1)
    Character.edit_action_parameters(GOKU, Action.Jab1,              File.GOKU_JAB1,                 JAB1,                     -1)
    Character.edit_action_parameters(GOKU, Action.Jab2,              File.GOKU_JAB2,                 JAB2,                     -1)
    Character.edit_action_parameters(GOKU, 0x0DC,                    File.GOKU_JAB3,                 JAB3,                     -1)
    Character.edit_action_parameters(GOKU, 0x0DD,                    -1,                             JABLSTART,                -1)
    Character.edit_action_parameters(GOKU, 0x0DE,                    File.GOKU_JABLOOP,             JABLOOP,                   -1)

    Character.edit_action_parameters(GOKU, Action.Tech,                  -1,                              TECH,                       -1)
    Character.edit_action_parameters(GOKU, Action.TechF,                 -1,                             TECHF,                       -1)
    Character.edit_action_parameters(GOKU, Action.TechB,                 -1,                             TECHF,                       -1)
    Character.edit_action_parameters(GOKU, Action.JumpAerialF,                 -1,                       JUMPAERIAL,                       -1)
    Character.edit_action_parameters(GOKU, Action.JumpAerialB,                 -1,                       JUMPAERIAL,                       -1)
    Character.edit_action_parameters(GOKU, Action.JumpF,                 File.GOKU_JUMPF,                               JUMPF,                       -1)

    Character.edit_action_parameters(GOKU, Action.JumpB,                 File.GOKU_JUMPB,                               JUMPF,                       -1)
    Character.edit_action_parameters(GOKU, Action.DTilt,                 File.GOKU_DTILT,                  -1,                       -1)
    Character.edit_action_parameters(GOKU, Action.UTilt,                 File.GOKU_UTILT,                  -1,                       -1)
    Character.edit_action_parameters(GOKU, Action.Fall,                 File.GOKU_FALL,                  -1,                       -1)
    Character.edit_action_parameters(GOKU, Action.Crouch,                 File.GOKU_CROUCH,                  -1,                       -1)
    Character.edit_action_parameters(GOKU, Action.CrouchEnd,                 File.GOKU_CROUCHEND,                  -1,                       -1)
    Character.edit_action_parameters(GOKU, Action.CrouchIdle,                 File.GOKU_CROUCHWAIT,                  -1,                       -1)
    Character.edit_action_parameters(GOKU, Action.DashAttack,                 File.GOKU_DASHATTACK,            DASHATTACK,                       -1)
    Character.edit_action_parameters(GOKU, Action.AttackAirN,                 File.GOKU_NAIR,                  -1,                       -1)
    Character.edit_action_parameters(GOKU, Action.AttackAirB,                 File.GOKU_BAIR,                  -1,                       -1)
    Character.edit_action_parameters(GOKU, Action.AttackAirD,                 File.GOKU_DAIR,                  -1,                       -1)
    Character.edit_action_parameters(GOKU, Action.AttackAirU,                 File.GOKU_UAIR,                  -1,                       -1)
    Character.edit_action_parameters(GOKU, Action.USmash,                     File.GOKU_USMASH,                  -1,                       -1)
    Character.edit_action_parameters(GOKU, Action.DSmash,                     File.GOKU_DSMASH,                  -1,                       -1)

    Character.edit_action_parameters(GOKU, Action.FTiltHigh,               0,                              0x80000000,                 -1)
    Character.edit_action_parameters(GOKU, Action.FTiltMidHigh,            0,                              0x80000000,                 -1)
    Character.edit_action_parameters(GOKU, Action.FTilt,                   File.GOKU_FTILT,              -1,                      -1)
    Character.edit_action_parameters(GOKU, Action.FTiltMidLow,             0,                              0x80000000,                 -1)
    Character.edit_action_parameters(GOKU, Action.FTiltLow,                0,                              0x80000000,                 -1)

    Character.edit_action_parameters(GOKU, Action.FSmashHigh,              0,                             0x80000000,                0)
    Character.edit_action_parameters(GOKU, Action.FSmashMidHigh,           0,                             0x80000000,                0)
    Character.edit_action_parameters(GOKU, Action.FSmash,                  File.GOKU_FSMASH,             -1,                        -1)
    Character.edit_action_parameters(GOKU, Action.FSmashMidLow,            0,                             0x80000000,                 0)
    Character.edit_action_parameters(GOKU, Action.FSmashLow,               0,                             0x80000000,                 0)

    Character.edit_action_parameters(GOKU, Action.AttackAirF,         File.GOKU_FAIR,                -1,                  -1)

    Character.edit_action_parameters(GOKU, Action.FSmash,          -1,                            FSMASH,                     0x40000000)


    // Modify Actions            // Action          // Staling ID   // Main ASM                 // Interrupt/Other ASM          // Movement/Physics ASM         // Collision ASM
    Character.edit_menu_action_parameters(GOKU,  0x0,      File.GOKU_IDLE,            -1,                         -1)


    // Add Action Parameters                // Action Name      // Base Action  // Animation                // Moveset Data             // Flags
    Character.add_new_action_params(GOKU, NSP_Ground_Begin,   -1,             File.GOKU_KHWAIT,     NSP_BEGIN,                  0)
    Character.add_new_action_params(GOKU, NSP_Ground_Wait,    -1,             File.GOKU_KH1,      NSP_WAIT,                   0)
    Character.add_new_action_params(GOKU, NSP_Ground_Walk1,   -1,             File.DKING_DSP_A_LOOP,    NSP_WAIT,                   0)
    Character.add_new_action_params(GOKU, NSP_Ground_Walk2,   -1,             File.DKING_DSP_A_LOOP,    NSP_WAIT,                   0)
    Character.add_new_action_params(GOKU, NSP_Ground_BWalk1,  -1,             File.DKING_DSP_A_LOOP,   NSP_WAIT,                   0)
    Character.add_new_action_params(GOKU, NSP_Ground_BWalk2,  -1,             File.DKING_DSP_A_LOOP,   NSP_WAIT,                   0)
    Character.add_new_action_params(GOKU, NSP_Ground_End,     -1,             File.GOKU_KH2,           NSP_END,                    0)
    Character.add_new_action_params(GOKU, NSP_Air_Begin,      -1,             File.DKING_DSP_A_LOOP,     NSP_BEGIN,                  0)
    Character.add_new_action_params(GOKU, NSP_Air_Wait,       -1,             File.DKING_DSP_A_LOOP,      NSP_WAIT,                   0)
    Character.add_new_action_params(GOKU, NSP_Air_End,        -1,             File.DKING_DSP_A_LOOP,       NSP_END,                    0)
    Character.add_new_action_params(GOKU, NSPG,               -1,             File.DKING_JUMP_F,                NSPG,                       -1)
    Character.add_new_action_params(GOKU, NSPA,               -1,             File.DKING_JUMP_F,                NSPA,                       -1)

    Character.add_new_action_params(GOKU,  NSP_Begin,          -1,             File.SSONIC_NSP_BEGIN,     NSP_CHARGE,                 0)
    Character.add_new_action_params(GOKU,  NSP_Move,           -1,             File.SSONIC_NSP_MOVE,      NSP_MOVE,                   0x10000000)
    Character.add_new_action_params(GOKU,  NSP_Locked_Move,    -1,             File.SSONIC_NSP_MOVE,      NSP_MOVE,                   0x10000000)
    Character.add_new_action_params(GOKU,  NSP_Ground_End2,     -1,             File.SONIC_NSP_GROUND_END,  0x80000000,                 0)

    Character.add_new_action_params(GOKU,  NSP_Air_End2,        -1,             File.SONIC_JUMP_F,          0x80000000,                 0)
    Character.add_new_action_params(GOKU,  NSP_Ground_Recoil,  -1,             File.SONIC_NSP_GROUND_RECOIL, 0x80000000,               0)
    Character.add_new_action_params(GOKU,  NSP_Air_Recoil,     -1,             File.SONIC_JUMP_B,          0x80000000,                 0)
    Character.add_new_action_params(GOKU,  NSP_Bounce,         -1,             File.SONIC_JUMP_F,          NSP_BOUNCE,                 0)


    Character.add_new_action_params(GOKU,  NSPG_Begin,          -1,                    File.MTWO_NSPG_BEGIN,       NSPG_BEGIN,                 0x10000000)
    Character.add_new_action_params(GOKU,  NSPG_Charge,         -1,                 File.MTWO_NSPG_CHARGE,      NSPG_CHARGE,                0x10000000)
    Character.add_new_action_params(GOKU,  NSPG_Shoot,          -1,               File.MTWO_NSPG_SHOOT,       NSPG_SHOOT,                 0x10000000)
    Character.add_new_action_params(GOKU,  NSPA_Begin,          -1,                 File.MTWO_NSPA_BEGIN,       NSPA_BEGIN,                 0x10000000)
    Character.add_new_action_params(GOKU,  NSPA_Charge,         -1,                File.MTWO_NSPA_CHARGE,      NSPA_CHARGE,                0x10000000)
    Character.add_new_action_params(GOKU,  NPSA_Shoot,          -1,                 File.MTWO_NSPA_SHOOT,       NSPA_SHOOT,                 0x10000000)




    // Add Actions                   // Action Name     // Base Action  //Parameters                    // Staling ID   // Main ASM                     // Interrupt/Other ASM          // Movement/Physics ASM             // Collision ASM
    Character.add_new_action(GOKU, NSP_Ground_Begin,  -1,             ActionParams.NSP_Ground_Begin,  0x12,           GokuNSP.ground_begin_main_,   0,                              0x800D8BB4,                         GokuNSP.ground_collision_)
    Character.add_new_action(GOKU, NSP_Ground_Wait,   -1,             ActionParams.NSP_Ground_Wait,   0x12,           GokuNSP.ground_wait_main_,    GokuNSP.ground_interrupt_,    0x800D8BB4,                         GokuNSP.ground_collision_)
    Character.add_new_action(GOKU, NSP_Ground_Walk1,  -1,             ActionParams.NSP_Ground_Walk1,  0x12,           GokuNSP.ground_wait_main_,    GokuNSP.ground_interrupt_,    GokuNSP.ground_walk_physics_,     GokuNSP.ground_collision_)
    Character.add_new_action(GOKU, NSP_Ground_Walk2,  -1,             ActionParams.NSP_Ground_Walk2,  0x12,           GokuNSP.ground_wait_main_,    GokuNSP.ground_interrupt_,    GokuNSP.ground_walk_physics_,     GokuNSP.ground_collision_)
    Character.add_new_action(GOKU, NSP_Ground_BWalk1, -1,             ActionParams.NSP_Ground_BWalk1, 0x12,           GokuNSP.ground_wait_main_,    GokuNSP.ground_interrupt_,    GokuNSP.ground_back_walk_physics_, GokuNSP.ground_collision_)
    Character.add_new_action(GOKU, NSP_Ground_BWalk2, -1,             ActionParams.NSP_Ground_BWalk2, 0x12,           GokuNSP.ground_wait_main_,    GokuNSP.ground_interrupt_,    GokuNSP.ground_back_walk_physics_, GokuNSP.ground_collision_)
    Character.add_new_action(GOKU, NSP_Ground_End,    -1,             ActionParams.NSP_Ground_End,    0x12,           GokuNSP.end_main_,            0,                              0x800D8BB4,                         GokuNSP.ground_collision_)
    Character.add_new_action(GOKU, NSP_Air_Begin,     -1,             ActionParams.NSP_Air_Begin,     0x12,           GokuNSP.air_begin_main_,      0,                              GokuNSP.air_physics_,             GokuNSP.air_collision_)
    Character.add_new_action(GOKU, NSP_Air_Wait,      -1,             ActionParams.NSP_Air_Wait,      0x12,           GokuNSP.air_wait_main_,       0,                              GokuNSP.air_physics_,             GokuNSP.air_collision_)
    Character.add_new_action(GOKU, NSP_Air_End,       -1,             ActionParams.NSP_Air_End,       0x12,           GokuNSP.end_main_,            0,                              GokuNSP.air_physics_,             GokuNSP.air_collision_)
    Character.add_new_action(GOKU,  NSPG,             -1,                 ActionParams.NSPG,             0x12,        GokuNSP.main_,                -1,                               -1,                              -1)
    Character.add_new_action(GOKU,  NSPA,             -1,                 ActionParams.NSPA,             0x12,        GokuNSP.main_,               -1,                                   -1,                              -1)

    Character.add_new_action(GOKU,  NSP_Begin,         -1,             ActionParams.NSP_Begin,             0x11,           GokuUSP.ssonic_begin_main_,    0,                              0,                                  0x800DE958)
    Character.add_new_action(GOKU,  NSP_Move,          -1,             ActionParams.NSP_Move,              0x11,           GokuUSP.ssonic_move_main_,     0,                              GokuUSP.move_physics_,             GokuUSP.ssonic_move_collision_)
    Character.add_new_action(GOKU,  NSP_Locked_Move,   -1,             ActionParams.NSP_Locked_Move,       0x11,           GokuUSP.ssonic_move_main_,     0,                              GokuUSP.move_physics_,             GokuUSP.ssonic_move_collision_)
    Character.add_new_action(GOKU,  NSP_Ground_End2,    -1,             ActionParams.NSP_Ground_End2,        0x12,           0x800D94C4,                     0,                              0x800D8BB4,                         GokuUSP.ground_end_collision_)
    Character.add_new_action(GOKU,  NSP_Air_End2,       -1,             ActionParams.NSP_Air_End2,           0x12,           0x800D94E8,                     0,                              0x800D91EC,                         GokuUSP.air_end_collision_)
    Character.add_new_action(GOKU,  NSP_Ground_Recoil, -1,             ActionParams.NSP_Ground_Recoil,     0x12,           0x800D94C4,                     0,                              0x800D8BB4,                         GokuUSP.ground_recoil_collision_)
    Character.add_new_action(GOKU,  NSP_Air_Recoil,    -1,             ActionParams.NSP_Air_Recoil,        0x12,           0x800D94E8,                     0,                              0x800D91EC,                         GokuUSP.air_recoil_collision_)
    Character.add_new_action(GOKU,  NSP_Bounce,        -1,             ActionParams.NSP_Bounce,            0x12,           0x800D94E8,                     0,                              0x800D91EC,                         0x800DE99C)

    Character.add_new_action(GOKU, NSPG_Begin,          -1,               ActionParams.NSPG_Begin,            0x12,             GokuDSP.begin_main_,        0x8015D464,                         0x800D8BB4,                     GokuDSP.ground_begin_collision_)  //NSP_Ground_Begin
    Character.add_new_action(GOKU, NSPG_Charge,        -1,                ActionParams.NSPG_Charge,            0x12,             GokuDSP.charge_main_,       GokuDSP.ground_charge_interrupt_, 0x800D8BB4,                     GokuDSP.ground_charge_collision_) //NSP_Ground_Charge
    Character.add_new_action(GOKU, NSPG_Shoot,         -1,                ActionParams.NSPG_Shoot,            0x12,             GokuDSP.shoot_main_,        0,                                  0x800D8BB4,                     GokuDSP.ground_shoot_collision_)  //NSP_Ground_Shoot
    Character.add_new_action(GOKU, NSPA_Begin,           -1,              ActionParams.NSPA_Begin,            0x12,             GokuDSP.begin_main_,        0x8015D464,                         0x800D90E0,                     GokuDSP.air_begin_collision_)     //NSP_Air_Begin
    Character.add_new_action(GOKU, NSPA_Charge,        -1,                 ActionParams.NSPA_Charge,           0x12,             GokuDSP.charge_main_,       GokuDSP.air_charge_interrupt_,    0x800D91EC,                     GokuDSP.air_charge_collision_)    //NSP_Air_Charge
    Character.add_new_action(GOKU, NSPA_Shoot,          -1,               ActionParams.NPSA_Shoot,         0x12,             GokuDSP.shoot_main_,        0,                                  0x800D91EC,                     GokuDSP.air_shoot_collision_)     //NSP_Air_Shoot



    Character.table_patch_start(ground_nsp, Character.id.GOKU, 0x4)
    dw      GokuNSP.ground_begin_initial_
    OS.patch_end()
    Character.table_patch_start(air_nsp, Character.id.GOKU, 0x4)
    dw      GokuNSP.air_begin_initial_
    OS.patch_end()
    Character.table_patch_start(ground_usp, Character.id.GOKU, 0x4)
    dw      GokuUSP.ssonic_begin_initial_
    OS.patch_end()
    Character.table_patch_start(air_usp, Character.id.GOKU, 0x4)
    dw      GokuUSP.ssonic_begin_initial_
    OS.patch_end()

}
