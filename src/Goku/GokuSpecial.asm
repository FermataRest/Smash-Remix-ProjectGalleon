// GoemonSpecial.asm

// This file contains subroutines used by Goemon's special moves.

scope GokuNSP {
    constant WALK_MULTIPLIER(0x3E80)        // float32 0.25
    constant WALK_TRACTION(0x41F0)          // float32 30
    constant AIR_SPEED(0x41E0)              // float32 28
    constant CHARGE_TIME4(210)
    constant CHARGE_TIME3(140)
    constant CHARGE_TIME2(70)
    constant CHARGE_TIME(0)
    constant SFX_RYO_SHOOT_1(1612)
    constant SFX_RYO_SHOOT_2(1613)
    constant SFX_RYO_SHOOT_3(1614)
    constant SFX_RYO_SHOOT_4(1615)

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

        lli     a1, Goku.Action.NSP_Ground_Begin // a1(action id) = NSP_Ground_Begin
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
        addiu   sp, sp,-0x0028              // allocate stack space
        sw      ra, 0x0014(sp)              // ~
        sw      a0, 0x0018(sp)              // store ra, a0
        lli     a1, Goku.Action.NSP_Air_Begin // a1(action id) = NSP_Air_Begin
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        jal     0x800E0830                  // known common subroutine (plays first animation frame)
        lw      a0, 0x0018(sp)              // a0 = player object

        lw      a0, 0x0018(sp)              // a0 = player object
        lw      a0, 0x0018(sp)              // a0 = player object
        lw      v1, 0x0084(a0)              // v1 = player struct
        sw      r0, 0x017C(v1)              // temp variable 1 = 0
        sw      r0, 0x0180(v1)              // temp variable 2 = 0
        sw      r0, 0x0184(v1)              // temp variable 3 = 0
        lli     t0, 10                      // ~
        sw      t0, 0x0B28(v1)              // set gravity delay
        lui     t0, 0x3FA0                  // ~
        mtc1    t0, f0                      // f0 = 1.25
        lwc1    f2, 0x0048(v1)              // f2 = x velocity
        mul.s   f2, f2, f0                  // ~
        swc1    f2, 0x0048(v1)              // multiply x velocity by 1.25 and update
        lui     t0, 0xC0A0                  // ~
        sw      t0, 0x004C(v1)              // y velocity = 0
        beqz    v0, _end                    // branch if no gfx object created
        sw      v0, 0x0B24(v1)              // store gfx object
        lbu     t0, 0x018F(v1)              // ~
        ori     t0, t0, 0x0010              // ~
        sb      t0, 0x018F(v1)              // enable is_attach_effect bitflag

        _end:
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0028              // deallocate stack space


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

        lli     a1, Goku.Action.NSP_Ground_Wait // a1(action id) = NSP_Ground_Wait
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

        lli     a1, Goku.Action.NSP_Air_Wait // a1(action id) = NSP_Air_Wait
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

        lli     a1, Goku.Action.NSP_Ground_End // a1(action id) = NSP_Ground_End
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

        lli     a1, Goku.Action.NSP_Air_End // a1(action id) = NSP_Ground_End
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

        j       _continue


        _continuet:
        lw      t7, 0x0B18(v0)              // t7 = charge timer
        addiu   t7, t7, 0x0001              // ~
        sw      t7, 0x0B18(v0)              // increment charge timer
        lh      t7, 0x01BC(v0)              // t7 = buttons_held
        andi    t7, t7, Joypad.B            // t7 = 0x0020 if (B_HELD); else t7 = 0
        bnez    t7, _end                    // branch if (B_HELD)
        nop


        // if we reach this point, the b button is not being held, so transition to ending action
        jal     ground_end_initial_         // transition to NSP_Ground_End
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
        addiu   a1, r0, Goku.Action.NSPG  // insert action in a1
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
        bne     t7, at, _continue           // branch if charge timer != CHARGE_TIME
        sw      a0, 0x0018(sp)              // 0x0018(sp) = player object

        // if we reach this point play a sound, begin the GFX routine and set the charge flag
        lli     at, OS.TRUE                 // ~
        sw      at, 0x0B1C(v0)              // set charge flag to TRUE
        jal     0x800269C0                  // play FGM
        lli     a0, 28                      // FGM id = 28
        jal     0x800269C0                  // play FGM
        lli     a0, 65                      // FGM id = 65
        lli     a1, GFXRoutine.id.GOEMON_CHARGE // a1 = GOEMON_CHARGE id
        or      a2, r0, r0                  // a2 = 0
        jal     0x800E9814                  // begin gfx routine
        lw      a0, 0x0018(sp)              // a0 = player object
        lw      a0, 0x0018(sp)              // a0 = player object
        lw      v0, 0x0084(a0)              // v0 = player struct

        _continue:
        lw      t7, 0x0B18(v0)              // t7 = charge timer
        addiu   t7, t7, 0x0001              // ~
        sw      t7, 0x0B18(v0)              // increment charge timer
        lh      t7, 0x01BC(v0)              // t7 = buttons_held
        andi    t7, t7, Joypad.B            // t7 = 0x0020 if (B_HELD); else t7 = 0
        bnez    t7, _end                    // branch if (B_HELD)
        nop

        // if we reach this point, the b button is not being held, so transition to ending action
        jal     air_end_initial_            // transition to NSP_Air_End
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
        addiu   at, r0, Character.id.GOKU

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
        lli     a1, Goku.Action.NSP_Ground_BWalk2 // a1 = Action.NSP_Ground_BWalk2
        slti    at, t6, -9                  // at = 1 if stick_x < -9, else at = 0
        bnezl   at, _check_transition       // branch if stick_x < -9
        lli     a1, Goku.Action.NSP_Ground_BWalk1 // a1 = Action.NSP_Ground_BWalk1
        slti    at, t6, 10                  // at = 1 if stick_x < 10, else at = 0
        bnezl   at, _check_transition       // branch if stick_x < 10
        lli     a1, Goku.Action.NSP_Ground_Wait // a1 = Action.NSP_Ground_Wait
        slti    at, t6, 45                  // at = 1 if stick_x < 45, else at = 0
        bnezl   at, _check_transition       // branch if stick_x < 45
        lli     a1, Goku.Action.NSP_Ground_Walk1 // a1 = Action.NSP_Ground_Walk1
        // if here stick_x >= 45
        lli     a1, Goku.Action.NSP_Ground_Walk2 // a1 = Action.NSP_Ground_Walk2


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
        lli     at, Goku.Action.NSP_Ground_Wait // at = NSP_Ground_Wait
        beql    t5, at, _end                // branch if current action = NSP_Ground_Wait...
        or      a2, r0, r0                  // ...a2 = starting frame = 0
        beql    a2, at, _end                // branch if target action = NSP_Ground_Wait...
        or      a2, r0, r0                  // ...a2 = starting frame = 0

        addiu   at, t5, -Goku.Action.NSP_Ground_Wait
        sll     at, at, 0x2                 // at = table index for current action
        addu    t7, t6, at                  // t7 = cycle_length_table + current action index
        addiu   at, a1, -Goku.Action.NSP_Ground_Wait
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
        addiu   t7, t7, -Goku.Action.NSP_Ground_Begin
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
        addiu   t7, t7, -Goku.Action.NSP_Air_Begin
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
    dh Goku.Action.NSP_Air_Begin          // NSP_Ground_Begin
    dh Goku.Action.NSP_Air_Wait           // NSP_Ground_Wait
    dh Goku.Action.NSP_Air_Wait           // NSP_Ground_Walk1
    dh Goku.Action.NSP_Air_Wait           // NSP_Ground_Walk2
    dh Goku.Action.NSP_Air_Wait           // NSP_Ground_BWalk1
    dh Goku.Action.NSP_Air_Wait           // NSP_Ground_BWalk2
    dh Goku.Action.NSP_Air_End            // NSP_Ground_End
    OS.align(4)

    air_to_ground_table:
    dh Goku.Action.NSP_Ground_Begin       // NSP_Air_Begin
    dh Goku.Action.NSP_Ground_Wait        // NSP_Air_Wait
    dh Goku.Action.NSP_Ground_End         // NSP_Air_End
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
        FGM.play(SFX_RYO_FIRE)              // play FGM

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
    dw Character.GOKU_file_6_ptr          // address of goemon's file 6 pointer
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
    dw Character.GOKU_file_6_ptr          // address of goemon's file 6 pointer
    dw 0x00000080                           // offset to hitbox
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
    dw Character.GOKU_file_6_ptr          // address of goemon's file 6 pointer
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
    dw Character.GOKU_file_6_ptr          // 0x0024   projectile data pointer
    dw 0x00000000                           // 0x0028   offset to hitbox
    dw 0x00000000                           // 0x002C   palette index (0 = mario, 1 = luigi)

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
    dw Character.GOKU_file_6_ptr          // 0x0024   projectile data pointer
    dw 0x00000040                           // 0x0028   offset to hitbox
    dw 0x00000000                           // 0x002C   palette index (0 = mario, 1 = luigi)



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

        lli     a1, Goku.Action.NSPG       // a1(action id) = NSPG
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
        lli     at, 5                       // ~
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

        lli     a1, Goku.Action.NSPA       // a1(action id) = NSPA
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
        lli     at, Kirby.Action.LANKY_NSP_Ground - Goku.Action.NSPG
        // if kinetic state = aerial
        lli     at, Kirby.Action.LANKY_NSP_Air - Goku.Action.NSPA
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
        lli     a1, Goku.Action.NSPG
        // if kinetic state = aerial
        lli     a1, Goku.Action.NSPA
        beqz    a2, pc() + 12               // branch if kinetic state = grounded
        // if kinetic state = grounded
        lli     at, Kirby.Action.LANKY_NSP_Ground - Goku.Action.NSPG
        // if kinetic state = aerial
        lli     at, Kirby.Action.LANKY_NSP_Air - Goku.Action.NSPA
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
        constant MAX_POWER(4)
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
        lli     a0, 1521                    // FGM id = 1521
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
    dw Character.GOKU_file_6_ptr           // address of conker's file 6 pointer
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
    dw 70                                   // 0x0000 - duration (int)
    float32 150                              // 0x0004 - max speed
    float32 0                               // 0x0008 - min speed
    float32 0                               // 0x000C - gravity
    float32 0                               // 0x0010 - bounce multiplier
    float32 0                             // 0x0014 - rotation speed
    float32 0                               // 0x0018 - initial angle (ground)
    float32 0                               // 0x001C   initial angle (air)
    float32 60                              // 0x0020   initial speed
    dw Character.GOKU_file_6_ptr           // 0x0024   projectile data pointer
    dw 0x00000000                           // 0x0028   unknown (default 0)
    dw 0x00000000                           // 0x002C   palette index (0 = mario, 1 = luigi)


}


