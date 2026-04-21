// Uzi.asm

// This file contains file inclusions, action edits, and assembly for Uzi.

scope Uzi {



    scope MODEL {



        scope WEAPON {
            constant RAILGUN(0xA0880000)
        }

        scope WING {
            constant WINGL(0xA0880001)
            constant WINGR(0xA0380000)

        }

    }



    // Insert Moveset files

    insert RUN, "moveset/RUN.bin"; Moveset.GO_TO(RUN) // loops
    insert RAILGUN, "moveset/RAILGUN.bin"
    insert RAILGUN_AERIAL, "moveset/RAILGUN_AERIAL.bin"
    insert SPARKLE, "moveset/SPARKLE.bin"; Moveset.GO_TO(SPARKLE) // loops
    insert SHIELDBREAK, "moveset/SHIELDBREAK.bin"; Moveset.GO_TO(SPARKLE) // loops
    insert SHITHEAVY, "moveset/HEAVYPICK.bin"
    insert JUMP, "moveset/JUMP1.bin"
    insert JUMP_2, "moveset/JUMP2.bin"
    insert STUN, "moveset/STUN.bin"
    insert STUN2, "moveset/STUN2.bin"; Moveset.GO_TO(STUN2) // loops
    insert SLEEP, "moveset/SLEEP.bin"; Moveset.GO_TO(SLEEP) // loops
    insert LOSE, "moveset/LOSE.bin"
    insert SELECT, "moveset/SELECT.bin"
    insert IDLE, "moveset/IDLE.bin"
    insert DSMASH, "moveset/DSMASH.bin"
    insert FAIR, "moveset/FAIR.bin"
    insert JAB1, "moveset/JAB1.bin"
    insert JAB2, "moveset/JAB2.bin"
    insert TEETER, "moveset/TEETER.bin"
    insert TECH, "moveset/TECH.bin"
    insert TECHF, "moveset/TECHF.bin"
    insert ROLLF, "moveset/ROLLF.bin"
    insert ROLLB, "moveset/ROLLB.bin"
    insert UAIR, "moveset/UAIR.bin"
    insert NAIR, "moveset/NAIR.bin"

    UTILT:; dw MODEL.WEAPON.RAILGUN; insert "moveset/UP_TILT.bin"

    DASH_ATTACK:; dw MODEL.WEAPON.RAILGUN; insert "moveset/DASH_ATTACK.bin"


    insert GRAB_RELEASE_DATA,"moveset/GRAB_RELEASE_DATA.bin"

    insert THROW_F_DATA,"moveset/THROWFDATA.bin"
    THROW_F:; Moveset.THROW_DATA(THROW_F_DATA); insert "moveset/THROWF.bin"
    insert THROW_B_DATA,"moveset/BTHROWDATA.bin"
    THROW_B:; Moveset.THROW_DATA(THROW_B_DATA); insert "moveset/THROWB.bin"

    insert FSMASH, "moveset/FSMASH.bin"
    insert USMASH, "moveset/USMASH.bin"

    insert TAUNT, "moveset/TAUNT.bin"

    NSP_BEGIN:; dw MODEL.WEAPON.RAILGUN; insert "moveset/NSP_BEGIN.bin"
    NSP_WAIT:; dw MODEL.WEAPON.RAILGUN; insert "moveset/NSP_WAIT.bin"
    NSP_END:; dw MODEL.WEAPON.RAILGUN; insert "moveset/NSP_END.bin"

    insert USP_CONCURRENT,"moveset/USP_CONCURRENT.bin"
    USP:; Moveset.CONCURRENT_STREAM(USP_CONCURRENT); Moveset.HIDE_ITEM(); dw MODEL.WING.WINGL; dw MODEL.WING.WINGR; insert "moveset/USP.bin"
    USP_OPEN:; Moveset.HIDE_ITEM(); dw MODEL.WING.WINGL; dw MODEL.WING.WINGR; insert "moveset/USP_OPEN.bin"
    USP_FLOAT:; Moveset.HIDE_ITEM(); dw MODEL.WING.WINGL; dw MODEL.WING.WINGR; dw 0
    USP_CLOSE:; Moveset.HIDE_ITEM(); dw 0xB01C0000; Moveset.AFTER(3); dw 0
    USP_FALL:; Moveset.HIDE_ITEM(); dw 0

    NSP_AIR_PULL_CONCURRENT:
    Moveset.AFTER(30)
    Moveset.SET_FLAG(0)
    dw 0x98012800, 0, 0, 0
    Moveset.WAIT(1)
    dw 0x54000002
    Moveset.WAIT(1)
    Moveset.GO_TO(NSP_AIR_PULL_CONCURRENT + 4)
    NSPA2:; insert "moveset/NSPA.bin"
    insert NSP_THROW_DATA,"moveset/NSP_THROW_DATA.bin"

    NSP_AIR_PULL:; Moveset.CONCURRENT_STREAM(NSP_AIR_PULL_CONCURRENT); Moveset.THROW_DATA(GRAB_RELEASE_DATA); insert "moveset/NSP_AIR_PULL.bin"
    NSP_LANDING_THROW:; Moveset.THROW_DATA(NSP_THROW_DATA); insert "moveset/NSP_LANDING_THROW.bin"

    NSPG:
    dw 0x98004C00, 0x00000000, 0xFF4C0000, 0x00000000
    NSP:
    dw MODEL.WEAPON.RAILGUN
    Moveset.HIDE_ITEM()

    Moveset.AFTER(4)
    Moveset.AFTER(20)
    Moveset.SET_FLAG(0)                             // spawn projectile
    Moveset.SET_FLAG(1)                             // allow cancel
    Moveset.HURTBOXES(3)                            // intangible
    Moveset.CREATE_GFX(18, 31, 0, -300, 0, 20, 20, 20) // spark on grape shooter
    Moveset.SFX(1576)                               // grape shooter sound

    Moveset.AFTER(22)
    Moveset.HURTBOXES(1)                            // vulnerable
    Moveset.AFTER(28)
    Moveset.AFTER(36)
    dw 0x58000000                                   // disallow cancel
    dw 0
    NSPA:
    dw 0x98004000, 0x00000000, 0xFF6A0000, 0x00000000
    Moveset.GO_TO(NSP)



    NSPG2:
    dw 0x98004C00, 0x00000000, 0xFF4C0000, 0x00000000
    NSP2:
    dw MODEL.WEAPON.RAILGUN
    Moveset.HIDE_ITEM()


    Moveset.SET_FLAG(0)                             // spawn projectile
    Moveset.SET_FLAG(1)                             // allow cancel
    Moveset.HURTBOXES(3)                            // intangible
    Moveset.CREATE_GFX(18, 31, 0, -300, 0, 20, 20, 20) // spark on grape shooter
    Moveset.SFX(1576)                               // grape shooter sound

    Moveset.AFTER(22)
    Moveset.HURTBOXES(1)                            // vulnerable
    Moveset.AFTER(28)
    Moveset.AFTER(36)
    dw 0x58000000                                   // disallow cancel
    dw 0
    NSPA22:
    dw 0x98004000, 0x00000000, 0xFF6A0000, 0x00000000
    Moveset.GO_TO(NSP2)

    NSP_CHARGE:; dw MODEL.WING.WINGL; dw MODEL.WING.WINGR; insert "moveset/NSP_CHARGE.bin"
    NSP_MOVE:; dw MODEL.WING.WINGL; dw MODEL.WING.WINGR; insert "moveset/NSP_MOVE.bin"
    NSP_BOUNCE:; dw MODEL.WING.WINGL; dw MODEL.WING.WINGR; insert "moveset/NSP_BOUNCE.bin"

    DSPA_BEGIN:; dw MODEL.WING.WINGL; dw MODEL.WING.WINGR; insert "moveset/DSPA_BEGIN.bin"
    DSPA_LOOP:; insert "moveset/DAIR.bin"
    DSPA_LAND:; insert "moveset/DSPA_LAND.bin"
    ZERO:; dw 0


    scope Action: {
        constant EntryL(0xDC)
        constant EntryR(0xDD)
        constant Float(0xDE)
        constant NSPG0(0xDF)
        constant NSPA0(0xE0)
        constant NSPRecoil(0xE1)
        //constant ?(0xE2)
        constant USPG(0xE3)
        constant USPA(0xE4)
        constant USPOpen(0xE5)
        constant USPFloat(0xE6)
        constant USPClose(0xE7)
        constant USPFall(0xE8)
        constant DSPPull(0xE9)

        // strings!
        string_0x0DC:; String.insert("")
        string_0x0DD:; String.insert("")
        string_0x0DE:; String.insert("Float")
        string_0x0DF:; String.insert("PeachBomber")
        string_0x0E0:; String.insert("PeachBomberAir")
        string_0x0E1:; String.insert("PeachBomberRecoil")
        string_0x0E3:; String.insert("PeachParasol")
        string_0x0E4:; String.insert("PeachParasolAir")
        string_0x0E5:; String.insert("PeachParasolOpen")
        string_0x0E6:; String.insert("PeachParasolFloat")
        string_0x0E7:; String.insert("PeachParasolClose")
        string_0x0E8:; String.insert("FallSpecial")
        string_0x0E9:; String.insert("PeachTurnip")

        action_string_table:
        dw Action.COMMON.string_appear1
        dw Action.COMMON.string_appear2
        dw string_0x0DE
        dw string_0x0DF
        dw string_0x0E0
        dw string_0x0E1
        dw 0
        dw string_0x0E3
        dw string_0x0E4
        dw string_0x0E5
        dw string_0x0E6
        dw string_0x0E7
        dw string_0x0E8
        dw string_0x0E9
    }


    // Modify Action Parameters           // Action                     // Animation                    // Moveset Data             // Flags
    Character.edit_action_parameters(UZI, 0xE1,                         File.UZI_LASER,                 RAILGUN,                     0)
    Character.edit_action_parameters(UZI, 0xE2,                         File.UZI_LASERA,                RAILGUN_AERIAL,              0)
    Character.edit_action_parameters(UZI, Action.Taunt,                 File.UZI_LAUGH,                 TAUNT,                      -1)
    Character.edit_action_parameters(UZI, Action.ReviveWait,            File.UZI_IDLE,                  -1,                         -1)
    Character.edit_action_parameters(UZI, Action.Idle,                  File.UZI_IDLE,                  IDLE,                         -1)
    Character.edit_action_parameters(UZI, Action.Run,                   File.UZI_RUN,                   RUN,                        -1)
    Character.edit_action_parameters(UZI, Action.Walk2,                 File.UZI_WALK2,                 -1,                         -1)
    Character.edit_action_parameters(UZI, Action.Walk3,                 File.UZI_WALK3,                 -1,                         -1)
    Character.edit_action_parameters(UZI, Action.ShieldBreak,           -1,                             SHIELDBREAK,                -1)
    Character.edit_action_parameters(UZI, Action.Stun,                  File.UZI_STUNSLEEP,             STUN,                       -1)
    Character.edit_action_parameters(UZI, Action.Sleep,                 File.UZI_STUNSLEEP,             SLEEP,                      -1) 
    Character.edit_action_parameters(UZI, Action.HeavyItemPickup,       -1,                             SHITHEAVY,                  -1)
    Character.edit_action_parameters(UZI, Action.JumpF,                 File.UZI_JUMPF,                 JUMP,                       -1)
    Character.edit_action_parameters(UZI, Action.JumpB,                 -1,                             JUMP,                       -1)
    Character.edit_action_parameters(UZI, Action.JumpAerialF,           -1,                             JUMP_2,                     -1)
    Character.edit_action_parameters(UZI, Action.JumpAerialB,           -1,                             JUMP_2,                     -1)
    Character.edit_action_parameters(UZI, Action.DSmash,                File.UZI_DSMASH,                DSMASH,                     -1)
    Character.edit_action_parameters(UZI, Action.AttackAirU,            File.UZI_UAIR,                  UAIR,                       -1)
    Character.edit_action_parameters(UZI, Action.AttackAirF,            File.UZI_FAIR,                  FAIR,                       -1)
    Character.edit_action_parameters(UZI, Action.AttackAirB,            File.UZI_BAIR,                  -1,                       -1)
    Character.edit_action_parameters(UZI, Action.AttackAirD,            File.UZI_DAIR,                  Spiderman.DOWN_AERIAL,                       -1)
    Character.edit_action_parameters(UZI, Action.AttackAirN,            File.UZI_NAIR,                  NAIR,                       -1)
    Character.edit_action_parameters(UZI, Action.Jab1,                  File.UZI_JAB1,                  JAB1,                       -1)
    Character.edit_action_parameters(UZI, Action.Jab2,                  File.UZI_JAB2,                Peach.JAB2,                       -1)

    Character.edit_action_parameters(UZI, Action.Tech,                  -1,                              TECH,                       -1)
    Character.edit_action_parameters(UZI, Action.TechF,                 -1,                             TECHF,                       -1)
    Character.edit_action_parameters(UZI, Action.TechB,                 -1,                             TECHF,                       -1)
    Character.edit_action_parameters(UZI, Action.RollB,                 -1,                             ROLLB,                       -1)
    Character.edit_action_parameters(UZI, Action.RollF,                 -1,                             ROLLF,                       -1)
    Character.edit_action_parameters(UZI, Action.Crouch,                 File.UZI_CSTART,               -1,                       -1)
    Character.edit_action_parameters(UZI, Action.CrouchIdle,             File.UZI_CIDLE,               -1,                       -1)
    Character.edit_action_parameters(UZI, Action.CrouchEnd,              File.UZI_CEND,               -1,                       -1)
    Character.edit_action_parameters(UZI, Action.DTilt,                  File.UZI_DTILT_NEW,               -1,                       -1)
    Character.edit_action_parameters(UZI, Action.UTilt,                  File.FALCO_UTILT,                           UTILT,                       -1)
    Character.edit_action_parameters(UZI, Action.FSmash,                  File.UZI_FSMASH,               FSMASH,                       -1)
    Character.edit_action_parameters(UZI, Action.USmash,                  File.UZI_USMASH,               USMASH,                       -1)
    Character.edit_action_parameters(UZI, Action.DashAttack,         File.UZI_DASH_ATTACK,        DASH_ATTACK,                -1)

    Character.edit_action_parameters(UZI, Action.FTiltHigh,          File.CONKER_FTILT_HIGH,         Conker.FTILT_HIGH,                 0x00000000)
    Character.edit_action_parameters(UZI, Action.FTiltMidHigh,       0,                              0x80000000,                 0x00000000)
    Character.edit_action_parameters(UZI, Action.FTilt,              File.CONKER_FTILT_MID,          Conker.FTILT_MID,                  0x00000000)
    Character.edit_action_parameters(UZI, Action.FTiltMidLow,        0,                              0x80000000,                 0x00000000)
    Character.edit_action_parameters(UZI, Action.FTiltLow,           File.CONKER_FTILT_LOW,          Conker.FTILT_LOW,                  0x00000000)

    Character.edit_action_parameters(UZI, Action.USPG,                  File.UZI_USP_START,                USP,                         0)
    Character.edit_action_parameters(UZI, Action.USPA,                  File.UZI_USP_START,                USP,                         0)
    Character.edit_action_parameters(UZI, Action.USPOpen,               File.UZI_USP_LOOP,            USP_OPEN,                    0)
    Character.edit_action_parameters(UZI, Action.USPFloat,              File.UZI_USP_LOOP,           USP_FLOAT,                   0)
    Character.edit_action_parameters(UZI, Action.USPClose,              File.PEACH_USP_CLOSE,           USP_CLOSE,                   0)
    Character.edit_action_parameters(UZI, Action.USPFall,               File.PEACH_FALL_SPECIAL,        USP_FALL,                   0)

    Character.edit_action_parameters(UZI, Action.Entry,                  File.UZI_IDLE,                  -1,                         -1)
    Character.edit_action_parameters(UZI, 0xDF,                   File.UZI_ENTRY2,     -1,                      -1)
    Character.edit_action_parameters(UZI, 0xE0,                   File.UZI_ENTRY,      -1,                      -1)

    Character.edit_action_parameters(UZI, Action.Walk1,                   File.UZI_WALK1,               -1,                         -1)
    Character.edit_action_parameters(UZI, Action.Walk2,                   File.UZI_WALK2,               -1,                         -1)
    Character.edit_action_parameters(UZI, Action.Walk3,                   File.UZI_WALK3,               -1,                         -1)

    Character.edit_action_parameters(UZI, Action.Fall,                   File.UZI_JUMPFALL,               -1,                         -1)

    Character.edit_action_parameters(UZI, Action.ThrowF,                  File.CONKER_THROWF,                             THROW_F,                         -1)
    Character.edit_action_parameters(UZI, Action.ThrowB,                  -1,                             THROW_B,                         -1)
    Character.edit_action_parameters(UZI, Action.Teeter,                  -1,                             TEETER,                         -1)


    Character.edit_action(UZI, Action.USPG,       0x11,           UziUSP.main_,             UziUSP.change_direction_,     UziUSP.physics_,              UziUSP.collision_)
    Character.edit_action(UZI, Action.USPA,       0x11,           UziUSP.main_,             UziUSP.change_direction_,     UziUSP.physics_,              UziUSP.collision_)
    Character.edit_action(UZI, Action.USPOpen,    0x11,           UziUSP.open_main_,        0,                              UziUSP.float_physics_,        UziUSP.collision_)
    Character.edit_action(UZI, Action.USPFloat,   0x11,           UziUSP.float_main_,                          UziUSP.float_interrupt_,      UziUSP.float_physics_,        UziUSP.collision_)
    Character.edit_action(UZI, Action.USPClose,   0x11,           UziUSP.close_main_,       0,                              0x800D9160,                     UziUSP.collision_)
    Character.edit_action(UZI, Action.USPFall,    0x11,           0,                          UziUSP.fall_interrupt_,       0x80143750,                     0x8014384C)


    // Modify Menu Action Parameters           // Action    // Animation             // Moveset Data     // Flags
    Character.edit_menu_action_parameters(UZI, 0x0,         File.UZI_IDLE,              IDLE,                 -1)
    Character.edit_menu_action_parameters(UZI, 0x1,         File.UZI_SELECT,      SELECT,          -1)
    Character.edit_menu_action_parameters(UZI, 0x2,         File.UZI_SELECT,      SELECT,          -1)
    Character.edit_menu_action_parameters(UZI, 0x3,         File.UZI_SELECT,      SELECT,          -1)
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
    Character.add_new_action_params(UZI, NSPAir,             -1,             File.UZI_NSP_IDLE,          NSPA2,                        0x40000000)
    Character.add_new_action_params(UZI, NSPAirPull,         -1,             File.UZI_NSP_IDLE,    NSP_AIR_PULL,               0x10000000)
    Character.add_new_action_params(UZI, NSPLandingThrow,    -1,             File.UZI_NSP_IDLE,        NSP_LANDING_THROW,          0x10000000)

    Character.add_new_action_params(UZI, NSPG,               -1,             0x30B,                NSPG,                       -1)
    Character.add_new_action_params(UZI, NSPA,               -1,             0x30B,                NSPA,                       -1)

    Character.add_new_action_params(UZI, NSPG2,               -1,             0x30B,                NSPG,                       -1)
    Character.add_new_action_params(UZI, NSPA2,               -1,             0x30B,                NSPA,                       -1)

    Character.add_new_action_params(UZI, NSPG3,               -1,             0x30B,                NSPG,                       -1)
    Character.add_new_action_params(UZI, NSPA3,               -1,             0x30B,                NSPA,                       -1)

    Character.add_new_action_params(UZI, NSPG4,               -1,             0x30B,                NSPG,                       -1)
    Character.add_new_action_params(UZI, NSPA4,               -1,             0x30B,                NSPA,                       -1)

    Character.add_new_action_params(UZI, NSPG5,               -1,             File.UZI_NSP_PULL,                NSPG,                       -1)
    Character.add_new_action_params(UZI, NSPA5,               -1,             File.UZI_NSP_PULL,                NSPA,                       -1)

    Character.add_new_action_params(UZI,  NSP_Begin,          -1,             File.UZI_USP_START,       NSP_CHARGE,                 0)
    Character.add_new_action_params(UZI,  NSP_Move,           -1,             File.UZI_USP_LOOP,  NSP_MOVE,                   0)
    Character.add_new_action_params(UZI,  NSP_Locked_Move,    -1,             File.UZI_USP_START,  NSP_MOVE,                   0)
    Character.add_new_action_params(UZI,  NSP_Ground_End2,     -1,             File.UZI_USP_LOOP,  0x80000000,                 0)
    Character.add_new_action_params(UZI,  NSP_Air_End2,        -1,             File.UZI_USP_LOOP,          0x80000000,                 0)
    Character.add_new_action_params(UZI,  NSP_Ground_Recoil,  -1,             File.SONIC_TUMBLE, 0x80000000,               0)
    Character.add_new_action_params(UZI,  NSP_Air_Recoil,     -1,             File.SONIC_TUMBLE,          0x80000000,                 0)
    Character.add_new_action_params(UZI,  NSP_Bounce,         -1,             File.SONIC_TUMBLE,          NSP_BOUNCE,                 0)
    Character.add_new_action_params(UZI,    DSPA_LOOP,      -1,                 File.SONIC_TUMBLE,          DSPA_LOOP,                  0x00000000)
    Character.add_new_action_params(UZI,    DSPA_LAND,       -1,            File.SONIC_JUMPSQUAT,       DSPA_LAND,                  0x00000000)
    Character.add_new_action_params(UZI,    DSPA_BEGIN,       -1,            File.UZI_USP_START,         DSPA_BEGIN,                 0x00000000)

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
    Character.add_new_action(UZI,    NSPAir,             -1,         ActionParams.NSPAir,            0x11,           0x801602B0,                  0x80160370,                     0x801603F0,                         0x80160560)
    Character.add_new_action(UZI, NSPAirPull,        -1,             ActionParams.NSPAirPull,        0x11,           UziNSPA.air_pull_main_,       0,                          UziNSPA.air_pull_physics_,       UziNSPA.air_pull_collision_)
    Character.add_new_action(UZI,    NSPLandingThrow,    -1,             ActionParams.NSPLandingThrow,   0x11,           UziNSPA.throw_main_,          0,                              0x800D8BB4,                         0x80149B78)

    Character.add_new_action(UZI,  NSPG,             -1,                 ActionParams.NSPG,             0x12,        UziNSP.main_,                 UziUSP.change_direction_,     UziUSP.physics_,              UziUSP.collision_)
    Character.add_new_action(UZI,  NSPA,             -1,                 ActionParams.NSPA,             0x12,        UziNSP.main_,                UziUSP.change_direction_,     UziUSP.physics_,              UziUSP.collision_)

    Character.add_new_action(UZI,  NSPG2,             -1,                 ActionParams.NSPG,             0x12,        UziNSP.main2_,                 UziUSP.change_direction_,     UziUSP.physics_,              UziUSP.collision_)
    Character.add_new_action(UZI,  NSPA2,             -1,                 ActionParams.NSPA,             0x12,        UziNSP.main2_,                UziUSP.change_direction_,     UziUSP.physics_,              UziUSP.collision_)

    Character.add_new_action(UZI,  NSPG3,             -1,                 ActionParams.NSPG,             0x12,        UziNSP.main3_,                 UziUSP.change_direction_,     UziUSP.physics_,              UziUSP.collision_)
    Character.add_new_action(UZI,  NSPA3,             -1,                 ActionParams.NSPA,             0x12,        UziNSP.main3_,                UziUSP.change_direction_,     UziUSP.physics_,              UziUSP.collision_)

    Character.add_new_action(UZI,  NSPG4,             -1,                 ActionParams.NSPG,             0x12,        UziNSP.main4_,                 UziUSP.change_direction_,     UziUSP.physics_,              UziUSP.collision_)
    Character.add_new_action(UZI,  NSPA4,             -1,                 ActionParams.NSPA,             0x12,        UziNSP.main4_,                UziUSP.change_direction_,     UziUSP.physics_,              UziUSP.collision_)


    Character.add_new_action(UZI,  NSPG5,             -1,                 ActionParams.NSPG5,             0x12,        UziNSP3.main_,                 UziUSP.change_direction_,     UziUSP.physics_,              UziUSP.collision_)
    Character.add_new_action(UZI,  NSPA5,             -1,                 ActionParams.NSPA5,             0x12,        UziNSP3.main_,                UziUSP.change_direction_,     UziUSP.physics_,              UziUSP.collision_)

    Character.add_new_action(UZI,  NSP_Begin,         -1,             ActionParams.NSP_Begin,             0x12,           UziNSP3.begin_main_,           0,                              0,                                  0x800DE6B0)
    Character.add_new_action(UZI,  NSP_Move,          -1,             ActionParams.NSP_Move,              0x12,           UziNSP3.move_main_,            0,                              UziNSP3.move_physics_,             UziNSP3.move_collision_)
    Character.add_new_action(UZI,  NSP_Locked_Move,   -1,             ActionParams.NSP_Locked_Move,       0x12,           UziNSP3.move_main_,            0,                              UziNSP3.move_physics_,             UziNSP3.move_collision_)
    Character.add_new_action(UZI,  NSP_Ground_End2,    -1,             ActionParams.NSP_Ground_End2,        0x12,           0x800D94C4,                     0,                              0x800D8BB4,                         UziNSP3.ground_end_collision_)
    Character.add_new_action(UZI,  NSP_Air_End2,       -1,             ActionParams.NSP_Air_End2,           0x12,           0x800D94E8,                     0,                              0x800D91EC,                         UziNSP3.air_end_collision_)
    Character.add_new_action(UZI,  NSP_Ground_Recoil, -1,             ActionParams.NSP_Ground_Recoil,     0x12,           0x800D94C4,                     0,                              0x800D8BB4,                         UziNSP3.ground_recoil_collision_)
    Character.add_new_action(UZI,  NSP_Air_Recoil,    -1,             ActionParams.NSP_Air_Recoil,        0x12,           0x800D94E8,                     0,                              0x800D91EC,                         UziNSP3.air_recoil_collision_)
    Character.add_new_action(UZI,  NSP_Bounce,        -1,             ActionParams.NSP_Bounce,            0x12,           0x800D94E8,                     0,                              0x800D91EC,                         0x800DE99C)

    Character.add_new_action(UZI,   DSPA_LOOP,         -1,        ActionParams.DSPA_LOOP,                0x1E,           0x00000000,                     0,                          UziDSPA.physics_,         UziDSPA.collision_)   // DSP Air Loop
    Character.add_new_action(UZI,   DSPA_LAND,          -1,        ActionParams.DSPA_LAND,               0x1E,           0x800D94C4,                     0,                          0x800D8BB4,                     0x800DDF44)                 // DSP Air Landing
    Character.add_new_action(UZI,   DSPA_BEGIN,        -1,         ActionParams.DSPA_BEGIN,              0x1E,           UziDSPA.aerial_main_,     0,                          UziDSPA.physics_,         UziDSPA.collision_)   // DSP Air Begin

    Character.add_new_action(UZI,   DSPA_LOOP2,         -1,        ActionParams.DSPA_LOOP,                0x1E,           0x00000000,                     0,                          UziUSP.physics2_,         UziUSP.collision2_)   // DSP Air Loop
    Character.add_new_action(UZI,   DSPA_LAND2,          -1,        ActionParams.DSPA_LAND,               0x1E,           0x800D94C4,                     0,                          0x800D8BB4,                     0x800DDF44)                 // DSP Air Landing
    Character.add_new_action(UZI,   DSPA_BEGIN2,        -1,         ActionParams.DSPA_BEGIN,              0x1E,           UziUSP.aerial_main2_,     0,                          UziUSP.physics2_,         UziUSP.collision2_)   // DSP Air Begin

    Character.table_patch_start(air_usp, Character.id.UZI, 0x4)
    dw      UziUSP.air_initial_
    OS.patch_end()
    Character.table_patch_start(ground_usp, Character.id.UZI, 0x4)
    dw      UziUSP.ground_initial_
    OS.patch_end()
    Character.table_patch_start(ground_nsp, Character.id.UZI, 0x4)
    dw      UziNSP.ground_begin_initial_
    OS.patch_end()
    Character.table_patch_start(air_nsp, Character.id.UZI, 0x4)
    dw      UziNSP3.begin_initial_
    OS.patch_end()
    Character.table_patch_start(ground_dsp, Character.id.UZI, 0x4)
    dw      UziNSP3.begin_initial_
    OS.patch_end()
    Character.table_patch_start(air_dsp, Character.id.UZI, 0x4)
    dw      UziDSPA.air_initial_
    OS.patch_end()

    // Set default costumes
    Character.set_default_costumes(Character.id.UZI, 0, 1, 3, 3, 1, 2, 3)
    Teams.add_team_costume(YELLOW, UZI, 0x5)

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
    dh  0x0625
    OS.patch_end()

    // Set menu zoom size.
    Character.table_patch_start(menu_zoom, Character.id.UZI, 0x4)
    float32 1.125
    OS.patch_end()

    // Allows Marina to use her entry which is similar to Link
    Character.table_patch_start(entry_action, Character.id.UZI, 0x8)
    dw 0xDF, 0xE0
    OS.patch_end()


    // Remove entry script.
    Character.table_patch_start(entry_script, Character.id.UZI, 0x4)
    dw 0x8013DD68                           // skips entry script
    dw marina_entry_routine_
    OS.patch_end()




    Character.table_patch_start(jab_3, Character.id.UZI, 0x4)
    dw      Character.jab_3.DISABLED        // disable jab 3
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