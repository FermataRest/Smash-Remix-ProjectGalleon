// GoemonSpecial.asm

// This file contains subroutines used by Uzi's special moves.

scope UziNSPA {
    constant Y_SPEED(0x4258)                // float32 54
    constant THROW_AIR_FRICTION(0x3FE0)     // float32 1.75
    constant THROW_FALL_SPEED(0x42DC)       // float32 110
    constant THROW_GRAVITY(0x3F00)          // float32 0.5
    constant THROW_GRAVITY_2(0x40E0)        // float32 7

    // @ Description
    // Initial subroutine for USPAir.
    scope air_initial_: {
        addiu   sp, sp,-0x0028              // allocate stack space
        sw      ra, 0x0014(sp)              // ~
        sw      a0, 0x0018(sp)              // store ra, a0
        lw      v1, 0x0084(a0)              // v1 = player struct

        lw      v0, 0x0084(a0)              // ~
        li      t6, 0x801605FC              // ~
        sw      t6, 0x0A0C(v0)              // run this falcon function to avoid random bs

        lli     a1, Uzi.Action.NSPAir // a1(action id) = USPAir
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        lw      a0, 0x0018(sp)              // a0 = player object
        li      a1, air_pull_initial_       // a1 = air_pull_initial_
        jal     0x8015E310                  // command grab setup (yoshi)
        lw      a0, 0x0084(a0)              // a0 = player struct
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0018(sp)              // a0 = player object
        lw      a0, 0x0018(sp)              // ~
        lw      a0, 0x0084(a0)              // ~
        sw      r0, 0x017C(a0)              // temp variable 1 = 0
        sw      r0, 0x0180(a0)              // temp variable 2 = 0
        sw      r0, 0x0184(a0)              // temp variable 3 = 0
        ori     t6, r0, 0x0007              // t6 = bitmask (01111111)
        and     v1, v1, t6                  // ~
        sb      v1, 0x018D(a0)              // disable fast fall flag
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0028              // deallocate stack space
    }



    // @ Description
    // Initial subroutine for USPAirPull.
    scope air_pull_initial_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // store a0, ra
        lw      v1, 0x0084(a0)              // v1 = player struct

        lli     a1, Uzi.Action.NSPAirPull // a1(action id) = USPAirPull
        or      a2, r0, r0                  // a2(starting frame) = 0
        lli     t6, 0x0002                  // ~
        sw      t6, 0x0010(sp)              // argument 4 = 0x0002
        jal     0x800E6F24                  // change action
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0020(sp)              // a0 = player object
        jal     throw_setup_                // additional command grab setup
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      a0, 0x0020(sp)              // ~
        lw      a0, 0x0084(a0)              // a0 = player struct
        lui     at, 0x3F00                  // ~
        mtc1    at, f2                      // f2 = 0.5
        lwc1    f4, 0x0048(a0)              // f4 = x velocity
        mul.s   f4, f4, f2                  // f4 = x velocity * 0.5
        lui     at, 0x3E00                  // ~
        mtc1    at, f10                     // f10 = 0.125
        lwc1    f6, 0x004C(a0)              // f6 = y velocity
        mul.s   f6, f6, f10                 // f6 = y velocity * 0.125
        sw      r0, 0x017C(a0)              // temp variable 1 = 0
        sw      r0, 0x0180(a0)              // temp variable 2 = 0
        sw      r0, 0x0184(a0)              // temp variable 3 = 0
        lui     at, Y_SPEED                 // ~
        mtc1    at, f8                      // ~
        add.s   f6, f6, f8                  // y velocity = y velocity * 0.5 + Y_SPEED
        swc1    f4, 0x0048(a0)              // store updated x velocity
        swc1    f6, 0x004C(a0)              // store updated y velocity
        lw      ra, 0x001C(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0020              // deallocate stack space
    }

    // @ Description
    // Initial subroutine for USPLandingThrow
    scope landing_throw_initial_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // store a0, ra
        jal     0x800DEE98                  // set grounded state
        lw      a0, 0x0084(a0)              // a0 = player struct
        lw      a0, 0x0020(sp)              // a0 = player object
        lli     a1, Uzi.Action.NSPLandingThrow // a1(action id) = Ground_Cmd_Throw
        or      a2, r0, r0                  // a2(starting frame) = 0
        lli     t6, 0x0002                  // ~
        sw      t6, 0x0010(sp)              // argument 4 = 0x0002
        jal     0x800E6F24                  // change action
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        lw      a0, 0x0020(sp)              // ~
        lw      a0, 0x0084(a0)              // ~
        sw      r0, 0x017C(a0)              // temp variable 1 = 0
        sw      r0, 0x0180(a0)              // temp variable 2 = 0
        sw      r0, 0x0184(a0)              // temp variable 3 = 0
        lw      ra, 0x001C(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0020              // deallocate stack space
    }

    // @ Description
    // Subroutine which helps set up the command grab for Dragon King.
    scope throw_setup_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // store a0, ra
        lli     a1, 0x003F                  // a1 = bitflags?
        jal     0x800E8098                  // sets the byte at 0x193 in the player struct to the value in a1
        lw      a0, 0x0084(a0)              // a0 = player struct
        lw      t6, 0x0830(a0)              // ~
        sw      t6, 0x0840(a0)              // update captured player?
        lw      ra, 0x001C(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0020              // deallocate stack space
    }

    // @ Description
    // Main function for Up Special throw actions
    scope throw_main_: {
        OS.routine_begin(0x20)
        sw      a0, 0x0018(sp)
        jal     0x8014A0C0                  // original throw routine
        nop
        lw      a0, 0x0018(sp)              // restore a0
        lw      v1, 0x0084(a0)              // v1 = player struct

        lw      at, 0x017C(v1)              // at = temp variable 1
        beqz    at, _end                    // skip if temp variable 1 not set
        lli     t6, 0x0001                  // t6 = 1
        bne     t6, at, _end                // if temp variable 1 != 1, skip
        nop

        _drain:
        // heal HP
        lw      t6, 0x0818(v1)
        addiu   t6, t6, 1
        sw      t6, 0x0818(v1)              // increase HP heal by 1
        // drain hp
        lw      a0, 0x0840(v1)              // a0 = captured player object
        lw      a0, 0x0084(a0)              // a0 = captured played struct

        lw      at, 0x05B0(a0)              // at = super star counter
        bnez    at, _end                    // do not apply damage to players with super star
        nop

        li      at, Item.CloakingDevice.cloaked_players
        lbu     t6, 0x000D(a0)          // load port
        addu    at, at, t6              // t5 = players entry in table
        lbu     at, 0x0000(at)
        bnez    at, _end                // do not apply damage to cloaking device players
        nop

        jal     0x800EA248                  // apply 1 damage to captured player
        addiu   a1, r0, 1

        _end:
        OS.routine_end(0x20)
    }

    // @ Description
    // Main function for Up Special air pull
    scope air_pull_main_: {
        OS.routine_begin(0x20)
        lw      v1, 0x0084(a0)              // v1 = player struct

        lw      at, 0x017C(v1)              // at = temp variable 1
        beqz    at, _end                    // skip if temp variable 1 not set
        lli     t6, 0x0001                  // t6 = 1
        bne     t6, at, _end                // if temp variable 1 != 1, skip
        nop

        _drain:
        // heal HP
        lw      t6, 0x0818(v1)
        addiu   t6, t6, 1
        sw      t6, 0x0818(v1)              // increase HP heal by 1
        // drain hp
        lw      a0, 0x0840(v1)              // a0 = captured player object
        lw      a0, 0x0084(a0)              // a0 = captured played struct


        lw      at, 0x05B0(a0)              // at = super star counter
        bnez    at, _end                    // do not apply damage to players with super star
        nop

        li      at, Item.CloakingDevice.cloaked_players
        lbu     t6, 0x000D(a0)          // load port
        addu    at, at, t6              // t5 = players entry in table
        lbu     at, 0x0000(at)
        bnez    at, _end                // do not apply damage to cloaking device players
        nop

        jal     0x800EA248                  // apply 1 damage to captured player
        addiu   a1, r0, 1

        _end:
        OS.routine_end(0x20)
    }

    // @ Description
    // Aerial movement subroutine for USPAirPull
    // Modified version of subroutine 0x800D90E0.
    scope air_pull_physics_: {
        // Copy the first 8 lines of subroutine 0x800D90E0
        OS.copy_segment(0x548E0, 0x20)

        // Skip 7 lines (fast fall branch logic)

        // jal 0x800D8E50                   // ~
        // or a1, s1, r0                    // original 2 lines call gravity subroutine
        lui     a1, THROW_GRAVITY           // a1 = THROW_GRAVITY
        lw      t6, 0x0180(s0)              // t6 = temp variable 2
        bnezl   t6, _apply_gravity          // branch if temp variable 2 is set...
        lui     a1, THROW_GRAVITY_2         // ...and a1 = THROW_GRAVITY_2

        _apply_gravity:
        jal     0x800D8D68                  // apply gravity/fall speed
        lui     a2, THROW_FALL_SPEED        // a1 = THROW_FALL_SPEED

        // Copy the next 8 lines of subroutine 0x800D90E0
        OS.copy_segment(0x54924, 0x20)
        // jal 0x800D9074                   // original line calls air friction subroutine
        jal     air_pull_friction_          // call custom wrapped subroutine instead
        // Copy the last 6 lines of subroutine 0x800D90E0
        OS.copy_segment(0x54948, 0x18)
    }

    scope air_pull_friction_: {
        OS.routine_begin(0x80)
        // use sp as fake attribute pointer for custom air friction
        lui     at, THROW_AIR_FRICTION      // ~
        sw      at, 0x0054(sp)              // 0x0054(sp) = THROW_AIR_FRICTION
        jal     0x800D9074                  // air friction function
        or      a1, sp, r0                  // a1 = sp
        OS.routine_end(0x80)
    }

    // @ Description
    // Collision subroutine for USPGround.
    scope ground_collision_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        li      a1, ground_to_air_          // a1(transition subroutine) = ground_to_air_
        jal     0x800DDDDC                  // common ground collision subroutine (transition on no floor, slide-off)
        nop
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0018              // deallocate stack space
    }

    // @ Description
    // Subroutine which handles the transition from USPGround to USPAir.
    scope ground_to_air_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // store a0, ra
        jal     0x800DEEC8                  // set aerial state
        lw      a0, 0x0084(a0)              // a0 = player struct

        lw      a0, 0x0020(sp)              // a0 = player object
        lw      v0, 0x0084(a0)              // ~
        li      t6, 0x801605FC              // ~
        sw      t6, 0x0A0C(v0)              // run this falcon function to avoid random bs

        lli     a1, Uzi.Action.NSPAir // a1 = Action.USPAir
        lw      a2, 0x0078(a0)              // a2(starting frame) = current animation frame
        lli     t6, 0x0003                  // ~
        sw      t6, 0x0010(sp)              // argument 4 = 0x0003
        jal     0x800E6F24                  // change action
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        lw      a0, 0x0020(sp)              // a0 = player object
        li      a1, air_pull_initial_       // a1 = air_pull_initial_
        jal     0x8015E310                  // command grab setup (yoshi)
        lw      a0, 0x0084(a0)              // a0 = player struct
        lw      ra, 0x001C(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0020              // deallocate stack space
    }

    // @ Description
    // Collision wubroutine for USPAirPull
    scope air_pull_collision_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        li      a1, landing_throw_initial_  // a1(transition subroutine) = landing_throw_initial_
        jal     0x800DE6E4                  // common air collision subroutine (transition on landing, no ledge grab)
        nop
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0018              // deallocate stack space
    }

    // @ Description
    // Makes the % display during dragon king up special friendlier towards photosensitivity
    scope drain_flash_fix_: {
        OS.patch_start(0x8A1E4, 0x8010E9E4)
        j       drain_flash_fix_
        nop
        _return:
        OS.patch_end()

        lw      s0, 0x0078(a1)              // s0 = player object, if any
        beqz    s0, _original               // skip if no player object
        nop
        lw      s0, 0x0084(s0)              // s0 = player struct, if any
        beqz    s0, _original               // skip if no player struct
        nop
        lw      s0, 0x0844(s0)              // t6 = capturing player object, if any
        beqz    s0, _original               // skip if no capturing player object
        nop

        lw      s0, 0x0084(s0)              // s0 = capturing player struct
        lw      t6, 0x0008(s0)              // a2 = capturing character ID
        lli     at, Character.id.UZI // at = id.DRAGONKING
        bne     t6, at, _original           // skip if capturing character != DRAGONKING
        lw      t6, 0x0024(s0)              // t6 = capturing character Action ID
        lli     at, Uzi.Action.NSPAirPull // USPAirPull
        beq     t6, at, _override           // override if action = USPAirPull
        nop

        _override:
        lw      t6, 0x017C(s0)              // t6 = temp variable 1
        bnez    t6, _j_0x8010E9F4           // if we're here and temp variable 1 is set, skip branch and prevent % colour from turning white
        nop

        _original:
        beqz    t3, _j_0x8010E9F4           // original branch logic
        nop

        _end:
        j       _return
        addiu   s0, sp, 0x003C

        _j_0x8010E9F4:
        j       0x8010E9F4                  // original branch location
        addiu   s0, sp, 0x003C

    }
}


scope UziUSP {
    // floating point constants for physics and fsm
    constant AIR_Y_SPEED(0x42F9)            // current setting - float32 82
    constant GROUND_Y_SPEED(0x42F8)         // current setting - float32 84
    constant X_SPEED(0x4190)                // current setting - float32 18
    constant FLOAT_GRAVITY(0x0)          // current setting - float32 0.5
    constant FLOAT_FALL_SPEED(0x4150)       // current setting - float32 13
    constant AIR_ACCELERATION(0x3C24)       // current setting - float32 0.01
    constant AIR_SPEED(0x41C0)              // current setting - float32 24
    constant LANDING_FSM(0x3EC0)            // current setting - float32 0.375
    constant MAX_TIME(80)
    constant B_PRESSED(0x40)                // bitmask for b press

    constant AERIAL_INITIAL_Y_SPEED(0x4100) // DSP rise
    constant X_SPEED2(0x4270)                // current setting - float:60
    constant Y_SPEED(0xC30C)                // current setting - float:-140.0
    constant INITIAL_Y_SPEED(0x4334)        // current setting - float:180.0
    // temp variable 3 constants for movement states
    constant BEGIN(0x1)
    constant BEGIN_MOVE(0x2)
    constant MOVE(0x3)
    constant END_MOVE(0x4)




    // @ Description
    // Subroutine which runs when Peach initiates an aerial up special.
    // Changes action, and sets up initial variable values.
    scope air_initial_: {
        addiu   sp, sp,-0x0030              // ~
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // original lines 1-3
        lli     t6, 0x0020                  // ~
        sw      t6, 0x0010(sp)              // argument 4 = 0x0020 (continue: special model parts)
        lli     a1, Uzi.Action.USPA       // a1 = Action.USPA
        or      a2, r0, r0                  // a2 = float: 0.0
        jal     0x800E6F24                  // change action
        lui     a3, 0x3F80                  // a3 = float: 1.0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      a0, 0x0020(sp)              // ~
        lw      a0, 0x0084(a0)              // a0 = player struct
        sw      r0, 0x017C(a0)              // temp variable 1 = 0
        sw      r0, 0x0180(a0)              // temp variable 2 = 0

        sw      r0, 0x0B18(a0)              // frame timer = 0

        ori     v1, r0, 0x0001              // ~
        sw      v1, 0x0184(a0)              // temp variable 3 = 0x1(BEGIN)
        // reset fall speed
        lbu     v1, 0x018D(a0)              // v1 = fast fall flag
        ori     t6, r0, 0x0007              // t6 = bitmask (01111111)
        and     v1, v1, t6                  // ~
        sb      v1, 0x018D(a0)              // disable fast fall flag
        // freeze y position
        lw      v1, 0x09C8(a0)              // v1 = attribute pointer
        lw      v1, 0x0058(v1)              // v1 = gravity
        sw      v1, 0x004C(a0)              // y velocity = gravity
        lw      ra, 0x001C(sp)              // ~
        addiu   sp, sp, 0x0030              // ~
        jr      ra                          // original return logic
        nop
    }

    // @ Description
    // Subroutine which runs when Peach initiates a grounded up special.
    // Changes action, and sets up initial variable values.
    scope ground_initial_: {
        addiu   sp, sp,-0x0030              // ~
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // original lines 1-3
        lli     t6, 0x0020                  // ~
        sw      t6, 0x0010(sp)              // argument 4 = 0x0020 (continue: special model parts)
        lli     a1, Uzi.Action.USPG       // a1 = Action.USPG
        or      a2, r0, r0                  // a2 = float: 0.0
        jal     0x800E6F24                  // change action
        lui     a3, 0x3F80                  // a3 = float: 1.0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      a0, 0x0020(sp)              // ~
        lw      a0, 0x0084(a0)              // a0 = player struct
        sw      r0, 0x017C(a0)              // temp variable 1 = 0
        sw      r0, 0x0180(a0)              // temp variable 2 = 0

        sw      r0, 0x0B18(a0)              // frame timer = 0

        ori     v1, r0, 0x0001              // ~
        sw      v1, 0x0184(a0)              // temp variable 3 = 0x1(BEGIN)
        lw      ra, 0x001C(sp)              // ~
        addiu   sp, sp, 0x0030              // ~
        jr      ra                          // original return logic
        nop
    }

    // @ Description
    // Subroutine which runs when Peach opens her parasol.
    // Changes action, and sets up initial variable values.
    scope open_initial_: {
        addiu   sp, sp,-0x0030              // ~
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // original lines 1-3
        lli     t6, 0x0020                  // ~
        sw      t6, 0x0010(sp)              // argument 4 = 0x0020 (continue: special model parts)
        lli     a1, Uzi.Action.USPOpen    // a1 = Action.USPOpen
        or      a2, r0, r0                  // a2 = float: 0.0
        jal     0x800E6F24                  // change action
        lui     a3, 0x3F80                  // a3 = float: 1.0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      a0, 0x0020(sp)              // ~
        lw      a0, 0x0084(a0)              // a0 = player struct
        ori     v1, r0, 0x0001              // ~
        sw      v1, 0x0180(a0)              // temp variable 2 = 0x1
        // reset fall speed
        lbu     v1, 0x018D(a0)              // v1 = fast fall flag
        ori     t6, r0, 0x0007              // t6 = bitmask (01111111)
        and     v1, v1, t6                  // ~
        sb      v1, 0x018D(a0)              // disable fast fall flag
        // reset y velocity
        sw      r0, 0x004C(a0)              // y velocity = 0
        lw      ra, 0x001C(sp)              // ~
        addiu   sp, sp, 0x0030              // ~
        jr      ra                          // original return logic
        nop
    }

    // @ Description
    // Subroutine which runs when Peach begins floating with her parasol.
    // Changes action, and sets up initial variable values.
    scope float_initial_: {
        addiu   sp, sp,-0x0030              // ~
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // original lines 1-3





        lli     t6, 0x0020                  // ~
        sw      t6, 0x0010(sp)              // argument 4 = 0x0020 (continue: special model parts)
        lli     a1, Uzi.Action.USPFloat   // a1 = Action.USPFloat
        or      a2, r0, r0                  // a2 = float: 0.0
        jal     0x800E6F24                  // change action
        lui     a3, 0x3F80                  // a3 = float: 1.0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      a0, 0x0020(sp)              // ~
        lw      a0, 0x0084(a0)              // a0 = player struct
        ori     v1, r0, 0x0001              // ~
        sw      v1, 0x0180(a0)              // temp variable 2 = 0x1
        _end:
        lw      ra, 0x001C(sp)              // ~
        addiu   sp, sp, 0x0030              // ~
        jr      ra                          // original return logic
        nop
    }


    scope float_main_: {
        addiu   sp, sp,-0x0030              // ~
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // original lines 1-3



        _update_buffer:
        lw      a2, 0x0084(a0)              // a2 = player struct
        lbu     t1, 0x01BE(a2)              // t1 = button_pressed
        lw      t2, 0x0B18(a2)              // t2 = button_press_buffer
        or      t1, t1, t2                  // t1 = button_pressed | button_press_buffer
        sw      t1, 0x0B18(a2)              // update button_press_buffer with current inputs
        sw      t1, 0x0018(sp)              // save button_pressed to stack




        lw      t3, 0x0018(sp)              // load button press buffer
        andi    t1, t3, B_PRESSED           // t1 = 0x40 if (B_PRESSED); else t1 = 0
        beq     t1, r0, _timer          // skip if (!B_PRESSED)
        nop


        sw      r0, 0x0010(sp)              // unknown argument = 0
        sw      r0, 0x0018(sp)              // interrupt flag = FALSE

        jal     air_initial2_
        nop

        beq     r0, r0, _end
        nop


        _timer:
        lw      t6, 0x0B18(v1)              // t6 = frame timer
        slti    at, t6, MAX_TIME            // at = 1 if frame timer < MAX_TIME, else at = 0
        addiu   t6, t6, 0x0001              // ~
        bnez    at, _end                    // branch if frame timer < MAX_TIME
        sw      t6, 0x0B18(v1)              // increment frame timer
        // if frame timer has reached MAX_TIME
        jal     close_initial_   // a1(action id) = USPJump
        b       _end                        // end
        nop


        _end:
        lw      ra, 0x001C(sp)              // ~
        addiu   sp, sp, 0x0030              // ~
        jr      ra                          // original return logic
        nop

    }

    // @ Description
    // Subroutine which runs when Peach closes her parasol.
    // Changes action, and sets up initial variable values.
    scope close_initial_: {
        addiu   sp, sp,-0x0030              // ~
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // original lines 1-3
        lli     t6, 0x0020                  // ~
        sw      t6, 0x0010(sp)              // argument 4 = 0x0020 (continue: special model parts)
        lli     a1, Uzi.Action.USPClose   // a1 = Action.USPClose
        or      a2, r0, r0                  // a2 = float: 0.0
        jal     0x800E6F24                  // change action
        lui     a3, 0x3F80                  // a3 = float: 1.0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      a0, 0x0020(sp)              // ~
        lw      a0, 0x0084(a0)              // a0 = player struct
        ori     v1, r0, 0x0001              // ~
        sw      v1, 0x0180(a0)              // temp variable 2 = 0x1
        lw      ra, 0x001C(sp)              // ~
        addiu   sp, sp, 0x0030              // ~
        jr      ra                          // original return logic
        nop
    }


    scope shared_initial_: {
        addiu   sp, sp,-0x0028              // allocate stack space
        sw      ra, 0x0014(sp)              // ~
        sw      a0, 0x0018(sp)              // store ra, a0
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        lw      a0, 0x0018(sp)              // a0 = player object
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0018(sp)              // a0 = player object
        lw      a0, 0x0018(sp)              // ~
        lw      a0, 0x0084(a0)              // a0 = player struct
        lli     at, 0x0001                  // ~
        sw      at, 0x0180(a0)              // temp variable 2 = 1
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0028              // deallocate stack space
    }

    // @ Description
    // Main subroutine for USPA/USPG
    scope main_: {
        addiu   sp, sp,-0x0040              // allocate stack space
        sw      ra, 0x0014(sp)              // 0x0014(sp) = ra




        _wing:
        // checks the current animation frame to see if we've reached end of the animation
        mtc1    r0, f6                      // ~
        lwc1    f8, 0x0078(a0)              // ~
        c.le.s  f8, f6                      // ~
        nop
        bc1fl   _end                        // skip if animation end has not been reached
        nop
        jal     open_initial_               // transition to USPOpen
        nop

        _end:
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0040              // deallocate stack space
        jr      ra
        nop
    }

    // @ Description
    // Main subroutine for USPOpen.
    scope open_main_: {
        addiu   sp, sp,-0x0040              // allocate stack space
        sw      ra, 0x0014(sp)              // 0x0014(sp) = ra

        // checks the current animation frame to see if we've reached end of the animation
        mtc1    r0, f6                      // ~
        lwc1    f8, 0x0078(a0)              // ~
        c.le.s  f8, f6                      // ~
        nop
        bc1fl   _end                        // skip if animation end has not been reached
        nop
        jal     float_initial_              // transition to USPFloat
        nop

        _end:
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0040              // deallocate stack space
        jr      ra
        nop
    }



    // @ Description
    // Main subroutine for USPClose.
    // Based on subroutine 0x8015C750, which is the main subroutine of Fox's up special ending.
    // Modified to load Peach's landing FSM value and disable the interrupt flag.
    scope close_main_: {
        // Copy the first 8 lines of subroutine 0x8015C750
        OS.copy_segment(0xD7190, 0x20)
        bc1fl   _end                        // skip if animation end has not been reached
        lw      ra, 0x0024(sp)              // restore ra
        sw      r0, 0x0010(sp)              // unknown argument = 0
        sw      r0, 0x0018(sp)              // interrupt flag = FALSE
        lui     t6, LANDING_FSM             // t6 = LANDING_FSM
        jal     0x801438F0                  // begin special fall
        sw      t6, 0x0014(sp)              // store LANDING_FSM
        lw      ra, 0x0024(sp)              // restore ra

        _end:
        addiu   sp, sp, 0x0028              // deallocate stack space
        jr      ra                          // return
        nop
    }




    // @ Description
    // Subroutine which allows a direction change for Peach's up special.
    // Uses the moveset data command 580000XX (orignally identified as "set flag" by toomai)
    // This command's purpose appears to be setting a temporary variable in the player struct.
    // Variable values used by this subroutine:
    // 0x2 = change direction
    scope change_direction_: {
        // 0x180 in player struct = temp variable 2
        lw      a1, 0x0084(a0)              // a1 = player struct
        addiu   sp, sp,-0x0010              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      t1, 0x0008(sp)              // ~
        sw      ra, 0x000C(sp)              // store t0, t1, ra
        lw      t0, 0x0180(a1)              // t0 = temp variable 2
        ori     t1, r0, 0x0002              // t1 = 0x2
        bne     t1, t0, _end                // skip if temp variable 2 != 2
        nop
        jal     0x80160370                  // turn subroutine (copied from captain falcon)
        nop

        _end:
        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // ~
        lw      ra, 0x000C(sp)              // load t0, t1, ra
        addiu   sp, sp, 0x0010              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Allows USPFloat to be interrupted with USPClose.
    scope float_interrupt_: {
        OS.routine_begin(0x30)

        lw      v1, 0x0084(a0)              // v1 = player struct
        lb      t6, 0x01C3(v1)              // t6 = stick_y
        slti    at, t6, -39                 // at = 1 if stick_y < -39, else at = 0
        beq     at, r0, _end                // end if stick_y >= -39
        nop

        // if stick_y < -39
        jal     close_initial_              // transition to USPClose
        nop

        _end:
        OS.routine_end(0x30)
    }

    // @ Description
    // Allows USPFall to be interrupted with USPOpen.
    // Replaces 0x80143730
    scope fall_interrupt_: {
        OS.routine_begin(0x30)

        lw      v1, 0x0084(a0)              // v1 = player struct
        lb      t6, 0x01C3(v1)              // t6 = stick_y
        slti    at, t6, 40                  // at = 1 if stick_y < 40, else at = 0
        bne     at, r0, _end                // end if stick_y < 40
        nop

        // if stick_y >= 40
        jal     open_initial_              // transition to USPOpen
        nop

        _end:
        OS.routine_end(0x30)
    }

    // @ Description
    // Subroutine which handles movement for Peach's up special.
    // Uses the moveset data command 5C0000XX (orignally identified as "apply throw?" by toomai)
    // This command's purpose appears to be setting a temporary variable in the player struct.
    // The most common use of this variable is to determine when a throw should be applied.
    // Variable values used by this subroutine:
    // 0x2 = begin movement
    // 0x3 = movement
    // 0x4 = end movement
    scope physics_: {
        // s0 = player struct
        // s1 = attributes pointer
        // 0x184 in player struct = temp variable 3
        addiu   sp, sp,-0x0038              // allocate stack space
        sw      ra, 0x001C(sp)              // ~
        sw      s0, 0x0014(sp)              // ~
        sw      s1, 0x0018(sp)              // store ra, s0, s1

        lw      s0, 0x0084(a0)              // s0 = player struct
        lw      t0, 0x014C(s0)              // t0 = kinetic state
        bnez    t0, _aerial                 // branch if kinetic state !grounded
        nop

        _grounded:
        jal     0x800D8BB4                  // grounded physics subroutine
        nop
        b       _end                        // end subroutine
        nop

        _aerial:
        OS.copy_segment(0x548F0, 0x40)      // copy from original air physics subroutine
        bnez    v0, _check_begin            // modified original branch
        nop
        li      t8, 0x800D8FA8              // t8 = subroutine which disallows air control
        lw      t0, 0x0184(s0)              // t0 = temp variable 3
        ori     t1, r0, MOVE                // t1 = MOVE
        bne     t0, t1, _apply_air_physics  // branch if temp variable 3 != MOVE
        nop
        li      t8, air_control_             // t8 = air_control_

        _apply_air_physics:
        or      a0, s0, r0                  // a0 = player struct
        jalr    t8                          // air control subroutine
        or      a1, s1, r0                  // a1 = attributes pointer
        or      a0, s0, r0                  // a0 = player struct
        jal     0x800D9074                  // air friction subroutine?
        or      a1, s1, r0                  // a1 = attributes pointer

        _check_begin:
        lw      t0, 0x0184(s0)              // t0 = temp variable 3
        ori     t1, r0, BEGIN               // t1 = BEGIN
        bne     t0, t1, _check_begin_move   // skip if temp variable 3 != BEGIN
        lw      t0, 0x0024(s0)              // t0 = current action
        lli     t1, Uzi.Action.USPG      // t1 = Action.USPG
        beq     t0, t1, _check_begin_move   // skip if current action = USP_GROUND
        nop
        // slow x movement
        lwc1    f0, 0x0048(s0)              // f0 = current x velocity
        lui     t0, 0x3F60                  // ~
        mtc1    t0, f2                      // f2 = 0.875
        mul.s   f0, f0, f2                  // f0 = x velocity * 0.875
        swc1    f0, 0x0048(s0)              // x velocity = (x velocity * 0.875)
        // freeze y position
        sw      r0, 0x004C(s0)              // y velocity = 0

        _check_begin_move:
        lw      t0, 0x0184(s0)              // t0 = temp variable 3
        ori     t1, r0, BEGIN_MOVE          // t1 = BEGIN_MOVE
        bne     t0, t1, _check_end_move     // skip if temp variable 3 != BEGIN_MOVE
        nop
        // initialize x/y velocity
        lw      t0, 0x0024(s0)              // t0 = current action
        lli     t1, Uzi.Action.USPG      // t1 = Action.USPG
        beq     t0, t1, _apply_velocity     // branch if current action = USP_GROUND
        lui     t1, GROUND_Y_SPEED          // t1 = GROUND_Y_SPEED
        // if current action != USP_GROUND
        lui     t1, AIR_Y_SPEED             // t1 = AIR_Y_SPEED

        _apply_velocity:
        lui     t0, X_SPEED                 // ~
        mtc1    t0, f2                      // f2 = X_SPEED
        lwc1    f0, 0x0044(s0)              // ~
        cvt.s.w f0, f0                      // f0 = direction
        mul.s   f2, f0, f2                  // f2 = x velocity * direction
        ori     t0, r0, MOVE                // t0 = MOVE
        sw      t0, 0x0184(s0)              // temp variable 3 = MOVE
        // take mid-air jumps away at this point
        lw      t0, 0x09C8(s0)              // t0 = attribute pointer
        lw      t0, 0x0064(t0)              // t0 = max jumps
        sb      t0, 0x0148(s0)              // jumps used = max jumps
        swc1    f2, 0x0048(s0)              // store x velocity
        sw      t1, 0x004C(s0)              // store y velocity

        _check_end_move:
        lw      t0, 0x0184(s0)              // t0 = temp variable 3
        ori     t1, r0, END_MOVE            // t1 = END_MOVE
        bne     t0, t1, _end                // skip if temp variable 3 != END_MOVE
        lwc1    f0, 0x0048(s0)              // f0 = current x velocity

        lui     t0, 0x3F60                  // ~
        mtc1    t0, f2                      // f2 = 0.875
        mul.s   f0, f0, f2                  // f0 = x velocity * 0.875
        swc1    f0, 0x0048(s0)              // x velocity = (x velocity * 0.875)

        _end:
        lw      ra, 0x001C(sp)              // ~
        lw      s0, 0x0014(sp)              // ~
        lw      s1, 0x0018(sp)              // loar ra, s0, s1
        addiu   sp, sp, 0x0038              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Subroutine which handles Peach's horizontal control for up special.
    scope air_control_: {
        addiu   sp, sp,-0x0028              // allocate stack space
        sw      a1, 0x001C(sp)              // ~
        sw      ra, 0x0014(sp)              // ~
        sw      t0, 0x0020(sp)              // ~
        sw      t1, 0x0024(sp)              // store a1, ra, t0, t1
        addiu   a1, r0, 0x0008              // a1 = 0x8 (original line)
        lw      t6, 0x001C(sp)              // t6 = attribute pointer
        // load an immediate value into a2 instead of the air acceleration from the attributes
        lui     a2, AIR_ACCELERATION        // a2 = AIR_ACCELERATION
        lui     a3, AIR_SPEED               // a3 = AIR_SPEED
        jal     0x800D8FC8                  // air drift subroutine?
        nop
        lw      ra, 0x0014(sp)              // ~
        lw      t0, 0x0020(sp)              // ~
        lw      t1, 0x0024(sp)              // load ra, t0, t1
        addiu   sp, sp, 0x0028              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Aerial movement subroutine for USPOpen and USPFloat
    // Modified version of subroutine 0x800D90E0.
    scope float_physics_: {
        // Copy the first 8 lines of subroutine 0x800D90E0
        OS.copy_segment(0x548E0, 0x20)

        // Skip 7 lines (fast fall branch logic)

        // jal 0x800D8E50                   // ~
        // or a1, s1, r0                    // original 2 lines call gravity subroutine
        lui     a1, FLOAT_GRAVITY           // a1 = FLOAT_GRAVITY
        jal     0x800D8D68                  // apply gravity/fall speed
        lui     a2, FLOAT_FALL_SPEED        // a1 = FLOAT_FALL_SPEED

        // Copy the next 15 lines of subroutine 0x800D90E0
        OS.copy_segment(0x54924, 0x3C)
    }

    // @ Description
    // Collision wubroutine for Peach's up special.
    // Copy of subroutine 0x80156358, which is the collision subroutine for Mario's up special.
    // Loads the appropriate landing fsm value for Peach.
    scope collision_: {
        // Copy the first 30 lines of subroutine 0x80156358
        OS.copy_segment(0xD0D98, 0x78)
        // Replace original line which loads the landing fsm
        //lui     a2, 0x3E8F                // original line 1
        lui     a2, LANDING_FSM             // a2 = LANDING_FSM
        // Copy the last 17 lines of subroutine 0x80156358
        OS.copy_segment(0xD0E14, 0x44)
    }



    // @ Description
    // Subroutine which runs when Dragon King initiates an aerial down special.
    // Changes action, and sets up initial variable values.
    scope air_initial2_: {
        addiu   sp, sp,-0x0020              // ~
        sw      ra, 0x001C(sp)              // ~
        addiu   t6, r0, 0x0008              // ~
        sw      a0, 0x0020(sp)              // ~
        sw      t6, 0x0010(sp)              // original begin logic
        ori     a1, r0, Uzi.Action.DSPA_BEGIN2               // a1 = action id: DSP Begin
        ori     a2, r0, 0x0000              // a2 = 0 (begin action frame)
        jal     0x800E6F24                  // change action
        lui     a3, 0x3F80                  // a2 = float: 1.0
        jal     0x800E0830                  // unknown original subroutine
        lw      a0, 0x0020(sp)              // unknown original subroutine
        lw      a0, 0x0020(sp)              // ~
        lw      a0, 0x0084(a0)              // a0 = player struct
        sw      r0, 0x017C(a0)              // temp variable 1 = 0
        sw      r0, 0x0180(a0)              // temp variable 2 = 0
        ori     v1, r0, 0x0001              // ~
        sw      v1, 0x0184(a0)              // temp variable 3 = 0x1(BEGIN)
        // reset fall speed
        lbu     v1, 0x018D(a0)              // v1 = fast fall flag
        ori     t6, r0, 0x0007              // t6 = bitmask (01111111)
        and     v1, v1, t6                  // ~
        sb      v1, 0x018D(a0)              // disable fast fall flag
        lw      ra, 0x001C(sp)              // ~
        jr      ra                          // original return logic
        addiu   sp, sp, 0x0020              // ~
    }

    // Main subroutine for DSPA
    scope aerial_main2_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        lw      t8, 0x014C(a2)              // t8 = kinetic state
        li      a1, loop_initial2_           // a1(transition subroutine) = loop_initial_
        jal     0x800D9480                  // common main subroutine (transition on animation end)
        nop
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0018              // deallocate stack space
    }

    // @ Description
    // Subroutine which handles physics for Dragon King's down special.
    // Prevents player control when temp variable 2 = 0
    // Prevents negative Y velocity when temp variable 3 = 1 (BEGIN)
    scope physics2_: {
        // 0x180 in player struct = temp variable 2

        addiu   sp, sp,-0x0018              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      t1, 0x0008(sp)              // ~
        sw    	ra, 0x000C(sp)              // ~
        sw      a0, 0x0010(sp)              // store t0, t1, ra, a0
        lw      t0, 0x0084(a0)              // t0 = player struct
        lw      t1, 0x0180(t0)              // t1 = temp variable 2
        li      t8, 0x800D91EC              // t8 = physics subroutine which prevents player control
        bnez    t1, _subroutine2             // skip if t1 != 0
        nop

        li      t8, 0x800D90E0              // t8 = physics subroutine which allows player control
        _subroutine2:
        jalr      t8                        // run physics subroutine
        nop

        _check_fall2:
        lw      a0, 0x0010(sp)              // ~
        lw      a0, 0x0084(a0)              // a0 = player struct
        lw      t0, 0x0184(a0)              // t0 = temp variable 3
        ori     t1, r0, BEGIN               // t1 = BEGIN
        bne     t0, t1, _check_move2         // skip if temp variable 3 != BEGIN
        nop

        _check_move2:
        lw      t0, 0x0024(a0)              // action id
        addiu   at, r0, Uzi.Action.DSPA_LOOP2               // action = DSPA Loop
        beq     at, t0, _moving_down2        // branch if in DSPALoop
        lw      t0, 0x0184(a0)              // t0 = temp variable 3
        ori     t1, r0, MOVE                // t1 = MOVE
        bne     t0, t1, _apply_y_speed2      // skip if t0 != MOVE
        lui     t1, AERIAL_INITIAL_Y_SPEED  // moving up y speed
        _moving_down2:
        lui     t0, X_SPEED2                 // ~
        mtc1    t0, f2                      // f2 = X_SPEED
        lwc1    f0, 0x0044(a0)              // ~
        cvt.s.w f0, f0                      // f0 = direction
        mul.s   f2, f0, f2                  // f2 = x velocity * direction
        lui     t1, Y_SPEED                 // moving down y speed
        _apply_y_speed2:
        swc1    f2, 0x0048(a0)              // x velocity = X_SPEED
        sw      t1, 0x004C(a0)              // y velocity = Y_SPEED

        _end:
        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // ~
        lw      ra, 0x000C(sp)              // ~
        lw      a0, 0x0010(sp)              // load t0, t1, ra, a0
        jr      ra                          // return
        addiu   sp, sp, 0x0018              // deallocate stack space
    }

    // @ Description
    // Subroutine which handles collision for Dragon King's down special.
    // Transitions into the down special landing action when temp variable 3 = MOVE,
    // otherwise lands normally.
    scope collision2_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      a0, 0x0010(sp)              // ~
        sw      ra, 0x0014(sp)              // store ra, a0
        lw      a1, 0x0084(a0)              // a1 = player struct
        lw      v0, 0x014C(a1)              // v0 = kinetic state
        bnez    v0, _aerial2                 // branch if kinetic state != grounded
        nop

        _grounded2:
        jal     0x800DDF44                  // grounded collision subroutine
        nop
        b       _end                        // branch to end
        nop

        _aerial2:
        lw      v0, 0x184(a1)               // v0 = temp variable 3
        ori     t0, r0, MOVE                // a1 = MOVE
        beq     t0, v0, _main_collision2     // branch if temp variable 3 = MOVE
        addiu   at, r0, Uzi.Action.DSPA_LOOP2               // DSP loop action
        lw      v1, 0x0024(a1)              // current action
        beq     at, v1, _main_collision2     // branch if doing aerial loop action
        nop

        // If Dragon King is not in the earthquake motion, run a normal aerial collision subroutine
        // instead.
        jal     0x800DE978                  // aerial collision subroutine
        nop
        b       _end                        // branch to end
        nop

        _main_collision2:
        li      a1, landing_initial2_        // a1 = landing_initial_
        jal     0x800DE80C                  // common air collision subroutine (transition on landing, allow ledge grab)
        lw      a0, 0x0010(sp)              // load a0

        _end:
        lw      ra, 0x0014(sp)              // load ra
        jr      ra
        addiu   sp, sp, 0x0018              // deallocate stack space
    }

    // @ Description
    // Initial for Dragon King's DSP loop
    // Changes action, and sets up initial variable values.
    scope loop_initial2_: {
        addiu   sp, sp,-0x0020              // ~
        sw      ra, 0x001C(sp)              // ~
        addiu   t6, r0, 0x0001              // ~
        sw      a0, 0x0020(sp)              // ~
        sw      t6, 0x0010(sp)              // original begin logic
        ori     a1, r0, Uzi.Action.DSPA_LOOP2               // a1 = action id: DragonKing DSPA Loop
        ori     a2, r0, 0x0000              // a2 = 0 (begin action frame)
        jal     0x800E6F24                  // change action
        lui     a3, 0x3F80                  // a2 = float: 1.0
        jal     0x800E0830                  // unknown original subroutine
        lw      a0, 0x0020(sp)              // unknown original subroutine
        lw      a0, 0x0020(sp)              // ~
        lw      a0, 0x0084(a0)              // a0 = player struct
        sw      r0, 0x017C(a0)              // temp variable 1 = 0
        sw      r0, 0x0180(a0)              // temp variable 2 = 0
        sw      r0, 0x0184(a0)              // temp variable 2 = 0
        lw      ra, 0x001C(sp)              // ~
        jr      ra                          // original return logic
        addiu   sp, sp, 0x0020              // ~
    }

    // @ Description
    // Initial function for DSPLanding
    // Copy of subroutine 0x801600EC, which begins the landing action for Falcon Kick.
    // Loads the appropriate landing action for Dark Samus.
    scope landing_initial2_: {
        // Copy the first 6 lines of subroutine 0x801600EC
        OS.copy_segment(0xDAB2C, 0x18)
        // Replace original line which loads the landing action id
        // addiu   a1, r0, 0x00E8           // replaced line
        lw      t6, 0x0084(a0)              // t6 = player struct
        lui     at, 0x3F00                  // ~
        mtc1    at, f2                      // f2 = 0.625
        lwc1    f4, 0x0060(t6)              // f4 = ground x velocity
        mul.s   f4, f4, f2                  // f4 = ground x velocity * 0.625
        swc1    f4, 0x0060(t6)              // store updated ground x velocity
        addiu   a1, r0, Uzi.Action.DSPA_LAND2              // DSP landing action
        // Copy the last 8 lines of subroutine 0x801600EC
        OS.copy_segment(0xDAB48, 0x20)
    }
}

}