scope GokuUSP {
    constant MAX_X_RANGE(0x450A)            // current setting - float: 2208
    constant MIN_Y_RANGE(0x447A)            // current setting - float: 1000
    constant MAX_X_RANGE_SS(0x45BB)         // current setting (Super Sonic) - float: 5984
    constant MIN_Y_RANGE_SS(0x457A)         // current setting (Super Sonic) - float: 4000
    constant SPEED(0x42DC)                  // current setting - float: 110
    constant LOCKED_SPEED(0x4302)           // current setting - float: 130
    constant SPEED_SS(0x4302)               // current setting (Super Sonic) - float: 130
    constant LOCKED_SPEED_SS(0x4302)        // current setting (Super Sonic) - float: 130
    constant RECOIL_X_SPEED(0xC1A0)         // current setting - float: -20
    constant RECOIL_Y_SPEED(0x42A0)         // current setting - float: 80
    constant BOUNCE_Y_SPEED(0x4270)         // current setting - float: 60
    constant TURN_SPEED(0x3E0EFA1E)         // current setting - float: 0.139626 rads/8 degrees
    constant TURN_SPEED_SS(0x3CD7)          // current setting - float: 0.026 rads/1.5 degrees
    constant DEFAULT_ANGLE(0xBEBBA861)      // current setting - float: -0.366519 rads/-21 degrees
    constant MAX_INITAL_ANGLE(0x3F1C61A6)   // current setting - float: 0.610865 rads/35 degrees
    constant MIN_INITAL_ANGLE(0xBF1C61A6)   // current setting - float: -0.610865 rads/-35 degrees
    constant DURATION(12)
    constant LOCKED_DURATION(20)
    constant WALL_COLLISION_L(0x0001)       // bitmask for wall collision
    constant WALL_COLLISION_R(0x0020)       // bitmask for wall collision
    constant MOVE(0x2)

    // returns TRUE if player is either super sonic or is kirby wearing super sonics hat
    // a0 = player struct
    scope is_super_sonic: {
        // check if character id = kirby or jkirby
        lw      t0, 0x0008(a0)              // load character id
        ori     at, r0, Character.id.KIRBY  // at = KIRBY
        beq     at, t0, _kirby_hat_check    // branch if not Dedede
        ori     at, r0, Character.id.JKIRBY // at = JKIRBY
        beq     at, t0, _kirby_hat_check    // branch if not Dedede
        nop
        
        ori     at, r0, Character.id.GOKU  // at = SSONIC
        beql    at, t0, _return
        addiu   v0, r0, 1                   // return TRUE
        jr      ra
        addiu   v0, r0, 0                   // return FALSE

        _kirby_hat_check:
        lb      at, 0x0980(a0)              // at = current hat ID
        addiu   t0, r0, 0x002F              // t0 = ssonics hat id
        beql    at, t0, _return             // branch if ssonic hat
        addiu   v0, r0, 1                   // return TRUE if ssonic hat
        addiu   v0, r0, 0                   // return FALSE if sonic hat

        _return:
        jr      ra
        nop
    }

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

        lli     a1, Goku.Action.NSP_Begin  // a1(action id) = NSP_Begin
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
    // Subroutine which runs when Sonic initiates a neutral special.
    scope ssonic_begin_initial_: {
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
        lli     a1, Kirby.Action.SSONIC_NSP_Begin
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.SSONIC_NSP_Begin

        lli     a1, Goku.Action.NSP_Begin // a1(action id) = NSP_Begin
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        // jal     0x800E0830                  // unknown common subroutine
        // lw      a0, 0x0038(sp)              // a0 = player object
        lw      a0, 0x0034(sp)              // a0 = player struct
        sw      r0, 0x017C(a0)              // temp variable 1 = 0
        sw      r0, 0x0180(a0)              // temp variable 2 = 0
        sw      r0, 0x0184(a0)              // temp variable 3 = 0
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
    // Main subroutine for SSonic NSP_Begin
    scope ssonic_begin_main_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        li      a1, ssonic_move_initial_    // a1(transition subroutine) = ssonic_move_initial_
        jal     0x800D9480                  // common main subroutine (transition on animation end)
        nop
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0018              // deallocate stack space
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

        jal     is_super_sonic              // returns 1 if super sonic
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

        jal     is_super_sonic              // returns 1 if super sonic
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
        lli     a1, Goku.Action.NSP_Locked_Move // a1(action id) = NSP_Locked_Move

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
        lli     a1, Goku.Action.NSP_Move   // a1(action id) = NSP_Move

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
    // Subroutine which begins NSP movement for SSonic.
    scope ssonic_move_initial_: {
        addiu   sp, sp,-0x0040              // allocate stack space
        sw      ra, 0x0014(sp)              // ~
        sw      a0, 0x0018(sp)              // ~
        sw      s0, 0x001C(sp)              // store ra, a0, s0
        lw      s0, 0x0084(a0)              // s0 = player struct
        sw      r0, 0x0B18(s0)              // target = NULL
        sw      r0, 0x0B1C(s0)              // X_DIFF = 0
        sw      r0, 0x0048(s0)              // x velocity = 0
        sw      r0, 0x004C(s0)              // y velocity = 0

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
        jal     ground_end_initial_         // transition to NSP_Ground_End
        lw      a0, 0x0020(sp)              // a0 = player object
        b       _end                        // end
        nop

        _aerial:
        jal     air_end_initial_            // transition to NSP_Air_End
        lw      a0, 0x0020(sp)              // a0 = player object

        _end:
        lw      ra, 0x001C(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0040              // deallocate stack space
    }

    // @ Description
    // Main subroutine for SSonic NSP_Moveand NSP_Locked_Move.
    scope ssonic_move_main_: {
        addiu   sp, sp,-0x0040              // allocate stack space
        sw      ra, 0x001C(sp)              // store ra
        lw      v1, 0x0084(a0)              // v1 = player struct

        lw      t6, 0x0180(v1)              // t6 = temp variable 2
        beqz    t6, _end                    // end if temp variable 2 not set
        lh      t6, 0x01BC(v1)              // t6 = buttons_held

        _check_b_held:
        andi    t6, t6, Joypad.B            // t6 = 0x0020 if (B_HELD); else t6 = 0
        bnez    t6, _end                    // skip if (B_HELD)
        nop



        _end_movement:
        lui     at, 0x3E80                  // ~
        mtc1    at, f6                      // f6 = 0.25
        lwc1    f2, 0x0048(v1)              // ~
        mul.s   f2, f2, f6                  // ~
        swc1    f2, 0x0048(v1)              // multiply x velocity by 0.25
        lwc1    f2, 0x004C(v1)              // ~
        mul.s   f2, f2, f6                  // ~
        jal     0x800DEE54                  // transition to idle
        swc1    f2, 0x004C(v1)              // multiply x velocity by 0.25

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

        jal     is_super_sonic              // returns 1 if super sonic
        lw      a0, 0x0044(sp)              // a0 = player struct

        bnez    v0, _save_speed
        lui     at, SPEED_SS                // super sonic speed

        lui     at, SPEED                   // sonic speed

        _save_speed:
        beqz    t9, _apply_movement         // branch if target object = NULL
        sw      at, 0x0030(sp)              // 0x0030(sp) = SPEED

        _get_angle:
        jal     is_super_sonic              // returns 1 if super sonic
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

        jal     is_super_sonic              // returns 1 if super sonic
        lw      a0, 0x0044(sp)              // a0 = player struct
        li      at, TURN_SPEED              // sonics turn speed
        bnezl   v0, _apply_turn_speed
        lui     at, TURN_SPEED_SS           // ...use Super Sonic turn speed instead

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
    // Subroutine which handles collision for Super Sonic NSP_Move and NSP_Locked_Move.
    scope ssonic_move_collision_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        lw      v1, 0x0084(a0)              // v1 = player struct
        lw      t6, 0x0180(v1)              // t6 = temp variable 2
        beqz    t6, _project                // branch if temp variable 2 not set
        nop
        // if temp variable 2 is set, allow landing
        jal     0x800DE978                  // mpCommonProcFighterCliffWaitOrLanding
        nop
        b       _end                        // end
        nop

        _project:
        jal     0x800DE958                  // mpCommonProcFighterProject
        nop

        _end:
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0018              // deallocate stack space
    }

    // @ Description
    // Subroutine which handles air to ground transition Wario's grounded neutral special.
    scope air_to_ground_: {
        OS.copy_segment(0xD098C, 0x1C)      // copy beginning of subroutine from Mario NSP
        ori     t7, r0, 0x0003              // t7 = 0x0003 (hitbox persist)

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.WARIO_NSP_Ground
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.WARIO_NSP_Ground

        ori     a1, r0, 0x00E3              // a1 = 0xDF

        lw      a2, 0x0078(a0)              // a2 = current animation frame
        sw      t7, 0x0010(sp)              // store t7 (some kind of parameter for change action)
        jal     0x800E6F24                  // change action
        lui     a3, 0x3F80                  // a3 = float: 1.0
        lw      ra, 0x001C(sp)              // ~
        addiu   sp, sp, 0x0028              // ~
        jr      ra                          // original return logic
        nop
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

        lli     a1, Goku.Action.NSP_Bounce // a1(action id) = NSP_Bounce
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

        lli     a1, Goku.Action.NSP_Ground_End // a1(action id) = NSP_Ground_End
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

        lli     a1, Goku.Action.NSP_Air_End2 // a1(action id) = NSP_Air_End
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

        lli     a1, Goku.Action.NSP_Ground_End // a1(action id) = NSP_Ground_End
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

        lli     a1, Goku.Action.NSP_Air_End // a1(action id) = NSP_Air_End
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

        lli     a1, Goku.Action.NSP_Air_Recoil // a1(action id) = NSP_Air_Recoil
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

        lli     a1, Goku.Action.NSP_Ground_Recoil // a1(action id) = NSP_Ground_Recoil
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

        lli     a1, Goku.Action.NSP_Air_Recoil // a1(action id) = NSP_Air_Recoil
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
    // Patch which removes destroyed objects as Sonic's target.
    scope destroyed_target_fix_: {
        OS.patch_start(0xA698, 0x80009A98)
        j       destroyed_target_fix_
        nop
        _return:
        OS.patch_end()

        lui     t0, 0x8004                  // ~
        lw      t0, 0x66FC(t0)              // t0 = first player object
        lw      t1, 0x0000(s0)              // t1 = object type
        lli     at, 0x03F5                  // at = item object id
        beq     t1, at, _loop               // branch if object type = item
        lli     at, 0x03E8                  // at = player object id
        bne     t1, at, _end                // skip if object type != player
        nop

        _loop:
        // t0 = player object
        beqz    t0, _end                    // exit loop when s1 no longer holds an object pointer
        nop

        lw      t1, 0x0084(t0)              // t1 = player struct
        lw      t2, 0x0008(t1)              // t2 = character id
        lli     at, Character.id.GOKU     // at = id.SSONIC
        beq     t2, at, _sonic              // branch if character = SSONIC
        lli     at, Character.id.SONIC      // at = id.SONIC
        bne     t2, at, _loop_end           // skip if character != SONIC
        nop

        _sonic:
        lw      t2, 0x0B18(t1)              // t2 = target object
        beql    s0, t2, _loop_end           // branch if object being destroyed is Sonic's target...
        sw      r0, 0x0B18(t1)              // ...and set target object to NULL

        _loop_end:
        b       _loop                       // loop
        lw      t0, 0x0004(t0)              // t0 = next player object

        _end:
        lui     t6, 0x8004                  // original line 1
        j       _return                     // return
        lw      t6, 0x6A54(t6)              // original line 2
    }



    // @ Description
    // Subroutine which handles hitbox collision for Wario's neutral special.
    // @ Arguments
    // a0 - entity struct?
    // a1 - return address upon collision
    scope check_recoil_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      t1, 0x0008(sp)              // ~
        sw      a0, 0x000C(sp)              // ~
        sw      a1, 0x0010(sp)              // ~
        sw      ra, 0x0014(sp)              // ~
        swc1    f0, 0x0018(sp)              // ~
        swc1    f2, 0x001C(sp)              // store t0, t1, a0, a1, ra, f0, f2

        _check:
        lw      t0, 0x0084(a0)              // t0 = player struct
        lw      t1, 0x017C(t0)              // t1 = temp variable 1
        beq     t1, r0, _end                // skip if temp variable 1 = 0
        nop

        _collision:
        sw      a1, 0x0014(sp)              // overwrite return address in stack
        jal     0x800E6F24                  // change action
        nop
        lw      a0, 0x000C(sp)              // load a0
        lw      t0, 0x0084(a0)              // t0 = player struct
        sw      r0, 0x0180(t0)              // temp variable 2 = 0
        // initial x velocity
        lui     t1, RECOIL_X_SPEED          // ~
        mtc1    t1, f0                      // f0 = RECOIL_X_SPEED
        lwc1    f2, 0x0044(t0)              // ~
        cvt.s.w f2, f2                      // f2 = DIRECTION
        mul.s   f0, f0, f2                  // f0 = RECOIL_X_SPEED * DIRECTION
        swc1    f0, 0x0048(t0)              // x velocity = RECOIL_X_SPEED * DIRECTION
        // initial y velocity
        lui     t1, RECOIL_Y_SPEED          // t1 = RECOIL_Y_SPEED
        sw      t1, 0x004C(t0)              // y velocity = RECOIL_Y_SPEED

        _end:
        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // ~
        lw      a0, 0x000C(sp)              // ~
        lw      ra, 0x0014(sp)              // ~
        lwc1    f0, 0x0018(sp)              // ~
        lwc1    f2, 0x001C(sp)              // load t0, t1, ra, f0, f2
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // This is Jim's special collision flag.
    // Its primary purpose is to disable grounded wall collision recoil when Wario transitions from
    // air to ground while already colliding with a wall.
    // Its secondary purpose is to make Jim shut up.
    special_jim_flag:
    db 0x00 //p1
    db 0x00 //p2
    db 0x00 //p3
    db 0x00 //p4


}

scope GokuDSP {
    constant SHOOT_X_SPEED(0x40A0)          // current setting: float 5.0

    // @ Description
    // Subroutine which runs when Mewtwo initiates a grounded neutral special.
    scope ground_begin_initial_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.MTWO_NSP_Ground_Begin
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.MTWO_NSP_Ground_Begin

        lli     a1, Goku.Action.NSPG_Begin                   // a1(action id) = NSP_Ground_Begin
        jal     begin_initial_              // begin_initial_
        nop
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Subroutine which runs when Mewtwo initiates an aerial neutral special.
    scope air_begin_initial_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.MTWO_NSP_Air_Begin
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.MTWO_NSP_Air_Begin

        lli     a1, Goku.Action.NSPA_Begin                  // a1(action id) = NSP_Air_Begin
        jal     begin_initial_              // begin_initial_
        nop
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Subroutine for when Mewtwo initiates a neutral special.
    // Based on subroutine 0x8015DB64, which is the initial subroutine for Samus' grounded neutral special.
    // a0 - player object
    // a1 - action id
    scope begin_initial_: {
        addiu   sp, sp,-0x0030              // allocate stack spcae
        sw      s0, 0x0020(sp)              // ~
        sw      ra, 0x0024(sp)              // ~
        sw      a0, 0x0028(sp)              // store s0, ra, a0
        lw      s0, 0x0084(a0)              // s0 = player struct
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x0010(sp)              // argument 4 = 0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0028(sp)              // a0 = player object


        lw      t7, 0x0008(s0)              // t7 = current character ID
        lli     at, Character.id.KIRBY      // at = id.KIRBY
        beq     t7, at, _kirby              // branch if character = KIRBY
        lli     at, Character.id.JKIRBY     // at = id.JKIRBY
        bne     t7, at, _mewtwo             // branch if character != JKIRBY
        nop

        _kirby:
        jal     0x801576B4                  // kirby's on hit subroutine setup
        or      a0, s0, r0                  // a0 = player struct
        b       _continue                   // branch
        nop

        _mewtwo:
        jal     0x8015DB4C                  // on hit subroutine setup
        or      a0, s0, r0                  // a0 = player struct

        _continue:
        lw      at, 0x0008(s0)              // at = current character ID
        lli     t7, Character.id.KIRBY      // t7 = id.KIRBY
        beql    t7, at, pc() + 24           // if Kirby, load Kirby charge level
        lw      t7, 0x0AE0(s0)              // t7 = charge level
        lli     t7, Character.id.JKIRBY     // t7 = id.JKIRBY
        beql    t7, at, pc() + 12           // if J Kirby, load Kirby charge level
        lw      t7, 0x0AE0(s0)              // t7 = charge level

        lw      t7, 0x0ADC(s0)              // t7 = charge level
        lli     at, 0x0007                  // at = 0x0007
        lli     t8, 0x0001                  // t8 = 0x0001
        bnel    t7, at, _end                // end if charge level != 7(max)
        sw      r0, 0x0B18(s0)              // set transition bool to 0 (charge)

        // if we're here, the neutral special is fully charged, so set transition bool to shoot
        sw      t8, 0x0B18(s0)              // set transition bool to 1 (shoot)

        _end:
        lw      s0, 0x0020(sp)              // ~
        lw      ra, 0x0024(sp)              // load s0, ra
        addiu   sp, sp, 0x0030              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Main subroutine for NSP_Ground_Begin and NSP_Air_Begin.
    // Based on subroutine 0x8015D3EC, which is the main subroutine for Samus's NSPG_Begin and NSPA_Begin actions.
    scope begin_main_: {
        addiu   sp, sp,-0x0040              // allocate stack space
        sw      ra, 0x0014(sp)              // ~
        sw      a0, 0x0030(sp)              // store ra, a0
        lw      v0, 0x0084(a0)              // v0 = player struct
        // checks the current animation frame to see if we've reached end of the animation
        lwc1    f6, 0x0078(a0)              // ~
        mtc1    r0, f4                      // ~
        c.le.s  f6, f4                      // ~
        nop
        bc1fl   _end                        // skip if animation end has not been reached
        lw      ra, 0x0014(sp)              // load ra
        lw      t6, 0x014C(v0)              // t6 = kinetic state (0 = grounded, 1 = aerial)
        beq     t6, r0, _grounded           // branch if kinetic state = grounded
        lw      t7, 0x0B18(v0)              // t7 = transition bool (0 = charge, 1 = shoot)

        _aerial:
        bnez    t7, _air_shoot              // branch if transition bool = shoot
        nop

        _air_charge:
        jal     air_charge_initial_         // air_charge_initial_
        nop
        b       _end                        // end
        lw      ra, 0x0014(sp)              // load ra

        _air_shoot:
        jal     attach_shadow_ball_         // attach_shadow_ball_
        nop
        jal     air_shoot_initial_          // air_shoot_initial_
        lw      a0, 0x0030(sp)              // a0 = player object
        b       _end                        // end
        lw      ra, 0x0014(sp)              // load ra


        _grounded:
        bnez    t7, _ground_shoot           // branch if transition bool = shoot
        nop

        _ground_charge:
        jal     ground_charge_initial_      // ground_charge_initial_
        nop
        b       _end                        // end
        lw      ra, 0x0014(sp)              // load ra

        _ground_shoot:
        jal     attach_shadow_ball_         // attach_shadow_ball_
        nop
        jal     ground_shoot_initial_       // ground_shoot_initial_
        lw      a0, 0x0030(sp)              // a0 = player object
        lw      ra, 0x0014(sp)              // load ra

        _end:
        addiu   sp, sp, 0x0040              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Collision subroutine for NSP_Ground_Begin.
    scope ground_begin_collision_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        li      a1, air_begin_transition_   // a1(transition subroutine) = air_charge_transition_
        jal     0x800DDE84                  // common ground collision subroutine (transition on no floor, no slide-off)
        nop
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0018              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Collision subroutine for Kirby's NSP_Ground_Begin.
    scope kirby_ground_begin_collision_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        li      a1, air_begin_transition_   // a1(transition subroutine) = air_charge_transition_
        jal     0x800DDDDC                  // common ground collision subroutine (transition on no floor, slide-off)
        nop
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0018              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Collision subroutine for NSP_Air_Begin.
    scope air_begin_collision_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        li      a1, ground_begin_transition_ // a1(transition subroutine) = ground_begin_transition_
        jal     0x800DE6E4                  // common air collision subroutine (transition on landing, no ledge grab)
        nop
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0018              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Subroutine which transitions to NSP_Air_Begin.
    scope air_begin_transition_: {
        addiu   sp, sp,-0x0030              // allocate stack spcae
        sw      s0, 0x0020(sp)              // ~
        sw      ra, 0x0024(sp)              // ~
        sw      a0, 0x0028(sp)              // store s0, ra, a0
        lw      s0, 0x0084(a0)              // s0 = player struct
        jal     0x800DEEC8                  // set aerial state
        or      a0, s0, r0                  // a0 = player struct
        jal     0x800D8EB8                  // momentum capture?
        or      a0, s0, r0                  // a0 = player struct
        lw      a0, 0x0028(sp)              // a0 = player object

        lw      a2, 0x0008(s0)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.MTWO_NSP_Air_Begin
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.MTWO_NSP_Air_Begin

        lli     a1, Goku.Action.NSPA_Begin                  // a1(action id) = NSP_Air_Begin
        lw      a2, 0x0078(a0)              // a2(starting frame) = current animation frame
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        lli     t8, 0x0002                  // ~
        jal     0x800E6F24                  // change action
        sw      t8, 0x0010(sp)              // argument 4 = 0x0002

        lw      t7, 0x0008(s0)              // t7 = current character ID
        lli     at, Character.id.KIRBY      // at = id.KIRBY
        beq     t7, at, _kirby              // branch if character = KIRBY
        lli     at, Character.id.JKIRBY     // at = id.JKIRBY
        bne     t7, at, _mewtwo             // branch if character != JKIRBY
        nop

        _kirby:
        li      t7, 0x80156E98              // t7 = kirby's on hit subroutine
        b       _end                        // branch to end
        nop

        _mewtwo:
        li      t7, 0x8015D338              // t7 = on hit subroutine

        _end:
        sw      t7, 0x09EC(s0)              // store on hit subroutine in player struct
        lw      s0, 0x0020(sp)              // ~
        lw      ra, 0x0024(sp)              // load s0, ra
        addiu   sp, sp, 0x0030              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Subroutine which transitions to NSP_Ground_Begin.
    scope ground_begin_transition_: {
        addiu   sp, sp,-0x0030              // allocate stack spcae
        sw      s0, 0x0020(sp)              // ~
        sw      ra, 0x0024(sp)              // ~
        sw      a0, 0x0028(sp)              // store s0, ra, a0
        lw      s0, 0x0084(a0)              // s0 = player struct
        jal     0x800DEE98                  // set grounded state
        or      a0, s0, r0                  // a0 = player struct
        lw      a0, 0x0028(sp)              // a0 = player object

        lw      a2, 0x0008(s0)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.MTWO_NSP_Ground_Begin
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.MTWO_NSP_Ground_Begin

        lli     a1, Goku.Action.NSPG_Begin                  // a1(action id) = NSP_Ground_Begin
        lw      t8, 0x08E8(s0)              // t8 = top joint struct (original logic, useless?)
        lw      a2, 0x0078(a0)              // a2(starting frame) = current animation frame
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        lli     t8, 0x0002                  // ~
        jal     0x800E6F24                  // change action
        sw      t8, 0x0010(sp)              // argument 4 = 0x0002

        lw      t7, 0x0008(s0)              // t7 = current character ID
        lli     at, Character.id.KIRBY      // at = id.KIRBY
        beq     t7, at, _kirby              // branch if character = KIRBY
        lli     at, Character.id.JKIRBY     // at = id.JKIRBY
        bne     t7, at, _mewtwo             // branch if character != JKIRBY
        nop

        _kirby:
        li      t7, 0x80156E98              // t7 = kirby's on hit subroutine
        b       _end                        // branch to end
        nop

        _mewtwo:
        li      t7, 0x8015D338              // t7 = on hit subroutine

        _end:
        sw      t7, 0x09EC(s0)              // store on hit subroutine in player struct
        lw      s0, 0x0020(sp)              // ~
        lw      ra, 0x0024(sp)              // load s0, ra
        addiu   sp, sp, 0x0030              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Initial subroutine for NSP_Ground_Charge.
    scope ground_charge_initial_: {
        addiu   sp, sp,-0x0028              // allocate stack space
        sw      ra, 0x0014(sp)              // ~
        sw      a0, 0x0018(sp)              // store ra, a0

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.MTWO_NSP_Ground_Charge
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.MTWO_NSP_Ground_Charge

        lli     a1, Goku.Action.NSPG_Charge                  // a1(action id) = NSP_Ground_Charge
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        lli     t6, 0x0002                  // ~
        jal     0x800E6F24                  // change action
        sw      t6, 0x0010(sp)              // argument 4 = 0x0002
        jal     attach_shadow_ball_         // attach_shadow_ball_
        lw      a0, 0x0018(sp)              // a0 = player object
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0028              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Initial subroutine for NSP_Air_Charge.
    scope air_charge_initial_: {
        addiu   sp, sp,-0x0028              // allocate stack space
        sw      ra, 0x0014(sp)              // ~
        sw      a0, 0x0018(sp)              // store ra, a0

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.MTWO_NSP_Air_Charge
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.MTWO_NSP_Air_Charge

        lli     a1, Goku.Action.NSPA_Charge                  // a1(action id) = NSP_Air_Charge
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        lli     t6, 0x0002                  // ~
        jal     0x800E6F24                  // change action
        sw      t6, 0x0010(sp)              // argument 4 = 0x0002
        jal     attach_shadow_ball_         // attach_shadow_ball_
        lw      a0, 0x0018(sp)              // a0 = player object
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0028              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Subroutine which attaches a shadow ball to mewtwo's hand.
    // a0 - player object
    scope attach_shadow_ball_: {
        addiu   sp, sp,-0x0050              // allocate stack space
        sw      s0, 0x0020(sp)              // ~
        sw      ra, 0x0024(sp)              // ~
        sw      a0, 0x0038(sp)              // store s0, ra, a0
        lw      s0, 0x0084(a0)              // s0 = player struct

        lw      t7, 0x0008(s0)              // t7 = current character ID
        lli     at, Character.id.KIRBY      // at = id.KIRBY
        beq     t7, at, _kirby              // branch if character = KIRBY
        lli     at, Character.id.JKIRBY     // at = id.JKIRBY
        bne     t7, at, _mewtwo             // branch if character != JKIRBY
        nop

        _kirby:
        li      t7, 0x80156E98              // t7 = kirby's on hit subroutine
        b       _continue                   // branch
        nop

        _mewtwo:
        li      t7, 0x8015D338              // t7 = on hit subroutine

        _continue:
        sw      t7, 0x09EC(s0)              // store on hit subroutine in player struct
        lli     t8, 0x0014                  // t8 = maybe a timer?
        sw      t8, 0x0B1C(s0)              // store unknown variable
        or      a0, s0, r0                  // a0 = player struct
        jal     0x8015D35C                  // get part position
        addiu   a1, sp, 0x0028              // a1 = address to return x/y/z coordinates to
        lw      a0, 0x0038(sp)              // a0 = player object
        addiu   a1, sp, 0x0028              // x/y/z coordinates

        lw      a3, 0x0008(s0)              // a3 = current character ID
        lli     a2, Character.id.KIRBY      // a2 = id.KIRBY
        beql    a2, a3, pc() + 24           // if Kirby, load Kirby charge level
        lw      a2, 0x0AE0(s0)              // a2 = charge level
        lli     a2, Character.id.JKIRBY     // a2 = id.JKIRBY
        beql    a2, a3, pc() + 12           // if J Kirby, load Kirby charge level
        lw      a2, 0x0AE0(s0)              // a2 = charge level

        lw      a2, 0x0ADC(s0)              // a2 = charge level
        jal     0x80168DDC                  // projectile stage setting
        or      a3, r0, r0                  // a3 = 0
        sw      v0, 0x0B20(s0)              // store projectile object
        lw      s0, 0x0024(sp)              // ~
        lw      ra, 0x0024(sp)              // load s0, ra
        addiu   sp, sp, 0x0050              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Main subroutine for NSP_Ground_Charge and NSP_Air_Charge.
    // Based on subroutine 0x8015D5AC, which is the main subroutine for Samus' grounded neutral special charge.
    scope charge_main_: {
        // First 2 lines of subroutine 0x8015D5AC
        addiu   sp, sp,-0x0050              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        // Now add some new logic to update the projectile position.
        sw      a0, 0x0020(sp)              // store a0
        jal     0x8015D394                  // update projectile position
        lw      a0, 0x0084(a0)              // a0 = player struct
        lw      a0, 0x0020(sp)              // load a0
        // Copy the next 15 lines of subroutine 0x8015D5AC
        OS.copy_segment(0xD7FF4, 0x3C)
        lli     a1, 0x0058                  // a1 = Mewtwo Shadow Ball Charge id (hard coded)
        or      a2, r0, r0                  // a2 = 0
        sw      a0, 0x0020(sp)              // store a0
        jal     0x800E9814                  // begin gfx routine
        sw      a3, 0x001C(sp)              // store a3
        jal     0x8015D300                  // destroy attached projectile
        lw      a0, 0x001C(sp)              // a0 = player struct
        jal     0x800DEE54                  // transition to idle (ground and air)
        lw      a0, 0x0020(sp)              // a0 = player object
        // Copy the next 8 lines of subroutine 0x8015D5AC
        OS.copy_segment(0xD8054, 0x20)
        // End
        addiu   sp, sp, 0x0050              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Main subroutine for NSP_Ground_Charge and NSP_Air_Charge.
    // Based on subroutine 0x80157114, which is the main subroutine for Kirby's Samus grounded neutral special charge.
    scope kirby_charge_main_: {
        // First 2 lines of subroutine 0x80157114
        addiu   sp, sp,-0x0050              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        // Now add some new logic to update the projectile position.
        sw      a0, 0x0020(sp)              // store a0
        jal     0x8015D394                  // update projectile position
        lw      a0, 0x0084(a0)              // a0 = player struct
        lw      a0, 0x0020(sp)              // load a0
        // Copy the next 15 lines of subroutine 0x80157114
        OS.copy_segment(0xD1B5C, 0x3C)
        lli     a1, 0x0064                  // a1 = Kirby Mewtwo Shadow Ball Charge id (hard coded)
        or      a2, r0, r0                  // a2 = 0
        sw      a0, 0x0020(sp)              // store a0
        jal     0x800E9814                  // begin gfx routine
        sw      a3, 0x001C(sp)              // store a3
        jal     0x8015D300                  // destroy attached projectile
        lw      a0, 0x001C(sp)              // a0 = player struct
        jal     0x800DEE54                  // transition to idle (ground and air)
        lw      a0, 0x0020(sp)              // a0 = player object
        // Copy the next 8 lines of subroutine 0x80157114
        OS.copy_segment(0xD1BBC, 0x20)
        // End
        addiu   sp, sp, 0x0050              // deallocate stack space
        jr      ra                          // return
        nop
    }

    80157114

    // @ Description
    // Interrupt subroutine for NSP_Ground_Charge.
    // Based on subroutine 0x8015D640, which is the interrupt subroutine for Samus' grounded neutral special charge.
    scope ground_charge_interrupt_: {
        // Copy the first 14 lines of subroutine 0x8015D640
        OS.copy_segment(0xD8080, 0x38)
        jal     ground_shoot_initial_       // ground_shoot_initial_
        or      a0, a2, r0                  // original line
        j       0x8015D6F4                  // return to original subroutine
        lw      ra, 0x0014(sp)              // original line
        sw      a1, 0x001C(sp)              // original line
        j       0x8015D68C                  // return to original subroutine
        nop
    }

    // @ Description
    // Interrupt subroutine for NSP_Air_Charge.
    // Loosely based on subroutine 0x8015D640, which is the interrupt subroutine for Samus' grounded neutral special charge.
    scope air_charge_interrupt_: {
        addiu   sp, sp,-0x0030              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra

        // begin by checking for A or B presses
        lw      a1, 0x0084(a0)              // a1 = player struct
        lhu     v0, 0x01BE(a1)              // v0 = buttons_pressed
        andi    t6, v0, Joypad.B            // t6 = 0x4000 if (B_PRESSED); else t6 = 0
        andi    t7, v0, Joypad.A            // t7 = 0x8000 if (A_PRESSED); else t6 = 0
        or      at, t6, t7                  // at = !0 if (A_PRESSED) or (B_PRESSED), else at = 0
        beqz    at, _check_cancel           // branch if both A and B are not being pressed
        nop

        // if we're here, A or B has been pressed, so transition to NSP_Air_Shoot
        jal     air_shoot_initial_          // air_shoot_initial_
        nop
        b       _end                        // end
        lw      ra, 0x0014(sp)              // load ra

        _check_cancel:
        // now check if Shield button has been pressed
        lhu     at, 0x01B8(a1)              // at = shield press bitmask
        and     at, at, v0                  // at != 0 if shield pressed; else at = 0
        beql    at, r0, _end                // end if shield is not pressed
        lw      ra, 0x0014(sp)              // load ra

        // if we're here, Z has been pressed, so transition to fall
        sw      a0, 0x0020(sp)              // 0x0020(sp) = player object
        jal     0x8015D300                  // destroy attached projectile
        lw      a0, 0x0084(a0)              // a0 = player struct
        jal     0x8013F9E0                  // transition to fall
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      ra, 0x0014(sp)              // load ra

        _end:
        addiu   sp, sp, 0x0030              // dellocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Collision subroutine for NSP_Ground_Charge.
    scope ground_charge_collision_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        li      a1, air_charge_transition_  // a1(transition subroutine) = air_charge_transition_
        jal     0x800DDE84                  // common ground collision subroutine (transition on no floor, no slide-off)
        nop
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0018              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Collision subroutine for Kirby's NSP_Ground_Charge.
    scope kirby_ground_charge_collision_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        li      a1, air_charge_transition_  // a1(transition subroutine) = air_charge_transition_
        jal     0x800DDDDC                  // common ground collision subroutine (transition on no floor, slide-off)
        nop
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0018              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Collision subroutine for NSP_Ground_Charge
    scope air_charge_collision_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        li      a1, ground_charge_transition_ // a1(transition subroutine) = ground_charge_transition_
        jal     0x800DE6E4                  // common air collision subroutine (transition on landing, no ledge grab)
        nop
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0018              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Subroutine which transitions to NSP_Ground_Charge.
    scope ground_charge_transition_: {
        addiu   sp, sp,-0x0030              // allocate stack spcae
        sw      s0, 0x0020(sp)              // ~
        sw      ra, 0x0024(sp)              // ~
        sw      a0, 0x0028(sp)              // store s0, ra, a0
        lw      s0, 0x0084(a0)              // s0 = player struct
        jal     0x800DEE98                  // set grounded state
        or      a0, s0, r0                  // a0 = player struct
        lw      a0, 0x0028(sp)              // a0 = player object

        lw      a2, 0x0008(s0)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.MTWO_NSP_Ground_Charge
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.MTWO_NSP_Ground_Charge

        lli     a1, Goku.Action.NSPG_Charge                  // a1(action id) = NSP_Ground_Charge
        lw      a2, 0x0078(a0)              // a2(starting frame) = current animation frame
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        lli     t8, 0x0802                  // ~
        jal     0x800E6F24                  // change action
        sw      t8, 0x0010(sp)              // argument 4 = 0x0802

        lw      t7, 0x0008(s0)              // t7 = current character ID
        lli     at, Character.id.KIRBY      // at = id.KIRBY
        beq     t7, at, _kirby              // branch if character = KIRBY
        lli     at, Character.id.JKIRBY     // at = id.JKIRBY
        bne     t7, at, _mewtwo             // branch if character != JKIRBY
        nop

        _kirby:
        li      t7, 0x80156E98              // t7 = kirby's on hit subroutine
        b       _end                        // branch to end
        nop

        _mewtwo:
        li      t7, 0x8015D338              // t7 = on hit subroutine

        _end:
        sw      t7, 0x09EC(s0)              // store on hit subroutine in player struct
        lw      s0, 0x0020(sp)              // ~
        lw      ra, 0x0024(sp)              // load s0, ra
        addiu   sp, sp, 0x0030              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Subroutine which transitions to NSP_Air_Charge.
    scope air_charge_transition_: {
        addiu   sp, sp,-0x0030              // allocate stack spcae
        sw      s0, 0x0020(sp)              // ~
        sw      ra, 0x0024(sp)              // ~
        sw      a0, 0x0028(sp)              // store s0, ra, a0
        lw      s0, 0x0084(a0)              // s0 = player struct
        jal     0x800DEEC8                  // set aerial state
        or      a0, s0, r0                  // a0 = player struct
        jal     0x800D8EB8                  // momentum capture?
        or      a0, s0, r0                  // a0 = player struct
        lw      a0, 0x0028(sp)              // a0 = player object

        lw      a2, 0x0008(s0)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.MTWO_NSP_Air_Charge
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.MTWO_NSP_Air_Charge

        lli     a1, Goku.Action.NSPA_Charge                  // a1(action id) = NSP_Air_Charge
        lw      a2, 0x0078(a0)              // a2(starting frame) = current animation frame
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        lli     t8, 0x0802                  // ~
        jal     0x800E6F24                  // change action
        sw      t8, 0x0010(sp)              // argument 4 = 0x0802

        lw      t7, 0x0008(s0)              // t7 = current character ID
        lli     at, Character.id.KIRBY      // at = id.KIRBY
        beq     t7, at, _kirby              // branch if character = KIRBY
        lli     at, Character.id.JKIRBY     // at = id.JKIRBY
        bne     t7, at, _mewtwo             // branch if character != JKIRBY
        nop

        _kirby:
        li      t7, 0x80156E98              // t7 = kirby's on hit subroutine
        b       _end                        // branch to end
        nop

        _mewtwo:
        li      t7, 0x8015D338              // t7 = on hit subroutine

        _end:
        sw      t7, 0x09EC(s0)              // store on hit subroutine in player struct
        lw      s0, 0x0020(sp)              // ~
        lw      ra, 0x0024(sp)              // load s0, ra
        addiu   sp, sp, 0x0030              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Initial subroutine for NSP_Ground_Shoot.
    // Based on subroutine 0x8015DA60, which is the initial subroutine for Samus' grounded neutral special shot.
    scope ground_shoot_initial_: {
        // Copy the first 5 lines of subroutine 0x8015DA60
        OS.copy_segment(0xD84A0, 0x14)

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.MTWO_NSP_Ground_Shoot
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.MTWO_NSP_Ground_Shoot

        lli     a1, Goku.Action.NSPG_Shoot                  // a1(action id) = NSP_Ground_Shoot
        or      a2, r0, r0                  // a2(starting frame) = 0
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      t6, 0x0024(sp)              // 0x0024(sp) = player struct

        lw      t9, 0x0024(sp)              // t9 = player struct
        lw      t7, 0x0008(t9)              // t7 = current character ID
        lli     at, Character.id.KIRBY      // at = id.KIRBY
        beq     t7, at, _kirby              // branch if character = KIRBY
        lli     at, Character.id.JKIRBY     // at = id.JKIRBY
        bne     t7, at, _mewtwo             // branch if character != JKIRBY
        nop

        _kirby:
        li      t7, 0x80156E98              // t7 = kirby's on hit subroutine
        b       _end                        // branch to end
        nop

        _mewtwo:
        li      t7, 0x8015D338              // t7 = on hit subroutine

        _end:
        sw      t7, 0x09EC(t9)              // store on hit subroutine in player struct
        lw      ra, 0x001C(sp)              // load ra
        addiu   sp, sp, 0x0028              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Initial subroutine for NSP_Air_Shoot.
    // Based on subroutine 0x8015DAA8, which is the initial subroutine for Samus' grounded neutral special shot.
    scope air_shoot_initial_: {
        // Copy the first 15 lines of subroutine 0x8015DAA8
        OS.copy_segment(0xD84E8, 0x3C)

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.MTWO_NSP_Air_Shoot
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.MTWO_NSP_Air_Shoot

        lli     a1, Goku.Action.NSPA_Shoot                  // a1(action id) = NSP_Air_Shoot
        or      a2, r0, r0                  // a2(starting frame) = 0
        jal     0x800E6F24                  // change action
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0

        lw      t7, 0x0008(s0)              // t7 = current character ID
        lli     at, Character.id.KIRBY      // at = id.KIRBY
        beq     t7, at, _kirby              // branch if character = KIRBY
        lli     at, Character.id.JKIRBY     // at = id.JKIRBY
        bne     t7, at, _mewtwo             // branch if character != JKIRBY
        nop

        _kirby:
        li      t7, 0x80156E98              // t7 = kirby's on hit subroutine
        b       _end                        // branch to end
        nop

        _mewtwo:
        li      t7, 0x8015D338              // t7 = on hit subroutine

        _end:
        sw      t7, 0x09EC(s0)              // store on hit subroutine in player struct
        lw      s0, 0x0020(sp)              // ~
        lw      ra, 0x0024(sp)              // load s0, ra
        addiu   sp, sp, 0x0028              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Main subroutine for NSP_Ground_Shoot and NSP_Air_Shoot.
    // Wrapped version of subroutine 0x0x8015D7AC (SamusNSP.shoot_main_)
    // Adds a jump to update_ball_position_
    scope shoot_main_: {
        addiu   sp, sp,-0x0030              // allocate stack space
        sw      ra, 0x0014(sp)              // ~
        sw      a0, 0x0018(sp)              // store ra, a0
        jal     0x8015D394                  // update projectile position
        lw      a0, 0x0084(a0)              // a0 = player struct
        jal     0x8015D7AC                  // jump to SamusNSP.shoot_main_
        lw      a0, 0x0018(sp)              // load a0
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0030              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Main
    // Main subroutine for NSP_Ground_Shoot and NSP_Air_Shoot.
    // Wrapped version of subroutine 0x80157314 (Kirby.SamusNSP_shoot_main_)
    // Adds a jump to update_ball_position_
    scope kirby_shoot_main_: {
        addiu   sp, sp,-0x0030              // allocate stack space
        sw      ra, 0x0014(sp)              // ~
        sw      a0, 0x0018(sp)              // store ra, a0
        jal     0x8015D394                  // update projectile position
        lw      a0, 0x0084(a0)              // a0 = player struct
        jal     0x80157314                  // jump to Kirby.SamusNSP_shoot_main_
        lw      a0, 0x0018(sp)              // load a0
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0030              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Collision subroutine for NSP_Ground_Shoot.
    scope ground_shoot_collision_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        li      a1, air_shoot_transition_   // a1(transition subroutine) = air_shoot_transition_
        jal     0x800DDE84                  // common ground collision subroutine (transition on no floor, no slide-off)
        nop
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0018              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Collision subroutine for Kirby's NSP_Ground_Shoot.
    scope kirby_ground_shoot_collision_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        li      a1, air_shoot_transition_   // a1(transition subroutine) = air_shoot_transition_
        jal     0x800DDDDC                  // common ground collision subroutine (transition on no floor, slide-off)
        nop
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0018              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Collision subroutine for NSP_Air_Shoot.
    scope air_shoot_collision_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        li      a1, ground_shoot_transition_ // a1(transition subroutine) = ground_shoot_transition_
        jal     0x800DE6E4                  // common air collision subroutine (transition on landing, no ledge grab)
        nop
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0018              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Subroutine which transitions to NSP_Ground_Shoot.
    // Based on subroutine 0x8015D9B0, which is the transition subroutine for Samus' aerial neutral special shot.
    scope ground_shoot_transition_: {
        // Copy the first 8 lines of subroutine 0x8015D9B0
        OS.copy_segment(0xD83F0, 0x20)

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.MTWO_NSP_Ground_Shoot
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.MTWO_NSP_Ground_Shoot

        lli     a1, Goku.Action.NSPG_Shoot                  // a1(action id) = NSP_Ground_Shoot
        lw      a2, 0x0078(a0)              // a2(starting frame) = current animation frame
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      t7, 0x0010(sp)              // argument 4 = t7

        lw      t9, 0x0024(sp)              // t9 = player struct
        lw      t7, 0x0008(t9)              // t7 = current character ID
        lli     at, Character.id.KIRBY      // at = id.KIRBY
        beq     t7, at, _kirby              // branch if character = KIRBY
        lli     at, Character.id.JKIRBY     // at = id.JKIRBY
        bne     t7, at, _mewtwo             // branch if character != JKIRBY
        nop

        _kirby:
        li      t7, 0x80156E98              // t7 = kirby's on hit subroutine
        b       _end                        // branch to end
        nop

        _mewtwo:
        li      t7, 0x8015D338              // t7 = on hit subroutine

        _end:
        sw      t7, 0x09EC(t9)              // store on hit subroutine in player struct
        lw      ra, 0x001C(sp)              // load ra
        addiu   sp, sp, 0x0028              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Subroutine which transitions to NSP_Air_Shoot.
    // Based on subroutine 0x8015DA04, which is the transition subroutine for Samus' aerial neutral special shot.
    scope air_shoot_transition_: {
        // Copy the first 8 lines of subroutine 0x8015DA04
        OS.copy_segment(0xD8444, 0x20)

        lw      a2, 0x0084(a0)              // ~
        lw      a2, 0x0008(a2)              // a2 = current character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, pc() + 24           // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.MTWO_NSP_Air_Shoot
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, pc() + 12           // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.MTWO_NSP_Air_Shoot

        lli     a1, Goku.Action.NSPA_Shoot                  // a1(action id) = NSP_Air_Shoot
        lw      a2, 0x0078(a0)              // a2(starting frame) = current animation frame
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      t7, 0x0010(sp)              // argument 4 = t7

        lw      t9, 0x0024(sp)              // t9 = player struct
        lw      t7, 0x0008(t9)              // t7 = current character ID
        lli     at, Character.id.KIRBY      // at = id.KIRBY
        beq     t7, at, _kirby              // branch if character = KIRBY
        lli     at, Character.id.JKIRBY     // at = id.JKIRBY
        bne     t7, at, _mewtwo             // branch if character != JKIRBY
        nop

        _kirby:
        li      t7, 0x80156E98              // t7 = kirby's on hit subroutine
        b       _end                        // branch to end
        nop

        _mewtwo:
        li      t7, 0x8015D338              // t7 = on hit subroutine

        _end:
        sw      t7, 0x09EC(t9)              // store on hit subroutine in player struct
        lw      ra, 0x001C(sp)              // load ra
        addiu   sp, sp, 0x0028              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Main subroutine for Shadow Ball.
    // Based on subroutine 0x80168BFC, which is the main subroutine for the Charge Shot projectile.
    scope shadow_ball_main_: {
        constant AMPLITUDE(0x42C8)          // float: 100
        constant FREQUENCY(0x4040)          // float: 3Hz

        addiu   sp, sp,-0x0030              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        lw      a1, 0x0084(a0)              // a1 = projectile special struct
        sw      a1, 0x001C(sp)              // 0x001C(sp) = projectile special struct
        sw      a0, 0x0020(sp)              // 0x0020(sp) = projectile object
        lw      t6, 0x029C(a1)              // t6 = frame count
        bnez    t6, _projectile_active      // branch if projectile is active (frame counter has started)
        nop

        // if projectile is not active (charging state)
        lw      t6, 0x02A4(a1)              // t6 = charge level
        sll     t7, t6, 0x0003              // ~
        addu    t7, t7, t6                  // ~
        sll     t7, t7, 0x0002              // t7 = offset (charge level * 0x24)
        li      at, charge_level_array      // ~
        addu    at, at, t7                  // at = struct for current charge level (charge_level_array + offset)
        lwc1    f4, 0x0000(at)              // f4 = current charge level graphic size
        lui     at, 0x41F0                  // ~
        mtc1    at, f6                      // f6 = 30
        div.s   f4, f4, f6                  // f4 = size multiplier (base size / 30)
        lw      t6, 0x0074(a0)              // t6 = projectile first bone(0) struct
        swc1    f4, 0x0040(t6)              // update bone x size multiplier
        swc1    f4, 0x0044(t6)              // update bone y size multiplier
        lw      t1, 0x02A0(a1)              // t1 = bool begin_shot
        beqz    t1, _end                    // skip if begin_shot = FALSE
        nop

        // if the bool for beginning the shot was enabled
        lw      t1, 0x0020(t6)              // t1 = current y position
        sw      t1, 0x02AC(a1)              // save current y position as base y
        sw      r0, 0x02B0(a1)              // set shield bounce flag to FALSE
        jal     apply_charge_level_         // apply charge level
        nop
        lw      a1, 0x001C(sp)              // a1 = projectile special struct
        lli     at, 0x0001                  // ~
        sw      at, 0x0100(a1)              // enable hitbox
        jal     0x80165F60                  // unknown original subroutine
        lw      a0, 0x0020(sp)              // a0 = projectile object
        lw      a1, 0x001C(sp)              // a1 = projectile special struct
        addiu   at, r0, 0x0001              // at = 0x1
        b       _end                        // end subroutine
        sw      at, 0x029C(a1)              // set frame count to initial value of 1

        _projectile_active:
        lw      at, 0x02B0(a1)              // at = shield bounce flag
        bnez    at, _update_frame_count     // skip if a shield bounce has ocurred
        lw      at, 0x029C(a1)              // ~
        mtc1    at, f6                      // ~
        cvt.s.w f6, f6                      // f6 = frame
        lui     at, FREQUENCY               // ~
        mtc1    at, f4                      // f4 = FREQUENCY
        li      at, 0x3DD67750              // ~
        mtc1    at, f2                      // f2 = 2π/60
        mul.s   f4, f4, f2                  // f4 = FREQUENCY * 2π/60 = ω/60
        jal     0x800303F0                  // f0 = sin(f12)
        mul.s   f12, f4, f6                 // f12 = ω/60 * frame = ωt
        lw      a1, 0x001C(sp)              // a1 = projectile special struct
        lw      a0, 0x0020(sp)              // a0 = projectile object
        lui     at, AMPLITUDE               // ~
        mtc1    at, f4                      // f4 = AMPLITUDE
        mul.s   f4, f4, f0                  // f4 = AMPLITUDE * sin(ωt)
        lwc1    f6, 0x02AC(a1)              // f6 = base y
        add.s   f6, f6, f4                  // f6 = base y + AMPLITUDE * sin(ωt)
        lw      t6, 0x0074(a0)              // t6 = projectile first bone(0) struct
        swc1    f6, 0x0020(t6)              // store updated y position

        _update_frame_count:
        lw      at, 0x029C(a1)              // at = frame count
        addiu   at, at, 0x0001              // increment frame count
        sw      at, 0x029C(a1)              // store updated frame count


        _end:
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0030              // deallocate stack space
        jr      ra                          // return
        or      v0, r0, r0                  // return 0 (don't destroy projectile)
    }

    // @ Description
    // Subroutine for applying charge levels to Shadow Ball.
    // Based on subroutine 0x80168B00 which applies charge levels for Charge Shot.
    scope apply_charge_level_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x0014(sp)              // store ra
        lw      v0, 0x0084(a0)              // v0 = item special struct
        li      t8, charge_level_array      // t8 = charge_level_array
        // Copy the next 34 lines of subroutine 0x80168B00
        OS.copy_segment(0xE3554, 0x88)
        li      t5, charge_level_array      // t5 = charge_level_array
        // Copy the next 14 lines of subroutine 0x80168B00
        OS.copy_segment(0xE35E4, 0x38)
    }




    // @ Description
    // Runs when a Shadow Ball collides with a hurtbox or shield, is absorbed, or clangs.
    // Based on 0x80168D24, which is the equivalent for Charge Shot.
    scope shadow_ball_hurtbox_collision_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x00014(sp)             // store ra
        lw      v0, 0x0084(a0)              // v0 = projectile special struct
        lw      a1, 0x0104(v0)              // a1 = projectile damage
        lw      a0, 0x0074(a0)              // a0 = projectile first bone(0) struct
        addiu   a0, a0, 0x001C              // a0 = projectile x/y/z coordinates
        li      t6, GFX.current_gfx_id      // t6 = current_gfx_id
        lli     at, 0x006C                  // at = dark cross id
        jal     0x800FE2F4                  // create fire cross effect
        sw      at, 0x0000(t6)              // set dark cross as current GFX id
        jal     0x800269C0                  // play FGM
        lli     a0, 0x003C                  // FGM id = 0x3C
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0018              // deallocate stack space
        jr      ra                          // return
        lli     v0, 0x0001                  // return 1 (destroy projectile)
    }

    // @ Description
    // Collision subroutine for Shadow Ball.
    // Based on 0x801688C4, which is the equivalent for Charge Shot.
    scope shadow_ball_collision_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x00014(sp)             // store ra
        lw      v0, 0x0084(a0)              // v0 = projectile special struct
        lw      t6, 0x029C(v0)              // t6 = frame count
        beql    t6, r0, _end                // skip if projectile is not active (frame counter hasn't started)
        or      v0, r0, r0                  // return 0 (don't destroy projectile)

        jal     0x80167C04                  // charge shot collision detection?
        sw      a0, 0x0018(sp)              // 0x0018(sp) = projectile object
        beqz    v0, _end                    // end if collision wasn't detected
        lw      a0, 0x0018(sp)              // a2 = projectile object
        // if collision was detected
        lw      v0, 0x0084(a0)              // v0 = projectile special struct
        lw      a0, 0x0074(a0)              // a0 = projectile first bone(0) struct
        addiu   a0, a0, 0x001C              // a0 = projectile x/y/z coordinates
        li      t7, GFX.current_gfx_id      // t7 = current_gfx_id
        lw      t6, 0x02A4(v0)              // t6 = charge level
        lli     at, 0x0007                  // at = 7 (full charge)
        beq     at, t6, _full_charge        // branch if projectile is fully charged
        nop

        // if projectile is not fully charged
        lli     at, 0x005C                  // at = blue explosion id
        jal     0x80100480                  // create explosion effect
        sw      at, 0x0000(t7)              // set blue explosion as current GFX id
        jal     0x801008F4                  // screen shake
        lli     a0, 0x0000                  // shake severity = light
        jal     0x800269C0                  // play FGM
        lli     a0, 0x0000                  // FGM id = 0
        b       _end                        // end subroutine
        lli     v0, 0x0001                  // return 1 (destroy projectile)

        _full_charge:
        lli     at, 0x005D                  // at = "blue bomb explosion" id
        jal     0x801005C8                  // create large explosion effect
        sw      at, 0x0000(t7)              // set blue bomb explosion as current GFX id
        jal     0x801008F4                  // screen shake
        lli     a0, 0x0001                  // shake severity = moderate
        jal     0x800269C0                  // play FGM
        lli     a0, 0x0001                  // FGM id = 1
        lli     v0, 0x0001                  // return 1 (destroy projectile)

        _end:
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Runs when a Shadow Ball collides with edges of a shield and bounces off.
    // Wrapped version of 0x80168D54, which is the shield collision subroutine for Carge Shot.
    scope shadow_ball_shield_collision_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x00014(sp)             // store ra
        lw      v0, 0x0084(a0)              // v0 = projectile special struct
        lli     at, OS.TRUE                 // at = TRUE
        jal     0x80168D54                  // original subroutine
        sw      at, 0x02B0(v0)              // set shield bounce flag to TRUE
        lw      ra, 0x0014(sp)              // load ra
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop
    }

    OS.align(16)
    projectile_struct:
    constant SBALL_ID(0x1002)
    dw 0x00000000                           // unknown
    dw 0x00000002                           // projectile id
    dw Character.GOKU_file_7_ptr            // address of Mewtwo's file 8 pointer
    dw 0x00000000                           // 00000000
    dw 0x122E0000                           // Render routine?
    dw shadow_ball_main_                    // This is the main subroutine for the projectile, handles duration and other things. (default 0x80168BFC)
    dw shadow_ball_collision_               // This is the collision subroutine for the projectile, responsible for detecting collision with clipping. (default 0x80168CC4)
    dw shadow_ball_hurtbox_collision_       // This function runs when the projectile collides with a hurtbox. (default 0x80168D24)
    dw shadow_ball_hurtbox_collision_       // This function runs when the projectile collides with a shield. (default 0x80168D24)
    dw shadow_ball_shield_collision_        // This function runs when the projectile collides with edges of a shield and bounces off. (default 0x80168D54)
    dw shadow_ball_hurtbox_collision_       // This function runs when the projectile collides/clangs with a hitbox. (default 0x80168D24)
    dw 0x80168DA4                           // This function runs when the projectile collides with Fox's reflector. (default 0x80168DA4)
    dw shadow_ball_hurtbox_collision_       // This function runs when the projectile collides with Ness's psi magnet. (default 0x80168D24)
    OS.align(16)                            // pad to 0x10

    // @ Description
    // Adds a charge level struct for Mewtwo.
    // graphic_size - graphic size multiplier
    // speed - x speed
    // damage - hitbox damage
    // hitbox_size - hitbox size
    // unknown_1 - unknown, always 10 for charge shot
    // shot_fgm - fgm to play when shooting
    // charge_fgm - fgm to play when charging
    // hit_fgm - fgm to play when the projectile hits an opponent
    // priority - clang priority (all projectiles are 1 other than full charge shot)
    macro add_charge_level(graphic_size, speed, damage, hitbox_size, unknown_1, shot_fgm, charge_fgm, hit_fgm, priority) {
        float32 {graphic_size}              // 0x00 - graphic size multiplier
        float32 {speed}                     // 0x04 - x speed
        dw {damage}                         // 0x08 - hitbox damage
        dw {hitbox_size}                    // 0x0C - hitbox size
        dw {unknown_1}                      // 0x10 - unknown, always 10 for charge shot
        dw {shot_fgm}                       // 0x14 - fgm to play when shooting
        dw {charge_fgm}                     // 0x18 - fgm to play when charging
        dw {hit_fgm}                        // 0x1C - fgm to play when the projectile hits an opponent
        dw {priority}                       // 0x20 - clang priority (all projectiles are 1 other than full charge shot)
    }

    OS.align(16)
    charge_level_array:
    add_charge_level(130, 70,  2,  90, 10,  0x1A,  0x3C9, 0x1C, 1)      // level 0
    add_charge_level(160, 72,  4, 110, 10,  0x1A,  0x3CA, 0x1C, 1)      // level 1
    add_charge_level(200, 74,  6, 130, 10,  0x1A,  0x3CB, 0x1B, 1)      // level 2
    add_charge_level(260, 76,  9, 150, 10,  0x3C,  0x3CC, 0x1B, 1)      // level 3
    add_charge_level(330, 78, 12, 170, 10,  0x3C,  0x3CD, 0x1B, 1)      // level 4
    add_charge_level(410, 80, 15, 190, 10,  0x3C,  0x3CE, 0x19, 1)      // level 5
    add_charge_level(500, 82, 18, 210, 10,  0x3C,  0x3CF, 0x19, 1)      // level 6
    add_charge_level(600, 84, 22, 230, 10,  0xC1,  0x3D0, 0x19, 2)      // level 7
}
