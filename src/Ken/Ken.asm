// Ken.asm

// This file contains file inclusions, action edits, and assembly for Ken.

scope Ken {

	// scope FACE: {
	// 	constant NORMAL(0xAC000000)
	// 	constant SHOCK(0xAC000006)
	// }

    // Insert Moveset files
    insert IDLE,"moveset/IDLE.bin"
    insert RUN,"moveset/RUN.bin"; Moveset.GO_TO(RUN)            // loops
    insert JUMP2, "moveset/IDLE.bin"
    insert JUMPB, "moveset/IDLE.bin"
    insert TECHSTAND, "moveset/TECHSTAND.bin"
    insert TECHROLL, "moveset/TECHFROLL.bin"
    insert EDGEATTACKF, "moveset/EDGEATTACKF.bin"
    insert EDGEATTACKS, "moveset/EDGEATTACKS.bin"
    insert TAUNT,"moveset/TAUNT.bin"
    insert SPARKLE,"moveset/SPARKLE.bin"; Moveset.GO_TO(SPARKLE)            // loops
    insert SHIELD_BREAK,"moveset/SHIELD_BREAK.bin"; Moveset.GO_TO(SPARKLE)            // loops
    insert STUN, "moveset/STUN.bin"; Moveset.GO_TO(STUN)         // loops
    insert JAB_1,"moveset/JAB_1.bin"
    insert JAB_2,"moveset/JAB_2.bin"
    insert JAB_3,"moveset/JAB_3.bin"
    insert DASH_ATTACK,"moveset/DASH_ATTACK.bin"
    insert FTILT_HI,"moveset/FORWARD_TILT_HIGH.bin"
    insert FTILT_M_HI,"moveset/FORWARD_TILT_MID_HIGH.bin"
    insert FTILT_L,"moveset/FORWARD_TILT.bin"
    insert FTILT_M_LO,"moveset/FORWARD_TILT_MID_LOW.bin"
    insert FTILT_LO,"moveset/FORWARD_TILT_LOW.bin"
    insert UTILT_L,"moveset/UP_TILT.bin"
    insert DTILT_L,"moveset/DOWN_TILT.bin"
    insert FSMASH,"moveset/FORWARD_SMASH.bin"
    insert USMASH,"moveset/UP_SMASH.bin"
    insert DSMASH,"moveset/DOWN_SMASH.bin"
    insert NAIR,"moveset/NEUTRAL_AERIAL.bin"
    insert FAIR,"moveset/FORWARD_AERIAL.bin"
    insert BAIR,"moveset/BACK_AERIAL.bin"
    insert UAIR,"moveset/UP_AERIAL.bin"
    insert DAIR,"moveset/DOWN_AERIAL.bin"
    insert NSP_GROUND,"moveset/NSP_GROUND.bin"
    insert NSP_AIR,"moveset/NSP_AIR.bin"
    insert USP_L,"moveset/SHORYUKEN_L.bin"
    insert USP_H,"moveset/SHORYUKEN_H.bin"
    insert DSP_L,"moveset/DOWN_SPECIAL_L.bin"
    insert DSP_M,"moveset/DOWN_SPECIAL_M.bin"
    insert DSP_H,"moveset/DOWN_SPECIAL_H.bin"
    insert VICTORY_POSE_1,"moveset/VICTORY_POSE_1.bin"
    insert VICTORY_POSE_2,"moveset/VICTORY_POSE_2.bin"
    insert VICTORY_POSE_3,"moveset/VICTORY_POSE_3.bin"
	insert ONEP,"moveset/ONEP.bin"
	insert ENTRY_1,"moveset/ENTRY_1.bin"
	insert ENTRY_2,"moveset/ENTRY_2.bin"
    insert DOWN_STAND,"moveset/DOWN_STAND.bin"
    insert ROUNDHOUSE,"moveset/ROUNDHOUSE.bin"
    insert DTILT_H,"moveset/DOWN_TILT_H.bin"
    insert UTILT_H,"moveset/UP_TILT_H.bin"
    insert FTILT_H,"moveset/FORWARD_TILT_H.bin"
    insert JAB_CLOSE,"moveset/JAB_CLOSE.bin"
    insert JAB_FAR,"moveset/JAB_FAR.bin"
    insert COMMAND_KICK,"moveset/COMMAND_KICK.bin"
    insert COMMAND_KICK_2,"moveset/COMMAND_KICK_2.bin"
    insert FTILT_CLOSE,"moveset/FORWARD_TILT_CLOSE.bin"
    insert ENTRY,"moveset/ENTRY.bin"

    insert THROWF_DATA, "moveset/THROWF_DATA.bin"
    THROWF:; Moveset.THROW_DATA(THROWF_DATA); insert "moveset/THROWF.bin"
    insert THROWB_DATA, "moveset/THROWB_DATA.bin"
    THROWB:; Moveset.THROW_DATA(Ryu.THROWB_DATA); insert "moveset/THROWB.bin"

    // TEETER:
    // dw FACE.SHOCK; dw 0;

	// DOWN_BOUNCE:
	// dw FACE.SHOCK
	// Moveset.GO_TO(Moveset.shared.DOWN_BOUNCE)

    // Insert AI attack options
    constant CPU_ATTACKS_ORIGIN(origin())
    insert CPU_ATTACKS,"AI/attack_options.bin"
    OS.align(16)

    // Modify Action Parameters             // Action               // Animation                // Moveset Data             // Flags
    Character.edit_action_parameters(KEN,   Action.Entry,           File.RYU_IDLE,              Ryu.IDLE,                         -1)
    Character.edit_action_parameters(KEN,   0x006,                  File.RYU_IDLE,              Ryu.IDLE,                         -1)
    Character.edit_action_parameters(KEN,   Action.Idle,            File.RYU_IDLE,              Ryu.IDLE,                       -1)
    Character.edit_action_parameters(KEN,   Action.ReviveWait,      File.RYU_IDLE,              Ryu.IDLE,                       -1)
    Character.edit_action_parameters(KEN,   Action.Run,             -1,                         Ryu.RUN,                        -1)
    Character.edit_action_parameters(KEN,   Action.Dash,            File.RYU_DASH,              -1,                         -1)
    Character.edit_action_parameters(KEN,   Action.Walk3,           File.RYU_WALK3,              -1,                         -1)
    Character.edit_action_parameters(KEN,   Action.Teeter,          -1,                         Ryu.IDLE,                       -1)
    Character.edit_action_parameters(KEN,   Action.TeeterStart,     -1,                         Ryu.IDLE,                       -1)
    Character.edit_action_parameters(KEN,   Action.Fall,            File.RYU_FALL,              -1,                         0x00000000)
    Character.edit_action_parameters(KEN,   Action.FallAerial,      File.RYU_AIRFALL,           -1,                         0x00000000)
    Character.edit_action_parameters(KEN,   Action.FallSpecial,      File.RYU_FALLSPECIAL,           -1,                         -1)
    Character.edit_action_parameters(KEN,   Action.JumpF,           File.RYU_JUMPF,             -1,                         0x00000000)
    Character.edit_action_parameters(KEN,   Action.JumpB,           File.RYU_JUMPB,             Ryu.JUMPB,                      0x80000000)
    Character.edit_action_parameters(KEN,   Action.ThrowF,          File.RYU_THROWF,            Ryu.THROWF,                     0x10000000)
    Character.edit_action_parameters(KEN,   Action.ThrowB,          File.KEN_THROWB,            THROWB,                     0x50000000)
    Character.edit_action_parameters(KEN,   Action.JumpAerialF,     File.RYU_AIRJUMPF,          Ryu.JUMP2,                      -1)
    Character.edit_action_parameters(KEN,   Action.JumpAerialB,     File.RYU_AIRJUMPB,          Ryu.JUMP2,                      -1)
    // Character.edit_action_parameters(KEN,   Action.DownBounceD,     -1,                         Ryu.DOWN_BOUNCE,                -1)
    // Character.edit_action_parameters(KEN,   Action.DownBounceU,     -1,                         Ryu.DOWN_BOUNCE,                -1)
    Character.edit_action_parameters(KEN,   Action.DownStandD,      -1,                         Ryu.DOWN_STAND,                 -1)
    Character.edit_action_parameters(KEN,   Action.DownStandU,      -1,                         Ryu.DOWN_STAND,                 -1)
    Character.edit_action_parameters(KEN,   Action.TechF,           -1,                         Ryu.TECHROLL,                   -1)
    Character.edit_action_parameters(KEN,   Action.TechB,           -1,                         Ryu.TECHROLL,                   -1)
    Character.edit_action_parameters(KEN,   Action.Tech,            -1,                         Ryu.TECHSTAND,                  -1)
    Character.edit_action_parameters(KEN,   Action.CliffAttackQuick2, -1,                       Ryu.EDGEATTACKF,                -1)
    Character.edit_action_parameters(KEN,   Action.CliffAttackSlow2, -1,                        Ryu.EDGEATTACKS,                -1)
    Character.edit_action_parameters(KEN,   Action.Taunt,           File.KEN_TAUNT,             Ryu.TAUNTKEN,                      -1)
    Character.edit_action_parameters(KEN,   Action.ShieldBreak,     -1,                         Ryu.SHIELD_BREAK,               -1)
    Character.edit_action_parameters(KEN,   Action.Stun,             -1,                        Ryu.STUN,                       -1)
    Character.edit_action_parameters(KEN,   Action.Jab1,            File.KEN_FAR_JAB,           Ryu.JAB_FAR,                 0x40000000)
    Character.edit_action_parameters(KEN,   Action.DashAttack,      File.RYU_DASH_ATTACK,       Ryu.DASH_ATTACK,                0x40000000)
    Character.edit_action_parameters(KEN,   Action.FTiltHigh,       File.KEN_HARD_FTILT,        FTILT_H,                   0x00000000)
    Character.edit_action_parameters(KEN,   Action.FTiltMidHigh,    File.KEN_HARD_FTILT,        FTILT_H,                 0x00000000)
    Character.edit_action_parameters(KEN,   Action.FTilt,           File.KEN_HARD_FTILT,        FTILT_H,                    0x00000000)
    Character.edit_action_parameters(KEN,   Action.FTiltMidLow,     File.KEN_HARD_FTILT,        FTILT_H,                 0x00000000)
    Character.edit_action_parameters(KEN,   Action.FTiltLow,        File.KEN_HARD_FTILT,        FTILT_H,                   0x00000000)
    Character.edit_action_parameters(KEN,   Action.UTilt,           File.RYU_UTILT_H,           Ryu.UTILT_H,                    0x40000000)
    Character.edit_action_parameters(KEN,   Action.DTilt,           File.RYU_DTILT_H,           Ryu.DTILT_H,                      0)
    Character.edit_action_parameters(KEN,   Action.FSmashHigh,      File.KEN_FSMASH,            FSMASH,                 0x40000000)
    Character.edit_action_parameters(KEN,   Action.FSmash,          File.KEN_FSMASH,            FSMASH,                     0x40000000)
    Character.edit_action_parameters(KEN,   Action.FSmashLow,       File.KEN_FSMASH,            FSMASH,                 0x40000000)
    Character.edit_action_parameters(KEN,   Action.USmash,          File.RYU_USMASH,            Ryu.USMASH,                     0)
    Character.edit_action_parameters(KEN,   Action.DSmash,          File.RYU_DSMASH,            Ryu.DSMASH,                     -1)
    Character.edit_action_parameters(KEN,   Action.AttackAirN,      File.KEN_AIRN,              Ryu.NAIR,                       -1)
    Character.edit_action_parameters(KEN,   Action.AttackAirF,      File.RYU_AIRF,              Ryu.FAIR,                       -1)
    Character.edit_action_parameters(KEN,   Action.AttackAirB,      File.RYU_AIRB,              Ryu.BAIR,                       -1)
    Character.edit_action_parameters(KEN,   Action.AttackAirU,      File.KEN_AIRU,              Ryu.UAIR,                       -1)
    Character.edit_action_parameters(KEN,   Action.AttackAirD,      File.RYU_AIRD,              Ryu.DAIR,                       -1)
    Character.edit_action_parameters(KEN,   Action.LandingAirN,     0x66B,                      0x1720,                     -1)
    Character.edit_action_parameters(KEN,   Action.LandingAirF,     0,                          0x80000000,                 -1)
    Character.edit_action_parameters(KEN,   0xE0,                   File.RYU_ENTRYR,            Ryu.ENTRY,                     0x40000009)
    Character.edit_action_parameters(KEN,   0xE1,                   File.RYU_ENTRYR,            Ryu.ENTRY,                     0x40000009)
	Character.edit_action_parameters(KEN,   0xE4,                   File.RYU_HADOUKEN_GND,      NSP_AIR,                 0x40000000)
    Character.edit_action_parameters(KEN,   0xE5,                   File.RYU_HADOUKEN_GND,      NSP_AIR,                 0x40000000)
    Character.edit_action_parameters(KEN,   0xE6,                   File.KEN_TATSU_L,       DSP_L,                 -1)
    Character.edit_action_parameters(KEN,   0xE9,                   File.KEN_TATSU_M,       DSP_M,                 -1) // aerial dsp
    Character.edit_action_parameters(KEN,   Action.Crouch,          File.RYU_CROUCH_START,        -1,                         -1)
    Character.edit_action_parameters(KEN,   Action.CrouchIdle,      File.RYU_CROUCH_IDLE,         -1,                         -1)
    Character.edit_action_parameters(KEN,   Action.CrouchEnd,       File.RYU_CROUCH_END,          -1,                         -1)
    
    Character.edit_action_parameters(KEN,   Action.Run,             File.RYU_RUN,      -1,                         -1)
    Character.edit_action_parameters(KEN,   Action.RunBrake,        File.RYU_RUN_BRAKE,      -1,                         -1)

    Character.edit_action_parameters(KEN,   Action.DamageHigh1,       File.RYU_DAMAGE_H1,          -1,                         -1)
    Character.edit_action_parameters(KEN,   Action.DamageHigh2,       File.RYU_DAMAGE_H2,          -1,                         -1)
    Character.edit_action_parameters(KEN,   Action.DamageHigh3,       File.RYU_DAMAGE_H3,          -1,                         -1)
    Character.edit_action_parameters(KEN,   Action.DamageMid1,       File.RYU_DAMAGE_M1,          -1,                         -1)
    Character.edit_action_parameters(KEN,   Action.DamageMid2,       File.RYU_DAMAGE_M2,          -1,                         -1)
    Character.edit_action_parameters(KEN,   Action.DamageMid3,       File.RYU_DAMAGE_M3,          -1,                         -1)
    Character.edit_action_parameters(KEN,   Action.DamageFlyHigh,    File.RYU_DAMAGE_FLY_HI,        -1,                        -1)

    // Modify Actions            // Action          // Staling ID   // Main ASM                 // Interrupt/Other ASM          // Movement/Physics ASM         // Collision ASM
    Character.edit_action(KEN,  0xE4,              -1,             RyuNSP.main,  				RyuNSP.change_direction_,                             RyuNSP.physics_,                -1)
	Character.edit_action(KEN,  0xE5,              -1,             RyuNSP.main,  				RyuNSP.change_direction_,                             RyuNSP.physics_,                RyuNSP.air_collision_)
    Character.edit_action(KEN, 0xE6,               -1,             RyuDSP.main_,                  RyuDSP.ground_subroutine_,      RyuNSP.physics_,              RyuDSP.ground_collision_)
    Character.edit_action(KEN, 0xE9,               -1,             RyuDSP.main_,                  RyuDSP.air_subroutine_,         RyuDSP.air_physics_,            RyuDSP.air_collision_)

    Character.edit_action(KEN, 0xE0,                   -1,            0x8013DA94,                    0,                              0x8013DB2C,                    0x800DE348)   // LEFT ENTRY
    Character.edit_action(KEN, 0xE1,                   -1,            0x8013DA94,                    0,                              0x8013DB2C,                    0x800DE348)   // RIGHT ENTRY

    // Add Action Parameters                // Action Name      // Base Action  // Animation                    // Moveset Data             // Flags
    Character.add_new_action_params(KEN,    USP_L,             -1,             File.RYU_SHORYUKEN_L,            USP_L,                        0x40000000)
    Character.add_new_action_params(KEN,    JAB_L,             -1,             File.RYU_JAB_1,                 Ryu.JAB_1,                       -1)
    Character.add_new_action_params(KEN,    JAB_L2,             -1,            File.RYU_JAB_2,                 Ryu.JAB_2,                       0x40000000)
    Character.add_new_action_params(KEN,    JAB_L3,             -1,            File.RYU_JAB_3,                 Ryu.JAB_3,                       0x40000000)
    Character.add_new_action_params(KEN,    DTILT_L,           -1,             File.RYU_DTILT_L,               Ryu.DTILT_L,                      0x00000000)
    Character.add_new_action_params(KEN,    UTILT_L,           -1,             File.RYU_UTILT_L,               Ryu.UTILT_L,                      0x00000000)
    Character.add_new_action_params(KEN,    FTILT_L,           -1,             File.RYU_FTILT_L,               Ryu.FTILT_L,                      0x00000000)
    Character.add_new_action_params(KEN,    JAB_CLOSE,         -1,             File.RYU_UTILT_H,               Ryu.JAB_CLOSE,                    0x40000000)
    Character.add_new_action_params(KEN,    FTILT_CLOSE,       -1,             File.RYU_FTILT_CLOSE,           Ryu.FTILT_CLOSE,                  0x40000000)
    Character.add_new_action_params(KEN,    DSP_H,             0xE6,           File.KEN_TATSU_H,           DSP_H,                        -1)
    Character.add_new_action_params(KEN,    DSP_AIR_G,         0xE6,             File.RYU_TATSU_GND_M,           Ryu.DSP_M,                        -1)
    Character.add_new_action_params(KEN,    USP_H,             -1,             File.RYU_SHORYUKEN_H,            USP_H,                        0x40000000)
    Character.add_new_action_params(KEN,    ROUNDHOUSE,             -1,        File.RYU_ROUNDHOUSE,            Ryu.ROUNDHOUSE,                   0)
    Character.add_new_action_params(KEN,    COMMAND_KICK_2,             -1,    File.KEN_COMMAND_KICK_FINISHER,  Ryu.COMMAND_KICK_2,                   0x40000000)
    Character.add_new_action_params(KEN,    COMMAND_KICK,             -1,      File.KEN_COMMAND_KICK,         Ryu.COMMAND_KICK,                   0x40000000)

    // Add Actions                   // Action Name     // Base Action  //Parameters                    // Staling ID   // Main ASM                     // Interrupt/Other ASM          // Movement/Physics ASM             // Collision ASM
    Character.add_new_action(KEN,    USP_L,              -1,             ActionParams.USP_L,            -1,           RyuUSP.main_,                   RyuUSP.change_direction_,          RyuUSP.physics_,                 RyuUSP.collision_)
    Character.add_new_action(KEN,    JAB_L,              -1,             ActionParams.JAB_L,            -1,           0x800D94C4,                     0,                                  0x800D8BB4,                     0x800DDF44)
    Character.add_new_action(KEN,    JAB_L2,              -1,            ActionParams.JAB_L2,           -1,           0x800D94C4,                     0,                                  0x800D8C14,                     0x800DDF44)
    Character.add_new_action(KEN,    JAB_L3,              -1,            ActionParams.JAB_L3,           -1,           0x800D94C4,                     0,                                  0x800D8C14,                     0x800DDF44)
    Character.add_new_action(KEN,    DTILT_L,            -1,             ActionParams.DTILT_L,          -1,           RyuCancelItselfDtilt.main,      0,                                  0x800D8BB4,                     0x800DDF44)
    Character.add_new_action(KEN,    UTILT_L,            -1,             ActionParams.UTILT_L,          -1,           RyuCancelItselfUtilt.main,      0,                                  0x800D8BB4,                     0x800DDF44)
    Character.add_new_action(KEN,    FTILT_L,            -1,             ActionParams.FTILT_L,          -1,           0x800D94C4,                     0,                                  0x800D8BB4,                     0x800DDF44)
    Character.add_new_action(KEN,    JAB_CLOSE,            -1,           ActionParams.JAB_CLOSE,        -1,           0x800D94C4,                     0,                                  0x800D8BB4,                     0x800DDF44)
    Character.add_new_action(KEN,    FTILT_CLOSE,            -1,         ActionParams.FTILT_CLOSE,      -1,           0x800D94C4,                     0,                                  0x800D8BB4,                     0x800DDF44)

    Character.add_new_action(KEN,    DSP_H,              -1,             ActionParams.DSP_H,            -1,           RyuDSP.main_,                   RyuDSP.ground_subroutine_,          RyuNSP.physics_,            RyuDSP.ground_collision_)
    Character.add_new_action(KEN,    DSP_AIR_G,          -1,             ActionParams.DSP_AIR_G,        -1,           RyuDSP.main_,                   RyuDSP.ground_subroutine_,          RyuNSP.physics_,            RyuDSP.ground_collision_)
    Character.add_new_action(KEN,    USP_H,              -1,             ActionParams.USP_H,            -1,           RyuUSP.main_,                   RyuUSP.change_direction_,           RyuUSP.physics_,                RyuUSP.collision_)
    
    Character.add_new_action(KEN,    ROUNDHOUSE,            -1,         ActionParams.ROUNDHOUSE,        -1,           0x800D94C4,                     0,                                  0x800D8BB4,                     0x800DDF44)
    Character.add_new_action(KEN,    COMMAND_KICK_2,            -1,     ActionParams.COMMAND_KICK_2,    -1,       0x800D94C4,                     0,                                  0x800D8C14,                     0x800DDF44)
    Character.add_new_action(KEN,    COMMAND_KICK,            -1,     ActionParams.COMMAND_KICK,    -1,            0x800D94C4,                     0,                                  0x800D8C14,                     0x800DDF44)

    // Modify Menu Action Parameters             // Action          // Animation                // Moveset Data             // Flags
    Character.edit_menu_action_parameters(KEN,   0x0,               File.RYU_IDLE,              -1,                         -1)
    Character.edit_menu_action_parameters(KEN,   0x1,               File.RYU_WIN_1,             VICTORY_POSE_1,             -1)
    Character.edit_menu_action_parameters(KEN,   0x2,               File.RYU_WIN_1,             VICTORY_POSE_1,             -1)
    Character.edit_menu_action_parameters(KEN,   0x3,               File.RYU_WIN_1,             VICTORY_POSE_1,             -1)
    Character.edit_menu_action_parameters(KEN,   0x4,               File.RYU_WIN_1,             VICTORY_POSE_1,             -1)
    Character.edit_menu_action_parameters(KEN,   0xE,               File.GND_1P_CPU,            Ryu.ONEP,                       -1)
    Character.edit_menu_action_parameters(KEN,   0xD,               File.KEN_1P_POSE,           Ryu.ONEP,                       -1)

    Character.table_patch_start(variants, Character.id.KEN, 0x4)
    db      Character.id.NONE   // set as SPECIAL variant for KEN
    db      Character.id.NONE
    db      Character.id.NONE
    db      Character.id.NONE
    OS.patch_end()

    Character.table_patch_start(air_usp, Character.id.KEN, 0x4)
    dw      RyuUSP.air_initial_
    OS.patch_end()
    Character.table_patch_start(ground_usp, Character.id.KEN, 0x4)
    dw      RyuUSP.ground_initial_
    OS.patch_end()

    // Set menu zoom size.
    Character.table_patch_start(menu_zoom, Character.id.KEN, 0x4)
    float32 1
    OS.patch_end()

    // Allows Marina to use her entry which is similar to Link
    Character.table_patch_start(entry_action, Character.id.KEN, 0x8)
    dw 0xE0, 0xE1
    OS.patch_end()


    // Remove entry script.
    Character.table_patch_start(entry_script, Character.id.KEN, 0x4)
    // dw 0x8013DD68                           // skips entry script
    dw marina_entry_routine_
    OS.patch_end()

    // Remove entry script.
    // Character.table_patch_start(entry_script, Character.id.KEN, 0x4)
    // dw 0x8013DD68                           // skips entry script
    // OS.patch_end()

    // Set crowd chant FGM to none
    Character.table_patch_start(crowd_chant_fgm, Character.id.KEN, 0x2)
    dh  0x02B7
    OS.patch_end()

    // Set down bound FGM.
    Character.table_patch_start(down_bound_fgm, Character.id.KEN, 0x2)
    dh  0x06B4
    OS.patch_end()

    // Disable rapid jab
    Character.table_patch_start(rapid_jab, Character.id.KEN, 0x4)
    dw      Character.rapid_jab.DISABLED        // disable rapid jab
    OS.patch_end()

    // Set default costumes
    Character.set_default_costumes(Character.id.KEN, 0, 1, 2, 3, 0, 6, 4)
    Teams.add_team_costume(YELLOW, KEN, 5)

    // Shield colors for costume matching
    Character.set_costume_shield_colors(KEN, BROWN, BLUE, AZURE, PURPLE, GREEN, RED, YELLOW, NA)

    // Set Kirby star damage
    Character.table_patch_start(kirby_inhale_struct, 0x8, Character.id.KEN, 0xC)
    dw Character.kirby_inhale_struct.star_damage.DK
    OS.patch_end()

    // Set Kirby hat_id
    Character.table_patch_start(kirby_inhale_struct, 0x2, Character.id.KEN, 0xC)
    dh 0x11
    OS.patch_end()

    // @ Description
    // Entry routine for Marina. Sets the correct facing direction and then jumps to Link's entry routine.
    scope marina_entry_routine_: {
        lw      a1, 0x0B1C(s0)              // a1 = direction
        addiu   at, r0,-0x0001              // at = -1 (left)
        beql    a1, at, _end                // branch if direction = left...
        sw      v1, 0x0B24(s0)              // ...and enable reversed direction flag

        _end:
        j       0x8013DD68                  // jump to Link's entry routine to load entry object
        nop
    }

    // Set CPU behaviour
    Character.table_patch_start(ai_behaviour, Character.id.KEN, 0x4)
    dw      CPU_ATTACKS
    OS.patch_end()

    // Edit cpu attack behaviours
    // edit_attack_behavior(table, attack, override, start_hb, end_hb, min_x, max_x, min_y, max_y)
    AI.edit_attack_behavior(CPU_ATTACKS_ORIGIN, DAIR,   -1,  8,   18,   -1, -1, -1, -1)
    AI.edit_attack_behavior(CPU_ATTACKS_ORIGIN, DSPA,   -1,  8,   32,   -1, -1, -1, -1)
    AI.edit_attack_behavior(CPU_ATTACKS_ORIGIN, DSPG,   -1,  8,   32,   -1, -1, -1, -1)
    AI.edit_attack_behavior(CPU_ATTACKS_ORIGIN, DSMASH, -1,  5,   9,    -1, -1, -1, -1) // todo: coords
    AI.edit_attack_behavior(CPU_ATTACKS_ORIGIN, DTILT,  -1,  3,    6,  -1, -1, -1, -1)
    AI.edit_attack_behavior(CPU_ATTACKS_ORIGIN, FAIR,   -1,  8,    15,  -1, -1, -1, -1)
    AI.edit_attack_behavior(CPU_ATTACKS_ORIGIN, FSMASH, -1,  15,   17,  -1, -1, -1, -1) // todo: coords
    AI.edit_attack_behavior(CPU_ATTACKS_ORIGIN, FTILT,  -1,  9,   16,  -1, -1, -1, -1)
    AI.edit_attack_behavior(CPU_ATTACKS_ORIGIN, GRAB,   -1,  6,    6,   -1, -1, -1, -1)
    AI.edit_attack_behavior(CPU_ATTACKS_ORIGIN, JAB,    -1,  4,    7,   -1, -1, -1, -1)
    AI.edit_attack_behavior(CPU_ATTACKS_ORIGIN, NAIR,   -1,  4,    30,  -1, -1, -1, -1)
    AI.edit_attack_behavior(CPU_ATTACKS_ORIGIN, NSPG,   -1,  12,   70,  -1, -1, -1, -1)
    AI.edit_attack_behavior(CPU_ATTACKS_ORIGIN, NSPA,   -1,  12,   70,  -1, -1, -1, -1)
    AI.edit_attack_behavior(CPU_ATTACKS_ORIGIN, UAIR,   -1,  5,    12,  -1, -1, -1, -1)
    AI.edit_attack_behavior(CPU_ATTACKS_ORIGIN, USPA,   -1,  6,    18,   89, 475, 0, 1000)
    AI.edit_attack_behavior(CPU_ATTACKS_ORIGIN, USPG,   -1,  6,    18,   89, 475, 0, 1700)
    AI.edit_attack_behavior(CPU_ATTACKS_ORIGIN, USMASH, -1,  8,   17,  -1, -1, -1, -1) // todo: coords
    AI.edit_attack_behavior(CPU_ATTACKS_ORIGIN, UTILT,  -1,  5,   8,  -1, -1, -1, -1) // todo: coords

    // @ Description
    // Ken's extra actions
    scope Action {
        //constant Jab3(0x0DC)
        //constant JabLoopStart(0x0DD)
        //constant JabLoop(0x0DE)
        //constant JabLoopEnd(0x0DF)
        // constant AppearLeft1(0x0E0)
        constant Blaster(0x0E4)
        constant BlasterAir(0x0E5)
        // constant AppearRight2(0x0E3)
        constant Hadouken(0x0E4)
        constant HadoukenAir(0x0E5)
        constant WarlockKick(0x0E6)
        constant WarlockKickFromGroundAir(0x0E7)
        constant LandingWarlockKick(0x0E8)
        constant WarlockKickEnd(0x0E9)
        constant CollisionWarlockKick(0x0EA)
        constant WarlockDive(0x0EB)
        constant WarlockDiveCatch(0x0EC)
        constant WarlockDiveEnd1(0x0ED)
        constant WarlockDiveEnd2(0x0EE)

        // strings!
        //string_0x0DC:; String.insert("Jab3")
        //string_0x0DD:; String.insert("JabLoopStart")
        //string_0x0DE:; String.insert("JabLoop")
        //string_0x0DF:; String.insert("JabLoopEnd")
        // string_0x0E0:; String.insert("AppearLeft1")
        // string_0x0E1:; String.insert("AppearRight1")
        // string_0x0E2:; String.insert("AppearLeft1")
        // string_0x0E3:; String.insert("AppearRight2")
        string_0x0E4:; String.insert("Hadouken")
        string_0x0E5:; String.insert("HadoukenAir")
        string_0x0E6:; String.insert("WarlockKick")
        string_0x0E7:; String.insert("WarlockKickFromGroundAir")
        string_0x0E8:; String.insert("Hadouken")
        string_0x0E9:; String.insert("HadoukenAir")
        string_0x0EA:; String.insert("TatsumakiLight")
        string_0x0EB:; String.insert("---")
        string_0x0EC:; String.insert("DarkDiveCatch")
        string_0x0ED:; String.insert("TatsumakiAir")
        string_0x0EE:; String.insert("DarkDiveEnd2")

        string_0x0F3:; String.insert("ShoryukenLight")
        string_0x0F4:; String.insert("Jab1")
        string_0x0F5:; String.insert("Jab2")
        string_0x0F6:; String.insert("Jab3")
        string_0x0F7:; String.insert("DTiltLight")
        string_0x0F8:; String.insert("UTiltLight")
        string_0x0F9:; String.insert("FTiltLight")
        string_0x0FA:; String.insert("JabClose")
        string_0x0FB:; String.insert("FTiltClose")
        string_0x0FC:; String.insert("TatsumakiStrong")
        string_0x0FD:; String.insert("TatsumakiAirGround")
        string_0x0FE:; String.insert("ShoryukenHard")
        string_0x0FF:; String.insert("OosotoMawashiGeri")
        string_0x100:; String.insert("InazumaKick")
        string_0x101:; String.insert("NataOtoshiGeri")

        action_string_table:
        dw 0
        dw 0
        dw 0
        dw 0
        dw string_0x0E4
        dw string_0x0E5
        dw string_0x0E6
        dw string_0x0E7
        dw string_0x0E8
        dw string_0x0E9
        dw string_0x0EA
        dw string_0x0EB
        dw string_0x0EC
        dw string_0x0ED
        dw string_0x0EE

        dw 0
        dw 0
        dw 0
        dw 0
        dw string_0x0F3
        dw string_0x0F4
        dw string_0x0F5
        dw string_0x0F6
        dw string_0x0F7
        dw string_0x0F8
        dw string_0x0F9
        dw string_0x0FA
        dw string_0x0FB
        dw string_0x0FC
        dw string_0x0FD
        dw string_0x0FE
        dw string_0x0FF
        dw string_0x100
        dw string_0x101
    }

    // Set action strings
    Character.table_patch_start(action_string, Character.id.KEN, 0x4)
    dw  Action.action_string_table
    OS.patch_end()
}
