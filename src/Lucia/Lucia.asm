// Marina.asm

// This file contains file inclusions, action edits, and assembly for Ultra-InterGalactic-Cybot G Marina Liteyears.

scope Lucia {

    // Image commands used by moveset files
    scope EYES: {
        constant OPEN(0xAC000000)
        constant DAMAGE(0xAC000001)
        constant MID(0xAC000002)
        constant CLOSED(0xAC000003)
        constant CRAZY(0xAC000004)
    }
    scope MOUTH: {
        constant CLOSED(0xAC100000)
        constant OPEN(0xAC100001)
    }

    scope WAVES {
        constant NOWAVE(0xA0880001)
        constant WAVE(0xA0380000)

    }

	DOWN_BOUNCE:
	dw EYES.DAMAGE; dw MOUTH.OPEN
	Moveset.GO_TO(Moveset.shared.DOWN_BOUNCE)

    // Insert Moveset files
	insert BLINK,"moveset/BLINK.bin"; Moveset.GO_TO(BLINK)            // loops
	IDLE:
    dw 0xbc000003                                   // set slope contour state
    Moveset.SUBROUTINE(BLINK)                   // blink
    dw 0x0400005A; Moveset.SUBROUTINE(BLINK)    // wait 90 frames then blink
    dw 0x0400000A; Moveset.SUBROUTINE(BLINK)    // wait 10 frames then blink
    dw 0x04000050; Moveset.GO_TO(IDLE)         // loop

    insert DASH,"moveset/DASH.bin"
    insert RUN, "moveset/RUN.bin"; Moveset.GO_TO(RUN) // loops
    insert RUN_BRAKE,"moveset/RUN_BRAKE.bin"
    insert TURN,"moveset/TURN.bin"
    insert JUMP_1,"moveset/JUMP_1.bin"
    insert JUMP_2,"moveset/JUMP_2.bin"
    insert TEETER,"moveset/TEETER.bin"

    insert DOWN_STAND,"moveset/DOWN_STAND.bin"
    insert DAMAGED_FACE,"moveset/DAMAGED_FACE.bin"
    DMG_1:; Moveset.SUBROUTINE(DAMAGED_FACE); dw 0
    DMG_2:; Moveset.SUBROUTINE(DAMAGED_FACE); Moveset.GO_TO_FILE(0x270); dw 0
    FALCON_DIVE_PULLED:; Moveset.SUBROUTINE(DAMAGED_FACE); Moveset.GO_TO_FILE(0xF44); dw 0
    UNKNOWN_0B4:; Moveset.SUBROUTINE(DAMAGED_FACE); Moveset.GO_TO_FILE(0xF58); dw 0
    insert SPARKLE,"moveset/SPARKLE.bin"; Moveset.GO_TO(SPARKLE)                    // loops
    insert SHIELD_BREAK,"moveset/SHIELD_BREAK.bin"; Moveset.GO_TO(SPARKLE)          // loops
    insert STUN, "moveset/STUN.bin"; Moveset.GO_TO(STUN)                            // loops
    insert ASLEEP, "moveset/ASLEEP.bin"; Moveset.GO_TO(ASLEEP)                      // loops

    insert DOWN_ROLL,"moveset/DOWN_ROLL.bin"
    insert DOWN_ATTACK_D,"moveset/DOWN_ATTACK_D.bin"
    insert DOWN_ATTACK_U,"moveset/DOWN_ATTACK_U.bin"
	insert TECH,"moveset/TECH.bin"
	insert TECH_ROLL,"moveset/TECH_ROLL.bin"
    insert ROLL_F,"moveset/ROLL_F.bin"
    insert ROLL_B,"moveset/ROLL_B.bin"

    insert CLIFF_CATCH,"moveset/CLIFF_CATCH.bin"
    insert CLIFF_WAIT,"moveset/CLIFF_WAIT.bin"
	insert CLIFF_ATK_QUICK_2,"moveset/CLIFF_ATK_QUICK_2.bin"
	insert CLIFF_ATK_SLOW_2,"moveset/CLIFF_ATK_SLOW_2.bin"

    insert GRAB_RELEASE_DATA,"moveset/GRAB_RELEASE_DATA.bin"
    GRAB:; Moveset.THROW_DATA(GRAB_RELEASE_DATA); insert "moveset/GRAB.bin"
    insert THROW_F,"moveset/THROW_F.bin"
    insert THROW_B_DATA,"moveset/THROW_B_DATA.bin"
    THROW_B:; Moveset.THROW_DATA(THROW_B_DATA); insert "moveset/THROW_B.bin"
    insert CARGO_TURN,"moveset/CARGO_TURN.bin"
    insert CARGO_THROW_DATA,"moveset/CARGO_THROW_DATA.bin"
    CARGO_THROW:; Moveset.THROW_DATA(CARGO_THROW_DATA); insert "moveset/CARGO_THROW.bin"
    insert CARGO_SHAKE,"moveset/CARGO_SHAKE.bin"; Moveset.GO_TO(CARGO_SHAKE + 0x4)        // loops

    TAUNT:; dw MOUTH.OPEN; dw EYES.CLOSED; insert "moveset/TAUNT.bin"
    insert JAB_1, "moveset/JAB_1.bin"
    insert JAB_2, "moveset/JAB_2.bin"
    insert JAB_LOOP, "moveset/JAB_LOOP.bin"; Moveset.GO_TO(JAB_LOOP) // loops
    insert DASH_ATTACK, "moveset/DASH_ATTACK.bin"
    insert F_TILT_HIGH,"moveset/F_TILT_HIGH.bin"
    insert F_TILT,"moveset/F_TILT.bin"
    insert F_TILT_LOW,"moveset/F_TILT_LOW.bin"
    insert U_TILT,"moveset/U_TILT.bin"
    insert D_TILT,"moveset/D_TILT.bin"
    insert F_SMASH,"moveset/F_SMASH.bin"
    insert U_SMASH,"moveset/U_SMASH.bin"
    insert D_SMASH,"moveset/D_SMASH.bin"
    DSPA:; dw WAVES.WAVE; insert "moveset/DSPA.bin"

    insert ATTACK_AIR_N,"moveset/ATTACK_AIR_N.bin"
    insert ATTACK_AIR_F,"moveset/ATTACK_AIR_F.bin"
    insert ATTACK_AIR_B,"moveset/ATTACK_AIR_B.bin"
    insert ATTACK_AIR_U,"moveset/ATTACK_AIR_U.bin"
    insert ATTACK_AIR_D,"moveset/ATTACK_AIR_D.bin"

    insert NSP,"moveset/NSP.bin"
    NSP_PULL:; Moveset.THROW_DATA(GRAB_RELEASE_DATA); insert "moveset/NSP_PULL.bin"
    insert NSPG_THROW_DATA,"moveset/NSPG_THROW_DATA.bin"
    NSPG_THROW:; Moveset.THROW_DATA(NSPG_THROW_DATA); insert "moveset/NSPG_THROW.bin"
    insert NSPG_THROWU_DATA,"moveset/NSPG_THROWU_DATA.bin"
    NSPG_THROWU:; Moveset.THROW_DATA(NSPG_THROWU_DATA); insert "moveset/NSPG_THROWU.bin"
    insert NSPG_THROWD_DATA,"moveset/NSPG_THROWD_DATA.bin"
    NSPG_THROWD:; Moveset.THROW_DATA(NSPG_THROWD_DATA); insert "moveset/NSPG_THROWD.bin"
    insert NSPA_THROW_DATA,"moveset/NSPA_THROW_DATA.bin"
    NSPA_THROW:; Moveset.THROW_DATA(NSPA_THROW_DATA); insert "moveset/NSPA_THROW.bin"
    insert NSPA_THROWU_DATA,"moveset/NSPA_THROWU_DATA.bin"
    NSPA_THROWU:; Moveset.THROW_DATA(NSPA_THROWU_DATA); insert "moveset/NSPA_THROWU.bin"
    insert NSPA_THROWD_DATA,"moveset/NSPA_THROWD_DATA.bin"
    NSPA_THROWD:; Moveset.THROW_DATA(NSPA_THROWD_DATA); insert "moveset/NSPA_THROWD.bin"
    insert USP,"moveset/USP.bin"
    insert DSP_BEGIN, "moveset/DOWN_SPECIAL_BEGIN.bin"
    insert DSP_WAIT, "moveset/DOWN_SPECIAL_WAIT.bin"
    insert DSP_ABSORB, "moveset/DOWN_SPECIAL_ABSORB.bin"
    insert DSP_END, "moveset/DOWN_SPECIAL_END.bin"
    insert DSP_PULL, "moveset/DOWN_SPECIAL_PULL.bin"
    insert DSP_PULL_FAIL, "moveset/DOWN_SPECIAL_PULL_FAIL.bin"
    insert DSP_STOW, "moveset/DOWN_SPECIAL_STOW.bin"
    insert DSPG, "moveset/DSPG.bin"

    HAMMER:; dw 0xC4000007; dw 0xBC000004; dw 0xAC000001; dw 0xAC100001; Moveset.SUBROUTINE(Moveset.shared.HAMMER); dw 0x04000010; dw 0x18000000; Moveset.GO_TO(HAMMER)


    ONEP:; dw MOUTH.OPEN; dw EYES.CRAZY; insert "moveset/ONEP.bin"
    insert ENTRY,"moveset/ENTRY.bin"
	insert CLAP,"moveset/CLAP.bin"
	insert VICTORY,"moveset/VICTORY.bin"
	insert VICTORY_1,"moveset/VICTORY_1.bin"
	insert VICTORY_2,"moveset/VICTORY_2.bin"
    CSS:; dw MOUTH.OPEN; insert "moveset/CSS.bin"

    // Insert AI attack options
    include "AI/Attacks.asm"

    // @ Description
    // Marina's extra actions
    scope Action {
        constant JabLoopStart(0x0DC)
        constant JabLoop(0x0DD)
        constant JabLoopEnd(0x0DE)
        constant Entry_R(0x0DF)
        constant Entry_L(0x0E0)
        constant NSPGround(0x0E1)
        constant NSPGroundPull(0x0E2)
        constant NSPGroundThrow(0x0E3)
        constant NSPGroundThrowU(0x0E4)
        constant NSPGroundThrowD(0x0E5)
        constant NSPAir(0x0E6)
        constant NSPAirPull(0x0E7)
        constant NSPAirThrow(0x0E8)
        constant NSPAirThrowU(0x0E9)
        constant NSPAirThrowD(0x0EA)
        constant Cargo(0x0EB)
        constant CargoWalk1(0x0EC)
        constant CargoWalk2(0x0ED)
        constant CargoWalk3(0x0EE)
        // constant CargoTurn(0x0EF)
        // constant CargoJumpSquat(0x0F0)
        // constant CargoAir(0x0F1)
        // constant CargoLanding(0x0F2)
        // constant CargoDamage(0x0F3)
        // constant CargoThrow(0x0F4)
        // constant CargoThrowAir(0x0F5)
        // constant CargoItemThrowF(0x0F6)
        // constant CargoItemThrowB(0x0F7)
        // constant CargoItemThrowSmashF(0x0F8)
        // constant CargoItemThrowSmashB(0x0F9)
        // constant CargoJump(0x0FA)
        // constant CargoShake(0x0FB)
        // constant USPG(0x0FC)
        // constant USPA(0x0FD)
        // constant ClanpotBeginG(0x0FE)
        // constant ClanpotWaitG(0x0FF)
        // constant ClanpotAbsorbG(0x0100)
        // constant ClanpotEndG(0x0101)
        // constant ClanpotPullG(0x0102)
        // constant ClanpotFailG(0x0103)
        // constant ClanpotStowG(0x0104)
        // constant ClanpotBeginA(0x0105)
        // constant ClanpotWaitA(0x0106)
        // constant ClanpotAbsorbA(0x0107)
        // constant ClanpotEndA(0x0108)
        // constant ClanpotPullA(0x0109)
        // constant ClanpotFailA(0x010A)
        // constant ClanpotStowA(0x010B)
        // constant DSPG2(0x010C)
        // constant DSPA2(0x010D)

        // strings!
        string_0x0E1:; String.insert("JetSnatchG")
        string_0x0E2:; String.insert("JetSnatchPullG")
        string_0x0E3:; String.insert("JetSnatchThrowG")
        string_0x0E4:; String.insert("JetSnatchThrowUG")
        string_0x0E5:; String.insert("JetSnatchThrowDG")
        string_0x0E6:; String.insert("JetSnatchA")
        string_0x0E7:; String.insert("JetSnatchPullA")
        string_0x0E8:; String.insert("JetSnatchThrowA")
        string_0x0E9:; String.insert("JetSnatchThrowUA")
        string_0x0EA:; String.insert("JetSnatchThrowDA")
        string_0x0EB:; String.insert("Cargo")
        string_0x0EC:; String.insert("CargoWalk1")
        string_0x0ED:; String.insert("CargoWalk2")
        string_0x0EE:; String.insert("CargoWalk3")
        string_0x0EF:; String.insert("CargoTurn")
        string_0x0F0:; String.insert("CargoJumpSquat")
        string_0x0F1:; String.insert("CargoAir")
        string_0x0F2:; String.insert("CargoLanding")
        string_0x0F3:; String.insert("CargoDamage")
        string_0x0F4:; String.insert("CargoThrow")
        string_0x0F5:; String.insert("CargoThrowAir")
        string_0x0F6:; String.insert("CargoItemThrowF")
        string_0x0F7:; String.insert("CargoItemThrowB")
        string_0x0F8:; String.insert("CargoItemThrowSmashF")
        string_0x0F9:; String.insert("CargoItemThrowSmashB")
        string_0x0FA:; String.insert("CargoJump")
        string_0x0FB:; String.insert("CargoShake")
        string_0x0FC:; String.insert("AfterburnerUpperG")
        string_0x0FD:; String.insert("AfterburnerUpperA")
        string_0x0FE:; String.insert("ClanpotBeginG")
        string_0x0FF:; String.insert("ClanpotWaitG")
        string_0x0100:; String.insert("ClanpotAbsorbG")
        string_0x0101:; String.insert("ClanpotEndG")
        string_0x0102:; String.insert("ClanpotPullG")
        string_0x0103:; String.insert("ClanpotFailG")
        string_0x0104:; String.insert("ClanpotStowG")
        string_0x0105:; String.insert("ClanpotBeginA")
        string_0x0106:; String.insert("ClanpotWaitA")
        string_0x0107:; String.insert("ClanpotAbsorbA")
        string_0x0108:; String.insert("ClanpotEndA")
        string_0x0109:; String.insert("ClanpotPullA")
        string_0x010A:; String.insert("ClanpotFailA")
        string_0x010B:; String.insert("ClanpotStowA")
        string_0x010C:; String.insert("DSPG2")
        string_0x010D:; String.insert("DSPA2")

        action_string_table:
        dw Action.COMMON.string_jabloopstart
        dw Action.COMMON.string_jabloop
        dw Action.COMMON.string_jabloopend
        dw Action.COMMON.string_appear1
        dw Action.COMMON.string_appear2
        dw string_0x0E1
        dw string_0x0E2
        dw string_0x0E3
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
        dw string_0x0EF
        dw string_0x0F0
        dw string_0x0F1
        dw string_0x0F2
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
        dw string_0x0100
        dw string_0x0101
        dw string_0x0102
        dw string_0x0103
        dw string_0x0104
        dw string_0x0105
        dw string_0x0106
        dw string_0x0107
        dw string_0x0108
        dw string_0x0109
        dw string_0x010A
        dw string_0x010B
        dw string_0x010C
        dw string_0x010D
    }

    // Modify Action Parameters              // Action                      // Animation                        // Moveset Data             // Flags
    Character.edit_action_parameters(LUCIA, Action.DeadU,                  File.MARINA_TUMBLE,                 DMG_1,                      -1)
    Character.edit_action_parameters(LUCIA, Action.ScreenKO,               File.MARINA_TUMBLE,                 DMG_1,                      -1)
    Character.edit_action_parameters(LUCIA, Action.Entry,                  File.MARINA_IDLE,                   IDLE,                       -1)
    Character.edit_action_parameters(LUCIA, 0x006,                         File.MARINA_IDLE,                   IDLE,                       -1)
    Character.edit_action_parameters(LUCIA, Action.Revive1,                File.MARINA_DOWN_BNCE_D,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.Revive2,                File.MARINA_DOWN_STND_D,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.ReviveWait,             File.LUCIA_IDLE,                   IDLE,                       -1)
    Character.edit_action_parameters(LUCIA, Action.Idle,                   File.LUCIA_IDLE,                   IDLE,                       -1)
    Character.edit_action_parameters(LUCIA, Action.Walk1,                  File.MARINA_WALK_1,                 -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.Walk2,                  File.MARINA_WALK_2,                 -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.Walk3,                  File.MARINA_WALK_3,                 -1,                         -1)
    Character.edit_action_parameters(LUCIA, 0x00E,                         File.MARINA_WALK_END,               -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.Dash,                   File.MARINA_DASH,                   DASH,                       0x10000000)
    Character.edit_action_parameters(LUCIA, Action.Run,                    File.MARINA_RUN,                    RUN,                        -1)
    Character.edit_action_parameters(LUCIA, Action.RunBrake,               File.MARINA_RUN_BRAKE,              RUN_BRAKE,                  -1)
    Character.edit_action_parameters(LUCIA, Action.Turn,                   File.MARINA_TURN,                   TURN,                       -1)
    Character.edit_action_parameters(LUCIA, Action.TurnRun,                File.MARINA_TURN_RUN,               -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.JumpSquat,              File.MARINA_LANDING,                -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.ShieldJumpSquat,        File.MARINA_LANDING,                -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.JumpF,                  File.MARINA_JUMP_F,                 JUMP_1,                     -1)
    Character.edit_action_parameters(LUCIA, Action.JumpB,                  File.MARINA_JUMP_B,                 JUMP_1,                     -1)
    Character.edit_action_parameters(LUCIA, Action.JumpAerialF,            File.MARINA_JUMP_AERIAL_F,          JUMP_2,                     0x10000000)
    Character.edit_action_parameters(LUCIA, Action.JumpAerialB,            File.MARINA_JUMP_AERIAL_B,          JUMP_2,                     0x10000000)
    Character.edit_action_parameters(LUCIA, Action.Fall,                   File.MARINA_FALL,                   -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.FallAerial,             File.MARINA_FALL_AERIAL,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.Crouch,                 File.MARINA_CROUCH,                 -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.CrouchIdle,             File.MARINA_CROUCH_IDLE,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.CrouchEnd,              File.MARINA_CROUCH_END,             -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.LandingLight,           File.MARINA_LANDING,                -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.LandingHeavy,           File.MARINA_LANDING,                -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.Pass,                   File.MARINA_PLAT_DROP,              -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.ShieldDrop,             File.MARINA_PLAT_DROP,              -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.Teeter,                 File.MARINA_TEETER,                 TEETER,                     -1)
    Character.edit_action_parameters(LUCIA, Action.TeeterStart,            File.MARINA_TEETERSTART,            TEETER,                     -1)
    Character.edit_action_parameters(LUCIA, Action.DamageHigh1,            File.MARINA_DMG_HIGH_1,             DMG_1,                      -1)
    Character.edit_action_parameters(LUCIA, Action.DamageHigh2,            File.MARINA_DMG_HIGH_2,             DMG_1,                      -1)
    Character.edit_action_parameters(LUCIA, Action.DamageHigh3,            File.MARINA_DMG_HIGH_3,             DMG_1,                      -1)
    Character.edit_action_parameters(LUCIA, Action.DamageMid1,             File.MARINA_DMG_MID_1,              DMG_1,                      -1)
    Character.edit_action_parameters(LUCIA, Action.DamageMid2,             File.MARINA_DMG_MID_2,              DMG_1,                      -1)
    Character.edit_action_parameters(LUCIA, Action.DamageMid3,             File.MARINA_DMG_MID_3,              DMG_1,                      -1)
    Character.edit_action_parameters(LUCIA, Action.DamageLow1,             File.MARINA_DMG_LOW_1,              DMG_1,                      -1)
    Character.edit_action_parameters(LUCIA, Action.DamageLow2,             File.MARINA_DMG_LOW_2,              DMG_1,                      -1)
    Character.edit_action_parameters(LUCIA, Action.DamageLow3,             File.MARINA_DMG_LOW_3,              DMG_1,                      -1)
    Character.edit_action_parameters(LUCIA, Action.DamageAir1,             File.MARINA_DMG_AIR_1,              DMG_1,                      -1)
    Character.edit_action_parameters(LUCIA, Action.DamageAir2,             File.MARINA_DMG_AIR_2,              DMG_1,                      -1)
    Character.edit_action_parameters(LUCIA, Action.DamageAir3,             File.MARINA_DMG_AIR_3,              DMG_1,                      -1)
    Character.edit_action_parameters(LUCIA, Action.DamageElec1,            File.MARINA_DMG_ELEC,               DMG_1,                      -1)
    Character.edit_action_parameters(LUCIA, Action.DamageElec2,            File.MARINA_DMG_ELEC,               DMG_1,                      -1)
    Character.edit_action_parameters(LUCIA, Action.DamageFlyHigh,          File.MARINA_DMG_FLY_HIGH,           DMG_2,                      -1)
    Character.edit_action_parameters(LUCIA, Action.DamageFlyMid,           File.MARINA_DMG_FLY_MID,            DMG_2,                      -1)
    Character.edit_action_parameters(LUCIA, Action.DamageFlyLow,           File.MARINA_DMG_FLY_LOW,            DMG_2,                      -1)
    Character.edit_action_parameters(LUCIA, Action.DamageFlyTop,           File.MARINA_DMG_FLY_TOP,            DMG_2,                      -1)
    Character.edit_action_parameters(LUCIA, Action.DamageFlyRoll,          File.MARINA_DMG_FLY_ROLL,           DMG_2,                      -1)
    Character.edit_action_parameters(LUCIA, Action.WallBounce,             File.MARINA_TUMBLE,                 DMG_1,                      -1)
    Character.edit_action_parameters(LUCIA, Action.Tumble,                 File.MARINA_TUMBLE,                 DMG_1,                      -1)
    Character.edit_action_parameters(LUCIA, Action.FallSpecial,            File.MARINA_FALL_SPECIAL,           -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.LandingSpecial,         File.MARINA_LANDING,                -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.Tornado,                File.MARINA_TUMBLE,                 -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.EnterPipe,              File.MARINA_ENTER_PIPE,             -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.ExitPipe,               File.MARINA_EXIT_PIPE,              -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.ExitPipeWalk,           File.MARINA_EXIT_PIPE_WALK,         -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.CeilingBonk,            File.MARINA_CEILING_BONK,           -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.DownBounceD,            File.MARINA_DOWN_BNCE_D,            DOWN_BOUNCE,                -1)
    Character.edit_action_parameters(LUCIA, Action.DownBounceU,            File.MARINA_DOWN_BNCE_U,            DOWN_BOUNCE,                -1)
    Character.edit_action_parameters(LUCIA, Action.DownStandD,             File.MARINA_DOWN_STND_D,            DOWN_STAND,                 -1)
    Character.edit_action_parameters(LUCIA, Action.DownStandU,             File.MARINA_DOWN_STND_U,            DOWN_STAND,                 -1)
    Character.edit_action_parameters(LUCIA, Action.TechF,                  File.MARINA_TECH_F,                 TECH_ROLL,                  -1)
    Character.edit_action_parameters(LUCIA, Action.TechB,                  File.MARINA_TECH_B,                 TECH_ROLL,                  -1)
    Character.edit_action_parameters(LUCIA, Action.DownForwardD,           File.MARINA_DOWN_FWRD_D,            DOWN_ROLL,                  0x50000000)
    Character.edit_action_parameters(LUCIA, Action.DownForwardU,           File.MARINA_DOWN_FWRD_U,            DOWN_ROLL,                  0x50000000)
    Character.edit_action_parameters(LUCIA, Action.DownBackD,              File.MARINA_DOWN_BACK_D,            DOWN_ROLL,                  0x50000000)
    Character.edit_action_parameters(LUCIA, Action.DownBackU,              File.MARINA_DOWN_BACK_U,            DOWN_ROLL,                  0x50000000)
    Character.edit_action_parameters(LUCIA, Action.DownAttackD,            File.MARINA_DOWN_ATK_D,             DOWN_ATTACK_D,              -1)
    Character.edit_action_parameters(LUCIA, Action.DownAttackU,            File.MARINA_DOWN_ATK_U,             DOWN_ATTACK_U,              -1)
    Character.edit_action_parameters(LUCIA, Action.Tech,                   File.MARINA_TECH,                   TECH,                       -1)
    Character.edit_action_parameters(LUCIA, Action.ClangRecoil,            File.MARINA_CLANG_RECOIL,           -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.CliffCatch,             File.MARINA_CLF_CATCH,              CLIFF_CATCH,                -1)
    Character.edit_action_parameters(LUCIA, Action.CliffWait,              File.MARINA_CLF_WAIT,               CLIFF_WAIT,                 -1)
    Character.edit_action_parameters(LUCIA, Action.CliffQuick,             File.MARINA_CLF_QUICK,              -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.CliffClimbQuick1,       File.MARINA_CLF_CLM_Q_1,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.CliffClimbQuick2,       File.MARINA_CLF_CLM_Q_2,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.CliffSlow,              File.MARINA_CLF_SLOW,               -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.CliffClimbSlow1,        File.MARINA_CLF_CLM_S_1,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.CliffClimbSlow2,        File.MARINA_CLF_CLM_S_2,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.CliffAttackQuick1,      File.MARINA_CLF_ATK_Q_1,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.CliffAttackQuick2,      File.MARINA_CLF_ATK_Q_2,            CLIFF_ATK_QUICK_2,          -1)
    Character.edit_action_parameters(LUCIA, Action.CliffAttackSlow1,       File.MARINA_CLF_ATK_S_1,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.CliffAttackSlow2,       File.MARINA_CLF_ATK_S_2,            CLIFF_ATK_SLOW_2,           -1)
    Character.edit_action_parameters(LUCIA, Action.CliffEscapeQuick1,      File.MARINA_CLF_ESC_Q_1,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.CliffEscapeQuick2,      File.MARINA_CLF_ESC_Q_2,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.CliffEscapeSlow1,       File.MARINA_CLF_ESC_S_1,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.CliffEscapeSlow2,       File.MARINA_CLF_ESC_S_2,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.LightItemPickup,        File.MARINA_L_ITM_PICKUP,           -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.HeavyItemPickup,        File.MARINA_HEAVY_ITM_PICKUP,       -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.ItemDrop,               File.MARINA_ITM_DROP,               -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.ItemThrowDash,          File.MARINA_ITM_THROW_DASH,         -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.ItemThrowF,             File.MARINA_ITM_THROW_F,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.ItemThrowB,             File.MARINA_ITM_THROW_F,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.ItemThrowU,             File.MARINA_ITM_THROW_U,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.ItemThrowD,             File.MARINA_ITM_THROW_D,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.ItemThrowSmashF,        File.MARINA_ITM_THROW_F,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.ItemThrowSmashB,        File.MARINA_ITM_THROW_F,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.ItemThrowSmashU,        File.MARINA_ITM_THROW_U,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.ItemThrowSmashD,        File.MARINA_ITM_THROW_D,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.ItemThrowAirF,          File.MARINA_ITM_THROW_AIR_F,        -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.ItemThrowAirB,          File.MARINA_ITM_THROW_AIR_F,        -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.ItemThrowAirU,          File.MARINA_ITM_THROW_AIR_U,        -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.ItemThrowAirD,          File.MARINA_ITM_THROW_AIR_D,        -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.ItemThrowAirSmashF,     File.MARINA_ITM_THROW_AIR_F,        -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.ItemThrowAirSmashB,     File.MARINA_ITM_THROW_AIR_F,        -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.ItemThrowAirSmashU,     File.MARINA_ITM_THROW_AIR_U,        -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.ItemThrowAirSmashD,     File.MARINA_ITM_THROW_AIR_D,        -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.HeavyItemThrowF,        File.MARINA_CARGO_THROW,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.HeavyItemThrowB,        File.MARINA_CARGO_THROW,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.HeavyItemThrowSmashF,   File.MARINA_CARGO_THROW,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.HeavyItemThrowSmashB,   File.MARINA_CARGO_THROW,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.BeamSwordNeutral,       File.MARINA_ITM_NEUTRAL,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.BeamSwordTilt,          File.MARINA_ITM_TILT,               -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.BeamSwordSmash,         File.MARINA_ITM_SMASH,              -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.BeamSwordDash,          File.MARINA_ITM_DASH,               -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.BatNeutral,             File.MARINA_ITM_NEUTRAL,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.BatTilt,                File.MARINA_ITM_TILT,               -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.BatSmash,               File.MARINA_ITM_SMASH,              -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.BatDash,                File.MARINA_ITM_DASH,               -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.FanNeutral,             File.MARINA_ITM_NEUTRAL,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.FanTilt,                File.MARINA_ITM_TILT,               -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.FanSmash,               File.MARINA_ITM_SMASH,              -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.FanDash,                File.MARINA_ITM_DASH,               -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.StarRodNeutral,         File.MARINA_ITM_NEUTRAL,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.StarRodTilt,            File.MARINA_ITM_TILT,               -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.StarRodSmash,           File.MARINA_ITM_SMASH,              -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.StarRodDash,            File.MARINA_ITM_DASH,               -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.RayGunShoot,            File.MARINA_ITM_SHOOT,              -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.RayGunShootAir,         File.MARINA_ITM_SHOOT_AIR,          -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.FireFlowerShoot,        File.MARINA_ITM_SHOOT,              -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.FireFlowerShootAir,     File.MARINA_ITM_SHOOT_AIR,          -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.HammerIdle,             File.MARINA_HAMMER_IDLE,            HAMMER,                     -1)
    Character.edit_action_parameters(LUCIA, Action.HammerWalk,             File.MARINA_HAMMER_MOVE,            HAMMER,                     -1)
    Character.edit_action_parameters(LUCIA, Action.HammerTurn,             File.MARINA_HAMMER_MOVE,            HAMMER,                     -1)
    Character.edit_action_parameters(LUCIA, Action.HammerJumpSquat,        File.MARINA_HAMMER_MOVE,            HAMMER,                     -1)
    Character.edit_action_parameters(LUCIA, Action.HammerAir,              File.MARINA_HAMMER_MOVE,            HAMMER,                     -1)
    Character.edit_action_parameters(LUCIA, Action.HammerLanding,          File.MARINA_HAMMER_MOVE,            HAMMER,                     -1)
    Character.edit_action_parameters(LUCIA, Action.ShieldOn,               File.MARINA_SHIELD_ON,              -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.ShieldOff,              File.MARINA_SHIELD_OFF,             -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.RollF,                  File.MARINA_ROLL_F,                 ROLL_F,                     0x50000000)
    Character.edit_action_parameters(LUCIA, Action.RollB,                  File.MARINA_ROLL_B,                 ROLL_B,                     0x50000000)
    Character.edit_action_parameters(LUCIA, Action.ShieldBreak,            File.MARINA_DMG_FLY_TOP,            SHIELD_BREAK,               -1)
    Character.edit_action_parameters(LUCIA, Action.ShieldBreakFall,        File.MARINA_TUMBLE,                 SPARKLE,                    -1)
    Character.edit_action_parameters(LUCIA, Action.StunLandD,              File.MARINA_DOWN_BNCE_D,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.StunLandU,              File.MARINA_DOWN_BNCE_U,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.StunStartD,             File.MARINA_DOWN_STND_D,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.StunStartU,             File.MARINA_DOWN_STND_U,            -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.Stun,                   File.MARINA_STUN,                   STUN,                       -1)
    Character.edit_action_parameters(LUCIA, Action.Sleep,                  File.MARINA_STUN,                   ASLEEP,                     -1)
    Character.edit_action_parameters(LUCIA, Action.Grab,                   File.MARINA_GRAB,                   GRAB,                       -1)
    Character.edit_action_parameters(LUCIA, Action.GrabPull,               File.MARINA_GRAB_PULL,              -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.ThrowF,                 File.MARINA_THROW_F,                THROW_F,                    -1)
    Character.edit_action_parameters(LUCIA, Action.ThrowB,                 File.MARINA_THROW_B,                THROW_B,                    0x50000000)
    Character.edit_action_parameters(LUCIA, Action.CapturePulled,          File.MARINA_CAPTURE_PULLED,         DMG_1,                      -1)
    Character.edit_action_parameters(LUCIA, Action.InhalePulled,           File.MARINA_TUMBLE,                 DMG_1,                      -1)
    Character.edit_action_parameters(LUCIA, Action.InhaleSpat,             File.MARINA_TUMBLE,                 -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.InhaleCopied,           File.MARINA_TUMBLE,                 -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.EggLayPulled,           File.MARINA_CAPTURE_PULLED,         DMG_1,                      -1)
    Character.edit_action_parameters(LUCIA, Action.EggLay,                 File.MARINA_IDLE,                   -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.FalconDivePulled,       File.MARINA_DMG_HIGH_3,             -1,                         -1)
    Character.edit_action_parameters(LUCIA, 0x0B4,                         File.MARINA_TUMBLE,                 UNKNOWN_0B4,                -1)
    Character.edit_action_parameters(LUCIA, Action.ThrownDKPulled,         File.MARINA_THROWN_DKPULLED,        DMG_1,                      -1)
    Character.edit_action_parameters(LUCIA, Action.ThrownMarioBros,        File.MARINA_THROWN_MARIO_BROS,      DMG_1,                      -1)
    Character.edit_action_parameters(LUCIA, Action.ThrownDK,               File.MARINA_THROWN_DK,              DMG_1,                      -1)
    Character.edit_action_parameters(LUCIA, Action.Thrown1,                File.MARINA_THROWN_1,               DMG_1,                      -1)
    Character.edit_action_parameters(LUCIA, Action.Thrown2,                File.MARINA_THROWN_2,               DMG_1,                      -1)
    Character.edit_action_parameters(LUCIA, Action.Taunt,                  File.LUCIA_TAUNT,                  TAUNT,                      -1)
    Character.edit_action_parameters(LUCIA, Action.Jab1,                   File.MARINA_JAB_1,                  JAB_1,                      -1)
    Character.edit_action_parameters(LUCIA, Action.Jab2,                   File.MARINA_JAB_2,                  JAB_2,                      -1)
    Character.edit_action_parameters(LUCIA, Action.DashAttack,             File.MARINA_DASH_ATTACK,            DASH_ATTACK,                -1)
    Character.edit_action_parameters(LUCIA, Action.FTiltHigh,              File.MARINA_FTILT_HIGH,             F_TILT_HIGH,                -1)
    Character.edit_action_parameters(LUCIA, Action.FTiltMidHigh,           0,                                  0x80000000,                 0)
    Character.edit_action_parameters(LUCIA, Action.FTilt,                  File.MARINA_FTILT,                  F_TILT,                     1)
    Character.edit_action_parameters(LUCIA, Action.FTiltMidLow,            0,                                  0x80000000,                 0)
    Character.edit_action_parameters(LUCIA, Action.FTiltLow,               File.MARINA_FTILT_LOW,              F_TILT_LOW,                 -1)
    Character.edit_action_parameters(LUCIA, Action.UTilt,                  File.MARINA_UTILT,                  U_TILT,                     -1)
    Character.edit_action_parameters(LUCIA, Action.DTilt,                  File.MARINA_DTILT,                  D_TILT,                     -1)
    Character.edit_action_parameters(LUCIA, Action.FSmashHigh,             0,                                  0x80000000,                 -1)
    Character.edit_action_parameters(LUCIA, Action.FSmash,                 File.LUCIA_FSMASH,                  F_SMASH,                    -1)
    Character.edit_action_parameters(LUCIA, Action.FSmashLow,              0,                                  0x80000000,                 -1)
    Character.edit_action_parameters(LUCIA, Action.USmash,                 File.MARINA_USMASH,                 U_SMASH,                    0)
    Character.edit_action_parameters(LUCIA, Action.DSmash,                 File.MARINA_DSMASH,                 D_SMASH,                    -1)
    Character.edit_action_parameters(LUCIA, Action.AttackAirN,             File.MARINA_ATTACK_AIR_N,           ATTACK_AIR_N,               -1)
    Character.edit_action_parameters(LUCIA, Action.AttackAirF,             File.MARINA_ATTACK_AIR_F,           ATTACK_AIR_F,               -1)
    Character.edit_action_parameters(LUCIA, Action.AttackAirB,             File.MARINA_ATTACK_AIR_B,           ATTACK_AIR_B,               -1)
    Character.edit_action_parameters(LUCIA, Action.AttackAirU,             File.MARINA_ATTACK_AIR_U,           ATTACK_AIR_U,               -1)
    Character.edit_action_parameters(LUCIA, Action.AttackAirD,             File.LUCIA_DAIR,           ATTACK_AIR_D,               -1)
    Character.edit_action_parameters(LUCIA, Action.LandingAirF,            File.MARINA_LANDING_AIR_F,          -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.LandingAirB,            File.MARINA_LANDING_AIR_B,          -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.LandingAirX,            File.MARINA_LANDING,                -1,                         -1)
    Character.edit_action_parameters(LUCIA, Action.JabLoopStart,           File.MARINA_JAB_LOOP_START,         0x80000000,                 0)
    Character.edit_action_parameters(LUCIA, Action.JabLoop,                File.MARINA_JAB_LOOP,               JAB_LOOP,                   0)
    Character.edit_action_parameters(LUCIA, Action.JabLoopEnd,             File.MARINA_JAB_LOOP_END,           0x80000000,                 0)
    Character.edit_action_parameters(LUCIA, Action.Entry_R,                File.MARINA_ENTRY,                  ENTRY,                      0x40000000)
    Character.edit_action_parameters(LUCIA, Action.Entry_L,                File.MARINA_ENTRY,                  ENTRY,                      0x40000000)
    Character.edit_action_parameters(LUCIA, Action.NSPGround,              File.MARINA_NSPG,                   NSP,                        0x10000000)
    Character.edit_action_parameters(LUCIA, Action.NSPGroundPull,          File.MARINA_NSPG_PULL,              NSP_PULL,                   0x10000000)
    Character.edit_action_parameters(LUCIA, Action.NSPGroundThrow,         File.MARINA_NSPG_THROW,             NSPG_THROW,                 0x10000000)
    Character.edit_action_parameters(LUCIA, Action.NSPGroundThrowU,        File.MARINA_NSPG_THROW_U,           NSPG_THROWU,                0x10000000)
    Character.edit_action_parameters(LUCIA, Action.NSPGroundThrowD,        File.MARINA_NSPG_THROW_D,           NSPG_THROWD,                0x10000000)
    Character.edit_action_parameters(LUCIA, Action.NSPAir,                 File.MARINA_NSPA,                   NSP,                        0x10000000)
    Character.edit_action_parameters(LUCIA, Action.NSPAirPull,             File.MARINA_NSPA_PULL,              NSP_PULL,                   0x10000000)
    Character.edit_action_parameters(LUCIA, Action.NSPAirThrow,            File.MARINA_NSPA_THROW,             NSPA_THROW,                 0x10000000)
    Character.edit_action_parameters(LUCIA, Action.NSPAirThrowU,           File.MARINA_NSPA_THROW_U,           NSPA_THROWU,                0x10000000)
    Character.edit_action_parameters(LUCIA, Action.NSPAirThrowD,           File.MARINA_NSPA_THROW_D,           NSPA_THROWD,                0x10000000)
    Character.edit_action_parameters(LUCIA, Action.Cargo,                  File.MARINA_CARGO,                  0x80000000,                 0x10000000)
    Character.edit_action_parameters(LUCIA, Action.CargoWalk1,             File.MARINA_CARGO_WALK_1,           0x80000000,                 0x10000000)
    Character.edit_action_parameters(LUCIA, Action.CargoWalk2,             File.MARINA_CARGO_WALK_2,           0x80000000,                 0x10000000)
    Character.edit_action_parameters(LUCIA, Action.CargoWalk3,             File.MARINA_CARGO_WALK_3,           0x80000000,                 0x10000000)

    // Modify Actions             // Action                 // Staling ID   // Main ASM                     // Interrupt/Other ASM          // Movement/Physics ASM         // Collision ASM
    Character.edit_action(LUCIA, Action.JabLoopStart,      0x4,            0x8014F0D0,                     0,                              0x800D8BB4,                     0x800DDF44)
    Character.edit_action(LUCIA, Action.JabLoop,           0x4,            0x8014F2A8,                     0x8014F388,                     0x800D8BB4,                     0x800DDF44)
    Character.edit_action(LUCIA, Action.JabLoopEnd,        0x4,            0x800D94C4,                     0,                              0x800D8BB4,                     0x800DDF44)
    Character.edit_action(LUCIA, Action.Entry_R,           0,              0x8013DA94,                     0,                              0x8013DB2C,                     0x800DE348)
    Character.edit_action(LUCIA, Action.Entry_L,           0,              0x8013DA94,                     0,                              0x8013DB2C,                     0x800DE348)
    Character.edit_action(LUCIA, Action.NSPGround,         0x12,           0x800D94C4,                     0,                              LuciaNSP.ground_physics_,      LuciaNSP.ground_collision_)
    Character.edit_action(LUCIA, Action.NSPGroundPull,     0x12,           LuciaNSP.ground_pull_main_,    0,                              0x800D8BB4,                     LuciaNSP.grab_ground_collision_)
    Character.edit_action(LUCIA, Action.NSPGroundThrow,    0x12,           0x8014A0C0,                     LuciaNSP.throw_turn_,          0x800D8BB4,                     0x80149B78)
    Character.edit_action(LUCIA, Action.NSPGroundThrowU,   0x12,           0x8014A0C0,                     0,                              0x800D8BB4,                     0x80149B78)
    Character.edit_action(LUCIA, Action.NSPGroundThrowD,   0x12,           0x8014A0C0,                     0,                              0x800D8BB4,                     0x80149B78)
    Character.edit_action(LUCIA, Action.NSPAir,            0x12,           0x800D94E8,                     0,                              LuciaNSP.air_physics_,         LuciaNSP.air_collision_)
    Character.edit_action(LUCIA, Action.NSPAirPull,        0x12,           LuciaNSP.air_pull_main_,       0,                              0x800D91EC,                     LuciaNSP.grab_air_collision_)
    Character.edit_action(LUCIA, Action.NSPAirThrow,       0x12,           0x8014A0C0,                     LuciaNSP.throw_turn_,          LuciaNSP.throw_air_physics_,   LuciaNSP.throw_air_collision_)
    Character.edit_action(LUCIA, Action.NSPAirThrowU,      0x12,           0x8014A0C0,                     0,                              LuciaNSP.throw_air_physics_,   LuciaNSP.throw_air_collision_)
    Character.edit_action(LUCIA, Action.NSPAirThrowD,      0x12,           0x8014A0C0,                     0,                              LuciaNSP.throw_air_physics_,   LuciaNSP.throw_air_collision_)
    Character.edit_action(LUCIA, Action.Cargo,             0x23,           0,                              0x8014D400,                     0x800D8BB4,                     0x8014D478)
    Character.edit_action(LUCIA, Action.CargoWalk1,        0x23,           0,                              0x8014D590,                     0x8013E548,                     0x8014D478)
    Character.edit_action(LUCIA, Action.CargoWalk2,        0x23,           0,                              0x8014D590,                     0x8013E548,                     0x8014D478)
    Character.edit_action(LUCIA, Action.CargoWalk3,        0x23,           0,                              0x8014D590,                     0x8013E548,                     0x8014D478)

    // Add Action Parameters                // Action Name      // Base Action  // Animation                    // Moveset Data             // Flags
    Character.add_new_action_params(LUCIA, CargoTurn,          -1,             File.MARINA_CARGO_TURN,         CARGO_TURN,                 0x10000000)
    Character.add_new_action_params(LUCIA, CargoJumpSquat,     -1,             File.MARINA_CARGO_JUMPSQUAT,    0x80000000,                 0x10000000)
    Character.add_new_action_params(LUCIA, CargoAir,           -1,             File.MARINA_CARGO_AIR,          0x80000000,                 0x10000000)
    Character.add_new_action_params(LUCIA, CargoLanding,       -1,             File.MARINA_CARGO_JUMPSQUAT,    0x80000000,                 0x10000000)
    Character.add_new_action_params(LUCIA, CargoDamage,        -1,             File.MARINA_CARGO_AIR,          0x80000000,                 0x10000000)
    Character.add_new_action_params(LUCIA, CargoThrow,         -1,             File.MARINA_CARGO_THROW,        CARGO_THROW,                0x10000000)
    Character.add_new_action_params(LUCIA, CargoThrowAir,      -1,             File.MARINA_CARGO_THROW_AIR,    CARGO_THROW,                0x10000000)
    Character.add_new_action_params(LUCIA, CargoItemThrowF,    -1,             File.MARINA_CARGO_THROW,        0x8F8,                      0x10000000)
    Character.add_new_action_params(LUCIA, CargoItemThrowB,    -1,             File.MARINA_CARGO_THROW,        0x908,                      0x10000000)
    Character.add_new_action_params(LUCIA, CargoItemThrowSF,   -1,             File.MARINA_CARGO_THROW,        0x918,                      0x10000000)
    Character.add_new_action_params(LUCIA, CargoItemThrowSB,   -1,             File.MARINA_CARGO_THROW,        0x928,                      0x10000000)
    Character.add_new_action_params(LUCIA, CargoJump,          -1,             File.MARINA_CARGO_JUMP,         0x80000000,                 0x10000000)
    Character.add_new_action_params(LUCIA, CargoShake,         -1,             File.MARINA_CARGO_SHAKE,        CARGO_SHAKE,                0x10000000)
    Character.add_new_action_params(LUCIA, USPG,               -1,             File.MARINA_USPG,               USP,                        0x10000000)
    Character.add_new_action_params(LUCIA, USPA,               -1,             File.MARINA_USPA,               USP,                        0x10000000)
    Character.add_new_action_params(LUCIA, DSPG_Begin,         -1,             File.MARINA_DSPG_BEGIN,         DSP_BEGIN,                  0x10000000)
    Character.add_new_action_params(LUCIA, DSPG_Wait,          -1,             File.MARINA_DSPG_WAIT,          DSP_WAIT,                   0x10000000)
    Character.add_new_action_params(LUCIA, DSPG_Absorb,        -1,             File.MARINA_DSPG_ABSORB,        DSP_ABSORB,                 0x10000000)
    Character.add_new_action_params(LUCIA, DSPG_End,           -1,             File.MARINA_DSPG_END,           DSP_END,                    0x10000000)
    Character.add_new_action_params(LUCIA, DSPG_Pull,          -1,             File.MARINA_DSPG_PULL,          DSP_PULL,                   0x10000000)
    Character.add_new_action_params(LUCIA, DSPG_Pull_Fail,     -1,             File.MARINA_DSPG_PULL_FAIL,     DSP_PULL_FAIL,              0x10000000)
    Character.add_new_action_params(LUCIA, DSPG_Stow,          -1,             File.MARINA_DSPG_STOW,          DSP_STOW,                   0x10000000)
    Character.add_new_action_params(LUCIA, DSPA_Begin,         -1,             File.MARINA_DSPA_BEGIN,         DSP_BEGIN,                  0x10000000)
    Character.add_new_action_params(LUCIA, DSPA_Wait,          -1,             File.MARINA_DSPA_WAIT,          DSP_WAIT,                   0x10000000)
    Character.add_new_action_params(LUCIA, DSPA_Absorb,        -1,             File.MARINA_DSPA_ABSORB,        DSP_ABSORB,                 0x10000000)
    Character.add_new_action_params(LUCIA, DSPA_End,           -1,             File.MARINA_DSPA_END,           DSP_END,                    0x10000000)
    Character.add_new_action_params(LUCIA, DSPA_Pull,          -1,             File.MARINA_DSPA_PULL,          DSP_PULL,                   0x10000000)
    Character.add_new_action_params(LUCIA, DSPA_Pull_Fail,     -1,             File.MARINA_DSPA_PULL_FAIL,     DSP_PULL_FAIL,              0x10000000)
    Character.add_new_action_params(LUCIA, DSPA_Stow,          -1,             File.MARINA_DSPA_STOW,          DSP_STOW,                   0x10000000)
    Character.add_new_action_params(LUCIA, DSPG,               -1,             File.LUCIA_DSPG,                DSPG,                       0x00000000)
    Character.add_new_action_params(LUCIA, DSPA,               -1,             File.LUCIA_DSPA,                DSPA,                       0x00000000)

    // Add Actions                   // Action Name     // Base Action  //Parameters                    // Staling ID   // Main ASM                     // Interrupt/Other ASM          // Movement/Physics ASM             // Collision ASM
    Character.add_new_action(LUCIA, CargoTurn,         -1,             ActionParams.CargoTurn,         0x23,           0x8014D740,                     0x8014D790,                     0x800D8BB4,                         0x8014D478)
    Character.add_new_action(LUCIA, CargoJumpSquat,    -1,             ActionParams.CargoJumpSquat,    0x23,           0x8014D850,                     0x8014D8E4,                     0x800D8BB4,                         0x8014D478)
    Character.add_new_action(LUCIA, CargoAir,          -1,             ActionParams.CargoAir,          0x23,           0,                              0x8014DA00,                     0x800D9160,                         0x8014DA30)
    Character.add_new_action(LUCIA, CargoLanding,      -1,             ActionParams.CargoLanding,      0x23,           0x8014DC50,                     0,                              0x800D8BB4,                         0x8014D478)
    Character.add_new_action(LUCIA, CargoDamage,       -1,             ActionParams.CargoDamage,       0x23,           0x8014E050,                     0,                              0x801407A8,                         0x800DEDF0)
    Character.add_new_action(LUCIA, CargoThrow,        -1,             ActionParams.CargoThrow,        0x23,           0x8014DD00,                     0,                              0x800D8BB4,                         0x8014DECC)
    Character.add_new_action(LUCIA, CargoThrowAir,     -1,             ActionParams.CargoThrowAir,     0x23,           0x8014DD00,                     0,                              0x800D90E0,                         0x8014DEF0)
    Character.add_new_action(LUCIA, CargoItemThrowF,   -1,             ActionParams.CargoItemThrowF,   0x23,           0x8014634C,                     0,                              0x80146618,                         0x800DEDF0)
    Character.add_new_action(LUCIA, CargoItemThrowB,   -1,             ActionParams.CargoItemThrowB,   0x23,           0x8014634C,                     0,                              0x80146618,                         0x800DEDF0)
    Character.add_new_action(LUCIA, CargoItemThrowSF,  -1,             ActionParams.CargoItemThrowSF,  0x23,           0x8014634C,                     0,                              0x80146618,                         0x800DEDF0)
    Character.add_new_action(LUCIA, CargoItemThrowSB,  -1,             ActionParams.CargoItemThrowSB,  0x23,           0x8014634C,                     0,                              0x80146618,                         0x800DEDF0)
    Character.add_new_action(LUCIA, CargoJump,         -1,             ActionParams.CargoJump,         0x23,           LuciaCargo.jump_main_,         0x8014DA00,                     0x800D9160,                         0x8014DA30)
    Character.add_new_action(LUCIA, CargoShake,        -1,             ActionParams.CargoShake,        0x23,           LuciaCargo.shake_main_,        0,                              0x800D8BB4,                         0x8014D478)
    Character.add_new_action(LUCIA, USPG,              -1,             ActionParams.USPG,              0x11,           LuciaUSP.main_,                LuciaUSP.change_direction_,    LuciaUSP.physics_,                 LuciaUSP.collision_)
    Character.add_new_action(LUCIA, USPA,              -1,             ActionParams.USPA,              0x11,           LuciaUSP.main_,                LuciaUSP.change_direction_,    LuciaUSP.physics_,                 LuciaUSP.collision_)
    Character.add_new_action(LUCIA, DSPG_Begin,        -1,             ActionParams.DSPG_Begin,        0x1E,           LuciaDSP.ground_begin_main_,   0,                              0x800D8BB4,                         LuciaDSP.ground_collision_)
    Character.add_new_action(LUCIA, DSPG_Wait,         -1,             ActionParams.DSPG_Wait,         0x1E,           LuciaDSP.ground_wait_main_,    0,                              0x800D8BB4,                         LuciaDSP.ground_collision_)
    Character.add_new_action(LUCIA, DSPG_Absorb,       -1,             ActionParams.DSPG_Absorb,       0x1E,           LuciaDSP.ground_absorb_main_,  0,                              0x800D8BB4,                         LuciaDSP.ground_collision_)
    Character.add_new_action(LUCIA, DSPG_End,          -1,             ActionParams.DSPG_End,          0x1E,           LuciaDSP.ground_end_main_,     0,                              0x800D8BB4,                         LuciaDSP.ground_collision_)
    Character.add_new_action(LUCIA, DSPG_Pull,         -1,             ActionParams.DSPG_Pull,         0x1E,           LuciaDSP.pull_main_,           0,                              0x800D8BB4,                         LuciaDSP.ground_collision_)
    Character.add_new_action(LUCIA, DSPG_Pull_Fail,    -1,             ActionParams.DSPG_Pull_Fail,    0x1E,           0x800D94C4,                     0,                              0x800D8BB4,                         LuciaDSP.ground_collision_)
    Character.add_new_action(LUCIA, DSPG_Stow,         -1,             ActionParams.DSPG_Stow,         0x1E,           LuciaDSP.stow_main_,           0,                              0x800D8BB4,                         LuciaDSP.ground_collision_)
    Character.add_new_action(LUCIA, DSPA_Begin,        -1,             ActionParams.DSPA_Begin,        0x1E,           LuciaDSP.air_begin_main_,      0,                              0x800D90E0,                         LuciaDSP.air_collision_)
    Character.add_new_action(LUCIA, DSPA_Wait,         -1,             ActionParams.DSPA_Wait,         0x1E,           LuciaDSP.air_wait_main_,       0,                              0x800D90E0,                         LuciaDSP.air_collision_)
    Character.add_new_action(LUCIA, DSPA_Absorb,       -1,             ActionParams.DSPA_Absorb,       0x1E,           LuciaDSP.air_absorb_main_,     0,                              0x800D90E0,                         LuciaDSP.air_collision_)
    Character.add_new_action(LUCIA, DSPA_End,          -1,             ActionParams.DSPA_End,          0x1E,           LuciaDSP.air_end_main_,        0,                              0x800D90E0,                         LuciaDSP.air_collision_)
    Character.add_new_action(LUCIA, DSPA_Pull,         -1,             ActionParams.DSPA_Pull,         0x1E,           LuciaDSP.pull_main_,           0,                              0x800D90E0,                         LuciaDSP.air_collision_)
    Character.add_new_action(LUCIA, DSPA_Pull_Fail,    -1,             ActionParams.DSPA_Pull_Fail,    0x1E,           0x800D94E8,                     0,                              0x800D90E0,                         LuciaDSP.air_collision_)
    Character.add_new_action(LUCIA, DSPA_Stow,         -1,             ActionParams.DSPA_Stow,         0x1E,           LuciaDSP.stow_main_,           0,                              0x800D90E0,                         LuciaDSP.air_collision_)
    Character.add_new_action(LUCIA, DSPG,              -1,             ActionParams.DSPG,              0x1E,           0x800D94C4,                     0,                             0x800D8BB4,                         0x800DDF44)                 // DSP_Ground
    Character.add_new_action(LUCIA, DSPA,              -1,             ActionParams.DSPA,              0x1E,           0x800D94E8,                     0,                              -1,                                LuciaDSP.air_collision_)

    // Modify Menu Action Parameters              // Action     // Animation                // Moveset Data             // Flags
    Character.edit_menu_action_parameters(LUCIA, 0x0,          File.LUCIA_IDLE,           IDLE,                       -1)
    Character.edit_menu_action_parameters(LUCIA, 0x1,          File.LUCIA_SELECT,      CSS,                        -1)
    Character.edit_menu_action_parameters(LUCIA, 0x2,          File.MARINA_VICTORY_2,      VICTORY_2,                  -1)
    Character.edit_menu_action_parameters(LUCIA, 0x3,          File.MARINA_VICTORY_3,      VICTORY,                    -1)
    Character.edit_menu_action_parameters(LUCIA, 0x4,          File.LUCIA_SELECT,      CSS,                        -1)
    Character.edit_menu_action_parameters(LUCIA, 0x5,          File.MARINA_STUN,                   ASLEEP,                     -1)
    Character.edit_menu_action_parameters(LUCIA, 0x9,          File.MARINA_CONTINUE_FALL,  -1,                         -1)
    Character.edit_menu_action_parameters(LUCIA, 0xA,          File.MARINA_CONTINUE_UP,    -1,                         -1)
    Character.edit_menu_action_parameters(LUCIA, 0xD,          File.MARINA_1P_POSE,        ONEP,                       -1)
    Character.edit_menu_action_parameters(LUCIA, 0xE,          File.MARINA_CPU_POSE,        ONEP,                       -1)

    Character.table_patch_start(air_nsp, Character.id.LUCIA, 0x4)
    dw      LuciaNSP.air_initial_
    OS.patch_end()
    Character.table_patch_start(ground_nsp, Character.id.LUCIA, 0x4)
    dw      LuciaNSP.ground_initial_
    OS.patch_end()
    Character.table_patch_start(air_usp, Character.id.LUCIA, 0x4)
    dw      LuciaUSP.air_initial_
    OS.patch_end()
    Character.table_patch_start(ground_usp, Character.id.LUCIA, 0x4)
    dw      LuciaUSP.ground_initial_
    OS.patch_end()
    Character.table_patch_start(air_dsp, Character.id.LUCIA, 0x4)
    dw      LuciaDSPA.air_initial_
    OS.patch_end()
    Character.table_patch_start(ground_dsp, Character.id.LUCIA, 0x4)
    dw      LuciaDSPG.ground_initial_
    OS.patch_end()


    Character.table_patch_start(jab_3, Character.id.LUCIA, 0x4)
    dw      Character.jab_3.DISABLED        // disable jab 3
    OS.patch_end()
    Character.table_patch_start(rapid_jab_begin_action, Character.id.LUCIA, 0x4)
    dw      0x8014F13C                      // copied from FOX
    OS.patch_end()
    Character.table_patch_start(rapid_jab_loop_action, Character.id.LUCIA, 0x4)
    dw      0x8014F3F4                      // copied from FOX
    OS.patch_end()
    Character.table_patch_start(rapid_jab_ending_action, Character.id.LUCIA, 0x4)
    dw      0x8014F490                      // copied from FOX
    OS.patch_end()
    Character.table_patch_start(rapid_jab_unknown, Character.id.LUCIA, 0x4)
    dw      0x8014F5B0                      // copied from FOX
    OS.patch_end()

    // Set menu zoom size.
    Character.table_patch_start(menu_zoom, Character.id.LUCIA, 0x4)
    float32 0.63
    OS.patch_end()

    // Allows Marina to use her entry which is similar to Link
    Character.table_patch_start(entry_action, Character.id.LUCIA, 0x8)
    dw 0xDF, 0xE0
    OS.patch_end()


    // Remove entry script.
    Character.table_patch_start(entry_script, Character.id.LUCIA, 0x4)
    // dw 0x8013DD68                           // skips entry script
    dw marina_entry_routine_
    OS.patch_end()


    // Allows Marina to use her entry which is similar to Link
    // Character.table_patch_start(entry_action, Character.id.LUCIA, 0x8)
    // dw 0xDF, 0xE0
    // OS.patch_end()
    // Character.table_patch_start(entry_script, Character.id.LUCIA, 0x4)
    // dw marina_entry_routine_
    // OS.patch_end()

    // Patches for full charge Neutral B effect.
    Character.table_patch_start(gfx_routine_end, Character.id.LUCIA, 0x4)
    dw      charge_gfx_routine_
    OS.patch_end()
    Character.table_patch_start(initial_script, Character.id.LUCIA, 0x4)
    dw      0x800D7DEC                      // use samus jump
    OS.patch_end()

    // Remove grounded script.
    Character.table_patch_start(grounded_script, Character.id.LUCIA, 0x4)
    dw Character.grounded_script.DISABLED   // skips grounded script
    OS.patch_end()

    // Set crowd chant FGM.
    Character.table_patch_start(crowd_chant_fgm, Character.id.LUCIA, 0x2)
    dh  0x06DC
    OS.patch_end()

    // Set Kirby hat_id
    Character.table_patch_start(kirby_inhale_struct, 0x2, Character.id.LUCIA, 0xC)
    dh 0x1F
    OS.patch_end()

    // Set Remix 1P ending music
    Character.table_patch_start(remix_1p_end_bgm, Character.id.LUCIA, 0x2)
    dh {MIDI.id.TROUBLE_MAKER}
    OS.patch_end()

    // Set default costumes
    Character.set_default_costumes(Character.id.LUCIA, 0, 2, 4, 5, 1, 2, 3)
    Teams.add_team_costume(YELLOW, LUCIA, 0x5)

    // Shield colors for costume matching
    Character.set_costume_shield_colors(LUCIA, RED, MAGENTA, BLUE, GREEN, PURPLE, YELLOW, NA, NA)

    // Set action strings
    Character.table_patch_start(action_string, Character.id.LUCIA, 0x4)
    dw  Lucia.Action.action_string_table
    OS.patch_end()

    // Set Magnifying Glass Scale Override
    Character.table_patch_start(magnifying_glass_zoom, Character.id.LUCIA, 0x2)
    dh  0x0053
    OS.patch_end()

    // Fix the logic for breaking out of ThrownDK since we're using it for our grabbed opponent
    scope capture_action_fix_: {
        lli     a3, Action.ThrowF           // a3 = ThrowF
        lw      t7, 0x0024(a2)              // t7 = grabbing player action
        bne     a3, t7, _end                // if action != ThrowF, do nothing
        nop
        lli v0, 0x1 // During ThrowF return 1, which means it just skips the function completely
        _end:
        jr      ra
        nop
    }
    Character.table_patch_start(custom_capture_dk_interrupt, Character.id.LUCIA, 0x4)
    dw capture_action_fix_
    OS.patch_end()

    // @ Description
    // Jump table patch which enables Marina's charged down b effect when another gfx routine ends, or upon action change.
    scope charge_gfx_routine_: {
        lw      t9, 0x0ADC(a3)              // t9 = charge level
        lli     at, LuciaDSP.MAX_CHARGE    // at = MAX_CHARGE
        lw      a0, 0x0020(sp)              // a0 = player object
        bne     t9, at, _end                // skip if charge level != MAX_CHARGE (full)
        lli     a1, GFXRoutine.id.MARINA_CHARGE // a1 = MARINA_CHARGE id

        // if the down special is full charged
        or      a2, r0, r0                  // a2 = 0
        jal     0x800E9814                  // begin gfx routine
        sw      a3, 0x001C(sp)              // store a3

        _end:
        j       0x800E9A60                  // return
        lw      a3, 0x001C(sp)              // load a3
    }

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
    // Patch which handles the decaying jump height for Marina's multiple jumps.
    scope jump_height_patch_: {
    OS.patch_start(0xBA898, 0x8013FE58)
        j       jump_height_patch_
        lwc1    f16, 0x003C(t0)             // original line 2
        _return:
        OS.patch_end()

        lw      t6, 0x0008(s0)              // t6 = character id
        lli     at, Character.id.LUCIA     // at = id.LUCIA
        beq     at, t6, _marina             // branch if character = LUCIA...
        lli     at, Character.id.NMARINA    // at = id.NLUCIA
        bne     at, t6, _end                // branch if character != NLUCIA...
        lbu     t6, 0x0148(s0)              // t6 = jumps used

		_marina:
        // if we're here then the character is LUCIA, so apply alternate base jump height
        lbu     t6, 0x0148(s0)              // t6 = jumps used
        li      at, jump_height_table       // at = jump_height_table
        add     at, at, t6                  // at = jump_height_table + jumps used
        lbu     t3, 0x0000(at)              // t3 = base height for next jump

        _end:
        j       _return                     // return
        mtc1    t3, f8                      // original line 1
    }

    // @ Description
    // Patch which prevents marina from cancelling double jump into itself until a flag is set.
    scope jump_timing_patch_: {
    OS.patch_start(0xBAD50, 0x80140310)
        j       jump_timing_patch_
        lw      a0, 0x0020(sp)             // original line 2
        _return:
        OS.patch_end()

        lw      t6, 0x0008(a2)              // t6 = character id
        lli     at, Character.id.LUCIA     // at = id.LUCIA
        beq     at, t6, _marina             // branch if character = LUCIA...
        lli     at, Character.id.NMARINA    // at = id.NLUCIA
        bne     at, t6, _end                // branch if character != NLUCIA...
        nop

        _marina:
        // if we're here then the character is LUCIA, so check if special restrictions should be applied
        lw      t6, 0x0024(a2)              // t6 = current action
        lli     at, Action.JumpAerialF      // at = JumpAerialF
        beq     at, t6, _check_flag         // branch if current action = JumpAerialF
        lli     at, Action.JumpAerialB      // at = id.JumpAerialB
        bnel    at, t6, _end                // end if current action != JumpAerialB...
        sw      r0, 0x0180(a2)              // ...set temp variable 2 to FALSE


        _check_flag:
        // if the character is LUCIA and she is currently doing a double jump
        lw      t6, 0x0180(a2)              // t6 = temp variable 2
        bnezl   t6, _end                    // end if temp variable 2 != FALSE...
        sw      r0, 0x0180(a2)              // ...set temp variable 2 to FALSE

        // if we're here then LUCIA has attempted to start a consecutive double jump too soon, so disallow it
        j       0x80140324                  // end action checks
        or      v0, r0, r0                  // return FALSE (no action change occured)

        _end:
        jal     0x8013FD74                  // original line 1
        nop

        _no_jump:
        j       _return                     // return
        nop
    }

    jump_height_table:
    db  0   // jump 1
    db  80  // jump 2
    db  70  // jump 3
    db  60  // jump 4
    db  50  // jump 5
    db  40  // jump 6
    OS.align(4)
}
