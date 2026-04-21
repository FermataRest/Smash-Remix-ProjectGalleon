// Kazuya.asm

// This file contains file inclusions, action edits, and assembly for Kazuya.

scope Kazuya {


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
        string_0x0E4:; String.insert("---")
        string_0x0E5:; String.insert("---")
        string_0x0E6:; String.insert("---")
        string_0x0E7:; String.insert("---")
        string_0x0E8:; String.insert("LightningUppercut")
        string_0x0E9:; String.insert("LightningUppercutAir")
        string_0x0EA:; String.insert("StoneHead")
        string_0x0EB:; String.insert("---")
        string_0x0EC:; String.insert("---")
        string_0x0ED:; String.insert("StoneHeadAir")
        string_0x0EE:; String.insert("---")

        string_0x0F3:; String.insert("WhileStand")
        string_0x0F4:; String.insert("Wavedash")
        string_0x0F5:; String.insert("GodFist")
        string_0x0F6:; String.insert("CrouchJab")
        string_0x0F7:; String.insert("Sweep1")
        string_0x0F8:; String.insert("Sweep2")
        string_0x0F9:; String.insert("UpTilt2")
        string_0x0FA:; String.insert("CrouchTilt")
        string_0x0FB:; String.insert("Usp")
        string_0x0FC:; String.insert("UspLand")
        string_0x0FD:; String.insert("TsunamiKick2")
        string_0x0FE:; String.insert("RoundhouseToTripleSpinKick2")
        string_0x0FF:; String.insert("RoundhouseToTripleSpinKick3")
        string_0x100:; String.insert("RoundhouseToTripleSpinKick4")
        string_0x101:; String.insert("LightningScrewUppercut")

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


}