// GoemonSpecial.asm

// This file contains subroutines used by Goemon's special moves.

scope UziNSP {
    constant WALK_MULTIPLIER(0x3E80)        // float32 0.25
    constant WALK_TRACTION(0x41F0)          // float32 30
    constant AIR_SPEED(0x41E0)              // float32 28
    constant CHARGE_TIME4(600)
    constant CHARGE_TIME3(240)
    constant CHARGE_TIME2(70)
    constant CHARGE_TIME(0)
    constant SFX_RYO_SHOOT_1(1691)
    constant SFX_RYO_SHOOT_2(1692)
    constant SFX_RYO_SHOOT_3(1693)
    constant SFX_RYO_SHOOT_4(1694)

    constant SFX_RYO_FIRE(1617)

    // @ Description
    // Subroutine which runs when Goemon initiates a grounded neutral special.
    scope ground_begin_initial_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // store a0, ra

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.GOEMON_NSP_Ground_Begin
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.GOEMON_NSP_Ground_Begin

        lli     a1, Uzi.Action.NSP_Ground_Begin // a1(action id) = NSP_Ground_Begin
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      a0, 0x0020(sp)              // ~
        lw      a0, 0x0084(a0)              // ~
        sw      r0, 0x017C(a0)              // temp variable 1 = 0
        sw      r0, 0x0180(a0)              // temp variable 2 = 0
        sw      r0, 0x0184(a0)              // temp variable 3 = 0
        sw      r0, 0x0B18(a0)              // charge timer = 0
        sw      r0, 0x0B1C(a0)              // charge flag = 0
        lw      ra, 0x001C(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0020              // deallocate stack space
    }

    // @ Description
    // Subroutine which runs when Goemon initiates an aerial neutral special.
    scope air_begin_initial_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // store a0, ra

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.GOEMON_NSP_Air_Begin
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.GOEMON_NSP_Air_Begin

        lli     a1, Uzi.Action.NSP_Air_Begin // a1(action id) = NSP_Air_Begin
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      a0, 0x0020(sp)              // ~
        lw      a0, 0x0084(a0)              // ~
        sw      r0, 0x017C(a0)              // temp variable 1 = 0
        sw      r0, 0x0180(a0)              // temp variable 2 = 0
        sw      r0, 0x0184(a0)              // temp variable 3 = 0
        sw      r0, 0x0B18(a0)              // charge timer = 0
        sw      r0, 0x0B1C(a0)              // charge flag = 0
        lw      ra, 0x001C(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0020              // deallocate stack space
    }


















    // @ Description
    // Subroutine which begins Goemon's grounded neutral special wait action.
    scope ground_wait_initial_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // store a0, ra

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.GOEMON_NSP_Ground_Wait
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.GOEMON_NSP_Ground_Wait

        lli     a1, Uzi.Action.NSP_Ground_Wait // a1(action id) = NSP_Ground_Wait
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        lli     t6, 0x0800                  // ~
        jal     0x800E6F24                  // change action
        sw      t6, 0x0010(sp)              // argument 4 = 0x0800 (this flag continues FGM called with the 3C command)
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      ra, 0x001C(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0020              // deallocate stack space
    }

    // @ Description
    // Subroutine which begins Goemon's aerial neutral special wait action.
    scope air_wait_initial_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // store a0, ra

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.GOEMON_NSP_Air_Wait
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.GOEMON_NSP_Air_Wait

        lli     a1, Uzi.Action.NSP_Air_Wait // a1(action id) = NSP_Air_Wait
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        lli     t6, 0x0800                  // ~
        jal     0x800E6F24                  // change action
        sw      t6, 0x0010(sp)              // argument 4 = 0x0800 (this flag continues FGM called with the 3C command)
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      ra, 0x001C(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0020              // deallocate stack space
    }

    // @ Description
    // Subroutine which begins Goemon's grounded neutral special ending action.
    scope ground_end_initial_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // store a0, ra

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.GOEMON_NSP_Ground_End
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.GOEMON_NSP_Ground_End

        lli     a1, Uzi.Action.NSP_Ground_End // a1(action id) = NSP_Ground_End
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      ra, 0x001C(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0020              // deallocate stack space
    }

    // @ Description
    // Subroutine which begins Goemon's aerial neural special ending action.
    scope air_end_initial_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // store a0, ra

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.GOEMON_NSP_Air_End
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.GOEMON_NSP_Air_End

        lli     a1, Uzi.Action.NSP_Air_End // a1(action id) = NSP_Ground_End
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      ra, 0x001C(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0020              // deallocate stack space
    }

    // @ Description
    // Main subroutine for NSP_Ground_Begin
    // If temp variable 2 is set by moveset, cancel with NSP_Ground_End when B is not held.
    scope ground_begin_main_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        lw      v0, 0x0084(a0)              // v0 = player struct
        lw      t7, 0x0180(v0)              // t7 = temp variable 2
        beqz    t7, _check_end              // branch if temp variable 2 is not set
        lh      t7, 0x01BC(v0)              // t7 = buttons_held
        andi    t7, t7, Joypad.B            // t7 = 0x0020 if (B_HELD); else t7 = 0
        bnez    t7, _check_end              // branch if (B_HELD)
        nop

        _release:
        // if we're here then temp variable 2 is set and b is not held, so transition to ending action
        jal     ground_end_initial_         // transition to NSP_Ground_End
        nop
        b       _end
        nop

        _check_end:
        li      a1, ground_wait_initial_    // a1(transition subroutine) = ground_wait_initial_
        jal     0x800D9480                  // common main subroutine (transition on animation end)
        nop

        _end:
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0018              // deallocate stack space
    }

    // @ Description
    // Main subroutine for NSP_Air_Begin
    // If temp variable 2 is set by moveset, cancel with NSP_Ground_End when B is not held.
    scope air_begin_main_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        lw      v0, 0x0084(a0)              // v0 = player struct
        lw      t7, 0x0180(v0)              // t7 = temp variable 2
        beqz    t7, _check_end              // branch if temp variable 2 is not set
        lh      t7, 0x01BC(v0)              // t7 = buttons_held
        andi    t7, t7, Joypad.B            // t7 = 0x0020 if (B_HELD); else t7 = 0
        bnez    t7, _check_end              // branch if (B_HELD)
        nop

        _release:
        // if we're here then temp variable 2 is set and b is not held, so transition to ending action
        jal     air_end_initial_            // transition to NSP_Air_End
        nop
        b       _end
        nop

        _check_end:
        li      a1, air_wait_initial_       // a1(transition subroutine) = air_wait_initial_
        jal     0x800D9480                  // common main subroutine (transition on animation end)
        nop

        _end:
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0018              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Main subroutine for NSP_Ground_Wait
    scope ground_wait_main_: {
        addiu   sp, sp,-0x0028              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        lw      v0, 0x0084(a0)              // v0 = player struct
        lw      t7, 0x0B18(v0)              // t7 = charge timer
        lli     at, CHARGE_TIME             // ~
        beq     t7, at, _1           // branch if charge timer != CHARGE_TIME
        sw      a0, 0x0018(sp)              // 0x0018(sp) = player object
        nop
        lli     at, CHARGE_TIME2             // ~
        beq     t7, at, _2           // branch if charge timer != CHARGE_TIME
        sw      a0, 0x0018(sp)              // 0x0018(sp) = player object
        nop
        lli     at, CHARGE_TIME3             // ~
        beq     t7, at, _3           // branch if charge timer != CHARGE_TIME
        sw      a0, 0x0018(sp)              // 0x0018(sp) = player object
        nop
        lli     at, CHARGE_TIME4             // ~
        beq     t7, at, _4           // branch if charge timer != CHARGE_TIME
        sw      a0, 0x0018(sp)              // 0x0018(sp) = player object
        nop

        j       _continue3
        nop

        _4:

        // if we reach this point play a sound, begin the GFX routine and set the charge flag
        lli     at, OS.TRUE                 // ~
        sw      at, 0x0B1C(v0)              // set charge flag to TRUE
        FGM.play(SFX_RYO_SHOOT_4)           // play first sfx

        lli     a1, GFXRoutine.id.GOEMON_CHARGE // a1 = GOEMON_CHARGE id
        or      a2, r0, r0                  // a2 = 0
        jal     0x800E9814                  // begin gfx routine
        lw      a0, 0x0018(sp)              // a0 = player object
        lw      a0, 0x0018(sp)              // a0 = player object
        lw      v0, 0x0084(a0)              // v0 = player struct
        j       _continue3
        nop



        _3:

        // if we reach this point play a sound, begin the GFX routine and set the charge flag
        FGM.play(SFX_RYO_SHOOT_3)           // play first sfx

        or      a2, r0, r0                  // a2 = 0
        jal     0x800E9814                  // begin gfx routine
        lw      a0, 0x0018(sp)              // a0 = player object
        lw      a0, 0x0018(sp)              // a0 = player object
        lw      v0, 0x0084(a0)              // v0 = player struct
        j       _continue3
        nop


        _2:

        // if we reach this point play a sound, begin the GFX routine and set the charge flag
        FGM.play(SFX_RYO_SHOOT_2)           // play first sfx

        or      a2, r0, r0                  // a2 = 0
        jal     0x800E9814                  // begin gfx routine
        lw      a0, 0x0018(sp)              // a0 = player object
        lw      a0, 0x0018(sp)              // a0 = player object
        lw      v0, 0x0084(a0)              // v0 = player struct
        j       _continue3
        nop

        _1:

        // if we reach this point play a sound, begin the GFX routine and set the charge flag
        FGM.play(SFX_RYO_SHOOT_1)           // play first sfx

        or      a2, r0, r0                  // a2 = 0
        jal     0x800E9814                  // begin gfx routine
        lw      a0, 0x0018(sp)              // a0 = player object
        lw      a0, 0x0018(sp)              // a0 = player object
        lw      v0, 0x0084(a0)              // v0 = player struct
        j       _continue3
        nop


        _continue3:
        lli     at, CHARGE_TIME4             // ~
        bge     t7, at, _continuet           // branch if charge timer != CHARGE_TIME
        nop
        lli     at, CHARGE_TIME3             // ~
        bge     t7, at, _continue4           // branch if charge timer != CHARGE_TIME
        nop
        lli     at, CHARGE_TIME2             // ~
        bge     t7, at, _continue2           // branch if charge timer != CHARGE_TIME
        nop

        j       _continue
        nop


        _continuet:
        lw      t7, 0x0B18(v0)              // t7 = charge timer
        addiu   t7, t7, 0x0001              // ~
        sw      t7, 0x0B18(v0)              // increment charge timer
        lh      t7, 0x01BC(v0)              // t7 = buttons_held
        andi    t7, t7, Joypad.B            // t7 = 0x0020 if (B_HELD); else t7 = 0
        bnez    t7, _end                    // branch if (B_HELD)
        nop


        // if we reach this point, the b button is not being held, so transition to ending action
        jal     ground_initial4_         // transition to NSP_Ground_End
        nop
        j       _end
        nop



        _continue:
        lw      t7, 0x0B18(v0)              // t7 = charge timer
        addiu   t7, t7, 0x0001              // ~
        sw      t7, 0x0B18(v0)              // increment charge timer
        lh      t7, 0x01BC(v0)              // t7 = buttons_held
        andi    t7, t7, Joypad.B            // t7 = 0x0020 if (B_HELD); else t7 = 0
        bnez    t7, _end                    // branch if (B_HELD)
        nop


        // if we reach this point, the b button is not being held, so transition to ending action
        jal     ground_initial_         // transition to NSP_Ground_End
        nop

        j       _end
        nop

        _continue2:
        lw      t7, 0x0B18(v0)              // t7 = charge timer
        addiu   t7, t7, 0x0001              // ~
        sw      t7, 0x0B18(v0)              // increment charge timer
        lh      t7, 0x01BC(v0)              // t7 = buttons_held
        andi    t7, t7, Joypad.B            // t7 = 0x0020 if (B_HELD); else t7 = 0
        bnez    t7, _end                    // branch if (B_HELD)
        nop


        // if we reach this point, the b button is not being held, so transition to ending action
        jal     ground_initial2_         // transition to NSP_Ground_End
        nop

        j       _end
        nop

        _continue4:
        lw      t7, 0x0B18(v0)              // t7 = charge timer
        addiu   t7, t7, 0x0001              // ~
        sw      t7, 0x0B18(v0)              // increment charge timer
        lh      t7, 0x01BC(v0)              // t7 = buttons_held
        andi    t7, t7, Joypad.B            // t7 = 0x0020 if (B_HELD); else t7 = 0
        bnez    t7, _end                    // branch if (B_HELD)
        nop


        // if we reach this point, the b button is not being held, so transition to ending action
        jal     ground_initial3_         // transition to NSP_Ground_End
        nop

        _end:
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0028              // deallocate stack space

    }



    scope nsp_transition_attackg_: {
        addiu   sp, sp, -0x0020             // ~
        sw      ra, 0x001C(sp)              // ~
        addiu   t6, r0, 0x0003
        sw      a0, 0x0020(sp)
        sw      t6, 0x0010(sp)
        addiu   a1, r0, Uzi.Action.NSPG  // insert action in a1
        addiu   a2, r0, 0x0000





        lw      t0, 0x0084(a0)              // load player struct
        sw      r0, 0x017C(t0)              // temp variable 1 = 0
        sw      r0, 0x0180(t0)              // temp variable 2 = 0
        sw      r0, 0x0184(t0)              // temp variable 3 = 0





        jal     0x800E6F24                  // change action routine
        lui     a3, 0x3f80

        jal     0x800E0830
        lw      a0, 0x0020(sp)

        jal     0x8015BFBC
        lw      a0, 0x0020(sp)






        lw      ra, 0x001C(sp)              // ~
        addiu   sp, sp, 0x0020              // ~

        jr      ra                          // original return logic
        nop
    }



    // @ Description
    // Main subroutine for NSP_Air_Wait
    scope air_wait_main_: {
        addiu   sp, sp,-0x0028              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        lw      v0, 0x0084(a0)              // v0 = player struct
        lw      t7, 0x0B18(v0)              // t7 = charge timer
        lli     at, CHARGE_TIME             // ~
        beq     t7, at, _1           // branch if charge timer != CHARGE_TIME
        sw      a0, 0x0018(sp)              // 0x0018(sp) = player object
        nop
        lli     at, CHARGE_TIME2             // ~
        beq     t7, at, _2           // branch if charge timer != CHARGE_TIME
        sw      a0, 0x0018(sp)              // 0x0018(sp) = player object
        nop
        lli     at, CHARGE_TIME3             // ~
        beq     t7, at, _3           // branch if charge timer != CHARGE_TIME
        sw      a0, 0x0018(sp)              // 0x0018(sp) = player object
        nop
        lli     at, CHARGE_TIME4             // ~
        beq     t7, at, _4           // branch if charge timer != CHARGE_TIME
        sw      a0, 0x0018(sp)              // 0x0018(sp) = player object
        nop

        j       _continue3
        nop

        _4:

        // if we reach this point play a sound, begin the GFX routine and set the charge flag
        lli     at, OS.TRUE                 // ~
        sw      at, 0x0B1C(v0)              // set charge flag to TRUE
        FGM.play(SFX_RYO_SHOOT_4)           // play first sfx

        lli     a1, GFXRoutine.id.GOEMON_CHARGE // a1 = GOEMON_CHARGE id
        or      a2, r0, r0                  // a2 = 0
        jal     0x800E9814                  // begin gfx routine
        lw      a0, 0x0018(sp)              // a0 = player object
        lw      a0, 0x0018(sp)              // a0 = player object
        lw      v0, 0x0084(a0)              // v0 = player struct
        j       _continue3
        nop



        _3:

        // if we reach this point play a sound, begin the GFX routine and set the charge flag
        FGM.play(SFX_RYO_SHOOT_3)           // play first sfx

        or      a2, r0, r0                  // a2 = 0
        jal     0x800E9814                  // begin gfx routine
        lw      a0, 0x0018(sp)              // a0 = player object
        lw      a0, 0x0018(sp)              // a0 = player object
        lw      v0, 0x0084(a0)              // v0 = player struct
        j       _continue3
        nop


        _2:

        // if we reach this point play a sound, begin the GFX routine and set the charge flag
        FGM.play(SFX_RYO_SHOOT_2)           // play first sfx

        or      a2, r0, r0                  // a2 = 0
        jal     0x800E9814                  // begin gfx routine
        lw      a0, 0x0018(sp)              // a0 = player object
        lw      a0, 0x0018(sp)              // a0 = player object
        lw      v0, 0x0084(a0)              // v0 = player struct
        j       _continue3
        nop

        _1:

        // if we reach this point play a sound, begin the GFX routine and set the charge flag
        FGM.play(SFX_RYO_SHOOT_1)           // play first sfx

        or      a2, r0, r0                  // a2 = 0
        jal     0x800E9814                  // begin gfx routine
        lw      a0, 0x0018(sp)              // a0 = player object
        lw      a0, 0x0018(sp)              // a0 = player object
        lw      v0, 0x0084(a0)              // v0 = player struct
        j       _continue3
        nop


        _continue3:
        lli     at, CHARGE_TIME4             // ~
        bge     t7, at, _continuet           // branch if charge timer != CHARGE_TIME
        nop
        lli     at, CHARGE_TIME2             // ~
        bge     t7, at, _continue2          // branch if charge timer != CHARGE_TIME
        nop
        lli     at, CHARGE_TIME3             // ~
        bge     t7, at, _continue4           // branch if charge timer != CHARGE_TIME
        nop

        j       _continue
        nop


        _continuet:
        lw      t7, 0x0B18(v0)              // t7 = charge timer
        addiu   t7, t7, 0x0001              // ~
        sw      t7, 0x0B18(v0)              // increment charge timer
        lh      t7, 0x01BC(v0)              // t7 = buttons_held
        andi    t7, t7, Joypad.B            // t7 = 0x0020 if (B_HELD); else t7 = 0
        bnez    t7, _end                    // branch if (B_HELD)
        nop


        // if we reach this point, the b button is not being held, so transition to ending action
        jal     air_initial4_         // transition to NSP_air_End
        nop
        j       _end
        nop



        _continue:
        lw      t7, 0x0B18(v0)              // t7 = charge timer
        addiu   t7, t7, 0x0001              // ~
        sw      t7, 0x0B18(v0)              // increment charge timer
        lh      t7, 0x01BC(v0)              // t7 = buttons_held
        andi    t7, t7, Joypad.B            // t7 = 0x0020 if (B_HELD); else t7 = 0
        bnez    t7, _end                    // branch if (B_HELD)
        nop


        // if we reach this point, the b button is not being held, so transition to ending action
        jal     air_initial_         // transition to NSP_air_End
        nop

        j       _end
        nop
 

        _continue2:
        lw      t7, 0x0B18(v0)              // t7 = charge timer
        addiu   t7, t7, 0x0001              // ~
        sw      t7, 0x0B18(v0)              // increment charge timer
        lh      t7, 0x01BC(v0)              // t7 = buttons_held
        andi    t7, t7, Joypad.B            // t7 = 0x0020 if (B_HELD); else t7 = 0
        bnez    t7, _end                    // branch if (B_HELD)
        nop


        // if we reach this point, the b button is not being held, so transition to ending action
        jal     air_initial2_         // transition to NSP_air_End
        nop

        j       _end
        nop

        _continue4:
        lw      t7, 0x0B18(v0)              // t7 = charge timer
        addiu   t7, t7, 0x0001              // ~
        sw      t7, 0x0B18(v0)              // increment charge timer
        lh      t7, 0x01BC(v0)              // t7 = buttons_held
        andi    t7, t7, Joypad.B            // t7 = 0x0020 if (B_HELD); else t7 = 0
        bnez    t7, _end                    // branch if (B_HELD)
        nop


        // if we reach this point, the b button is not being held, so transition to ending action
        jal     air_initial3_         // transition to NSP_air_End
        nop







        _end:
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0028              // deallocate stack space
    }

    // @ Description
    // Main subroutine for neutral special air ending.
    // If temp variable 1 is set by moveset, create a projectile.
    // The value of temp variable 3 will be added as bonus power to the projectile.
    scope end_main_: {
        addiu   sp, sp,-0x0040              // allocate stack space
        sw      ra, 0x0014(sp)              // 0x0014(sp) = ra
        sw      a0, 0x0034(sp)              // 0x0034(sp) = player object
        addu    a2, a0, r0                  // a2 = player object
        lw      v0, 0x0084(a0)              // v0 = player struct
        lw      t6, 0x017C(v0)              // t6 = temp variable 1
        beq     t6, r0, _idle_check         // skip if temp variable 1 = 0
        sw      r0, 0x017C(v0)              // reset temp variable 1 to 0

        // if we're here, then temp variable 1 was enabled, so create a projectile
        swc1    f0, 0x0020(sp)              // ~
        swc1    f0, 0x0024(sp)              // ~
        swc1    f0, 0x0028(sp)              // clear space used for x/y/z coordinates (probably not needed)
        addiu   a1, sp, 0x0020              // a1 = address to return x/y/z coordinates to
        lw      a0, 0x0928(v0)              // a0 = part 0xC (right hand) struct
        jal     0x800EDF24                  // returns x/y/z coordinates of the part in a0 to a1
        sw      v0, 0x002C(sp)              // 0x002C(sp) = player struct
        lwc1    f6, 0x0024(sp)              // f6 = y coordinate
        lui     t6, 0x41F0                  // ~
        mtc1    t6, f8                      // f6 = 30
        add.s   f6, f6, f8                  // add 30 to y coordinate
        swc1    f6, 0x0024(sp)              // store updated y coordinate
        sw      r0, 0x0028(sp)              // set z coordinate to 0
        lw      v0, 0x002C(sp)              // v0 = player struct
        lw      a0, 0x0034(sp)              // a0 = player object
        jal     ryo_stage_setting_          // INITIATE RYO
        addiu   a1, sp, 0x0020              // a1 = coordinates to create projectile at
        lw      a0, 0x0034(sp)              // a0 = player object

        _idle_check:
        // checks the current animation frame to see if we've reached end of the animation
        mtc1    r0, f6                      // ~
        lwc1    f8, 0x0078(a0)              // ~
        c.le.s  f8, f6                      // ~
        nop
        bc1fl   _end                        // skip if animation end has not been reached
        nop
        jal     0x800DEE54                  // transition to idle
        nop

        _end:
        lw      ra, 0x0014(sp)              // load ra
        jr      ra
        addiu   sp, sp, 0x0040              // deallocate stack space
    }

    // @ Description
    // Interrupt function for ground wait/walk actions.
    scope ground_interrupt_: {
        addiu   sp, sp,-0x0040              // allocate stack space
        lw      v1, 0x0084(a0)              // v1 = player struct
        lb      t6, 0x01C2(v1)              // t6 = stick_x
        lw      t7, 0x0044(v1)              // t7 = DIRECTION
        multu   t6, t7                      // stick_x * DIRECTION
        sw      ra, 0x0014(sp)              // store ra

        lw      t7, 0x0008(v1)              // character id
        addiu   at, r0, Character.id.UZI

        beq     t7, at, _goemon
        lw      t7, 0x0024(v1)              // t7 = current action

        // kirby
        mflo    t6                          // t6 = stick_x * DIRECTION
        slti    at, t6, -44                 // at = 1 if stick_x < -44, else at = 0
        bnezl   at, _kirby_check_transition       // branch if stick_x < -44
        lli     a1, Kirby.Action.GOEMON_NSP_Ground_BWalk2 // a1 = Action.NSP_Ground_BWalk2
        slti    at, t6, -9                  // at = 1 if stick_x < -9, else at = 0
        bnezl   at, _kirby_check_transition       // branch if stick_x < -9
        lli     a1, Kirby.Action.GOEMON_NSP_Ground_BWalk1 // a1 = Action.NSP_Ground_BWalk1
        slti    at, t6, 10                  // at = 1 if stick_x < 10, else at = 0
        bnezl   at, _kirby_check_transition       // branch if stick_x < 10
        lli     a1, Kirby.Action.GOEMON_NSP_Ground_Wait // a1 = Action.NSP_Ground_Wait
        slti    at, t6, 45                  // at = 1 if stick_x < 45, else at = 0
        bnezl   at, _kirby_check_transition       // branch if stick_x < 45
        lli     a1, Kirby.Action.GOEMON_NSP_Ground_Walk1 // a1 = Action.NSP_Ground_Walk1
        // if here stick_x >= 45
        lli     a1, Kirby.Action.GOEMON_NSP_Ground_Walk2 // a1 = Action.NSP_Ground_Walk2

        _kirby_check_transition:
        beq     a1, t7, _end                // skip if already performing appropriate action
        nop
        jal     kirby_ground_transition_          // transition to new action
        nop
        b       _end
        nop

        _goemon:
        mflo    t6                          // t6 = stick_x * DIRECTION
        slti    at, t6, -44                 // at = 1 if stick_x < -44, else at = 0
        bnezl   at, _check_transition       // branch if stick_x < -44
        lli     a1, Uzi.Action.NSP_Ground_BWalk2 // a1 = Action.NSP_Ground_BWalk2
        slti    at, t6, -9                  // at = 1 if stick_x < -9, else at = 0
        bnezl   at, _check_transition       // branch if stick_x < -9
        lli     a1, Uzi.Action.NSP_Ground_BWalk1 // a1 = Action.NSP_Ground_BWalk1
        slti    at, t6, 10                  // at = 1 if stick_x < 10, else at = 0
        bnezl   at, _check_transition       // branch if stick_x < 10
        lli     a1, Uzi.Action.NSP_Ground_Wait // a1 = Action.NSP_Ground_Wait
        slti    at, t6, 45                  // at = 1 if stick_x < 45, else at = 0
        bnezl   at, _check_transition       // branch if stick_x < 45
        lli     a1, Uzi.Action.NSP_Ground_Walk1 // a1 = Action.NSP_Ground_Walk1
        // if here stick_x >= 45
        lli     a1, Uzi.Action.NSP_Ground_Walk2 // a1 = Action.NSP_Ground_Walk2


        _check_transition:
        beq     a1, t7, _end                // skip if already performing appropriate action
        nop
        jal     ground_transition_          // transition to new action
        nop

        _end:
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0040              // deallocate stack space
    }

    // @ Descirption
    // Transition between grounded wait/walk actions.
    // a0 - player object
    // a1 - action id
    scope ground_transition_: {
        addiu   sp, sp,-0x0038              // allocate stack space
        sw      ra, 0x001C(sp)              // store ra
        sw      a0, 0x0038(sp)              // 0x0038(sp) = player object
        lwc1    f4, 0x0078(a0)              // f4 = current animation frame
        li      t6, cycle_length_table      // t6 = cycle_length_table
        lw      t5, 0x0084(a0)              // t
        lw      t5, 0x0024(t5)              // t5 = current action
        lli     at, Uzi.Action.NSP_Ground_Wait // at = NSP_Ground_Wait
        beql    t5, at, _end                // branch if current action = NSP_Ground_Wait...
        or      a2, r0, r0                  // ...a2 = starting frame = 0
        beql    a2, at, _end                // branch if target action = NSP_Ground_Wait...
        or      a2, r0, r0                  // ...a2 = starting frame = 0

        addiu   at, t5, -Uzi.Action.NSP_Ground_Wait
        sll     at, at, 0x2                 // at = table index for current action
        addu    t7, t6, at                  // t7 = cycle_length_table + current action index
        addiu   at, a1, -Uzi.Action.NSP_Ground_Wait
        sll     at, at, 0x2                 // at = table index for target action
        addu    t8, t6, at                  // t8 = cycle_length_table + target action index
        lwc1    f6, 0x0000(t7)              // f6 = current cycle length
        lwc1    f8, 0x0000(t8)              // f8 = target cycle length
        div.s   f4, f4, f6                  // f4 = multiplier (current frame / current cycle length)
        mul.s   f6, f4, f8                  // ~
        trunc.w.s f6, f6                    // ~
        cvt.s.w f6, f6                      // f6 = starting frame = trunc(multiplier * target cycle length)
        mfc1    a2, f6                      // a2 = starting frame

        _end:
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        lli     t6, 0x0802                  // ~
        jal     0x800E6F24                  // change action
        sw      t6, 0x0010(sp)              // argument 4 = 0x0802 (continue: 3C FGM, gfx routines)
        lw      ra, 0x001C(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0038              // deallocate stack space
    }

    // @ Descirption
    // Transition between grounded wait/walk actions.
    // a0 - player object
    // a1 - action id
    scope kirby_ground_transition_: {
        addiu   sp, sp,-0x0038              // allocate stack space
        sw      ra, 0x001C(sp)              // store ra
        sw      a0, 0x0038(sp)              // 0x0038(sp) = player object
        lwc1    f4, 0x0078(a0)              // f4 = current animation frame
        li      t6, kirby_cycle_length_table      // t6 = kirby_cycle_length_table
        lw      t5, 0x0084(a0)              // t
        lw      t5, 0x0024(t5)              // t5 = current action
        lli     at, Kirby.Action.GOEMON_NSP_Ground_Wait // at = NSP_Ground_Wait
        beql    t5, at, _end                // branch if current action = NSP_Ground_Wait...
        or      a2, r0, r0                  // ...a2 = starting frame = 0
        beql    a2, at, _end                // branch if target action = NSP_Ground_Wait...
        or      a2, r0, r0                  // ...a2 = starting frame = 0

        addiu   at, t5, -Kirby.Action.GOEMON_NSP_Ground_Wait
        sll     at, at, 0x2                 // at = table index for current action
        addu    t7, t6, at                  // t7 = kirby_cycle_length_table + current action index
        addiu   at, a1, -Kirby.Action.GOEMON_NSP_Ground_Wait
        sll     at, at, 0x2                 // at = table index for target action
        addu    t8, t6, at                  // t8 = kirby_cycle_length_table + target action index
        lwc1    f6, 0x0000(t7)              // f6 = current cycle length
        lwc1    f8, 0x0000(t8)              // f8 = target cycle length
        div.s   f4, f4, f6                  // f4 = multiplier (current frame / current cycle length)
        mul.s   f6, f4, f8                  // ~
        trunc.w.s f6, f6                    // ~
        cvt.s.w f6, f6                      // f6 = starting frame = trunc(multiplier * target cycle length)
        mfc1    a2, f6                      // a2 = starting frame

        _end:
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        lli     t6, 0x0802                  // ~
        jal     0x800E6F24                  // change action
        sw      t6, 0x0010(sp)              // argument 4 = 0x0802 (continue: 3C FGM, gfx routines)
        lw      ra, 0x001C(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0038              // deallocate stack space
    }

    // @ Description
    // Physics function for ground walk actions.
    // Based on 0x8013E548
    scope ground_walk_physics_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        sw      a0, 0x0018(sp)              // 0x0018(a0) = player object
        lw      a0, 0x0084(a0)              // a0 = player struct
        lui     a1, WALK_MULTIPLIER         // a1 = WALK_MULTIPLIER
        jal     0x800D8A70                  // apply walk physics
        lui     a2, WALK_TRACTION           // a2 = WALK_TRACTION
        jal     0x800D87D0                  // unknown subroutine
        lw      a0, 0x0018(sp)              // a0 = player object
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0018              // deallocate stack space
    }

    // @ Description
    // Physics function for ground back walk actions.
    // Based on 0x8013E548
    scope ground_back_walk_physics_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        sw      a0, 0x0018(sp)              // 0x0018(a0) = player object
        lw      a0, 0x0084(a0)              // a0 = player struct
        lui     a1, WALK_MULTIPLIER | 0x8000 // a1 = -WALK_MULTIPLIER
        jal     0x800D8A70                  // apply walk physics
        lui     a2, WALK_TRACTION           // a2 = WALK_TRACTION
        jal     0x800D87D0                  // unknown subroutine
        lw      a0, 0x0018(sp)              // a0 = player object
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0018              // deallocate stack space
    }

    // @ Description
    // Shared air physics function.
    // Based on 0x800D90E0
    scope air_physics_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x001C(sp)              // ~
        sw      s0, 0x0014(sp)              // ~
        sw      s1, 0x0018(sp)              // original store registers
        OS.copy_segment(0x548F0, 0x40)      // copy from original air physics subroutine
        bnez    v0, _end                    // modified original branch
        or      a0, s0, r0                  // a0 = player struct
        jal     air_control_                // air control subroutine
        or      a1, s1, r0                  // a1 = attributes pointer
        or      a0, s0, r0                  // a0 = player struct
        jal     0x800D9074                  // air friction subroutine?
        or      a1, s1, r0                  // a1 = attributes pointer

        _end:
        lw      ra, 0x001C(sp)              // ~
        lw      s0, 0x0014(sp)              // ~
        lw      s1, 0x0018(sp)              // original load registers
        jr      ra                          // return
        addiu   sp, sp, 0x0020              // deallocate stack space
    }

    // @ Description
    // Subroutine which handles Goemons's horizontal air control for neutral special.
    // Based on 0x800D9044
    scope air_control_: {
        addiu   sp, sp,-0x0028              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        or      t6, a1, r0                  // t6 = attribute pointer
        addiu   a1, r0, 0x0008              // a1 = 0x8 (original line)
        lw      a2, 0x004C(t6)              // a2 = air acceleration
        // load an immediate value into a3 instead of the air acceleration from the attributes
        lui     a3, AIR_SPEED               // a3 = AIR_SPEED
        jal     0x800D8FC8                  // air drift subroutine?
        nop
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0028              // deallocate stack space
    }

    // @ Description
    // Subroutine which handles ground collision for neutral special actions
    scope ground_collision_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        li      a1, ground_to_air_          // a1(transition subroutine) = ground_to_air_
        jal     0x800DDDDC                  // common ground collision subroutine (transition on no floor, slide-off)
        nop
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0018              // deallocate stack space
    }

    // @ Description
    // Subroutine which handles air collision for neutral special begin and wait
    scope air_collision_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        li      a1, air_to_ground_          // a1(transition subroutine) = air_to_ground_
        jal     0x800DE6E4                  // common air collision subroutine (transition on landing, no ledge grab)
        nop
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0018              // deallocate stack space
    }

    // @ Description
    // Subroutine which handles ground collision for neutral special actions
    scope kirby_ground_collision_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        li      a1, kirby_ground_to_air_          // a1(transition subroutine) = ground_to_air_
        jal     0x800DDDDC                  // common ground collision subroutine (transition on no floor, slide-off)
        nop
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0018              // deallocate stack space
    }

    // @ Description
    // Subroutine which handles air collision for neutral special begin and wait
    scope kirby_air_collision_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        li      a1, kirby_air_to_ground_    // a1(transition subroutine) = air_to_ground_
        jal     0x800DE6E4                  // common air collision subroutine (transition on landing, no ledge grab)
        nop
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0018              // deallocate stack space
    }

    // @ Description
    // Subroutine which handles ground to air transition for neutral special actions
    scope ground_to_air_: {
        addiu   sp, sp,-0x0038              // allocate stack space
        sw      ra, 0x001C(sp)              // store ra
        sw      a0, 0x0038(sp)              // 0x0038(sp) = player object
        lw      a0, 0x0084(a0)              // a0 = player struct
        jal     0x800DEEC8                  // set aerial state
        sw      a0, 0x0034(sp)              // 0x0034(sp) = player struct
        lw      v0, 0x0034(sp)              // v0 = player struct
        lw      a0, 0x0038(sp)              // a0 = player object
        li      t6, ground_to_air_table     // t6 = ground_to_air_table
        lw      t7, 0x0024(v0)              // t7 = current action
        addiu   t7, t7, -Uzi.Action.NSP_Ground_Begin
        sll     t7, t7, 0x0001              // t7 = table index for current action
        addu    t6, t6, t7                  // t6 = ground_to_air_table + index
        lhu      a1, 0x0000(t6)              // a1 = equivalent air action for current ground action
        lw      a2, 0x0078(a0)              // a2(starting frame) = current animation frame
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        lli     t6, 0x0802                  // ~
        jal     0x800E6F24                  // change action
        sw      t6, 0x0010(sp)              // argument 4 = 0x0802 (continue: 3C FGM, gfx routines)
        jal     0x800D8EB8                  // momentum capture?
        lw      a0, 0x0034(sp)              // a0 = player struct
        lw      ra, 0x001C(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0038              // deallocate stack space
    }

    // @ Description
    // Subroutine which handles air to ground transition for begin and wait neutral special actions
    scope air_to_ground_: {
        addiu   sp, sp,-0x0038              // allocate stack space
        sw      ra, 0x001C(sp)              // store ra
        sw      a0, 0x0038(sp)              // 0x0038(sp) = player object
        lw      a0, 0x0084(a0)              // a0 = player struct
        jal     0x800DEE98                  // set grounded state
        sw      a0, 0x0034(sp)              // 0x0034(sp) = player struct
        lw      v0, 0x0034(sp)              // v0 = player struct
        lw      a0, 0x0038(sp)              // a0 = player object
        li      t6, air_to_ground_table     // t6 = air_to_ground_table
        lw      t7, 0x0024(v0)              // t7 = current action
        addiu   t7, t7, -Uzi.Action.NSP_Air_Begin
        sll     t7, t7, 0x0001              // t7 = table index for current action
        addu    t6, t6, t7                  // t6 = air_to_ground_table + index
        lhu      a1, 0x0000(t6)              // a1 = equivalent ground action for current air action
        lw      a2, 0x0078(a0)              // a2(starting frame) = current animation frame
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        lli     t6, 0x0802                  // ~
        jal     0x800E6F24                  // change action
        sw      t6, 0x0010(sp)              // argument 4 = 0x0802 (continue: 3C FGM, gfx routines)
        lw      ra, 0x001C(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0038              // deallocate stack space
    }

    // @ Description
    // Subroutine which handles ground to air transition for neutral special actions
    scope kirby_ground_to_air_: {
        addiu   sp, sp,-0x0038              // allocate stack space
        sw      ra, 0x001C(sp)              // store ra
        sw      a0, 0x0038(sp)              // 0x0038(sp) = player object
        lw      a0, 0x0084(a0)              // a0 = player struct
        jal     0x800DEEC8                  // set aerial state
        sw      a0, 0x0034(sp)              // 0x0034(sp) = player struct
        lw      v0, 0x0034(sp)              // v0 = player struct
        lw      a0, 0x0038(sp)              // a0 = player object
        li      t6, kirby_ground_to_air_table     // t6 = ground_to_air_table
        lw      t7, 0x0024(v0)              // t7 = current action
        addiu   t7, t7, -Kirby.Action.GOEMON_NSP_Ground_Begin
        sll     t7, t7, 0x0001              // t7 = table index for current action
        addu    t6, t6, t7                  // t6 = ground_to_air_table + index
        lhu      a1, 0x0000(t6)              // a1 = equivalent air action for current ground action
        lw      a2, 0x0078(a0)              // a2(starting frame) = current animation frame
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        lli     t6, 0x0802                  // ~
        jal     0x800E6F24                  // change action
        sw      t6, 0x0010(sp)              // argument 4 = 0x0802 (continue: 3C FGM, gfx routines)
        jal     0x800D8EB8                  // momentum capture?
        lw      a0, 0x0034(sp)              // a0 = player struct
        lw      ra, 0x001C(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0038              // deallocate stack space
    }

    // @ Description
    // Subroutine which handles air to ground transition for begin and wait neutral special actions
    scope kirby_air_to_ground_: {
        addiu   sp, sp,-0x0038              // allocate stack space
        sw      ra, 0x001C(sp)              // store ra
        sw      a0, 0x0038(sp)              // 0x0038(sp) = player object
        lw      a0, 0x0084(a0)              // a0 = player struct
        jal     0x800DEE98                  // set grounded state
        sw      a0, 0x0034(sp)              // 0x0034(sp) = player struct
        lw      v0, 0x0034(sp)              // v0 = player struct
        lw      a0, 0x0038(sp)              // a0 = player object
        li      t6, kirby_air_to_ground_table     // t6 = air_to_ground_table
        lw      t7, 0x0024(v0)              // t7 = current action
        addiu   t7, t7, -Kirby.Action.GOEMON_NSP_Air_Begin
        sll     t7, t7, 0x0001              // t7 = table index for current action
        addu    t6, t6, t7                  // t6 = air_to_ground_table + index
        lhu      a1, 0x0000(t6)              // a1 = equivalent ground action for current air action
        lw      a2, 0x0078(a0)              // a2(starting frame) = current animation frame
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        lli     t6, 0x0802                  // ~
        jal     0x800E6F24                  // change action
        sw      t6, 0x0010(sp)              // argument 4 = 0x0802 (continue: 3C FGM, gfx routines)
        lw      ra, 0x001C(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0038              // deallocate stack space
    }

    ground_to_air_table:
    dh Uzi.Action.NSP_Air_Begin          // NSP_Ground_Begin
    dh Uzi.Action.NSP_Air_Wait           // NSP_Ground_Wait
    dh Uzi.Action.NSP_Air_Wait           // NSP_Ground_Walk1
    dh Uzi.Action.NSP_Air_Wait           // NSP_Ground_Walk2
    dh Uzi.Action.NSP_Air_Wait           // NSP_Ground_BWalk1
    dh Uzi.Action.NSP_Air_Wait           // NSP_Ground_BWalk2
    dh Uzi.Action.NSP_Air_End            // NSP_Ground_End
    OS.align(4)

    air_to_ground_table:
    dh Uzi.Action.NSP_Ground_Begin       // NSP_Air_Begin
    dh Uzi.Action.NSP_Ground_Wait        // NSP_Air_Wait
    dh Uzi.Action.NSP_Ground_End         // NSP_Air_End
    OS.align(4)

    cycle_length_table:
    float32 40                              // NSP_Ground_Wait
    float32 80                              // NSP_Ground_Walk1
    float32 60                              // NSP_Ground_Walk2
    float32 80                              // NSP_Ground_BWalk1
    float32 60                              // NSP_Ground_BWalk2

    kirby_ground_to_air_table:
    dh Kirby.Action.GOEMON_NSP_Air_Begin    // NSP_Ground_Begin
    dh Kirby.Action.GOEMON_NSP_Air_Wait     // NSP_Ground_Wait
    dh Kirby.Action.GOEMON_NSP_Air_Wait     // NSP_Ground_Walk1
    dh Kirby.Action.GOEMON_NSP_Air_Wait     // NSP_Ground_Walk2
    dh Kirby.Action.GOEMON_NSP_Air_Wait     // NSP_Ground_BWalk1
    dh Kirby.Action.GOEMON_NSP_Air_Wait     // NSP_Ground_BWalk2
    dh Kirby.Action.GOEMON_NSP_Air_End      // NSP_Ground_End
    OS.align(4)

    kirby_air_to_ground_table:
    dh Kirby.Action.GOEMON_NSP_Ground_Begin // NSP_Air_Begin
    dh Kirby.Action.GOEMON_NSP_Ground_Wait  // NSP_Air_Wait
    dh Kirby.Action.GOEMON_NSP_Ground_End   // NSP_Air_End
    OS.align(4)

    kirby_cycle_length_table:
    float32 40                              // NSP_Ground_Wait
    float32 80                              // NSP_Ground_Walk1
    float32 60                              // NSP_Ground_Walk2
    float32 80                              // NSP_Ground_BWalk1
    float32 60                              // NSP_Ground_BWalk2

    // @ Description
    // Subroutine which sets up the initial properties for the ryo.
    // @ Arguments
    // a0 - player object
    // a1 - starting x/y/z coordinates
    scope ryo_stage_setting_: {
        addiu   sp, sp, -0x0050             // allocate stack space
        sw      s0, 0x0018(sp)              // store s0
        sw      s1, 0x001C(sp)              // store s1
        sw      a0, 0x0030(sp)              // 0x0030(sp) = player object
        sw      a1, 0x0034(sp)              // 0x0034(sp) = starting coordinates
        li      s0, ryo_properties_struct   // s0 = projectile properties struct address
        li      s1, sparkle_effect_projectile_struct // s1 = sparkle_effect_projectile_struct
        lw      t6, 0x0084(a0)              // t6 = player struct
        lw      at, 0x0B1C(t6)              // at = charge flag
        beqz    at, _continue               // branch if charge flag = FALSE
        sw      ra, 0x0038(sp)              // store ra

        // if we're here the charge flag is set to TRUE, so use the fire ryo properties instead
        li      s0, fire_ryo_properties_struct // s0 = projectile properties struct address
        li      s1, fire_effect_projectile_struct // s1 = fire_effect_projectile_struct

        _continue:
        lw      a2, 0x0034(sp)              // a2 = starting coordinates
        lw      t1, 0x0028(s0)              // t1 = hitbox offset
        li      a1, ryo_projectile_struct   // a1 = main projectile struct address
        lui     a3, 0x8000                  // a3 = bit flag?
        sw      t6, 0x002C(sp)              // 0x002C(sp) = player struct
        jal     0x801655C8                  // create projectile
        sw      t1, 0x000C(a1)              // override hitbox offset

        beq     v0, r0, _end_stage_setting  // if 801655C8 returns 0, there's no space to create a new projectile object, so skip to end
        sw      v0, 0x0028(sp)              // 0x0028(sp) = projectile object

        jal     0x801655A0                  // get projectile instance id
        nop
        lw      t0, 0x0028(sp)              // ~
        lw      t0, 0x0084(t0)              // t0 = ryo projectile special struct
        sw      r0, 0x01B8(t0)              // 0x01B8 in ryo projectile special struct = null
        beq     s1, r0, _projectile_branch  // skip if no effect projectile struct
        sw      v0, 0x0264(t0)              // store instance id
        lw      a0, 0x0030(sp)              // a0 = player object
        or      a1, s1, r0                  // a1 = effect projectile special struct
        lw      a2, 0x0034(sp)              // a2 = starting coordinates
        jal     0x801655C8                  // create projectile
        or      a3, r0, r0                  // a3 = 0

        beq     v0, r0, _projectile_branch  // if 801655C8 returns 0, there's no space to create a new projectile object, so skip ahead
        lw      t0, 0x0084(v0)              // t0 = ryo projectile special struct

        _effect_projectile_branch:
        or      v1, v0, r0                  // v1 = effect projectile object
        lw      v0, 0x0028(sp)              // v0 = ryo projectile object
        lw      t0, 0x0084(v0)              // t0 = ryo projectile special struct
        lw      t1, 0x0084(v1)              // t1 = effect projectile special struct
        lw      at, 0x0264(t0)              // ~
        sw      at, 0x0264(t1)              // pass instance id to effect projectile
        sw      v1, 0x01B8(t0)              // 0x01B8 in ryo projectile special struct = effect projectile object
        sw      r0, 0x01B4(t1)              // effect destruction flag = FALSE
        sw      v0, 0x01B8(t1)              // 0x01B8 in effect projectile special struct = ryo projectile object

        _projectile_branch:
        li      t3, ryo_blast_zone_         // t3 = ryo_blast_zone_
        sw      t3, 0x0298(t0)              // store blast zone routine
        lw      t3, 0x0000(s0)              // t3 = duration
        sw      t3, 0x0268(t0)              // store duration
        lw      t4, 0x002C(sp)              // t4 = player struct
        lw      t5, 0x0B1C(t4)              // t5 = charge flag
        sw      t5, 0x01B4(t0)              // 0x01B4 in ryo projectile special struct = charge flag
        lw      t5, 0x014C(t4)              // t5 = kinetic state
        beq     t5, r0, _play_fgm           // branch if kinetic state = grounded
        lwc1    f12, 0x0018(s0)             // f12 = initial angle (ground)
        lwc1    f12, 0x001C(s0)             // f12 = initial angle (air)

        _play_fgm:
        lw      t5, 0x0B1C(t4)              // t5 = charge flag
        beqz    t5, _skip_fgm               // skip if charge flag != TRUE
        nop


        _skip_fgm:
        swc1    f12, 0x0020(sp)             // 0x0020(sp) = projectile angle
        lw      v0, 0x0028(sp)              // v0 = ryo projectile object
        lw      v1, 0x0084(v0)              // v1 = ryo projectile special struct
        jal     0x80035CD0                  // ~
        sw      v1, 0x0024(sp)              // original logic

        lwc1    f6, 0x0020(s0)              // f6 = initial projectile speed
        lw      t6, 0x002C(sp)              // ~
        lw      v1, 0x0024(sp)              // ~
        lw      t7, 0x0044(t6)              // ~
        mul.s   f8, f0, f6                  // ~
        lwc1    f12, 0x0020(sp)             // ~
        mtc1    t7, f10                     // ~
        nop                                 // ~
        cvt.s.w f16, f10                    // ~
        mul.s   f18, f8, f16                // ~
        jal     0x800303F0                  // ~
        swc1    f18, 0x0020(v1)             // original logic

        lwc1    f4, 0x0020(s0)              // f4 = initial projectile speed
        lw      v1, 0x0024(sp)              // ~
        lw      a0, 0x0028(sp)              // ~
        mul.s   f6, f0, f4                  // ~
        swc1    f6, 0x0024(v1)              // ~
        lw      t8, 0x0074(a0)              // ~
        lwc1    f10, 0x002C(s0)             // ~
        lw      t9, 0x0080(t8)              // ~
        jal     ryo_rotation_               // ~
        swc1    f10, 0x0088(t9)             // ~
        lw      v0, 0x0028(sp)              // original logic

        _end_stage_setting:
        lw      ra, 0x0038(sp)              // load ra
        lw      s0, 0x0018(sp)              // load s0
        lw      s1, 0x001C(sp)              // load s1
        jr      ra                          // return
        addiu   sp, sp, 0x0050              // deallocate stack space
    }

    // @ Description
    // Subroutine which sets initial rotation for the ryo.
    // @ Arguments
    // a0 - projectile object
    scope ryo_rotation_: {
        lw      v0, 0x0084(a0)              // v0 = projectile special struct
        lw      a1, 0x01B8(v0)              // a1 = effect projectile object
        li      t0, 0x3FC90FDB              // t0 = initial angle (1.5708 rads/90 degrees)
        lw      t1, 0x0020(v0)              // t1 = projectile velocity
        lui     at, 0x8000                  // ~
        and     t1, t1, at                  // t0 = bitmask for positive/negative velocity
        or      t1, t1, t0                  // t1 = initial angle corrected with velocity bitmask
        beqz    a1, _end                    // skip if no effect projectile
        lw      v0, 0x0074(a0)              // v0 = projectile part 0 struct

        lw      v1, 0x0074(a1)              // v1 = effect projectile part 0 struct
        sw      t1, 0x0034(v1)              // effect y rotation = 90 degrees | direction

        _end:
        sw      t1, 0x0030(v0)              // x rotation = 90 degrees | direction
        sw      r0, 0x0034(v0)              // y rotation = 0
        jr      ra
        sw      t0, 0x0038(v0)              // z rotation = 90 degrees
    }

    // @ Description
    // Main subroutine for the ryo.
    scope ryo_main_: {
        addiu   sp, sp,-0x0040              // allocate stack space
        sw      a0, 0x0020(sp)              // 0x0020(sp) = projectile object
        sw      s0, 0x0024(sp)              // store s0
        lw      a0, 0x0084(a0)              // a0 = projectile special struct
        li      s0, ryo_properties_struct   // s0 = projectile properties struct address
        lw      at, 0x01B4(a0)              // at = charge flag
        beqz    at, _check_duration         // branch if charge flag = FALSE
        sw      ra, 0x0014(sp)              // store ra

        // if we're here the charge flag is set to TRUE, so use the fire ryo properties instead
        li      s0, fire_ryo_properties_struct // s0 = projectile properties struct address

        _check_duration:
        jal     0x80167FE8                  // original logic, subroutine returns 1 if projectile duration is over
        sw      a0, 0x001C(sp)              // 0x001C(sp) = projectile special struct
        beq     v0, r0, _continue           // branch if projectile duration has not ended
        lw      a0, 0x001C(sp)              // a0 = projectile special struct

        _end_duration:
        lw      a1, 0x001C(sp)              // a1 = projectile special struct
        lw      t0, 0x01B8(a1)              // t0 = effect projectile object
        beqz    t0, _destroy                // branch if no effect projectile
        lli     at, OS.TRUE                 // at = TRUE
        lw      t0, 0x0084(t0)              // t0 = effect projectile special struct
        sw      at, 0x01B4(t0)              // signify to the effect projectile struct that its time in this world has come to an end

        _destroy:
        lw      t7, 0x0020(sp)              // t7 = projectile object
        lw      a0, 0x0074(t7)              // a0 = projectile part 0 struct
        lw      at, 0x01B4(a1)              // at = charge flag
        bnez    at, _explode                // branch if charge flag = TRUE
        addiu   a0, a0, 0x001C              // a0 = projectile x/y/z coords

        jal     0x800FF648                  // create smoke gfx
        lui     a1, 0x3F80                  // a1 = 1.0
        b       _end                        // branch to end
        lli     v0, OS.TRUE                 // return TRUE (destroys projectile)

        _explode:
        jal     0x80100480                  // create smoke gfx
        nop
        jal     0x800269C0                  // play FGM
        lli     a0, 0                       // FGM id = 0
        b       _end                        // branch to end
        lli     v0, OS.TRUE                 // return TRUE (destroys projectile)

        _continue:
        lw      a1, 0x000C(s0)              // a1 = gravity
        jal     0x80168088                  // apply gravity to ryo
        lw      a2, 0x0004(s0)              // a2 = max speed

        lw      a0, 0x001C(sp)              // a0 = projectile special struct
        lw      t1, 0x0020(sp)              // t1 = projectile object
        lw      v1, 0x0074(t1)              // v1 = projectile joint 0 struct
        lwc1    f6, 0x0014(s0)              // f6 = rotation speed
        lwc1    f4, 0x0034(v1)              // f4 = current rotation
        sub.s   f8, f4, f6                  // subtract rotation speed from current rotation
        swc1    f8, 0x0034(v1)              // update rotation
        lli     v0, OS.FALSE                // return FALSE (don't destroy)

        _end:
        lw      ra, 0x0014(sp)              // load ra
        lw      s0, 0x0024(sp)              // load s0
        jr      ra                          // return
        addiu   sp, sp, 0x0040              // deallocate stack space
    }

    // @ Description
    // Collision subroutine for the ryo.
    // Based on 0x801688C4, which is the equivalent for Charge Shot.
    scope ryo_collision_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x00014(sp)             // store ra

        jal     0x80167C04                  // general collision detection?
        sw      a0, 0x0018(sp)              // 0x0018(sp) = projectile object
        beqz    v0, _end                    // end if collision wasn't detected
        lw      a0, 0x0018(sp)              // a2 = projectile object
        // if collision was detected
        jal     ryo_destruction_
        nop

        _end:
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Main subroutine for effect projectile objects.
    scope effect_projectile_main_: {
        addiu   sp, sp,-0x0040              // allocate stack space
        sw      a0, 0x0020(sp)              // 0x0020(sp) = projectile object
        sw      ra, 0x0014(sp)              // store ra
        lw      v0, 0x0084(a0)              // v0 = effect projectile special struct
        lw      t0, 0x01B4(v0)              // t0 = destruction flag
        bnezl   t0, _end                    // end if destruction flag = TRUE...
        lli     v0, OS.TRUE                 // ...and return TRUE (destroys projectile)

        lw      t0, 0x01B8(v0)              // ~
        lw      t0, 0x0074(t0)              // t0 = ryo projectile joint 0 struct
        beqzl   t0, _end
        lli     v0, OS.TRUE                 // return TRUE (destroy)
        lw      t1, 0x0074(a0)              // t1 = effect projectile joint 0 struct
        lw      at, 0x001C(t0)              // ~
        sw      at, 0x001C(t1)              // copy projectile x to effect projectile
        lw      at, 0x0020(t0)              // ~
        sw      at, 0x0020(t1)              // copy projectile y to effect projectile
        lw      at, 0x0024(t0)              // ~
        sw      at, 0x0024(t1)              // copy projectile z to effect projectile
        lli     v0, OS.FALSE                // return FALSE (don't destroy)

        _end:
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0040              // deallocate stack space
    }

    // @ Description
    // This subroutine destroys the ryo and creates a smoke gfx.
    scope ryo_destruction_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        lw      v0, 0x0084(a0)              // v0 = projectile special struct
        lw      t0, 0x01B8(v0)              // t0 = effect projectile object
        beqz    t0, _end                    // skip if no effect projectile
        lli     at, OS.TRUE                 // at = TRUE
        lw      t0, 0x0084(t0)              // t0 = effect projectile special struct
        sw      at, 0x01B4(t0)              // signify to the effect projectile struct that its time in this world has come to an end
        lw      a0, 0x0074(a0)              // projectile part 0 struct
        lw      at, 0x01B4(v0)              // at = charge flag
        bnez    at, _explode                // branch if charge flag = TRUE
        addiu   a0, a0, 0x001C              // a0 = projectile x/y/z coords

        jal     0x800FF648                  // create smoke gfx
        lui     a1, 0x3F80                  // a1 = 1.0
        b       _end                        // branch to end
        lli     v0, OS.TRUE                 // return TRUE (destroys projectile)

        _explode:
        jal     0x80100480                  // create smoke gfx
        nop
        jal     0x800269C0                  // play FGM
        lli     a0, 0                       // FGM id = 0
        b       _end                        // branch to end
        lli     v0, OS.TRUE                 // return TRUE (destroys projectile)

        _end:
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0018              // deallocate stack space
        jr      ra                          // return
        lli     v0, OS.TRUE                 // return TRUE (destroys projectile)
    }

    // @ Description
    // This subroutine destroys the ryo when it crosses a blast zone.
    scope ryo_blast_zone_: {
        lw      v0, 0x0084(a0)              // v0 = projectile special struct
        lw      t0, 0x01B8(v0)              // t0 = effect projectile object
        beqz    t0, _end                    // skip if no effect projectile
        lli     at, OS.TRUE                 // at = TRUE
        lw      t0, 0x0084(t0)              // t0 = effect projectile special struct
        sw      at, 0x01B4(t0)              // signify to the effect projectile struct that its time in this world has come to an end

        _end:
        jr      ra                          // return
        lli     v0, OS.TRUE                 // return TRUE (destroys projectile)
    }

    // @ Description
    // This subroutine reflects the ryo and changes the rotation of the graphic on top
    scope ryo_reflect_: {
        OS.routine_begin(0x20)              // allocate stackspace

        jal     0x801692C4                  // reflect projectile routine
        sw      a0, 0x0018(sp)              // save a0

        jal     ryo_rotation_
        lw      a0, 0x0018(sp)              // load a0

        addiu   v0, r0, 0                   // return 0 (dont destroy)

        OS.routine_end(0x20)                // deallocate stackspace and return
    }

    // @ Description
    // This subroutine bounces the ryo off shields and changes the rotation of the graphic on top
    scope ryo_shield_bounce_: {
        OS.routine_begin(0x20)              // allocate stackspace

        jal     0x801686F8                  // bounce projectile routine
        sw      a0, 0x0018(sp)              // save a0

        jal     ryo_rotation_
        lw      a0, 0x0018(sp)              // load a0

        addiu   v0, r0, 0                   // return 0 (dont destroy)

        OS.routine_end(0x20)                // deallocate stackspace and return
    }

    OS.align(16)
    ryo_projectile_struct:
    constant RYO_ID(0x1004)
    dw 0x00000000                           // unknown
    dw RYO_ID                               // projectile id
    dw Character.UZI_file_6_ptr          // address of goemon's file 6 pointer
    dw 0                           // offset to hitbox
    dw 0x12450000                           // Render routine
    dw ryo_main_                            // This is the main subroutine for the projectile, handles duration and other things. (default 0x80168540) (samus 0x80168F98)
    dw ryo_collision_                       // This is the collision subroutine for the projectile, responsible for detecting collision with clipping.
    dw 0                     // This function runs when the projectile collides with a hurtbox.
    dw ryo_destruction_                     // This function runs when the projectile collides with a shield.
    dw ryo_shield_bounce_                   // This function runs when the projectile collides with edges of a shield and bounces off
    dw ryo_destruction_                     // This function runs when the projectile collides/clangs with a hitbox.
    dw ryo_reflect_                         // This function runs when the projectile collides with Fox's reflector (default 0x80168748)
    dw ryo_destruction_                     // This function runs when the projectile collides with Ness's psi magnet
    OS.copy_segment(0x103904, 0x0C)         // empty

    fire_effect_projectile_struct:
    dw 0x00000000                           // unknown
    dw RYO_ID                               // projectile id
    dw Character.UZI_file_6_ptr          // address of goemon's file 6 pointer
    dw 0x000000C0                           // offset to hitbox
    dw 0x12480000                           // Render routine
    dw effect_projectile_main_              // This is the main subroutine for the projectile, handles duration and other things. (default 0x80168540) (samus 0x80168F98)
    dw 0                                    // This function runs when the projectile collides with clipping. (0x801685F0 - Mario) (0x80169108 - Samus)
    dw 0                                    // This function runs when the projectile collides with a hurtbox.
    dw 0                                    // This function runs when the projectile collides with a shield.
    dw 0                                    // This function runs when the projectile collides with edges of a shield and bounces off
    dw 0                                    // This function runs when the projectile collides/clangs with a hitbox.
    dw 0                                    // This function runs when the projectile collides with Fox's reflector (default 0x80168748)
    dw 0                                    // This function runs when the projectile collides with Ness's psi magnet
    OS.copy_segment(0x103904, 0x0C)         // empty

    sparkle_effect_projectile_struct:
    dw 0x00000000                           // unknown
    dw RYO_ID                               // projectile id
    dw Character.UZI_file_6_ptr          // address of goemon's file 6 pointer
    dw 0x000000C0                           // offset to hitbox
    dw 0x12480000                           // Render routine
    dw effect_projectile_main_              // This is the main subroutine for the projectile, handles duration and other things. (default 0x80168540) (samus 0x80168F98)
    dw 0                                    // This function runs when the projectile collides with clipping. (0x801685F0 - Mario) (0x80169108 - Samus)
    dw 0                                    // This function runs when the projectile collides with a hurtbox.
    dw 0                                    // This function runs when the projectile collides with a shield.
    dw 0                                    // This function runs when the projectile collides with edges of a shield and bounces off
    dw 0                                    // This function runs when the projectile collides/clangs with a hitbox.
    dw 0                                    // This function runs when the projectile collides with Fox's reflector (default 0x80168748)
    dw 0                                    // This function runs when the projectile collides with Ness's psi magnet
    OS.copy_segment(0x103904, 0x0C)         // empty

    OS.align(16)
    ryo_properties_struct:
    dw 40                                   // 0x0000 - duration (int)
    float32 100                             // 0x0004 - max speed
    float32 0                               // 0x0008 - min speed
    float32 0                               // 0x000C - gravity
    float32 0                               // 0x0010 - bounce multiplier
    float32 0.3                             // 0x0014 - rotation speed
    float32 0                               // 0x0018 - initial angle (ground)
    float32 0                               // 0x001C   initial angle (air)
    float32 100                             // 0x0020   initial speed
    dw Character.UZI_file_6_ptr          // 0x0024   projectile data pointer
    dw 0x00000000                           // 0x0028   offset to hitbox
    float32 1                           // 0x002C   palette index (0 = mario, 1 = luigi)

    OS.align(16)
    fire_ryo_properties_struct:
    dw 60                                   // 0x0000 - duration (int)
    float32 130                             // 0x0004 - max speed
    float32 0                               // 0x0008 - min speed
    float32 0                               // 0x000C - gravity
    float32 0                               // 0x0010 - bounce multiplier
    float32 0.5                             // 0x0014 - rotation speed
    float32 0                               // 0x0018 - initial angle (ground)
    float32 0                               // 0x001C   initial angle (air)
    float32 130                             // 0x0020   initial speed
    dw Character.UZI_file_6_ptr          // 0x0024   projectile data pointer
    dw 0x00000040                           // 0x0028   offset to hitbox
    float32 1                           // 0x002C   palette index (0 = mario, 1 = luigi)



    scope ground_initial_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // store a0, ra

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.LANKY_NSP_Ground
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.LANKY_NSP_Ground

        lli     a1, Uzi.Action.NSPG       // a1(action id) = NSPG
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      a0, 0x0020(sp)              // ~
        lw      a0, 0x0084(a0)              // ~
        sw      r0, 0x017C(a0)              // temp variable 1 = 0
        sw      r0, 0x0180(a0)              // temp variable 2 = 0
        sw      r0, 0x0184(a0)              // temp variable 3 = 0
        lli     at, 3                       // ~
        sw      at, 0x0B20(a0)              // ammo = 3
        lw      ra, 0x001C(sp)              // load ra
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Subroutine which runs when Lanky initiates an aerial neutral special.
    scope air_initial_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // store a0, ra

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.LANKY_NSP_Air
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.LANKY_NSP_Air

        lli     a1, Uzi.Action.NSPA       // a1(action id) = NSPA
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      a0, 0x0020(sp)              // ~
        lw      a0, 0x0084(a0)              // ~
        sw      r0, 0x017C(a0)              // temp variable 1 = 0
        sw      r0, 0x0180(a0)              // temp variable 2 = 0
        sw      r0, 0x0184(a0)              // temp variable 3 = 0
        lli     at, 3                       // ~
        sw      at, 0x0B20(a0)              // ammo = 3
        lw      ra, 0x001C(sp)              // load ra
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Main subroutine for neutral special.
    // If temp variable 1 is set by moveset, create a projectile.
    scope main_: {
        addiu   sp, sp,-0x0040              // allocate stack space
        sw      ra, 0x0014(sp)              // 0x0014(sp) = ra
        sw      a0, 0x0034(sp)              // 0x0034(sp) = player object
        addu    a2, a0, r0                  // a2 = player object
        lw      v0, 0x0084(a0)              // v0 = player struct
        lw      t6, 0x017C(v0)              // t6 = temp variable 1
        beq     t6, r0, _cancel_check       // skip if temp variable 1 = 0
        sw      r0, 0x017C(v0)              // reset temp variable 1 to 0

        // if we're here, then temp variable 1 was enabled, so create a projectile
        lw      t6, 0x0008(v0)              // t6 = current character ID
        lli     at, Kirby.Action.LANKY_NSP_Ground - Uzi.Action.NSPG
        // if kinetic state = aerial
        lli     at, Kirby.Action.LANKY_NSP_Air - Uzi.Action.NSPA
        lw      a2, 0x0008(v0)              // a2 = current character ID
        lli     t6, Character.id.KIRBY      // t6 = id.KIRBY
        beq     t6, a2, _kirby              // branch if Kirby
        lli     t6, Character.id.JKIRBY     // t6 = id.JKIRBY
        beq     t6, a2, _kirby              // branch if JKirby
        lw      a0, 0x0930(v0)              // a0 = part 0xE (weapon) struct
        sw      r0, 0x0020(sp)              // x offset = 0
        lui     at, 0xC348                  // ~
        sw      at, 0x0024(sp)              // y offset = -200
        b       _continue
        sw      r0, 0x0028(sp)              // z offset = 0

        _kirby:
        lw      a0, 0x092C(v0)              // a0 = part 0xD (weapon) struct
        lui     at, 0x4396                  // ~
        sw      at, 0x0020(sp)              // x offset = 200
        sw      r0, 0x0024(sp)              // y offset = 0
        sw      r0, 0x0028(sp)              // z offset = 0

        _continue:
        addiu   a1, sp, 0x0020              // a1 = address to return x/y/z coordinates to
        jal     0x800EDF24                  // returns x/y/z coordinates of the part in a0 to a1
        sw      v0, 0x002C(sp)              // 0x002C(sp) = player struct
        sw      r0, 0x0028(sp)              // set z coordinate to 0
        lw      v0, 0x002C(sp)              // v0 = player struct
        lw      a0, 0x0034(sp)              // a0 = player object
        jal     grape_stage_setting_        // INITIATE GRAPE
        addiu   a1, sp, 0x0020              // a1 = coordinates to create projectile at
        lw      a0, 0x0034(sp)              // a0 = player object
        lw      v0, 0x0084(a0)              // v0 = player struct

        _cancel_check:
        lw      t6, 0x0180(v0)              // t6 = temp variable 2
        beq     t6, r0, _idle_check         // skip if temp variable 2 = 0
        lhu     t7, 0x01BE(v0)              // t7 = buttons_pressed



        // if B was pressed
        lw      t0, 0x0B20(v0)              // t0 = ammo
        addiu   at, t0,-0x0001              // at = ammo - 1
        sw      at, 0x0B20(v0)              // store updated ammo...
        beqzl   t0, _idle_check             // skip if ammo = 0
        sw      r0, 0x0B20(v0)              // and set ammo to 0
        lw      a2, 0x014C(v0)              // a2 = kinetic state
        beqz    a2, pc() + 12               // branch if kinetic state = grounded
        // if kinetic state = grounded
        lli     a1, Uzi.Action.NSPG
        // if kinetic state = aerial
        lli     a1, Uzi.Action.NSPA
        beqz    a2, pc() + 12               // branch if kinetic state = grounded
        // if kinetic state = grounded
        lli     at, Kirby.Action.LANKY_NSP_Ground - Uzi.Action.NSPG
        // if kinetic state = aerial
        lli     at, Kirby.Action.LANKY_NSP_Air - Uzi.Action.NSPA
        lw      a2, 0x0008(v0)              // a2 = current character ID
        lli     t6, Character.id.KIRBY      // t6 = id.KIRBY
        beql    t6, a2, pc() + 20           // if Kirby, adjust action ID
        addu    a1, a1, at
        lli     t6, Character.id.JKIRBY     // t6 = id.JKIRBY
        beql    t6, a2, pc() + 8            // if J Kirby, adjust action ID
        addu    a1, a1, at
        lw      a0, 0x0034(sp)              // a0 = player object
        lui     a2, 0x4160                  // a2(starting frame) = 14
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0034(sp)              // a0 = player object

        lw      a0, 0x0034(sp)              // a0 = player object
        lw      v0, 0x0084(a0)              // v0 = player struct
        sw      r0, 0x0180(v0)              // reset temp variable 2

        _idle_check:
        // checks the current animation frame to see if we've reached end of the animation
        mtc1    r0, f6                      // ~
        lwc1    f8, 0x0078(a0)              // ~
        c.le.s  f8, f6                      // ~
        nop
        bc1fl   _end                        // skip if animation end has not been reached
        nop
        jal     0x800DEE54                  // transition to idle
        nop

        _end:
        lw      ra, 0x0014(sp)              // load ra
        jr      ra
        addiu   sp, sp, 0x0040              // deallocate stack space
    }


    // @ Description
    // Subroutine which sets up the initial properties for the projectile.
    // TODO: this is still largely uncommented, and may contain leftover logic that isn't needed.
    scope grape_stage_setting_: {
        constant MAX_POWER(5)
        addiu   sp, sp, -0x0050
        sw      s0, 0x0018(sp)
        li      s0, grape_properties_struct // s0 = projectile properties struct address
        sw      a1, 0x0034(sp)
        sw      ra, 0x001C(sp)
        lw      t6, 0x0084(a0)
        lw      t0, 0x0024(s0)
        lw      t1, 0x0028(s0)
        li      a1, grape_projectile_struct // a1 = main projectile struct address
        lw      a2, 0x0034(sp)
        lui     a3, 0x8000
        sw      t6, 0x002C(sp)              // 0x002C(sp) = player struct
        jal     0x801655C8                  // This is a generic routine that does much of the work for defining all projectiles
        sw      t1, 0x000C(a1)

        beq     v0, r0, _end_stage_setting  // if 801655C8 returns 0, there's no space to create a new projectile object, so skip to end
        nop

        _projectile_branch:
        sw      v0, 0x0028(sp)              // 0x0028(sp) = projectile object
        lw      v1, 0x0084(v0)              // v1 = projectile struct
        lw      t3, 0x0000(s0)              // t3 = duration
        sw      t3, 0x0268(v1)              // store duration
        lw      t4, 0x002C(sp)              // t4 = player struct
        lw      t5, 0x014C(t4)              // t5 = kinetic state
        beq     t5, r0, _continue           // branch if kinetic state = grounded
        lwc1    f12, 0x0018(s0)             // f12 = initial angle (ground)
        lwc1    f12, 0x001C(s0)             // f12 = initial angle (air)

        _continue:
        mtc1    r0, f4                      // f4 = 0
        swc1    f4, 0x0028(v1)              // set z speed? to 0
        swc1    f12, 0x0020(sp)             // 0x0020(sp) = adjusted angle
        jal     0x80035CD0                  // ~
        sw      v1, 0x0024(sp)              // original logic

        lwc1    f6, 0x0020(s0)              // f6 = initial projectile speed
        lw      t6, 0x002C(sp)              // ~
        lw      v1, 0x0024(sp)              // ~
        lw      t7, 0x0044(t6)              // ~
        mul.s   f8, f0, f6                  // ~
        lwc1    f12, 0x0020(sp)             // ~
        mtc1    t7, f10                     // ~
        nop                                 // ~
        cvt.s.w f16, f10                    // ~
        mul.s   f18, f8, f16                // ~
        jal     0x800303F0                  // ~
        swc1    f18, 0x0020(v1)             // original logic

        lwc1    f4, 0x0020(s0)              // f4 = initial projectile speed
        lw      v1, 0x0024(sp)              // ~
        lw      a0, 0x0028(sp)              // ~
        mul.s   f6, f0, f4                  // ~
        swc1    f6, 0x0024(v1)              // ~
        lw      t8, 0x0074(a0)              // ~
        lwc1    f10, 0x002C(s0)             // ~
        lw      t9, 0x0080(t8)              // ~
        jal     0x80167FA0                  // ~
        swc1    f10, 0x0088(t9)             // ~
        lw      v0, 0x0028(sp)              // original logic

        _end_stage_setting:
        lw      ra, 0x001C(sp)
        lw      s0, 0x0018(sp)
        addiu   sp, sp, 0x0050
        jr      ra
        nop
    }

    // @ Description
    // Main subroutine for the grape.
    scope grape_main_: {
        addiu   sp, sp, 0xFFE0              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        sw      a0, 0x0020(sp)              // 0x0020(sp) = projectile object
        lw      a0, 0x0084(a0)              // a0 = projectile struct
        jal     0x80167FE8                  // original logic, subroutine returns 1 if projectile duration is over
        sw      a0, 0x001C(sp)              // 0x001C(sp) = projectile struct
        beq     v0, r0, _continue           // branch if projectile duration has not ended
        lw      a0, 0x001C(sp)              // a0 = projectile struct

        _end_duration:
        lw      t7, 0x0020(sp)              // t7 = projectile object
        lw      a0, 0x0074(t7)              // ~
        addiu   a0, a0, 0x001C              // a0 = projectile x/y/z coords
        jal     0x800FF648                  // create smoke gfx
        lui     a1, 0x3F80                  // a1 = 1.0
        b       _end                        // branch to end
        lli     v0, OS.TRUE                 // return TRUE (destroys projectile)

        _continue:
        li      v0, grape_properties_struct // v0 = grape_properties_struct
        lw      a1, 0x000C(v0)              // a1 = gravity
        jal     0x80168088                  // apply gravity to grape
        lw      a2, 0x0004(v0)              // a2 = max speed
        lw      a0, 0x001C(sp)              // a0 = projectile struct
        lw      t1, 0x0020(sp)              // t1 = projectile object
        lw      v1, 0x0074(t1)              // v1 = projectile struct with coordinates/rotation etc (bone struct?)
        li      at, grape_properties_struct // at = grape properties struct
        lwc1    f6, 0x0014(at)              // f6 = rotation speed
        lwc1    f4, 0x0030(v1)              // f4 = current rotation
        add.s   f8, f4, f6                  // add rotation speed to current rotation
        swc1    f8, 0x0030(v1)              // update rotation
        lli     v0, OS.FALSE                // return FALSE (don't destroy)

        _end:
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Collision subroutine for the grape.
    // Based on 0x801688C4, which is the equivalent for Charge Shot.
    scope grape_collision_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x00014(sp)             // store ra

        jal     0x80167C04                  // general collision detection?
        sw      a0, 0x0018(sp)              // 0x0018(sp) = projectile object
        beqz    v0, _end                    // end if collision wasn't detected
        lw      a0, 0x0018(sp)              // a2 = projectile object
        // if collision was detected
        jal     grape_destruction_
        nop

        _end:
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // This subroutine spawns a hit effect and destroys the GRAPE
    scope grape_hit_: {
        addiu   sp, sp,-0x0028              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        sw      a0, 0x0018(sp)              // 0x0018(sp) = projectile object
        lw      v1, 0x0084(a0)              // v1 = projectile struct
        lw      a0, 0x0074(a0)              // ~
        addiu   a0, a0, 0x001C              // a0 = x/y/z coordinates
        or      a1, r0, r0                  // a1 = 0
        lw      a2, 0x0234(v1)              // a2 = damage
        jal     0x800FDC04                  // create "normal hit" gfx
        or      a3, r0, r0                  // a3 = 0
        jal     grape_destruction_          // destroy the grape
        lw      a0, 0x0018(sp)              // a0 = projectile obect
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0028              // deallocate stack space
    }

    // @ Description
    // This subroutine destroys the grape and creates a smoke gfx.
    scope grape_destruction_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        lw      a0, 0x0074(a0)              // ~
        addiu   a0, a0, 0x001C              // a0 = projectile x/y/z coords
        jal     0x800FF648                  // create smoke gfx
        lui     a1, 0x3F80                  // a1 = 1.0
        jal     0x800269C0                  // play FGM
        lli     a0, 18                    // FGM id = 1521
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0018              // deallocate stack space
        jr      ra                          // return
        lli     v0, OS.TRUE                 // return TRUE (destroys projectile)
    }

    OS.align(16)
    grape_projectile_struct:
    constant NUT_ID(0x1001)
    dw 0x00000000                           // unknown
    dw NUT_ID                               // projectile id
    dw Character.UZI_file_6_ptr           // address of conker's file 6 pointer
    dw 0x00000000                           // offset to hitbox
    dw 0x12470000                           // This determines z axis rotation? (samus is 1246)
    dw grape_main_                          // This is the main subroutine for the projectile, handles duration and other things. (default 0x80168540) (samus 0x80168F98)
    dw grape_collision_                     // This is the collision subroutine for the projectile, responsible for detecting collision with clipping.
    dw 0                           // This function runs when the projectile collides with a hurtbox.
    dw grape_destruction_                   // This function runs when the projectile collides with a shield.
    dw 0x801686F8                           // This function runs when the projectile collides with edges of a shield and bounces off
    dw grape_destruction_                   // This function runs when the projectile collides/clangs with a hitbox.
    dw 0x801692C4                           // This function runs when the projectile collides with Fox's reflector (default 0x80168748)
    dw grape_destruction_                   // This function runs when the projectile collides with Ness's psi magnet
    OS.copy_segment(0x103904, 0x0C)         // empty

    OS.align(16)
    grape_properties_struct:
    dw 300                                   // 0x0000 - duration (int)
    float32 500                              // 0x0004 - max speed
    float32 50                               // 0x0008 - min speed
    float32 0.5                               // 0x000C - gravity
    float32 0                               // 0x0010 - bounce multiplier
    float32 0.1                           // 0x0014 - rotation speed
    float32 0.5                               // 0x0018 - initial angle (ground)
    float32 0.5                               // 0x001C   initial angle (air)
    float32 50                              // 0x0020   initial speed
    dw Character.UZI_file_6_ptr           // 0x0024   projectile data pointer
    dw 0x00000000                           // 0x0028   unknown (default 0)
    float32 1                           // 0x002C   palette index (0 = mario, 1 = luigi)



    scope ground_initial2_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // store a0, ra

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.LANKY_NSP_Ground
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.LANKY_NSP_Ground

        lli     a1, Uzi.Action.NSPG2       // a1(action id) = NSPG
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      a0, 0x0020(sp)              // ~
        lw      a0, 0x0084(a0)              // ~
        sw      r0, 0x017C(a0)              // temp variable 1 = 0
        sw      r0, 0x0180(a0)              // temp variable 2 = 0
        sw      r0, 0x0184(a0)              // temp variable 3 = 0
        lli     at, 3                       // ~
        sw      at, 0x0B20(a0)              // ammo = 3
        lw      ra, 0x001C(sp)              // load ra
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Subroutine which runs when Lanky initiates an aerial neutral special.
    scope air_initial2_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // store a0, ra

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.LANKY_NSP_Air
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.LANKY_NSP_Air

        lli     a1, Uzi.Action.NSPA2       // a1(action id) = NSPA
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      a0, 0x0020(sp)              // ~
        lw      a0, 0x0084(a0)              // ~
        sw      r0, 0x017C(a0)              // temp variable 1 = 0
        sw      r0, 0x0180(a0)              // temp variable 2 = 0
        sw      r0, 0x0184(a0)              // temp variable 3 = 0
        lli     at, 3                       // ~
        sw      at, 0x0B20(a0)              // ammo = 3
        lw      ra, 0x001C(sp)              // load ra
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Main subroutine for neutral special.
    // If temp variable 1 is set by moveset, create a projectile.
    scope main2_: {
        addiu   sp, sp,-0x0040              // allocate stack space
        sw      ra, 0x0014(sp)              // 0x0014(sp) = ra
        sw      a0, 0x0034(sp)              // 0x0034(sp) = player object
        addu    a2, a0, r0                  // a2 = player object
        lw      v0, 0x0084(a0)              // v0 = player struct
        lw      t6, 0x017C(v0)              // t6 = temp variable 1
        beq     t6, r0, _cancel_check2       // skip if temp variable 1 = 0
        sw      r0, 0x017C(v0)              // reset temp variable 1 to 0

        // if we're here, then temp variable 1 was enabled, so create a projectile
        lw      t6, 0x0008(v0)              // t6 = current character ID
        lli     at, Kirby.Action.LANKY_NSP_Ground - Uzi.Action.NSPG2
        // if kinetic state = aerial
        lli     at, Kirby.Action.LANKY_NSP_Air - Uzi.Action.NSPA2
        lw      a2, 0x0008(v0)              // a2 = current character ID
        lli     t6, Character.id.KIRBY      // t6 = id.KIRBY
        beq     t6, a2, _kirby2              // branch if Kirby
        lli     t6, Character.id.JKIRBY     // t6 = id.JKIRBY
        beq     t6, a2, _kirby2              // branch if JKirby
        lw      a0, 0x0930(v0)              // a0 = part 0xE (weapon) struct
        sw      r0, 0x0020(sp)              // x offset = 0
        lui     at, 0xC348                  // ~
        sw      at, 0x0024(sp)              // y offset = -200
        b       _continue2
        sw      r0, 0x0028(sp)              // z offset = 0

        _kirby2:
        lw      a0, 0x092C(v0)              // a0 = part 0xD (weapon) struct
        lui     at, 0x4396                  // ~
        sw      at, 0x0020(sp)              // x offset = 200
        sw      r0, 0x0024(sp)              // y offset = 0
        sw      r0, 0x0028(sp)              // z offset = 0

        _continue2:
        addiu   a1, sp, 0x0020              // a1 = address to return x/y/z coordinates to
        jal     0x800EDF24                  // returns x/y/z coordinates of the part in a0 to a1
        sw      v0, 0x002C(sp)              // 0x002C(sp) = player struct
        sw      r0, 0x0028(sp)              // set z coordinate to 0
        lw      v0, 0x002C(sp)              // v0 = player struct
        lw      a0, 0x0034(sp)              // a0 = player object
        jal     grape_stage_setting2_        // INITIATE GRAPE
        addiu   a1, sp, 0x0020              // a1 = coordinates to create projectile at
        lw      a0, 0x0034(sp)              // a0 = player object
        lw      v0, 0x0084(a0)              // v0 = player struct

        _cancel_check2:
        lw      t6, 0x0180(v0)              // t6 = temp variable 2
        beq     t6, r0, _idle_check2         // skip if temp variable 2 = 0
        lhu     t7, 0x01BE(v0)              // t7 = buttons_pressed



        // if B was pressed
        lw      t0, 0x0B20(v0)              // t0 = ammo
        addiu   at, t0,-0x0001              // at = ammo - 1
        sw      at, 0x0B20(v0)              // store updated ammo...
        beqzl   t0, _idle_check2             // skip if ammo = 0
        sw      r0, 0x0B20(v0)              // and set ammo to 0
        lw      a2, 0x014C(v0)              // a2 = kinetic state
        beqz    a2, pc() + 12               // branch if kinetic state = grounded
        // if kinetic state = grounded
        lli     a1, Uzi.Action.NSPG2
        // if kinetic state = aerial
        lli     a1, Uzi.Action.NSPA2
        beqz    a2, pc() + 12               // branch if kinetic state = grounded
        // if kinetic state = grounded
        lli     at, Kirby.Action.LANKY_NSP_Ground - Uzi.Action.NSPG2
        // if kinetic state = aerial
        lli     at, Kirby.Action.LANKY_NSP_Air - Uzi.Action.NSPA2
        lw      a2, 0x0008(v0)              // a2 = current character ID
        lli     t6, Character.id.KIRBY      // t6 = id.KIRBY
        beql    t6, a2, pc() + 20           // if Kirby, adjust action ID
        addu    a1, a1, at
        lli     t6, Character.id.JKIRBY     // t6 = id.JKIRBY
        beql    t6, a2, pc() + 8            // if J Kirby, adjust action ID
        addu    a1, a1, at
        lw      a0, 0x0034(sp)              // a0 = player object
        lui     a2, 0x4160                  // a2(starting frame) = 14
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0034(sp)              // a0 = player object

        lw      a0, 0x0034(sp)              // a0 = player object
        lw      v0, 0x0084(a0)              // v0 = player struct
        sw      r0, 0x0180(v0)              // reset temp variable 2

        _idle_check2:
        // checks the current animation frame to see if we've reached end of the animation
        mtc1    r0, f6                      // ~
        lwc1    f8, 0x0078(a0)              // ~
        c.le.s  f8, f6                      // ~
        nop
        bc1fl   _end2                        // skip if animation end has not been reached
        nop
        jal     0x800DEE54                  // transition to idle
        nop

        _end2:
        lw      ra, 0x0014(sp)              // load ra
        jr      ra
        addiu   sp, sp, 0x0040              // deallocate stack space
    }


    // @ Description
    // Subroutine which sets up the initial properties for the projectile.
    // TODO: this is still largely uncommented, and may contain leftover logic that isn't needed.
    scope grape_stage_setting2_: {
        constant MAX_POWER(7)
        addiu   sp, sp, -0x0050
        sw      s0, 0x0018(sp)
        li      s0, grape_properties_struct2 // s0 = projectile properties struct address
        sw      a1, 0x0034(sp)
        sw      ra, 0x001C(sp)
        lw      t6, 0x0084(a0)
        lw      t0, 0x0024(s0)
        lw      t1, 0x0028(s0)
        li      a1, grape_projectile_struct2 // a1 = main projectile struct address
        lw      a2, 0x0034(sp)
        lui     a3, 0x8000
        sw      t6, 0x002C(sp)              // 0x002C(sp) = player struct
        jal     0x801655C8                  // This is a generic routine that does much of the work for defining all projectiles
        sw      t1, 0x000C(a1)

        beq     v0, r0, _end_stage_setting2  // if 801655C8 returns 0, there's no space to create a new projectile object, so skip to end
        nop

        _projectile_branch2:
        sw      v0, 0x0028(sp)              // 0x0028(sp) = projectile object
        lw      v1, 0x0084(v0)              // v1 = projectile struct
        lw      t3, 0x0000(s0)              // t3 = duration
        sw      t3, 0x0268(v1)              // store duration
        lw      t4, 0x002C(sp)              // t4 = player struct
        lw      t5, 0x014C(t4)              // t5 = kinetic state
        beq     t5, r0, _continue2           // branch if kinetic state = grounded
        lwc1    f12, 0x0018(s0)             // f12 = initial angle (ground)
        lwc1    f12, 0x001C(s0)             // f12 = initial angle (air)

        _continue2:
        mtc1    r0, f4                      // f4 = 0
        swc1    f4, 0x0028(v1)              // set z speed? to 0
        swc1    f12, 0x0020(sp)             // 0x0020(sp) = adjusted angle
        jal     0x80035CD0                  // ~
        sw      v1, 0x0024(sp)              // original logic

        lwc1    f6, 0x0020(s0)              // f6 = initial projectile speed
        lw      t6, 0x002C(sp)              // ~
        lw      v1, 0x0024(sp)              // ~
        lw      t7, 0x0044(t6)              // ~
        mul.s   f8, f0, f6                  // ~
        lwc1    f12, 0x0020(sp)             // ~
        mtc1    t7, f10                     // ~
        nop                                 // ~
        cvt.s.w f16, f10                    // ~
        mul.s   f18, f8, f16                // ~
        jal     0x800303F0                  // ~
        swc1    f18, 0x0020(v1)             // original logic

        lwc1    f4, 0x0020(s0)              // f4 = initial projectile speed
        lw      v1, 0x0024(sp)              // ~
        lw      a0, 0x0028(sp)              // ~
        mul.s   f6, f0, f4                  // ~
        swc1    f6, 0x0024(v1)              // ~
        lw      t8, 0x0074(a0)              // ~
        lwc1    f10, 0x002C(s0)             // ~
        lw      t9, 0x0080(t8)              // ~
        jal     0x80167FA0                  // ~
        swc1    f10, 0x0088(t9)             // ~
        lw      v0, 0x0028(sp)              // original logic

        _end_stage_setting2:
        lw      ra, 0x001C(sp)
        lw      s0, 0x0018(sp)
        addiu   sp, sp, 0x0050
        jr      ra
        nop
    }

    // @ Description
    // Main subroutine for the grape.
    scope grape_main2_: {
        addiu   sp, sp, 0xFFE0              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        sw      a0, 0x0020(sp)              // 0x0020(sp) = projectile object
        lw      a0, 0x0084(a0)              // a0 = projectile struct
        jal     0x80167FE8                  // original logic, subroutine returns 1 if projectile duration is over
        sw      a0, 0x001C(sp)              // 0x001C(sp) = projectile struct
        beq     v0, r0, _continue2           // branch if projectile duration has not ended
        lw      a0, 0x001C(sp)              // a0 = projectile struct

        _end_duration2:
        lw      t7, 0x0020(sp)              // t7 = projectile object
        lw      a0, 0x0074(t7)              // ~
        addiu   a0, a0, 0x001C              // a0 = projectile x/y/z coords
        jal     0x800FF648                  // create smoke gfx
        lui     a1, 0x3F80                  // a1 = 1.0
        b       _end2                        // branch to end
        lli     v0, OS.TRUE                 // return TRUE (destroys projectile)

        _continue2:
        li      v0, grape_properties_struct2 // v0 = grape_properties_struct
        lw      a1, 0x000C(v0)              // a1 = gravity
        jal     0x80168088                  // apply gravity to grape
        lw      a2, 0x0004(v0)              // a2 = max speed
        lw      a0, 0x001C(sp)              // a0 = projectile struct
        lw      t1, 0x0020(sp)              // t1 = projectile object
        lw      v1, 0x0074(t1)              // v1 = projectile struct with coordinates/rotation etc (bone struct?)
        li      at, grape_properties_struct2 // at = grape properties struct
        lwc1    f6, 0x0014(at)              // f6 = rotation speed
        lwc1    f4, 0x0030(v1)              // f4 = current rotation
        add.s   f8, f4, f6                  // add rotation speed to current rotation
        swc1    f8, 0x0030(v1)              // update rotation
        lli     v0, OS.FALSE                // return FALSE (don't destroy)

        _end2:
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Collision subroutine for the grape.
    // Based on 0x801688C4, which is the equivalent for Charge Shot.
    scope grape_collision2_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x00014(sp)             // store ra

        jal     0x80167C04                  // general collision detection?
        sw      a0, 0x0018(sp)              // 0x0018(sp) = projectile object
        beqz    v0, _end2                    // end if collision wasn't detected
        lw      a0, 0x0018(sp)              // a2 = projectile object
        // if collision was detected
        jal     grape_destruction2_
        nop

        _end2:
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // This subroutine spawns a hit effect and destroys the GRAPE
    scope grape_hit2_: {
        addiu   sp, sp,-0x0028              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        sw      a0, 0x0018(sp)              // 0x0018(sp) = projectile object
        lw      v1, 0x0084(a0)              // v1 = projectile struct
        lw      a0, 0x0074(a0)              // ~
        addiu   a0, a0, 0x001C              // a0 = x/y/z coordinates
        or      a1, r0, r0                  // a1 = 0
        lw      a2, 0x0234(v1)              // a2 = damage
        jal     0x800FDC04                  // create "normal hit" gfx
        or      a3, r0, r0                  // a3 = 0
        jal     grape_destruction2_          // destroy the grape
        lw      a0, 0x0018(sp)              // a0 = projectile obect
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0028              // deallocate stack space
    }

    // @ Description
    // This subroutine destroys the grape and creates a smoke gfx.
    scope grape_destruction2_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        lw      a0, 0x0074(a0)              // ~
        addiu   a0, a0, 0x001C              // a0 = projectile x/y/z coords
        jal     0x800FF648                  // create smoke gfx
        lui     a1, 0x3F80                  // a1 = 1.0
        jal     0x800269C0                  // play FGM
        lli     a0, 18                    // FGM id = 1521
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0018              // deallocate stack space
        jr      ra                          // return
        lli     v0, OS.TRUE                 // return TRUE (destroys projectile)
    }

    OS.align(16)
    grape_projectile_struct2:
    constant NUT_ID2(0x1001)
    dw 0x00000000                           // unknown
    dw NUT_ID2                               // projectile id
    dw Character.UZI_file_6_ptr           // address of conker's file 6 pointer
    dw 0x00000000                           // offset to hitbox
    dw 0x12470000                           // This determines z axis rotation? (samus is 1246)
    dw grape_main2_                          // This is the main subroutine for the projectile, handles duration and other things. (default 0x80168540) (samus 0x80168F98)
    dw grape_collision2_                     // This is the collision subroutine for the projectile, responsible for detecting collision with clipping.
    dw 0                           // This function runs when the projectile collides with a hurtbox.
    dw grape_destruction2_                   // This function runs when the projectile collides with a shield.
    dw 0x801686F8                           // This function runs when the projectile collides with edges of a shield and bounces off
    dw grape_destruction2_                   // This function runs when the projectile collides/clangs with a hitbox.
    dw 0x801692C4                           // This function runs when the projectile collides with Fox's reflector (default 0x80168748)
    dw grape_destruction2_                   // This function runs when the projectile collides with Ness's psi magnet
    OS.copy_segment(0x103904, 0x0C)         // empty

    OS.align(16)
    grape_properties_struct2:
    dw 300                                   // 0x0000 - duration (int)
    float32 500                              // 0x0004 - max speed
    float32 50                               // 0x0008 - min speed
    float32 0                               // 0x000C - gravity
    float32 0                               // 0x0010 - bounce multiplier
    float32 0.1                           // 0x0014 - rotation speed
    float32 0                               // 0x0018 - initial angle (ground)
    float32 0                               // 0x001C   initial angle (air)
    float32 50                              // 0x0020   initial speed
    dw Character.UZI_file_6_ptr           // 0x0024   projectile data pointer
    dw 0x00000000                           // 0x0028   unknown (default 0)
    float32 1                           // 0x002C   palette index (0 = mario, 1 = luigi)


    scope ground_initial3_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // store a0, ra

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.LANKY_NSP_Ground
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.LANKY_NSP_Ground

        lli     a1, Uzi.Action.NSPG3       // a1(action id) = NSPG
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      a0, 0x0020(sp)              // ~
        lw      a0, 0x0084(a0)              // ~
        sw      r0, 0x017C(a0)              // temp variable 1 = 0
        sw      r0, 0x0180(a0)              // temp variable 2 = 0
        sw      r0, 0x0184(a0)              // temp variable 3 = 0
        lli     at, 10                       // ~
        sw      at, 0x0B20(a0)              // ammo = 3
        lw      ra, 0x001C(sp)              // load ra
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Subroutine which runs when Lanky initiates an aerial neutral special.
    scope air_initial3_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // store a0, ra

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.LANKY_NSP_Air
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.LANKY_NSP_Air

        lli     a1, Uzi.Action.NSPA3       // a1(action id) = NSPA
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      a0, 0x0020(sp)              // ~
        lw      a0, 0x0084(a0)              // ~
        sw      r0, 0x017C(a0)              // temp variable 1 = 0
        sw      r0, 0x0180(a0)              // temp variable 2 = 0
        sw      r0, 0x0184(a0)              // temp variable 3 = 0
        lli     at, 10                       // ~
        sw      at, 0x0B20(a0)              // ammo = 3
        lw      ra, 0x001C(sp)              // load ra
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Main subroutine for neutral special.
    // If temp variable 1 is set by moveset, create a projectile.
    scope main3_: {
        addiu   sp, sp,-0x0040              // allocate stack space
        sw      ra, 0x0014(sp)              // 0x0014(sp) = ra
        sw      a0, 0x0034(sp)              // 0x0034(sp) = player object
        addu    a2, a0, r0                  // a2 = player object
        lw      v0, 0x0084(a0)              // v0 = player struct
        lw      t6, 0x017C(v0)              // t6 = temp variable 1
        beq     t6, r0, _cancel_check3       // skip if temp variable 1 = 0
        sw      r0, 0x017C(v0)              // reset temp variable 1 to 0

        // if we're here, then temp variable 1 was enabled, so create a projectile
        lw      t6, 0x0008(v0)              // t6 = current character ID
        lli     at, Kirby.Action.LANKY_NSP_Ground - Uzi.Action.NSPG3
        // if kinetic state = aerial
        lli     at, Kirby.Action.LANKY_NSP_Air - Uzi.Action.NSPA3
        lw      a2, 0x0008(v0)              // a2 = current character ID
        lli     t6, Character.id.KIRBY      // t6 = id.KIRBY
        beq     t6, a2, _kirby3              // branch if Kirby
        lli     t6, Character.id.JKIRBY     // t6 = id.JKIRBY
        beq     t6, a2, _kirby3              // branch if JKirby
        lw      a0, 0x0930(v0)              // a0 = part 0xE (weapon) struct
        sw      r0, 0x0020(sp)              // x offset = 0
        lui     at, 0xC348                  // ~
        sw      at, 0x0024(sp)              // y offset = -200
        b       _continue3
        sw      r0, 0x0028(sp)              // z offset = 0

        _kirby3:
        lw      a0, 0x092C(v0)              // a0 = part 0xD (weapon) struct
        lui     at, 0x4396                  // ~
        sw      at, 0x0020(sp)              // x offset = 200
        sw      r0, 0x0024(sp)              // y offset = 0
        sw      r0, 0x0028(sp)              // z offset = 0

        _continue3:
        addiu   a1, sp, 0x0020              // a1 = address to return x/y/z coordinates to
        jal     0x800EDF24                  // returns x/y/z coordinates of the part in a0 to a1
        sw      v0, 0x002C(sp)              // 0x002C(sp) = player struct
        sw      r0, 0x0028(sp)              // set z coordinate to 0
        lw      v0, 0x002C(sp)              // v0 = player struct
        lw      a0, 0x0034(sp)              // a0 = player object
        jal     grape_stage_setting3_        // INITIATE GRAPE
        addiu   a1, sp, 0x0020              // a1 = coordinates to create projectile at
        lw      a0, 0x0034(sp)              // a0 = player object
        lw      v0, 0x0084(a0)              // v0 = player struct

        _cancel_check3:
        lw      t6, 0x0180(v0)              // t6 = temp variable 2
        beq     t6, r0, _idle_check3         // skip if temp variable 2 = 0
        lhu     t7, 0x01BE(v0)              // t7 = buttons_pressed



        // if B was pressed
        lw      t0, 0x0B20(v0)              // t0 = ammo
        addiu   at, t0,-0x0001              // at = ammo - 1
        sw      at, 0x0B20(v0)              // store updated ammo...
        beqzl   t0, _idle_check3             // skip if ammo = 0
        sw      r0, 0x0B20(v0)              // and set ammo to 0
        lw      a2, 0x014C(v0)              // a2 = kinetic state
        beqz    a2, pc() + 12               // branch if kinetic state = grounded
        // if kinetic state = grounded
        lli     a1, Uzi.Action.NSPG3
        // if kinetic state = aerial
        lli     a1, Uzi.Action.NSPA3
        beqz    a2, pc() + 12               // branch if kinetic state = grounded
        // if kinetic state = grounded
        lli     at, Kirby.Action.LANKY_NSP_Ground - Uzi.Action.NSPG3
        // if kinetic state = aerial
        lli     at, Kirby.Action.LANKY_NSP_Air - Uzi.Action.NSPA3
        lw      a2, 0x0008(v0)              // a2 = current character ID
        lli     t6, Character.id.KIRBY      // t6 = id.KIRBY
        beql    t6, a2, pc() + 20           // if Kirby, adjust action ID
        addu    a1, a1, at
        lli     t6, Character.id.JKIRBY     // t6 = id.JKIRBY
        beql    t6, a2, pc() + 8            // if J Kirby, adjust action ID
        addu    a1, a1, at
        lw      a0, 0x0034(sp)              // a0 = player object
        lui     a2, 0x4160                  // a2(starting frame) = 14
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0034(sp)              // a0 = player object

        lw      a0, 0x0034(sp)              // a0 = player object
        lw      v0, 0x0084(a0)              // v0 = player struct
        sw      r0, 0x0180(v0)              // reset temp variable 2

        _idle_check3:
        // checks the current animation frame to see if we've reached end of the animation
        mtc1    r0, f6                      // ~
        lwc1    f8, 0x0078(a0)              // ~
        c.le.s  f8, f6                      // ~
        nop
        bc1fl   _end3                        // skip if animation end has not been reached
        nop
        jal     0x800DEE54                  // transition to idle
        nop

        _end3:
        lw      ra, 0x0014(sp)              // load ra
        jr      ra
        addiu   sp, sp, 0x0040              // deallocate stack space
    }


    // @ Description
    // Subroutine which sets up the initial properties for the projectile.
    // TODO: this is still largely uncommented, and may contain leftover logic that isn't needed.
    scope grape_stage_setting3_: {
        constant MAX_POWER(7)
        addiu   sp, sp, -0x0050
        sw      s0, 0x0018(sp)
        li      s0, grape_properties_struct3 // s0 = projectile properties struct address
        sw      a1, 0x0034(sp)
        sw      ra, 0x001C(sp)
        lw      t6, 0x0084(a0)
        lw      t0, 0x0024(s0)
        lw      t1, 0x0028(s0)
        li      a1, grape_projectile_struct3 // a1 = main projectile struct address
        lw      a2, 0x0034(sp)
        lui     a3, 0x8000
        sw      t6, 0x002C(sp)              // 0x002C(sp) = player struct
        jal     0x801655C8                  // This is a generic routine that does much of the work for defining all projectiles
        sw      t1, 0x000C(a1)

        beq     v0, r0, _end_stage_setting3  // if 801655C8 returns 0, there's no space to create a new projectile object, so skip to end
        nop

        _projectile_branch3:
        sw      v0, 0x0028(sp)              // 0x0028(sp) = projectile object
        lw      v1, 0x0084(v0)              // v1 = projectile struct
        lw      t3, 0x0000(s0)              // t3 = duration
        sw      t3, 0x0268(v1)              // store duration
        lw      t4, 0x002C(sp)              // t4 = player struct
        lw      t5, 0x014C(t4)              // t5 = kinetic state
        beq     t5, r0, _continue3           // branch if kinetic state = grounded
        lwc1    f12, 0x0018(s0)             // f12 = initial angle (ground)
        lwc1    f12, 0x001C(s0)             // f12 = initial angle (air)

        _continue3:
        mtc1    r0, f4                      // f4 = 0
        swc1    f4, 0x0028(v1)              // set z speed? to 0
        swc1    f12, 0x0020(sp)             // 0x0020(sp) = adjusted angle
        jal     0x80035CD0                  // ~
        sw      v1, 0x0024(sp)              // original logic

        lwc1    f6, 0x0020(s0)              // f6 = initial projectile speed
        lw      t6, 0x002C(sp)              // ~
        lw      v1, 0x0024(sp)              // ~
        lw      t7, 0x0044(t6)              // ~
        mul.s   f8, f0, f6                  // ~
        lwc1    f12, 0x0020(sp)             // ~
        mtc1    t7, f10                     // ~
        nop                                 // ~
        cvt.s.w f16, f10                    // ~
        mul.s   f18, f8, f16                // ~
        jal     0x800303F0                  // ~
        swc1    f18, 0x0020(v1)             // original logic

        lwc1    f4, 0x0020(s0)              // f4 = initial projectile speed
        lw      v1, 0x0024(sp)              // ~
        lw      a0, 0x0028(sp)              // ~
        mul.s   f6, f0, f4                  // ~
        swc1    f6, 0x0024(v1)              // ~
        lw      t8, 0x0074(a0)              // ~
        lwc1    f10, 0x002C(s0)             // ~
        lw      t9, 0x0080(t8)              // ~
        jal     0x80167FA0                  // ~
        swc1    f10, 0x0088(t9)             // ~
        lw      v0, 0x0028(sp)              // original logic

        _end_stage_setting3:
        lw      ra, 0x001C(sp)
        lw      s0, 0x0018(sp)
        addiu   sp, sp, 0x0050
        jr      ra
        nop
    }

    // @ Description
    // Main subroutine for the grape.
    scope grape_main3_: {
        addiu   sp, sp, 0xFFE0              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        sw      a0, 0x0020(sp)              // 0x0020(sp) = projectile object
        lw      a0, 0x0084(a0)              // a0 = projectile struct
        jal     0x80167FE8                  // original logic, subroutine returns 1 if projectile duration is over
        sw      a0, 0x001C(sp)              // 0x001C(sp) = projectile struct
        beq     v0, r0, _continue3           // branch if projectile duration has not ended
        lw      a0, 0x001C(sp)              // a0 = projectile struct

        _end_duration3:
        lw      t7, 0x0020(sp)              // t7 = projectile object
        lw      a0, 0x0074(t7)              // ~
        addiu   a0, a0, 0x001C              // a0 = projectile x/y/z coords
        jal     0x800FF648                  // create smoke gfx
        lui     a1, 0x3F80                  // a1 = 1.0
        b       _end3                        // branch to end
        lli     v0, OS.TRUE                 // return TRUE (destroys projectile)

        _continue3:
        li      v0, grape_properties_struct3 // v0 = grape_properties_struct
        lw      a1, 0x000C(v0)              // a1 = gravity
        jal     0x80168088                  // apply gravity to grape
        lw      a2, 0x0004(v0)              // a2 = max speed
        lw      a0, 0x001C(sp)              // a0 = projectile struct
        lw      t1, 0x0020(sp)              // t1 = projectile object
        lw      v1, 0x0074(t1)              // v1 = projectile struct with coordinates/rotation etc (bone struct?)
        li      at, grape_properties_struct3 // at = grape properties struct
        lwc1    f6, 0x0014(at)              // f6 = rotation speed
        lwc1    f4, 0x0030(v1)              // f4 = current rotation
        add.s   f8, f4, f6                  // add rotation speed to current rotation
        swc1    f8, 0x0030(v1)              // update rotation
        lli     v0, OS.FALSE                // return FALSE (don't destroy)

        _end3:
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Collision subroutine for the grape.
    // Based on 0x801688C4, which is the equivalent for Charge Shot.
    scope grape_collision3_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x00014(sp)             // store ra

        jal     0x80167C04                  // general collision detection?
        sw      a0, 0x0018(sp)              // 0x0018(sp) = projectile object
        beqz    v0, _end3                    // end if collision wasn't detected
        lw      a0, 0x0018(sp)              // a2 = projectile object
        // if collision was detected
        jal     grape_destruction3_
        nop

        _end3:
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // This subroutine spawns a hit effect and destroys the GRAPE
    scope grape_hit3_: {
        addiu   sp, sp,-0x0028              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        sw      a0, 0x0018(sp)              // 0x0018(sp) = projectile object
        lw      v1, 0x0084(a0)              // v1 = projectile struct
        lw      a0, 0x0074(a0)              // ~
        addiu   a0, a0, 0x001C              // a0 = x/y/z coordinates
        or      a1, r0, r0                  // a1 = 0
        lw      a2, 0x0234(v1)              // a2 = damage
        jal     0x800FDC04                  // create "normal hit" gfx
        or      a3, r0, r0                  // a3 = 0
        jal     grape_destruction3_          // destroy the grape
        lw      a0, 0x0018(sp)              // a0 = projectile obect
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0028              // deallocate stack space
    }

    // @ Description
    // This subroutine destroys the grape and creates a smoke gfx.
    scope grape_destruction3_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        lw      a0, 0x0074(a0)              // ~
        addiu   a0, a0, 0x001C              // a0 = projectile x/y/z coords
        jal     0x800FF648                  // create smoke gfx
        lui     a1, 0x3F80                  // a1 = 1.0
        jal     0x800269C0                  // play FGM
        lli     a0, 17                    // FGM id = 1521
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0018              // deallocate stack space
        jr      ra                          // return
        lli     v0, OS.TRUE                 // return TRUE (destroys projectile)
    }

    OS.align(16)
    grape_projectile_struct3:
    constant NUT_ID3(0x1001)
    dw 0x00000000                           // unknown
    dw NUT_ID3                               // projectile id
    dw Character.UZI_file_6_ptr           // address of conker's file 6 pointer
    dw 0x00000000                           // offset to hitbox
    dw 0x12470000                           // This determines z axis rotation? (samus is 1246)
    dw grape_main3_                          // This is the main subroutine for the projectile, handles duration and other things. (default 0x80168540) (samus 0x80168F98)
    dw grape_collision3_                     // This is the collision subroutine for the projectile, responsible for detecting collision with clipping.
    dw 0                           // This function runs when the projectile collides with a hurtbox.
    dw grape_destruction3_                   // This function runs when the projectile collides with a shield.
    dw 0x801686F8                           // This function runs when the projectile collides with edges of a shield and bounces off
    dw grape_destruction3_                   // This function runs when the projectile collides/clangs with a hitbox.
    dw 0x801692C4                           // This function runs when the projectile collides with Fox's reflector (default 0x80168748)
    dw grape_destruction3_                   // This function runs when the projectile collides with Ness's psi magnet
    OS.copy_segment(0x103904, 0x0C)         // empty

    OS.align(16)
    grape_properties_struct3:
    dw 300                                   // 0x0000 - duration (int)
    float32 500                              // 0x0004 - max speed
    float32 50                               // 0x0008 - min speed
    float32 1.1                               // 0x000C - gravity
    float32 0                               // 0x0010 - bounce multiplier
    float32 0.2                           // 0x0014 - rotation speed
    float32 0.5                               // 0x0018 - initial angle (ground)
    float32 0.5                               // 0x001C   initial angle (air)
    float32 80                              // 0x0020   initial speed
    dw Character.UZI_file_6_ptr           // 0x0024   projectile data pointer
    dw 0x00000000                           // 0x0028   unknown (default 0)
    float32 1                           // 0x002C   palette index (0 = mario, 1 = luigi)



    scope ground_initial4_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // store a0, ra

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.LANKY_NSP_Ground
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.LANKY_NSP_Ground

        lli     a1, Uzi.Action.NSPG4       // a1(action id) = NSPG
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      a0, 0x0020(sp)              // ~
        lw      a0, 0x0084(a0)              // ~
        sw      r0, 0x017C(a0)              // temp variable 1 = 0
        sw      r0, 0x0180(a0)              // temp variable 2 = 0
        sw      r0, 0x0184(a0)              // temp variable 3 = 0
        lli     at, 15                       // ~
        sw      at, 0x0B20(a0)              // ammo = 3
        lw      ra, 0x001C(sp)              // load ra
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Subroutine which runs when Lanky initiates an aerial neutral special.
    scope air_initial4_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // store a0, ra

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.LANKY_NSP_Air
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.LANKY_NSP_Air

        lli     a1, Uzi.Action.NSPA4       // a1(action id) = NSPA
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      a0, 0x0020(sp)              // ~
        lw      a0, 0x0084(a0)              // ~
        sw      r0, 0x017C(a0)              // temp variable 1 = 0
        sw      r0, 0x0180(a0)              // temp variable 2 = 0
        sw      r0, 0x0184(a0)              // temp variable 3 = 0
        lli     at, 15                       // ~
        sw      at, 0x0B20(a0)              // ammo = 3
        lw      ra, 0x001C(sp)              // load ra
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Main subroutine for neutral special.
    // If temp variable 1 is set by moveset, create a projectile.
    scope main4_: {
        addiu   sp, sp,-0x0040              // allocate stack space
        sw      ra, 0x0014(sp)              // 0x0014(sp) = ra
        sw      a0, 0x0034(sp)              // 0x0034(sp) = player object
        addu    a2, a0, r0                  // a2 = player object
        lw      v0, 0x0084(a0)              // v0 = player struct
        lw      t6, 0x017C(v0)              // t6 = temp variable 1
        beq     t6, r0, _cancel_check4       // skip if temp variable 1 = 0
        sw      r0, 0x017C(v0)              // reset temp variable 1 to 0

        // if we're here, then temp variable 1 was enabled, so create a projectile
        lw      t6, 0x0008(v0)              // t6 = current character ID
        lli     at, Kirby.Action.LANKY_NSP_Ground - Uzi.Action.NSPG4
        // if kinetic state = aerial
        lli     at, Kirby.Action.LANKY_NSP_Air - Uzi.Action.NSPA4
        lw      a2, 0x0008(v0)              // a2 = current character ID
        lli     t6, Character.id.KIRBY      // t6 = id.KIRBY
        beq     t6, a2, _kirby4              // branch if Kirby
        lli     t6, Character.id.JKIRBY     // t6 = id.JKIRBY
        beq     t6, a2, _kirby4              // branch if JKirby
        lw      a0, 0x0930(v0)              // a0 = part 0xE (weapon) struct
        sw      r0, 0x0020(sp)              // x offset = 0
        lui     at, 0xC348                  // ~
        sw      at, 0x0024(sp)              // y offset = -200
        b       _continue4
        sw      r0, 0x0028(sp)              // z offset = 0

        _kirby4:
        lw      a0, 0x092C(v0)              // a0 = part 0xD (weapon) struct
        lui     at, 0x4396                  // ~
        sw      at, 0x0020(sp)              // x offset = 200
        sw      r0, 0x0024(sp)              // y offset = 0
        sw      r0, 0x0028(sp)              // z offset = 0

        _continue4:
        addiu   a1, sp, 0x0020              // a1 = address to return x/y/z coordinates to
        jal     0x800EDF24                  // returns x/y/z coordinates of the part in a0 to a1
        sw      v0, 0x002C(sp)              // 0x002C(sp) = player struct
        sw      r0, 0x0028(sp)              // set z coordinate to 0
        lw      v0, 0x002C(sp)              // v0 = player struct
        lw      a0, 0x0034(sp)              // a0 = player object
        jal     grape_stage_setting4_        // INITIATE GRAPE
        addiu   a1, sp, 0x0020              // a1 = coordinates to create projectile at
        lw      a0, 0x0034(sp)              // a0 = player object
        lw      v0, 0x0084(a0)              // v0 = player struct

        _cancel_check4:
        lw      t6, 0x0180(v0)              // t6 = temp variable 2
        beq     t6, r0, _idle_check4         // skip if temp variable 2 = 0
        lhu     t7, 0x01BE(v0)              // t7 = buttons_pressed



        // if B was pressed
        lw      t0, 0x0B20(v0)              // t0 = ammo
        addiu   at, t0,-0x0001              // at = ammo - 1
        sw      at, 0x0B20(v0)              // store updated ammo...
        beqzl   t0, _idle_check4             // skip if ammo = 0
        sw      r0, 0x0B20(v0)              // and set ammo to 0
        lw      a2, 0x014C(v0)              // a2 = kinetic state
        beqz    a2, pc() + 12               // branch if kinetic state = grounded
        // if kinetic state = grounded
        lli     a1, Uzi.Action.NSPG4
        // if kinetic state = aerial
        lli     a1, Uzi.Action.NSPA4
        beqz    a2, pc() + 12               // branch if kinetic state = grounded
        // if kinetic state = grounded
        lli     at, Kirby.Action.LANKY_NSP_Ground - Uzi.Action.NSPG4
        // if kinetic state = aerial
        lli     at, Kirby.Action.LANKY_NSP_Air - Uzi.Action.NSPA4
        lw      a2, 0x0008(v0)              // a2 = current character ID
        lli     t6, Character.id.KIRBY      // t6 = id.KIRBY
        beql    t6, a2, pc() + 20           // if Kirby, adjust action ID
        addu    a1, a1, at
        lli     t6, Character.id.JKIRBY     // t6 = id.JKIRBY
        beql    t6, a2, pc() + 8            // if J Kirby, adjust action ID
        addu    a1, a1, at
        lw      a0, 0x0034(sp)              // a0 = player object
        lui     a2, 0x4160                  // a2(starting frame) = 14
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0034(sp)              // a0 = player object

        lw      a0, 0x0034(sp)              // a0 = player object
        lw      v0, 0x0084(a0)              // v0 = player struct
        sw      r0, 0x0180(v0)              // reset temp variable 2

        _idle_check4:
        // checks the current animation frame to see if we've reached end of the animation
        mtc1    r0, f6                      // ~
        lwc1    f8, 0x0078(a0)              // ~
        c.le.s  f8, f6                      // ~
        nop
        bc1fl   _end4                        // skip if animation end has not been reached
        nop
        jal     0x800DEE54                  // transition to idle
        nop

        _end4:
        lw      ra, 0x0014(sp)              // load ra
        jr      ra
        addiu   sp, sp, 0x0040              // deallocate stack space
    }


    // @ Description
    // Subroutine which sets up the initial properties for the projectile.
    // TODO: this is still largely uncommented, and may contain leftover logic that isn't needed.
    scope grape_stage_setting4_: {
        constant MAX_POWER(7)
        addiu   sp, sp, -0x0050
        sw      s0, 0x0018(sp)
        li      s0, grape_properties_struct4 // s0 = projectile properties struct address
        sw      a1, 0x0034(sp)
        sw      ra, 0x001C(sp)
        lw      t6, 0x0084(a0)
        lw      t0, 0x0024(s0)
        lw      t1, 0x0028(s0)
        li      a1, grape_projectile_struct4 // a1 = main projectile struct address
        lw      a2, 0x0034(sp)
        lui     a3, 0x8000
        sw      t6, 0x002C(sp)              // 0x002C(sp) = player struct
        jal     0x801655C8                  // This is a generic routine that does much of the work for defining all projectiles
        sw      t1, 0x000C(a1)

        beq     v0, r0, _end_stage_setting4  // if 801655C8 returns 0, there's no space to create a new projectile object, so skip to end
        nop

        _projectile_branch4:
        sw      v0, 0x0028(sp)              // 0x0028(sp) = projectile object
        lw      v1, 0x0084(v0)              // v1 = projectile struct
        lw      t3, 0x0000(s0)              // t3 = duration
        sw      t3, 0x0268(v1)              // store duration
        lw      t4, 0x002C(sp)              // t4 = player struct
        lw      t5, 0x014C(t4)              // t5 = kinetic state
        beq     t5, r0, _continue4           // branch if kinetic state = grounded
        lwc1    f12, 0x0018(s0)             // f12 = initial angle (ground)
        lwc1    f12, 0x001C(s0)             // f12 = initial angle (air)

        _continue4:
        mtc1    r0, f4                      // f4 = 0
        swc1    f4, 0x0028(v1)              // set z speed? to 0
        swc1    f12, 0x0020(sp)             // 0x0020(sp) = adjusted angle
        jal     0x80035CD0                  // ~
        sw      v1, 0x0024(sp)              // original logic

        lwc1    f6, 0x0020(s0)              // f6 = initial projectile speed
        lw      t6, 0x002C(sp)              // ~
        lw      v1, 0x0024(sp)              // ~
        lw      t7, 0x0044(t6)              // ~
        mul.s   f8, f0, f6                  // ~
        lwc1    f12, 0x0020(sp)             // ~
        mtc1    t7, f10                     // ~
        nop                                 // ~
        cvt.s.w f16, f10                    // ~
        mul.s   f18, f8, f16                // ~
        jal     0x800303F0                  // ~
        swc1    f18, 0x0020(v1)             // original logic

        lwc1    f4, 0x0020(s0)              // f4 = initial projectile speed
        lw      v1, 0x0024(sp)              // ~
        lw      a0, 0x0028(sp)              // ~
        mul.s   f6, f0, f4                  // ~
        swc1    f6, 0x0024(v1)              // ~
        lw      t8, 0x0074(a0)              // ~
        lwc1    f10, 0x002C(s0)             // ~
        lw      t9, 0x0080(t8)              // ~
        jal     0x80167FA0                  // ~
        swc1    f10, 0x0088(t9)             // ~
        lw      v0, 0x0028(sp)              // original logic

        _end_stage_setting4:
        lw      ra, 0x001C(sp)
        lw      s0, 0x0018(sp)
        addiu   sp, sp, 0x0050
        jr      ra
        nop
    }

    // @ Description
    // Main subroutine for the grape.
    scope grape_main4_: {
        addiu   sp, sp, 0xFFE0              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        sw      a0, 0x0020(sp)              // 0x0020(sp) = projectile object
        lw      a0, 0x0084(a0)              // a0 = projectile struct
        jal     0x80167FE8                  // original logic, subroutine returns 1 if projectile duration is over
        sw      a0, 0x001C(sp)              // 0x001C(sp) = projectile struct
        beq     v0, r0, _continue4           // branch if projectile duration has not ended
        lw      a0, 0x001C(sp)              // a0 = projectile struct

        _end_duration4:
        lw      t7, 0x0020(sp)              // t7 = projectile object
        lw      a0, 0x0074(t7)              // ~
        addiu   a0, a0, 0x001C              // a0 = projectile x/y/z coords
        jal     0x800FF648                  // create smoke gfx
        lui     a1, 0x3F80                  // a1 = 1.0
        b       _end4                        // branch to end
        lli     v0, OS.TRUE                 // return TRUE (destroys projectile)

        _continue4:
        li      v0, grape_properties_struct4 // v0 = grape_properties_struct
        lw      a1, 0x000C(v0)              // a1 = gravity
        jal     0x80168088                  // apply gravity to grape
        lw      a2, 0x0004(v0)              // a2 = max speed
        lw      a0, 0x001C(sp)              // a0 = projectile struct
        lw      t1, 0x0020(sp)              // t1 = projectile object
        lw      v1, 0x0074(t1)              // v1 = projectile struct with coordinates/rotation etc (bone struct?)
        li      at, grape_properties_struct4 // at = grape properties struct
        lwc1    f6, 0x0014(at)              // f6 = rotation speed
        lwc1    f4, 0x0030(v1)              // f4 = current rotation
        add.s   f8, f4, f6                  // add rotation speed to current rotation
        swc1    f8, 0x0030(v1)              // update rotation
        lli     v0, OS.FALSE                // return FALSE (don't destroy)

        _end4:
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Collision subroutine for the grape.
    // Based on 0x801688C4, which is the equivalent for Charge Shot.
    scope grape_collision4_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x00014(sp)             // store ra

        jal     0x80167C04                  // general collision detection?
        sw      a0, 0x0018(sp)              // 0x0018(sp) = projectile object
        beqz    v0, _end4                    // end if collision wasn't detected
        lw      a0, 0x0018(sp)              // a2 = projectile object
        // if collision was detected
        jal     grape_destruction4_
        nop

        _end4:
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // This subroutine spawns a hit effect and destroys the GRAPE
    scope grape_hit4_: {
        addiu   sp, sp,-0x0028              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        sw      a0, 0x0018(sp)              // 0x0018(sp) = projectile object
        lw      v1, 0x0084(a0)              // v1 = projectile struct
        lw      a0, 0x0074(a0)              // ~
        addiu   a0, a0, 0x001C              // a0 = x/y/z coordinates
        or      a1, r0, r0                  // a1 = 0
        lw      a2, 0x0234(v1)              // a2 = damage
        jal     0x800FDC04                  // create "normal hit" gfx
        or      a3, r0, r0                  // a3 = 0
        jal     grape_destruction4_          // destroy the grape
        lw      a0, 0x0018(sp)              // a0 = projectile obect
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0028              // deallocate stack space
    }

    // @ Description
    // This subroutine destroys the grape and creates a smoke gfx.
    scope grape_destruction4_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        lw      a0, 0x0074(a0)              // ~
        addiu   a0, a0, 0x001C              // a0 = projectile x/y/z coords
        jal     0x800FF648                  // create smoke gfx
        lui     a1, 0x3F80                  // a1 = 1.0
        jal     0x800269C0                  // play FGM
        lli     a0, 17                    // FGM id = 1521
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0018              // deallocate stack space
        jr      ra                          // return
        lli     v0, OS.TRUE                 // return TRUE (destroys projectile)
    }

    OS.align(16)
    grape_projectile_struct4:
    constant NUT_ID4(0x1001)
    dw 0x00000000                           // unknown
    dw NUT_ID4                               // projectile id
    dw Character.UZI_file_6_ptr           // address of conker's file 6 pointer
    dw 0x00000000                           // offset to hitbox
    dw 0x12470000                           // This determines z axis rotation? (samus is 1246)
    dw grape_main4_                          // This is the main subroutine for the projectile, handles duration and other things. (default 0x80168540) (samus 0x80168F98)
    dw grape_collision4_                     // This is the collision subroutine for the projectile, responsible for detecting collision with clipping.
    dw 0                           // This function runs when the projectile collides with a hurtbox.
    dw grape_destruction4_                   // This function runs when the projectile collides with a shield.
    dw 0x801686F8                           // This function runs when the projectile collides with edges of a shield and bounces off
    dw grape_destruction4_                   // This function runs when the projectile collides/clangs with a hitbox.
    dw 0x801692C4                           // This function runs when the projectile collides with Fox's reflector (default 0x80168748)
    dw grape_destruction4_                   // This function runs when the projectile collides with Ness's psi magnet
    OS.copy_segment(0x103904, 0x0C)         // empty

    OS.align(16)
    grape_properties_struct4:
    dw 300                                   // 0x0000 - duration (int)
    float32 500                              // 0x0004 - max speed
    float32 50                               // 0x0008 - min speed
    float32 0                               // 0x000C - gravity
    float32 0                               // 0x0010 - bounce multiplier
    float32 0.1                           // 0x0014 - rotation speed
    float32 0                               // 0x0018 - initial angle (ground)
    float32 0                               // 0x001C   initial angle (air)
    float32 150                              // 0x0020   initial speed
    dw Character.UZI_file_6_ptr           // 0x0024   projectile data pointer
    dw 0x00000000                           // 0x0028   unknown (default 0)
    float32 1                           // 0x002C   palette index (0 = mario, 1 = luigi)

}






scope UziNSP3 {

    constant MAX_X_RANGE(0x410A)            // current setting - float: 2208
    constant MIN_Y_RANGE(0x447A)            // current setting - float: 1000
    constant MAX_X_RANGE_SS(0x45BB)         // current setting (Super Sonic) - float: 5984
    constant MIN_Y_RANGE_SS(0x457A)         // current setting (Super Sonic) - float: 4000
    constant SPEED(0x12BC)                  // current setting - float: 110
    constant LOCKED_SPEED(0x4302)           // current setting - float: 130
    constant SPEED_SS(0x42B2)               // current setting (Super Sonic) - float: 130
    constant LOCKED_SPEED_SS(0x42B2)        // current setting (Super Sonic) - float: 130
    constant RECOIL_X_SPEED(0xC1A0)         // current setting - float: -20
    constant RECOIL_Y_SPEED(0x42A0)         // current setting - float: 80
    constant BOUNCE_Y_SPEED(0x4270)         // current setting - float: 60
    constant TURN_SPEED(0x3E0EFA1E)         // current setting - float: 0.139626 rads/8 degrees
    constant TURN_SPEED_SS(0x3CD7)          // current setting - float: 0.026 rads/1.5 degrees
    constant DEFAULT_ANGLE(0xBEBBA861)      // current setting - float: -0.366519 rads/-21 degrees
    constant MAX_INITAL_ANGLE(0x3F1C61A6)   // current setting - float: 0.610865 rads/35 degrees
    constant MIN_INITAL_ANGLE(0xBF1C61A6)   // current setting - float: -0.610865 rads/-35 degrees
    constant DURATION(1)
    constant LOCKED_DURATION(20)



    // @ Description
    // Subroutine which runs when Sonic initiates a neutral special.
    scope begin_initial_: {
        addiu   sp, sp,-0x0050              // allocate stack space
        sw      ra, 0x001C(sp)              // store ra
        sw      a0, 0x0038(sp)              // 0x0038(sp) = player object
        lw      a0, 0x0084(a0)              // a0 = player struct
        lw      t0, 0x014C(a0)              // t0 = kinetic state
        bnez    t0, _continue               // skip if kinetic state = aerial
        sw      a0, 0x0034(sp)              // 0x0034(sp) = player struct
        jal     0x800DEEC8                  // set aerial state
        nop

        _continue:
        lw      a0, 0x0038(sp)              // a0 = player object

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.SONIC_NSP_Begin
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.SONIC_NSP_Begin

        lli     a1, Uzi.Action.NSP_Begin  // a1(action id) = NSP_Begin
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0038(sp)              // a0 = player object
        lw      a0, 0x0034(sp)              // a0 = player struct
        sw      r0, 0x017C(a0)              // temp variable 1 = 0
        sw      r0, 0x0180(a0)              // temp variable 2 = 0
        sw      r0, 0x0184(a0)              // temp variable 3 = 0
        sw      r0, 0x0B18(a0)              // target = NULL
        sw      r0, 0x0B1C(a0)              // X_DIFF = 0
        lui     t0, 0x4140                  // ~
        sw      r0, 0x0048(a0)              // x velocity = 0
        sw      t0, 0x004C(a0)              // y velocity = 12
        lbu     v1, 0x018D(a0)              // v1 = fast fall flag
        ori     t6, r0, 0x0007              // t6 = bitmask (01111111)
        and     v1, v1, t6                  // ~
        sb      v1, 0x018D(a0)              // disable fast fall flag
        lw      ra, 0x001C(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0050              // deallocate stack space
    }



    // @ Description
    // Main subroutine for NSP_Begin
    scope begin_main_: {
        addiu   sp, sp,-0x0040              // allocate stack space
        sw      ra, 0x0014(sp)              // ~
        sw      a0, 0x0018(sp)              // ~
        sw      s0, 0x001C(sp)              // store ra, a0, s0
        lw      s0, 0x0084(a0)              // s0 = player struct

        // check temp variable 1 to determine the status of Sonic's charge
        lw      t0, 0x017C(s0)              // t0 = temp variable 1
        beqz    t0, _end                    // skip to end if temp variable 1 = 0
        lli     at, 0x0001                  // at = 1
        bne     t0, at, _begin_movement     // if temp variable is set to a value other than 1, force movement
        lh      t0, 0x01BC(s0)              // t0 = buttons_held
        andi    t0, t0, Joypad.B            // t0 = 0x0020 if (B_HELD); else t0 = 0
        bnez    t0, _end                    // skip to end if temp variable 1 = 1 and B is held
        nop


        // if we're here, then begin movement and check for targets in front of Sonic
        _begin_movement:
        jal     check_for_targets_          // check_for_targets_
        lw      a0, 0x0018(sp)              // a0 = player object
        lw      t0, 0x0B18(s0)              // t0 = target object
        beq     t0, r0, _no_target          // branch if no target was found
        nop
        jal     locked_move_initial_        // locked_move_initial_
        lw      a0, 0x0018(sp)              // a0 = player object
        b       _end                        // end
        nop

        // if no target was found, then move in a fixed direction instead
        _no_target:
        jal     move_initial_               // move_initial_
        lw      a0, 0x0018(sp)              // a0 = player object

        _end:
        lw      ra, 0x0014(sp)              // ~
        lw      s0, 0x001C(sp)              // load ra, s0
        jr      ra                          // return
        addiu   sp, sp, 0x0040              // deallocate stack space
    }



    // @ Description
    // Subroutine which checks for valid targets for Sonic's homing attack.
    // a0 - player object
    scope check_for_targets_: {
        addiu   sp, sp,-0x0050              // allocate stack space
        sw      ra, 0x001C(sp)              // ~
        sw      s0, 0x0020(sp)              // ~
        sw      s1, 0x0024(sp)              // ~
        sw      s2, 0x0028(sp)              // store ra, s0-s2

        or      s0, a0, r0                  // s0 = Sonic player object
        li      s1, 0x800466FC              // s1 = player object head
        lw      s1, 0x0000(s1)              // s1 = first player object
        lw      s2, 0x0084(s0)              // s2 = player struct

        _player_loop:
        beqz    s1, _player_loop_exit       // exit loop when s1 no longer holds an object pointer
        nop
        beql    s1, s0, _player_loop        // loop if player and target object match...
        lw      s1, 0x0004(s1)              // ...and load next object into s1

        _team_check:
        li      t0, Global.match_info       // ~
        lw      t0, 0x0000(t0)              // t0 = match info struct
        lbu     t1, 0x0002(t0)              // t1 = team battle flag
        beqz    t1, _action_check           // branch if team battle flag = FALSE
        lbu     t1, 0x0009(t0)              // t1 = team attack flag
        bnez    t1, _action_check           // branch if team attack flag != FALSE
        nop

        // if the match is a team battle with team attack disabled
        lw      t0, 0x0084(s1)              // t0 = target player struct
        lbu     t0, 0x000C(t0)              // t0 = target team
        lbu     t1, 0x000C(s2)              // t1 = player team
        beq     t0, t1, _player_loop_end    // skip if player and target are on the same team
        nop

        _action_check:
        lw      t0, 0x0084(s1)              // t0 = target player struct
        lw      t0, 0x0024(t0)              // t0 = target player action
        sltiu   at, t0, 0x0007              // at = 1 if action id < 7, else at = 0
        bnez    at, _player_loop_end        // skip if target action id < 7 (target is in a KO action)
        nop

        _target_check:
        or      a0, s2, r0                  // a0 = player struct
        lw      a1, 0x0074(s1)              // a1 = target top joint struct
        jal     check_target_               // check_target_
        or      a2, s1, r0                  // a2 = target object struct
        beqz    v0, _player_loop_end        // branch if no new target
        nop

        // if check_target_ returned a new valid target
        sw      v0, 0x0B18(s2)              // store target object
        sw      v1, 0x0B1C(s2)              // store target X_DIFF

        _player_loop_end:
        b       _player_loop                // loop
        lw      s1, 0x0004(s1)              // s1 = next object

        _player_loop_exit:
        lw      t0, 0x0B18(s2)              // t0 = target object
        bnez    t0, _end                    // end if there is a targeted object
        nop

        li      s1, 0x80046700              // s1 = item object head
        lw      s1, 0x0000(s1)              // s1 = first item object

        _item_loop:
        beqz    s1, _end                    // exit loop when s1 no longer holds an object pointer
        nop

        lw      t0, 0x0084(s1)              // t0 = item special struct
        lw      t0, 0x0248(t0)              // t0 = bit field with hurtbox state
        andi    t0, t0, 0x0001              // t0 = 1 if hurtbox is enabled, else t0 = 0
        beqz    t0, _item_loop_end          // skip if item doesn't have an active hurtbox
        nop
        or      a0, s2, r0                  // a0 = player struct
        lw      a1, 0x0074(s1)              // a1 = target top joint struct
        jal     check_target_               // check_target_
        or      a2, s1, r0                  // a2 = target object struct
        beqz    v0, _item_loop_end          // branch if no new target
        nop

        // if check_target_ returned a new valid target
        sw      v0, 0x0B18(s2)              // store target object
        sw      v1, 0x0B1C(s2)              // store target X_DIFF

        _item_loop_end:
        b       _item_loop                  // loop
        lw      s1, 0x0004(s1)              // s1 = next object

        _end:
        lw      ra, 0x001C(sp)              // ~
        lw      s0, 0x0020(sp)              // ~
        lw      s1, 0x0024(sp)              // ~
        lw      s2, 0x0028(sp)              // load ra, s0-s2
        jr      ra                          // return
        addiu   sp, sp, 0x0050              // deallocate stack space
    }

    // @ Description
    // Subroutine which checks if a potential target is in range for Sonic's homing attack.
    // a0 - player struct
    // a1 - target top joint struct
    // a2 - target object struct
    // returns
    // v0 - target object (NULL when no valid target)
    // v1 - target X_DIFF
    scope check_target_: {
        OS.routine_begin(0x20)
        lw      t8, 0x0078(a0)              // t8 = player x/y/z coordinates
        addiu   t9, a1, 0x001C              // t9 = target x/y/z coordinates

        // check if the target is within x range
        mtc1    r0, f0                      // f0 = 0
        lwc1    f2, 0x0000(t8)              // f2 = player x coordinate
        lwc1    f4, 0x0000(t9)              // f4 = target x coordinate
        sub.s   f10, f4, f2                 // f10 = X_DIFF (target x - player x)
        lwc1    f8, 0x0044(a0)              // ~
        cvt.s.w f8, f8                      // f8 = DIRECTION
        mul.s   f10, f10, f8                // f10 = X_DIFF * DIRECTION


        nop
        beqzl   v0, _apply_max_x_range
        lui     at, MAX_X_RANGE             // at = MAX_X_RANGE
        lui     at, MAX_X_RANGE_SS          // ... or use MAX_X_RANGE_SS instead

        _apply_max_x_range:
        mtc1    at, f8                      // f8 = MAX_X_RANGE
        c.le.s  f10, f8                     // ~
        nop                                 // ~
        bc1fl   _end                        // end if MAX_X_RANGE =< X_DIFF
        or      v0, r0, r0                  // return 0
        c.le.s  f0, f10                      // ~
        nop                                 // ~
        bc1fl   _end                        // end if X_DIFF =< 0
        or      v0, r0, r0                  // return 0

        // check if there is a previous target
        lw      t0, 0x0B18(a0)              // t0 = current target
        beq     t0, r0, _check_y            // branch if there is no current target
        lwc1    f8, 0x0B1C(a0)              // f8 = current target X_DIFF

        // compare X_DIFF to see if the previous target was within closer x proximity
        c.le.s  f10, f8                     // ~
        nop                                 // ~
        bc1fl   _end                        // end if prev X_DIFF =< current X_DIFF
        or      v0, r0, r0                  // return 0

        _check_y:
        // calculate Y_RANGE based on X_DIFF, creating a cone shaped range
        lwc1    f2, 0x0004(t8)              // f2 = player y coordinate
        lwc1    f4, 0x0004(t9)              // f4 = target y coordinate
        sub.s   f12, f4, f2                 // f12 = Y_DIFF (target y - player y)
        abs.s   f12, f12                    // f12 = absolute Y_DIFF


        nop
        beqzl   v0, _apply_min_y_range
        lui     at, MIN_Y_RANGE             // at = MIN_Y_RANGE
        lui     at, MIN_Y_RANGE_SS          // ...use MIN_Y_RANGE_SS instead

        _apply_min_y_range:
        mtc1    at, f8                      // f8 = MIN_Y_RANGE
        lui     at, 0x3F00                  // ~
        mtc1    at, f6                      // f6 = 0.5
        mul.s   f6, f6, f10                 // f6 = X_DIFF * 0.5
        add.s   f8, f8, f6                  // f8 = Y_RANGE (MIN_Y_RANGE + X_DIFF * 0.5)
        c.le.s  f12, f8                     // ~
        nop                                 // ~
        bc1fl   _end                        // end if Y_RANGE =< Y_DIFF
        or      v0, r0, r0                  // return 0

        // if we're here then the target is the closest within range
        or      v0, a2, r0                  // v0 = target object
        mfc1    v1, f10                     // v1 = X_DIFF

        _end:
        OS.routine_end(0x20)
    }

    // @ Description
    // Subroutine which begins NSP_Locked_Move.
    scope locked_move_initial_: {
        addiu   sp, sp,-0x0040              // allocate stack space
        sw      ra, 0x0014(sp)              // ~
        sw      a0, 0x0020(sp)              // ~
        sw      s0, 0x0024(sp)              // store ra, a0, s0

        lw      a2, 0x0084(a0)              // ~
        lw      at, 0x0008(a2)              // at = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beq     a1, at, _ssonic_hat_check   // if Kirby, ssonic hat check
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beq     a1, at, _ssonic_hat_check   // if J Kirby, ssonic hat check
        nop

        // if here, sonic
        b       _change_action
        lli     a1, Uzi.Action.NSP_Locked_Move // a1(action id) = NSP_Locked_Move

        _ssonic_hat_check:
        lb      at, 0x0980(a2)              // at = current hat ID
        addiu   t0, r0, 0x002F              // t0 = ssonics hat id
        bnel    t0, at, _change_action
        lli     a1, Kirby.Action.SONIC_NSP_Locked_Move  // sonic hat
        lli     a1, Kirby.Action.SSONIC_NSP_Locked_Move // super sonic hat

        _change_action:
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      a0, 0x0020(sp)              // ~
        lw      a0, 0x0084(a0)              // a0 = player struct
        lw      t8, 0x0078(a0)              // t8 = player x/y/z coordinates
        lw      t9, 0x0B18(a0)              // ~
        lw      t9, 0x0074(t9)              // ~
        addiu   t9, t9, 0x001C              // t9 = target x/y/z coordinates
        lw      t2, 0x0044(a0)              // ~
        mtc1    t2, f10                     // ~
        cvt.s.w f10, f10                    // f10 = DIRECTION
        lwc1    f4, 0x0000(t8)              // f4 = player x
        lwc1    f6, 0x0000(t9)              // f6 = target x
        sub.s   f14, f6, f4                 // f14 = X_DIFF
        mul.s   f14, f14, f10               // f14 = X_DIFF * DIRECTION
        lwc1    f4, 0x0004(t8)              // f4 = player y
        lwc1    f6, 0x0004(t9)              // f6 = target y
        sub.s   f12, f6, f4                 // f12 = Y_DIFF
        jal     0x8001863C                  // f0 = atan2(f12,f14)
        nop
        // f0 = initial angle
        li      at, MIN_INITAL_ANGLE        // ~
        mtc1    at, f2                      // f2 = MIN_INITAL_ANGLE
        li      at, MAX_INITAL_ANGLE        // ~
        mtc1    at, f4                      // f4 = MAX_INITAL_ANGLE
        c.lt.s  f2, f0                      // ~
        nop                                 // ~
        bc1fl   _end                        // branch if initial angle < MIN_INITAL_ANGLE...
        mov.s   f0, f2                      // ...and set initial angle to MIN_INITAL_ANGLE
        c.lt.s  f0, f4                      // ~
        nop                                 // ~
        bc1fl   _end                        // branch if initial angle > MAX_INITAL_ANGLE
        mov.s   f0, f4                      // set initial angle to MAX_INITAL_ANGLE

        _end:
        swc1    f0, 0x0B20(s0)              // set intial angle
        lwc1    f12, 0x0044(s0)             // ~
        cvt.s.w f12, f12                    // f12 = direction
        lw      t0, 0x0004(s0)              // ~
        lw      t0, 0x0074(t0)              // t0 = top joint struct
        mul.s   f12, f12, f0                // f12 = movement angle * direction
        swc1    f12, 0x0038(t0)             // set joint rotation
        lli     at, LOCKED_DURATION         // ~
        sw      at, 0x0B28(s0)              // set movement timer
        lw      s0, 0x0024(sp)              // ~
        lw      ra, 0x0014(sp)              // load s0, ra
        jr      ra                          // return
        addiu   sp, sp, 0x0040              // deallocate stack space
    }

    // @ Description
    // Subroutine which begins NSP_Move.
    scope move_initial_: {
        addiu   sp, sp,-0x0040              // allocate stack space
        sw      ra, 0x0014(sp)              // ~
        sw      a0, 0x0020(sp)              // ~
        sw      s0, 0x0024(sp)              // store ra, a0, s0

        lw      a2, 0x0084(a0)              // ~
        lw      at, 0x0008(a2)              // at = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beq     a1, at, _ssonic_hat_check   // if Kirby, ssonic hat check
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beq     a1, at, _ssonic_hat_check   // if J Kirby, ssonic hat check
        nop

        b       _change_action
        lli     a1, Uzi.Action.NSP_Move   // a1(action id) = NSP_Move

        _ssonic_hat_check:
        lb      at, 0x0980(a2)              // at = current hat ID
        addiu   t0, r0, 0x002F              // t0 = ssonics hat id
        bnel    t0, at, _change_action
        lli     a1, Kirby.Action.SONIC_NSP_Move  // sonic hat
        lli     a1, Kirby.Action.SSONIC_NSP_Move // super sonic hat

        _change_action:
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      a0, 0x0020(sp)              // ~

        _end:
        li      at, DEFAULT_ANGLE           // ~
        mtc1    at, f10                     // f10 = DEFAULT_ANGLE
        sw      at, 0x0B20(s0)              // set angle to DEFAULT_ANGLE
        lwc1    f12, 0x0044(s0)             // ~
        cvt.s.w f12, f12                    // f12 = direction
        lw      t0, 0x0004(s0)              // ~
        lw      t0, 0x0074(t0)              // t0 = top joint struct
        mul.s   f12, f12, f10               // f12 = DEFAULT_ANGLE * direction
        swc1    f12, 0x0038(t0)             // set joint rotation
        lli     at, DURATION                // ~
        sw      at, 0x0B28(s0)              // set movement timer
        lw      s0, 0x0024(sp)              // ~
        lw      ra, 0x0014(sp)              // load s0, ra
        jr      ra                          // return
        addiu   sp, sp, 0x0040              // deallocate stack space
    }



    // @ Description
    // Main subroutine for NSP_Move and NSP_Locked_Move.
    scope move_main_: {
        addiu   sp, sp,-0x0040              // allocate stack space
        sw      ra, 0x001C(sp)              // store ra
        sw      a0, 0x0020(sp)              // 0x0020(sp) = player object
        lw      a0, 0x0084(a0)              // a0 = player struct

        // v0 = collision flags for all active hitboxes
        jal     Character.get_hitbox_collision_flags_
        sw      a0, 0x0024(sp)              // 0x0024(sp) = player struct

        andi    v0, v0, 0x00F0              // v0 != 0 if hitbox collision has occured
        beq     v0, r0, _check_movement_end // skip if no hitbox collision is detected
        lw      v0, 0x0024(sp)              // v0 = player struct

        // If we're here, then a hitbox collision has occured, so begin recoil
        _begin_recoil:
        jal     air_recoil_initial_         // transition to NSP_Air_Recoil
        lw      a0, 0x0020(sp)              // a0 = player object
        b       _end                        // end
        nop

        _check_movement_end:
        lw      t6, 0x0B28(v0)              // t6 = movement timer
        addiu   t6, t6,-0x0001              // decrement timer
        bnez    t6, _end                    // skip if timer !0
        sw      t6, 0x0B28(v0)              // update movement timer

        // If we're here, then the movement timer has ended, so transition to ending animation
        lw      t6, 0x014C(v0)              // t6 = kinetic state
        bnez    t6, _aerial                 // branch if kinetic state !grounded
        nop

        _grounded:
        jal     ground_initial_         // transition to NSP_Ground_End
        lw      a0, 0x0020(sp)              // a0 = player object
        b       _end                        // end
        nop

        _aerial:
        jal     air_initial_            // transition to NSP_Air_End
        lw      a0, 0x0020(sp)              // a0 = player object

        _end:
        lw      ra, 0x001C(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0040              // deallocate stack space
    }



    // @ Description
    // Subroutine which controls movement for NSP_Move and NSP_Locked_Move.
    scope move_physics_: {
        addiu   sp, sp,-0x0050              // allocate stack space
        sw      ra, 0x0014(sp)              // ~
        sw      a0, 0x0020(sp)              // ~
        sw      s0, 0x0024(sp)              // store ra, a0, s0
        lw      s0, 0x0084(a0)              // s0 = player struct
        sw      s0, 0x0044(sp)              // store ~
        lw      t9, 0x0B18(s0)              // t9 = target object


        lw      a0, 0x0044(sp)              // a0 = player struct

        bnez    v0, _save_speed
        lui     at, SPEED_SS                // super sonic speed

        lui     at, SPEED                   // sonic speed

        _save_speed:
        beqz    t9, _apply_movement         // branch if target object = NULL
        sw      at, 0x0030(sp)              // 0x0030(sp) = SPEED

        _get_angle:

        lw      a0, 0x0044(sp)              // a0 = player struct

        bnez    v0, _move_locked
        lui     at, LOCKED_SPEED_SS         // ~

        lui     at, LOCKED_SPEED            // ~

        _move_locked:
        sw      at, 0x0030(sp)              // 0x0030(sp) = LOCKED_SPEED
        lw      t8, 0x0078(s0)              // t8 = player x/y/z coordinates
        lw      t9, 0x0074(t9)              // ~
        addiu   t9, t9, 0x001C              // t9 = target x/y/z coordinates
        lw      t2, 0x0044(s0)              // ~
        mtc1    t2, f10                     // ~
        cvt.s.w f10, f10                    // f10 = DIRECTION
        lwc1    f4, 0x0000(t8)              // f4 = player x
        lwc1    f6, 0x0000(t9)              // f6 = target x
        sub.s   f14, f6, f4                 // f14 = X_DIFF
        mul.s   f14, f14, f10               // f14 = X_DIFF * DIRECTION
        lwc1    f4, 0x0004(t8)              // f4 = player y
        lwc1    f6, 0x0004(t9)              // f6 = target y
        sub.s   f12, f6, f4                 // f12 = Y_DIFF
        jal     0x8001863C                  // f0 = atan2(f12,f14)
        nop
        mov.s   f12, f0                     // f12 = DIFF_ANGLE

        _get_turn_angle:
        mtc1    r0, f0                      // f0 = 0
        li      at, 0x40C90FE4              // ~
        mtc1    at, f2                      // f2 = 6.28319 rads/360 degrees
        li      at, 0xC0490FD0              // ~
        mtc1    at, f4                      // f4 = -3.14159 rads/-180 degrees


        lw      a0, 0x0044(sp)              // a0 = player struct
        li      at, TURN_SPEED              // sonics turn speed
        bnezl   v0, _apply_turn_speed


        _apply_turn_speed:
        mtc1    at, f6                      // f6 = TURN_SPEED
        lwc1    f10, 0x0B20(s0)             // f10 = current movement angle
        sub.s   f8, f12, f10                // f8 = angle difference: DIFF_ANGLE - current angle
        c.lt.s  f4, f8                      // ~
        nop                                 // ~
        bc1fl   _calculate_turn             // branch if angle difference < -180...
        add.s   f8, f8, f2                  // ...and add 360 degrees to angle differnece

        _calculate_turn:
        abs.s   f14, f8                     // f14 = absolute angle difference
        c.lt.s  f6, f14                     // ~
        nop                                 // ~
        bc1fl   _update_angle               // branch and immediately update if absolute angle difference < TURN_SPEED...
        mov.s   f10, f12                    // ...and set movement angle to DIFF_ANGLE
        c.lt.s  f0, f8                      // ~
        nop                                 // ~
        bc1fl   _apply_turn                 // branch if angle difference < 0...
        neg.s   f6, f6                      // ...and set f6 to -TURN_SPEED

        _apply_turn:
        add.s   f10, f10, f6                // f10 = previous angle + TURN_SPEED

        _update_angle:
        c.lt.s  f4, f10                     // ~
        nop                                 // ~
        bc1fl   pc() + 8                    // branch if new movement angle < -180...
        add.s   f10, f10, f2                // ...and add 360 degrees to movement angle
        swc1    f10, 0x0B20(s0)             // store updated movement angle
        lwc1    f12, 0x0044(s0)             // ~
        cvt.s.w f12, f12                    // f12 = direction
        lw      t0, 0x0004(s0)              // ~
        lw      t0, 0x0074(t0)              // t0 = top joint struct
        mul.s   f12, f12, f10               // f12 = movement angle * direction
        swc1    f12, 0x0038(t0)             // set joint rotation

        _apply_movement:
        // ultra64 cosf function
        jal     0x80035CD0                  // f0 = cos(f12)
        lwc1    f12, 0x0B20(s0)             // f12 = movement angle
        lwc1    f4, 0x0030(sp)              // f4 = SPEED
        mul.s   f4, f4, f0                  // f4 = x velocity (SPEED * cos(angle))
        swc1    f4, 0x0034(sp)              // 0x0034(sp) = x velocity
        // ultra64 sinf function
        jal     0x800303F0                  // f0 = sin(f12)
        lwc1    f12, 0x0B20(s0)             // f12 = movement angle
        lwc1    f4, 0x0030(sp)              // f4 = SPEED
        mul.s   f4, f4, f0                  // f4 = y velocity (SPEED * sin(angle))
        lwc1    f0, 0x0044(s0)              // ~
        cvt.s.w f0, f0                      // f0 = direction
        lwc1    f2, 0x0034(sp)              // f2 = x velocity
        mul.s   f2, f2, f0                  // f2 = x velocity * direction
        swc1    f2, 0x0048(s0)              // store updated x velocity
        swc1    f4, 0x004C(s0)              // store updated y velocity

        _end:
        lw      s0, 0x0024(sp)              // ~
        lw      ra, 0x0014(sp)              // load s0, ra
        jr      ra                          // return
        addiu   sp, sp, 0x0050              // deallocate stack space
    }

    // @ Description
    // Subroutine which handles collision for NSP_Move and NSP_Locked_Move.
    scope move_collision_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        li      a1, bounce_initial_         // a1(transition subroutine) = bounce_initial_
        jal     0x800DE6E4                  // common air collision subroutine (transition on landing, no ledge grab)
        nop
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0018              // deallocate stack space
    }


    // @ Description
    // Subroutine which begins NSP_Bounce.
    scope bounce_initial_: {
        addiu   sp, sp,-0x0030              // allocate stack space
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // store a0, ra

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.SONIC_NSP_Bounce
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.SONIC_NSP_Bounce

        lli     a1, Uzi.Action.NSP_Bounce // a1(action id) = NSP_Bounce
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      a0, 0x0020(sp)              // ~
        lw      a0, 0x0084(a0)              // a0 = player struct
        lui     t0, 0x3E80                  // ~
        mtc1    t0, f0                      // f0 = 0.25
        lwc1    f2, 0x0048(a0)              // f2 = x velocity
        mul.s   f2, f2, f0                  // ~
        swc1    f2, 0x0048(a0)              // multiply x velocity by 0.25 and update
        lui     at, BOUNCE_Y_SPEED          // at = BOUNCE_Y_SPEED
        sw      at, 0x004C(a0)              // set y velocity to BOUNCE_Y_SPEED
        lw      ra, 0x001C(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0030              // deallocate stack space
    }

    // @ Description
    // Subroutine which begins NSP_Ground_End.
    scope ground_end_initial_: {
        addiu   sp, sp,-0x0030              // allocate stack space
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // store a0, ra

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.SONIC_NSP_Ground_End
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.SONIC_NSP_Ground_End

        lli     a1, Uzi.Action.NSP_Ground_End2 // a1(action id) = NSP_Ground_End
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      a0, 0x0020(sp)              // ~
        lw      a0, 0x0084(a0)              // a0 = player struct
        lui     t0, 0x3F00                  // ~
        mtc1    t0, f0                      // f0 = 0.5
        lwc1    f2, 0x0060(a0)              // f2 = x velocity
        mul.s   f2, f2, f0                  // ~
        swc1    f2, 0x0060(a0)              // multiply x velocity by 0.5 and update
        lw      ra, 0x001C(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0030              // deallocate stack space
    }

    // @ Description
    // Subroutine which begins NSP_Air_End.
    scope air_end_initial_: {
        addiu   sp, sp,-0x0030              // allocate stack space
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // store a0, ra

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.SONIC_NSP_Air_End
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.SONIC_NSP_Air_End

        lli     a1, Uzi.Action.NSP_Air_End // a1(action id) = NSP_Air_End
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      a0, 0x0020(sp)              // ~
        lw      a0, 0x0084(a0)              // a0 = player struct
        lui     t0, 0x3F00                  // ~
        mtc1    t0, f0                      // f0 = 0.5
        lwc1    f2, 0x0048(a0)              // f2 = x velocity
        mul.s   f2, f2, f0                  // ~
        swc1    f2, 0x0048(a0)              // multiply x velocity by 0.5 and update
        lwc1    f2, 0x004C(a0)              // f2 = y velocity
        mul.s   f2, f2, f0                  // ~
        swc1    f2, 0x004C(a0)              // multiply y velocity by 0.5 and update
        lw      ra, 0x001C(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0030              // deallocate stack space
    }

    // @ Description
    // Collision subroutine for NSP_Ground_End.
    scope ground_end_collision_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        li      a1, air_end_transition_     // a1(transition subroutine) = air_end_transition_
        jal     0x800DDE84                  // common ground collision subroutine (transition on no floor, no slide-off)
        nop
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0018              // deallocate stack space
    }

    // @ Description
    // Collision subroutine for NSP_Air_End.
    scope air_end_collision_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        li      a1, ground_end_transition_  // a1(transition subroutine) = ground_end_transition_
        jal     0x800DE6E4                  // common air collision subroutine (transition on landing, no ledge grab)
        nop
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0018              // deallocate stack space
    }

    // @ Description
    // Subroutine which transitions to NSP_Ground_End.
    scope ground_end_transition_: {
        addiu   sp, sp,-0x0050              // allocate stack space
        sw      ra, 0x001C(sp)              // store ra
        sw      a0, 0x0038(sp)              // 0x0038(sp) = player object
        jal     0x800DEE98                  // set grounded state
        lw      a0, 0x0084(a0)              // a0 = player struct
        lw      a0, 0x0038(sp)              // a0 = player object

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.SONIC_NSP_Ground_End
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.SONIC_NSP_Ground_End

        lli     a1, Uzi.Action.NSP_Ground_End2 // a1(action id) = NSP_Ground_End
        lw      a2, 0x0078(a0)              // a2(starting frame) = current animation frame
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        lli     t6, 0x0001                  // ~
        jal     0x800E6F24                  // change action
        sw      t6, 0x0010(sp)              // argument 4 = 1 (continue hitbox)
        lw      ra, 0x001C(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0050              // deallocate stack space
    }

    // @ Description
    // Subroutine which transitions to NSP_Air_End.
    scope air_end_transition_: {
        addiu   sp, sp,-0x0050              // allocate stack space
        sw      ra, 0x001C(sp)              // store ra
        sw      a0, 0x0038(sp)              // 0x0038(sp) = player object
        jal     0x800DEEC8                  // set aerial state
        lw      a0, 0x0084(a0)              // a0 = player struct
        lw      a0, 0x0038(sp)              // a0 = player object

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.SONIC_NSP_Air_End
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.SONIC_NSP_Air_End

        lli     a1, Uzi.Action.NSP_Air_End // a1(action id) = NSP_Air_End
        lw      a2, 0x0078(a0)              // a2(starting frame) = current animation frame
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        lli     t6, 0x0001                  // ~
        jal     0x800E6F24                  // change action
        sw      t6, 0x0010(sp)              // argument 4 = 1 (continue hitbox)
        lw      a0, 0x0038(sp)              // a0 = player object
        jal     0x800D8EB8                  // momentum capture?
        lw      a0, 0x0084(a0)              // a0 = player struct
        lw      ra, 0x001C(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0050              // deallocate stack space
    }

    // @ Description
    // Subroutine which begins NSP_Air_Recoil.
    scope air_recoil_initial_: {
        addiu   sp, sp,-0x0030              // allocate stack space
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // store a0, ra

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.SONIC_NSP_Air_Recoil
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.SONIC_NSP_Air_Recoil

        lli     a1, Uzi.Action.NSP_Air_Recoil // a1(action id) = NSP_Air_Recoil
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      a0, 0x0020(sp)              // ~
        lw      a0, 0x0084(a0)              // a0 = player struct
        lwc1    f2, 0x0044(a0)              // ~
        cvt.s.w f2, f2                      // f2 = DIRECTION
        lui     at, RECOIL_X_SPEED          // ~
        mtc1    at, f4                      // f4 = RECOIL_X_SPEED
        mul.s   f4, f4, f2                  // f4 = RECOIL_X_SPEED * DIRECTION
        lui     at, RECOIL_Y_SPEED          // at = RECOIL_Y_SPEED
        swc1    f4, 0x0048(a0)              // set x velocity to RECOIL_X_SPEED
        sw      at, 0x004C(a0)              // set y velocity to RECOIL_Y_SPEED
        lw      ra, 0x001C(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0030              // deallocate stack space
    }

    // @ Description
    // Collision subroutine for NSP_Ground_Recoil.
    scope ground_recoil_collision_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        li      a1, air_recoil_transition_  // a1(transition subroutine) = air_recoil_transition_
        jal     0x800DDE84                  // common ground collision subroutine (transition on no floor, no slide-off)
        nop
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0018              // deallocate stack space
    }

    // @ Description
    // Collision subroutine for NSP_Air_Recoil.
    scope air_recoil_collision_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        li      a1, ground_recoil_transition_  // a1(transition subroutine) = ground_recoil_transition_
        jal     0x800DE6E4                  // common air collision subroutine (transition on landing, no ledge grab)
        nop
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0018              // deallocate stack space
    }

    // @ Description
    // Subroutine which transitions to NSP_Ground_Recoil.
    scope ground_recoil_transition_: {
        addiu   sp, sp,-0x0050              // allocate stack space
        sw      ra, 0x001C(sp)              // store ra
        sw      a0, 0x0038(sp)              // 0x0038(sp) = player object
        jal     0x800DEE98                  // set grounded state
        lw      a0, 0x0084(a0)              // a0 = player struct
        lw      a0, 0x0038(sp)              // a0 = player object

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.SONIC_NSP_Ground_Recoil
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.SONIC_NSP_Ground_Recoil

        lli     a1, Uzi.Action.NSP_Ground_Recoil // a1(action id) = NSP_Ground_Recoil
        lw      a2, 0x0078(a0)              // a2(starting frame) = current animation frame
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        lli     t6, 0x0001                  // ~
        jal     0x800E6F24                  // change action
        sw      t6, 0x0010(sp)              // argument 4 = 1 (continue hitbox)
        lw      ra, 0x001C(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0050              // deallocate stack space
    }

    // @ Description
    // Subroutine which transitions to NSP_Air_Recoil.
    scope air_recoil_transition_: {
        addiu   sp, sp,-0x0050              // allocate stack space
        sw      ra, 0x001C(sp)              // store ra
        sw      a0, 0x0038(sp)              // 0x0038(sp) = player object
        jal     0x800DEEC8                  // set aerial state
        lw      a0, 0x0084(a0)              // a0 = player struct
        lw      a0, 0x0038(sp)              // a0 = player object

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.SONIC_NSP_Air_Recoil
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.SONIC_NSP_Air_Recoil

        lli     a1, Uzi.Action.NSP_Air_Recoil // a1(action id) = NSP_Air_Recoil
        lw      a2, 0x0078(a0)              // a2(starting frame) = current animation frame
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        lli     t6, 0x0001                  // ~
        jal     0x800E6F24                  // change action
        sw      t6, 0x0010(sp)              // argument 4 = 1 (continue hitbox)
        lw      a0, 0x0038(sp)              // a0 = player object
        jal     0x800D8EB8                  // momentum capture?
        lw      a0, 0x0084(a0)              // a0 = player struct
        lw      ra, 0x001C(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0050              // deallocate stack space
    }

    scope ground_initial_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // store a0, ra

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.LANKY_NSP_Ground
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.LANKY_NSP_Ground

        lli     a1, Uzi.Action.NSPG5       // a1(action id) = NSPG
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      a0, 0x0020(sp)              // ~
        lw      a0, 0x0084(a0)              // ~
        sw      r0, 0x017C(a0)              // temp variable 1 = 0
        sw      r0, 0x0180(a0)              // temp variable 2 = 0
        sw      r0, 0x0184(a0)              // temp variable 3 = 0
        lli     at, 2                       // ~
        sw      at, 0x0B20(a0)              // ammo = 3
        lw      ra, 0x001C(sp)              // load ra
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Subroutine which runs when Lanky initiates an aerial neutral special.
    scope air_initial_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // store a0, ra

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.LANKY_NSP_Air
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.LANKY_NSP_Air

        lli     a1, Uzi.Action.NSPA5       // a1(action id) = NSPA
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      a0, 0x0020(sp)              // ~
        lw      a0, 0x0084(a0)              // ~
        sw      r0, 0x017C(a0)              // temp variable 1 = 0
        sw      r0, 0x0180(a0)              // temp variable 2 = 0
        sw      r0, 0x0184(a0)              // temp variable 3 = 0
        lli     at, 2                       // ~
        sw      at, 0x0B20(a0)              // ammo = 3
        lw      ra, 0x001C(sp)              // load ra
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Main subroutine for neutral special.
    // If temp variable 1 is set by moveset, create a projectile.
    scope main_: {
        addiu   sp, sp,-0x0040              // allocate stack space
        sw      ra, 0x0014(sp)              // 0x0014(sp) = ra
        sw      a0, 0x0034(sp)              // 0x0034(sp) = player object
        addu    a2, a0, r0                  // a2 = player object
        lw      v0, 0x0084(a0)              // v0 = player struct
        lw      t6, 0x017C(v0)              // t6 = temp variable 1
        beq     t6, r0, _cancel_check       // skip if temp variable 1 = 0
        sw      r0, 0x017C(v0)              // reset temp variable 1 to 0

        // if we're here, then temp variable 1 was enabled, so create a projectile
        lw      t6, 0x0008(v0)              // t6 = current character ID
        lli     at, Kirby.Action.LANKY_NSP_Ground - Uzi.Action.NSPG
        // if kinetic state = aerial
        lli     at, Kirby.Action.LANKY_NSP_Air - Uzi.Action.NSPA
        lw      a2, 0x0008(v0)              // a2 = current character ID
        lli     t6, Character.id.KIRBY      // t6 = id.KIRBY
        beq     t6, a2, _kirby              // branch if Kirby
        lli     t6, Character.id.JKIRBY     // t6 = id.JKIRBY
        beq     t6, a2, _kirby              // branch if JKirby
        lw      a0, 0x0930(v0)              // a0 = part 0xE (weapon) struct
        sw      r0, 0x0020(sp)              // x offset = 0
        lui     at, 0xC348                  // ~
        sw      at, 0x0024(sp)              // y offset = -200
        b       _continue
        sw      r0, 0x0028(sp)              // z offset = 0

        _kirby:
        lw      a0, 0x092C(v0)              // a0 = part 0xD (weapon) struct
        lui     at, 0x4396                  // ~
        sw      at, 0x0020(sp)              // x offset = 200
        sw      r0, 0x0024(sp)              // y offset = 0
        sw      r0, 0x0028(sp)              // z offset = 0

        _continue:
        addiu   a1, sp, 0x0020              // a1 = address to return x/y/z coordinates to
        jal     0x800EDF24                  // returns x/y/z coordinates of the part in a0 to a1
        sw      v0, 0x002C(sp)              // 0x002C(sp) = player struct
        sw      r0, 0x0028(sp)              // set z coordinate to 0
        lw      v0, 0x002C(sp)              // v0 = player struct
        lw      a0, 0x0034(sp)              // a0 = player object
        jal     grape_stage_setting_        // INITIATE GRAPE
        addiu   a1, sp, 0x0020              // a1 = coordinates to create projectile at
        lw      a0, 0x0034(sp)              // a0 = player object
        lw      v0, 0x0084(a0)              // v0 = player struct

        _cancel_check:
        lw      t6, 0x0180(v0)              // t6 = temp variable 2
        beq     t6, r0, _idle_check         // skip if temp variable 2 = 0
        lhu     t7, 0x01BE(v0)              // t7 = buttons_pressed



        // if B was pressed
        lw      t0, 0x0B20(v0)              // t0 = ammo
        addiu   at, t0,-0x0001              // at = ammo - 1
        sw      at, 0x0B20(v0)              // store updated ammo...
        beqzl   t0, _idle_check             // skip if ammo = 0
        sw      r0, 0x0B20(v0)              // and set ammo to 0
        lw      a2, 0x014C(v0)              // a2 = kinetic state
        beqz    a2, pc() + 12               // branch if kinetic state = grounded
        // if kinetic state = grounded
        lli     a1, Uzi.Action.NSPG
        // if kinetic state = aerial
        lli     a1, Uzi.Action.NSPA
        beqz    a2, pc() + 12               // branch if kinetic state = grounded
        // if kinetic state = grounded
        lli     at, Kirby.Action.LANKY_NSP_Ground - Uzi.Action.NSPG
        // if kinetic state = aerial
        lli     at, Kirby.Action.LANKY_NSP_Air - Uzi.Action.NSPA
        lw      a2, 0x0008(v0)              // a2 = current character ID
        lli     t6, Character.id.KIRBY      // t6 = id.KIRBY
        beql    t6, a2, pc() + 20           // if Kirby, adjust action ID
        addu    a1, a1, at
        lli     t6, Character.id.JKIRBY     // t6 = id.JKIRBY
        beql    t6, a2, pc() + 8            // if J Kirby, adjust action ID
        addu    a1, a1, at
        lw      a0, 0x0034(sp)              // a0 = player object
        lui     a2, 0x4160                  // a2(starting frame) = 14
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0034(sp)              // a0 = player object

        lw      a0, 0x0034(sp)              // a0 = player object
        lw      v0, 0x0084(a0)              // v0 = player struct
        sw      r0, 0x0180(v0)              // reset temp variable 2

        _idle_check:
        // checks the current animation frame to see if we've reached end of the animation
        mtc1    r0, f6                      // ~
        lwc1    f8, 0x0078(a0)              // ~
        c.le.s  f8, f6                      // ~
        nop
        bc1fl   _end                        // skip if animation end has not been reached
        nop
        jal     0x800DEE54                  // transition to idle
        nop

        _end:
        lw      ra, 0x0014(sp)              // load ra
        jr      ra
        addiu   sp, sp, 0x0040              // deallocate stack space
    }


    // @ Description
    // Subroutine which sets up the initial properties for the projectile.
    // TODO: this is still largely uncommented, and may contain leftover logic that isn't needed.
    scope grape_stage_setting_: {
        constant MAX_POWER(5)
        addiu   sp, sp, -0x0050
        sw      s0, 0x0018(sp)
        li      s0, grape_properties_struct // s0 = projectile properties struct address
        sw      a1, 0x0034(sp)
        sw      ra, 0x001C(sp)
        lw      t6, 0x0084(a0)
        lw      t0, 0x0024(s0)
        lw      t1, 0x0028(s0)
        li      a1, grape_projectile_struct // a1 = main projectile struct address
        lw      a2, 0x0034(sp)
        lui     a3, 0x8000
        sw      t6, 0x002C(sp)              // 0x002C(sp) = player struct
        jal     0x801655C8                  // This is a generic routine that does much of the work for defining all projectiles
        sw      t1, 0x000C(a1)

        beq     v0, r0, _end_stage_setting  // if 801655C8 returns 0, there's no space to create a new projectile object, so skip to end
        nop

        _projectile_branch:
        sw      v0, 0x0028(sp)              // 0x0028(sp) = projectile object
        lw      v1, 0x0084(v0)              // v1 = projectile struct
        lw      t3, 0x0000(s0)              // t3 = duration
        sw      t3, 0x0268(v1)              // store duration
        lw      t4, 0x002C(sp)              // t4 = player struct
        lw      t5, 0x014C(t4)              // t5 = kinetic state
        beq     t5, r0, _continue           // branch if kinetic state = grounded
        lwc1    f12, 0x0018(s0)             // f12 = initial angle (ground)
        lwc1    f12, 0x001C(s0)             // f12 = initial angle (air)

        _continue:
        mtc1    r0, f4                      // f4 = 0
        swc1    f4, 0x0028(v1)              // set z speed? to 0
        swc1    f12, 0x0020(sp)             // 0x0020(sp) = adjusted angle
        jal     0x80035CD0                  // ~
        sw      v1, 0x0024(sp)              // original logic

        lwc1    f6, 0x0020(s0)              // f6 = initial projectile speed
        lw      t6, 0x002C(sp)              // ~
        lw      v1, 0x0024(sp)              // ~
        lw      t7, 0x0044(t6)              // ~
        mul.s   f8, f0, f6                  // ~
        lwc1    f12, 0x0020(sp)             // ~
        mtc1    t7, f10                     // ~
        nop                                 // ~
        cvt.s.w f16, f10                    // ~
        mul.s   f18, f8, f16                // ~
        jal     0x800303F0                  // ~
        swc1    f18, 0x0020(v1)             // original logic

        lwc1    f4, 0x0020(s0)              // f4 = initial projectile speed
        lw      v1, 0x0024(sp)              // ~
        lw      a0, 0x0028(sp)              // ~
        mul.s   f6, f0, f4                  // ~
        swc1    f6, 0x0024(v1)              // ~
        lw      t8, 0x0074(a0)              // ~
        lwc1    f10, 0x002C(s0)             // ~
        lw      t9, 0x0080(t8)              // ~
        jal     0x80167FA0                  // ~
        swc1    f10, 0x0088(t9)             // ~
        lw      v0, 0x0028(sp)              // original logic

        _end_stage_setting:
        lw      ra, 0x001C(sp)
        lw      s0, 0x0018(sp)
        addiu   sp, sp, 0x0050
        jr      ra
        nop
    }

    // @ Description
    // Main subroutine for the grape.
    scope grape_main_: {
        addiu   sp, sp, 0xFFE0              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        sw      a0, 0x0020(sp)              // 0x0020(sp) = projectile object
        lw      a0, 0x0084(a0)              // a0 = projectile struct
        jal     0x80167FE8                  // original logic, subroutine returns 1 if projectile duration is over
        sw      a0, 0x001C(sp)              // 0x001C(sp) = projectile struct
        beq     v0, r0, _continue           // branch if projectile duration has not ended
        lw      a0, 0x001C(sp)              // a0 = projectile struct

        _end_duration:
        lw      t7, 0x0020(sp)              // t7 = projectile object
        lw      a0, 0x0074(t7)              // ~
        addiu   a0, a0, 0x001C              // a0 = projectile x/y/z coords
        jal     0x800FF648                  // create smoke gfx
        lui     a1, 0x3F80                  // a1 = 1.0
        b       _end                        // branch to end
        lli     v0, OS.TRUE                 // return TRUE (destroys projectile)

        _continue:
        li      v0, grape_properties_struct // v0 = grape_properties_struct
        lw      a1, 0x000C(v0)              // a1 = gravity
        jal     0x80168088                  // apply gravity to grape
        lw      a2, 0x0004(v0)              // a2 = max speed
        lw      a0, 0x001C(sp)              // a0 = projectile struct
        lw      t1, 0x0020(sp)              // t1 = projectile object
        lw      v1, 0x0074(t1)              // v1 = projectile struct with coordinates/rotation etc (bone struct?)
        li      at, grape_properties_struct // at = grape properties struct
        lwc1    f6, 0x0014(at)              // f6 = rotation speed
        lwc1    f4, 0x0030(v1)              // f4 = current rotation
        add.s   f8, f4, f6                  // add rotation speed to current rotation
        swc1    f8, 0x0030(v1)              // update rotation
        lli     v0, OS.FALSE                // return FALSE (don't destroy)

        _end:
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Collision subroutine for the grape.
    // Based on 0x801688C4, which is the equivalent for Charge Shot.
    scope grape_collision_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x00014(sp)             // store ra

        jal     0x80167C04                  // general collision detection?
        sw      a0, 0x0018(sp)              // 0x0018(sp) = projectile object
        beqz    v0, _end                    // end if collision wasn't detected
        lw      a0, 0x0018(sp)              // a2 = projectile object
        // if collision was detected
        jal     grape_destruction_
        nop

        _end:
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // This subroutine spawns a hit effect and destroys the GRAPE
    scope grape_hit_: {
        addiu   sp, sp,-0x0028              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        sw      a0, 0x0018(sp)              // 0x0018(sp) = projectile object
        lw      v1, 0x0084(a0)              // v1 = projectile struct
        lw      a0, 0x0074(a0)              // ~
        addiu   a0, a0, 0x001C              // a0 = x/y/z coordinates
        or      a1, r0, r0                  // a1 = 0
        lw      a2, 0x0234(v1)              // a2 = damage
        jal     0x800FDC04                  // create "normal hit" gfx
        or      a3, r0, r0                  // a3 = 0
        jal     grape_destruction_          // destroy the grape
        lw      a0, 0x0018(sp)              // a0 = projectile obect
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0028              // deallocate stack space
    }

    // @ Description
    // This subroutine destroys the grape and creates a smoke gfx.
    scope grape_destruction_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        lw      a0, 0x0074(a0)              // ~
        addiu   a0, a0, 0x001C              // a0 = projectile x/y/z coords
        jal     0x800FF648                  // create smoke gfx
        lui     a1, 0x3F80                  // a1 = 1.0
        jal     0x800269C0                  // play FGM
        lli     a0, 18                    // FGM id = 1521
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0018              // deallocate stack space
        jr      ra                          // return
        lli     v0, OS.TRUE                 // return TRUE (destroys projectile)
    }

    OS.align(16)
    grape_projectile_struct:
    constant NUT_ID(0x1001)
    dw 0x00000000                           // unknown
    dw NUT_ID                               // projectile id
    dw Character.UZI_file_6_ptr           // address of conker's file 6 pointer
    dw 0x00000000                           // offset to hitbox
    dw 0x12470000                           // This determines z axis rotation? (samus is 1246)
    dw grape_main_                          // This is the main subroutine for the projectile, handles duration and other things. (default 0x80168540) (samus 0x80168F98)
    dw grape_collision_                     // This is the collision subroutine for the projectile, responsible for detecting collision with clipping.
    dw 0                           // This function runs when the projectile collides with a hurtbox.
    dw grape_destruction_                   // This function runs when the projectile collides with a shield.
    dw 0x801686F8                           // This function runs when the projectile collides with edges of a shield and bounces off
    dw grape_destruction_                   // This function runs when the projectile collides/clangs with a hitbox.
    dw 0x801692C4                           // This function runs when the projectile collides with Fox's reflector (default 0x80168748)
    dw grape_destruction_                   // This function runs when the projectile collides with Ness's psi magnet
    OS.copy_segment(0x103904, 0x0C)         // empty

    OS.align(16)
    grape_properties_struct:
    dw 300                                   // 0x0000 - duration (int)
    float32 500                              // 0x0004 - max speed
    float32 50                               // 0x0008 - min speed
    float32 0.5                               // 0x000C - gravity
    float32 0                               // 0x0010 - bounce multiplier
    float32 0.1                           // 0x0014 - rotation speed
    float32 0.5                               // 0x0018 - initial angle (ground)
    float32 0.5                               // 0x001C   initial angle (air)
    float32 80                              // 0x0020   initial speed
    dw Character.UZI_file_6_ptr           // 0x0024   projectile data pointer
    dw 0x00000000                           // 0x0028   unknown (default 0)
    float32 1                           // 0x002C   palette index (0 = mario, 1 = luigi)


}

scope UziDSPA {

    constant AERIAL_INITIAL_Y_SPEED(0x4100) // DSP rise
    constant X_SPEED(0x4270)                // current setting - float:60
    constant Y_SPEED(0xC30C)                // current setting - float:-140.0
    constant INITIAL_Y_SPEED(0x4334)        // current setting - float:180.0
    constant BEGIN(0x1)
    constant MOVE(0x2)

    // @ Description
    // Subroutine which runs when Dragon King initiates an aerial down special.
    // Changes action, and sets up initial variable values.
    scope air_initial_: {
        addiu   sp, sp,-0x0020              // ~
        sw      ra, 0x001C(sp)              // ~
        addiu   t6, r0, 0x0008              // ~
        sw      a0, 0x0020(sp)              // ~
        sw      t6, 0x0010(sp)              // original begin logic
        ori     a1, r0, Uzi.Action.DSPA_BEGIN               // a1 = action id: DSP Begin
        ori     a2, r0, 0x0000              // a2 = 0 (begin action frame)
        jal     0x800E6F24                  // change action
        lui     a3, 0x3F80                  // a2 = float: 1.0
        jal     0x800E0830                  // unknown original subroutine
        lw      a0, 0x0020(sp)              // unknown original subroutine
        lw      a0, 0x0020(sp)              // ~
        lw      a0, 0x0084(a0)              // a0 = player struct
        sw      r0, 0x017C(a0)              // temp variable 1 = 0
        sw      r0, 0x0180(a0)              // temp variable 2 = 0
        ori     v1, r0, 0x0001              // ~
        sw      v1, 0x0184(a0)              // temp variable 3 = 0x1(BEGIN)
        // reset fall speed
        lbu     v1, 0x018D(a0)              // v1 = fast fall flag
        ori     t6, r0, 0x0007              // t6 = bitmask (01111111)
        and     v1, v1, t6                  // ~
        sb      v1, 0x018D(a0)              // disable fast fall flag
        lw      ra, 0x001C(sp)              // ~
        jr      ra                          // original return logic
        addiu   sp, sp, 0x0020              // ~
    }

    // Main subroutine for DSPA
    scope aerial_main_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        lw      t8, 0x014C(a2)              // t8 = kinetic state
        li      a1, loop_initial_           // a1(transition subroutine) = loop_initial_
        jal     0x800D9480                  // common main subroutine (transition on animation end)
        nop
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0018              // deallocate stack space
    }

    // @ Description
    // Subroutine which handles physics for Dragon King's down special.
    // Prevents player control when temp variable 2 = 0
    // Prevents negative Y velocity when temp variable 3 = 1 (BEGIN)
    scope physics_: {
        // 0x180 in player struct = temp variable 2

        addiu   sp, sp,-0x0018              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      t1, 0x0008(sp)              // ~
        sw    	ra, 0x000C(sp)              // ~
        sw      a0, 0x0010(sp)              // store t0, t1, ra, a0
        lw      t0, 0x0084(a0)              // t0 = player struct
        lw      t1, 0x0180(t0)              // t1 = temp variable 2
        li      t8, 0x800D91EC              // t8 = physics subroutine which prevents player control
        bnez    t1, _subroutine             // skip if t1 != 0
        nop

        li      t8, 0x800D90E0              // t8 = physics subroutine which allows player control
        _subroutine:
        jalr      t8                        // run physics subroutine
        nop

        _check_fall:
        lw      a0, 0x0010(sp)              // ~
        lw      a0, 0x0084(a0)              // a0 = player struct
        lw      t0, 0x0184(a0)              // t0 = temp variable 3
        ori     t1, r0, BEGIN               // t1 = BEGIN
        bne     t0, t1, _check_move         // skip if temp variable 3 != BEGIN
        nop

        _check_move:
        lw      t0, 0x0024(a0)              // action id
        addiu   at, r0, Uzi.Action.DSPA_LOOP               // action = DSPA Loop
        beq     at, t0, _moving_down        // branch if in DSPALoop
        lw      t0, 0x0184(a0)              // t0 = temp variable 3
        ori     t1, r0, MOVE                // t1 = MOVE
        bne     t0, t1, _apply_y_speed      // skip if t0 != MOVE
        lui     t1, AERIAL_INITIAL_Y_SPEED  // moving up y speed
        _moving_down:
        lui     t0, X_SPEED                 // ~
        mtc1    t0, f2                      // f2 = X_SPEED
        lwc1    f0, 0x0044(a0)              // ~
        cvt.s.w f0, f0                      // f0 = direction
        mul.s   f2, f0, f2                  // f2 = x velocity * direction
        lui     t1, Y_SPEED                 // moving down y speed
        _apply_y_speed:
        swc1    f2, 0x0048(a0)              // x velocity = X_SPEED
        sw      t1, 0x004C(a0)              // y velocity = Y_SPEED

        _end:
        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // ~
        lw      ra, 0x000C(sp)              // ~
        lw      a0, 0x0010(sp)              // load t0, t1, ra, a0
        jr      ra                          // return
        addiu   sp, sp, 0x0018              // deallocate stack space
    }

    // @ Description
    // Subroutine which handles collision for Dragon King's down special.
    // Transitions into the down special landing action when temp variable 3 = MOVE,
    // otherwise lands normally.
    scope collision_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      a0, 0x0010(sp)              // ~
        sw      ra, 0x0014(sp)              // store ra, a0
        lw      a1, 0x0084(a0)              // a1 = player struct
        lw      v0, 0x014C(a1)              // v0 = kinetic state
        bnez    v0, _aerial                 // branch if kinetic state != grounded
        nop

        _grounded:
        jal     0x800DDF44                  // grounded collision subroutine
        nop
        b       _end                        // branch to end
        nop

        _aerial:
        lw      v0, 0x184(a1)               // v0 = temp variable 3
        ori     t0, r0, MOVE                // a1 = MOVE
        beq     t0, v0, _main_collision     // branch if temp variable 3 = MOVE
        addiu   at, r0, Uzi.Action.DSPA_LOOP               // DSP loop action
        lw      v1, 0x0024(a1)              // current action
        beq     at, v1, _main_collision     // branch if doing aerial loop action
        nop

        // If Dragon King is not in the earthquake motion, run a normal aerial collision subroutine
        // instead.
        jal     0x800DE978                  // aerial collision subroutine
        nop
        b       _end                        // branch to end
        nop

        _main_collision:
        li      a1, landing_initial_        // a1 = landing_initial_
        jal     0x800DE80C                  // common air collision subroutine (transition on landing, allow ledge grab)
        lw      a0, 0x0010(sp)              // load a0

        _end:
        lw      ra, 0x0014(sp)              // load ra
        jr      ra
        addiu   sp, sp, 0x0018              // deallocate stack space
    }

    // @ Description
    // Initial for Dragon King's DSP loop
    // Changes action, and sets up initial variable values.
    scope loop_initial_: {
        addiu   sp, sp,-0x0020              // ~
        sw      ra, 0x001C(sp)              // ~
        addiu   t6, r0, 0x0001              // ~
        sw      a0, 0x0020(sp)              // ~
        sw      t6, 0x0010(sp)              // original begin logic
        ori     a1, r0, Uzi.Action.DSPA_LOOP               // a1 = action id: DragonKing DSPA Loop
        ori     a2, r0, 0x0000              // a2 = 0 (begin action frame)
        jal     0x800E6F24                  // change action
        lui     a3, 0x3F80                  // a2 = float: 1.0
        jal     0x800E0830                  // unknown original subroutine
        lw      a0, 0x0020(sp)              // unknown original subroutine
        lw      a0, 0x0020(sp)              // ~
        lw      a0, 0x0084(a0)              // a0 = player struct
        sw      r0, 0x017C(a0)              // temp variable 1 = 0
        sw      r0, 0x0180(a0)              // temp variable 2 = 0
        sw      r0, 0x0184(a0)              // temp variable 2 = 0
        lw      ra, 0x001C(sp)              // ~
        jr      ra                          // original return logic
        addiu   sp, sp, 0x0020              // ~
    }

    // @ Description
    // Initial function for DSPLanding
    // Copy of subroutine 0x801600EC, which begins the landing action for Falcon Kick.
    // Loads the appropriate landing action for Dark Samus.
    scope landing_initial_: {
        // Copy the first 6 lines of subroutine 0x801600EC
        OS.copy_segment(0xDAB2C, 0x18)
        // Replace original line which loads the landing action id
        // addiu   a1, r0, 0x00E8           // replaced line
        lw      t6, 0x0084(a0)              // t6 = player struct
        lui     at, 0x3F00                  // ~
        mtc1    at, f2                      // f2 = 0.625
        lwc1    f4, 0x0060(t6)              // f4 = ground x velocity
        mul.s   f4, f4, f2                  // f4 = ground x velocity * 0.625
        swc1    f4, 0x0060(t6)              // store updated ground x velocity
        addiu   a1, r0, Uzi.Action.DSPA_LAND              // DSP landing action
        // Copy the last 8 lines of subroutine 0x801600EC
        OS.copy_segment(0xDAB48, 0x20)
    }
}