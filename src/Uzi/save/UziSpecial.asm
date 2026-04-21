// GoemonSpecial.asm

// This file contains subroutines used by Goemon's special moves.

scope UziNSP {
    constant WALK_MULTIPLIER(0x3E80)        // float32 0.25
    constant WALK_TRACTION(0x41F0)          // float32 30
    constant AIR_SPEED(0x41E0)              // float32 28
    constant CHARGE_TIME(18)
    constant SFX_RYO_SHOOT_1(28)
    constant SFX_RYO_SHOOT_2(65)
    constant SFX_RYO_FIRE(27)

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
        bne     t7, at, _continue           // branch if charge timer != CHARGE_TIME
        sw      a0, 0x0018(sp)              // 0x0018(sp) = player object

        // if we reach this point play a sound, begin the GFX routine and set the charge flag
        lli     at, OS.TRUE                 // ~
        sw      at, 0x0B1C(v0)              // set charge flag to TRUE
        FGM.play(SFX_RYO_SHOOT_1)           // play first sfx
        FGM.play(SFX_RYO_SHOOT_2)           // play second sfx
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
        jal     ground_end_initial_         // transition to NSP_Ground_End
        nop

        _end:
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0028              // deallocate stack space
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
    dw Character.UZI_file_6_ptr          // address of goemon's file 6 pointer
    dw 0x00000000                           // offset to hitbox
    dw 0x12450000                           // Render routine
    dw ryo_main_                            // This is the main subroutine for the projectile, handles duration and other things. (default 0x80168540) (samus 0x80168F98)
    dw ryo_collision_                       // This is the collision subroutine for the projectile, responsible for detecting collision with clipping.
    dw ryo_destruction_                     // This function runs when the projectile collides with a hurtbox.
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
    dw Character.UZI_file_6_ptr          // 0x0024   projectile data pointer
    dw 0x00000040                           // 0x0028   offset to hitbox
    dw 0x00000000                           // 0x002C   palette index (0 = mario, 1 = luigi)
}