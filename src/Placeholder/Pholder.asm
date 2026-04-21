// Ryu.asm

// This file contains file inclusions, action edits, and assembly for Ryu.

scope Pholder {


    // Add Action Parameters                // Action Name      // Base Action  // Animation                    // Moveset Data             // Flags
    Character.add_new_action_params(PHOLDER,    JAB_L,             -1,             -1,                 -1,                       -1)
    Character.add_new_action_params(PHOLDER,    JAB_L2,             -1,             -1,                 -1,                       -1)
    Character.add_new_action_params(PHOLDER,    JAB_L3,             -1,             -1,                 -1,                       -1)
    Character.add_new_action_params(PHOLDER,    D_TILT,             -1,             -1,                 -1,                       -1)
    Character.add_new_action_params(PHOLDER,    DTILT_L,             -1,             -1,                 -1,                       -1)
    Character.add_new_action_params(PHOLDER,    U_TILT,             -1,             -1,                 -1,                       -1)
    Character.add_new_action_params(PHOLDER,    UTILT_L,             -1,             -1,                 -1,                       -1)
    Character.add_new_action_params(PHOLDER,    FTILT_L,             -1,             -1,                 -1,                       -1)
    Character.add_new_action_params(PHOLDER,    JAB_CLOSE,             -1,             -1,                 -1,                       -1)
    Character.add_new_action_params(PHOLDER,    FTILT_CLOSE,             -1,             -1,                 -1,                       -1)
    Character.add_new_action_params(PHOLDER,    ROUNDHOUSE,             -1,             -1,                 -1,                       -1)
    Character.add_new_action_params(PHOLDER,    COMMAND_KICK,             -1,             -1,                 -1,                       -1)
    Character.add_new_action_params(PHOLDER,    COMMAND_KICK_2,             -1,             -1,                 -1,                       -1)
    Character.add_new_action_params(PHOLDER,    CROUCH_JAB,             -1,             -1,                 -1,                       -1)
    Character.add_new_action_params(PHOLDER,    CROUCH_TILT,             -1,             -1,                 -1,                       -1)
    Character.add_new_action_params(PHOLDER,    WHILE_STAND,             -1,             -1,                 -1,                       -1)
    Character.add_new_action_params(PHOLDER,    WAVEDASH,             -1,             -1,                 -1,                       -1)
    Character.add_new_action_params(PHOLDER,    USP_H,             -1,             -1,                 -1,                       -1)
    Character.add_new_action_params(PHOLDER,    USP_L,             -1,             -1,                 -1,                       -1)
    Character.add_new_action_params(PHOLDER,    GFIST,             -1,             -1,                 -1,                       -1)

    // Add Actions                   // Action Name     // Base Action  //Parameters                    // Staling ID   // Main ASM                     // Interrupt/Other ASM          // Movement/Physics ASM             // Collision ASM
    Character.add_new_action(PHOLDER,    JAB_L,              -1,             ActionParams.JAB_L,            -1,           0x800DDF44,                   0x800DDF44,          0x800DDF44,                 0x800DDF44)
    Character.add_new_action(PHOLDER,    JAB_L2,              -1,             ActionParams.JAB_L2,            -1,           0x800DDF44,                   0x800DDF44,          0x800DDF44,                 0x800DDF44)
    Character.add_new_action(PHOLDER,    JAB_L3,              -1,             ActionParams.JAB_L3,            -1,           0x800DDF44,                   0x800DDF44,          0x800DDF44,                 0x800DDF44)
    Character.add_new_action(PHOLDER,    D_TILT,              -1,             ActionParams.D_TILT,            -1,           0x800DDF44,                   0x800DDF44,          0x800DDF44,                 0x800DDF44)
    Character.add_new_action(PHOLDER,    DTILT_L,              -1,             ActionParams.DTILT_L,            -1,           0x800DDF44,                   0x800DDF44,          0x800DDF44,                 0x800DDF44)
    Character.add_new_action(PHOLDER,    UTILT_L,              -1,             ActionParams.UTILT_L,            -1,           0x800DDF44,                   0x800DDF44,          0x800DDF44,                 0x800DDF44)
    Character.add_new_action(PHOLDER,    FTILT_L,              -1,             ActionParams.FTILT_L,            -1,           0x800DDF44,                   0x800DDF44,          0x800DDF44,                 0x800DDF44)
    Character.add_new_action(PHOLDER,    U_TILT,              -1,             ActionParams.U_TILT,            -1,           0x800DDF44,                   0x800DDF44,          0x800DDF44,                 0x800DDF44)
    Character.add_new_action(PHOLDER,    JAB_CLOSE,              -1,          ActionParams.JAB_CLOSE,            -1,           0x800DDF44,                   0x800DDF44,          0x800DDF44,                 0x800DDF44)
    Character.add_new_action(PHOLDER,    FTILT_CLOSE,              -1,          ActionParams.FTILT_CLOSE,            -1,           0x800DDF44,                   0x800DDF44,          0x800DDF44,                 0x800DDF44)
    Character.add_new_action(PHOLDER,    ROUNDHOUSE,              -1,          ActionParams.ROUNDHOUSE,            -1,           0x800DDF44,                   0x800DDF44,          0x800DDF44,                 0x800DDF44)
    Character.add_new_action(PHOLDER,    COMMAND_KICK,              -1,          ActionParams.COMMAND_KICK,            -1,           0x800DDF44,                   0x800DDF44,          0x800DDF44,                 0x800DDF44)
    Character.add_new_action(PHOLDER,    COMMAND_KICK_2,              -1,          ActionParams.COMMAND_KICK_2,            -1,           0x800DDF44,                   0x800DDF44,          0x800DDF44,                 0x800DDF44)
    Character.add_new_action(PHOLDER,    CROUCH_JAB,              -1,          ActionParams.CROUCH_JAB,            -1,           0x800DDF44,                   0x800DDF44,          0x800DDF44,                 0x800DDF44)
    Character.add_new_action(PHOLDER,    CROUCH_TILT,              -1,          ActionParams.CROUCH_TILT,            -1,           0x800DDF44,                   0x800DDF44,          0x800DDF44,                 0x800DDF44)
    Character.add_new_action(PHOLDER,    WHILE_STAND,              -1,          ActionParams.WHILE_STAND,            -1,           0x800DDF44,                   0x800DDF44,          0x800DDF44,                 0x800DDF44)
    Character.add_new_action(PHOLDER,    WAVEDASH,              -1,          ActionParams.WAVEDASH,            -1,           0x800DDF44,                   0x800DDF44,          0x800DDF44,                 0x800DDF44)
    Character.add_new_action(PHOLDER,    USP_H,              -1,          ActionParams.USP_H,            -1,           0x800DDF44,                   0x800DDF44,          0x800DDF44,                 0x800DDF44)
    Character.add_new_action(PHOLDER,    USP_L,              -1,          ActionParams.USP_L,            -1,           0x800DDF44,                   0x800DDF44,          0x800DDF44,                 0x800DDF44)
    Character.add_new_action(PHOLDER,    GFIST,              -1,          ActionParams.GFIST,            -1,           0x800DDF44,                   0x800DDF44,          0x800DDF44,                 0x800DDF44)



    // @ Description
    // Ryu's extra actions
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
    }


}
