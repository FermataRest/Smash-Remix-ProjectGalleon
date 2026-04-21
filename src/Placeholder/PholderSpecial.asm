// RyuSpecial.asm

scope PholderUSP {
    // floating point constants for physics and fsm
    constant AIR_Y_SPEED(0x0)            // current setting - float32 92
    constant GROUND_Y_SPEED(0x0)         // current setting - float32 98
    constant X_SPEED(0x4140)                // current setting - float32 12
    constant AIR_ACCELERATION(0x3a83)       // current setting - float32 0.0099
    constant AIR_SPEED(0x4120)              // current setting - float32 10
    constant LANDING_FSM(0x3EC0)            // current setting - float32 0.375
    // temp variable 3 constants for movement states
    constant BEGIN(0x1)
    constant BEGIN_MOVE(0x2)
    constant MOVE(0x3)

    // @ Description
    // Subroutine which runs when Ryu initiates an aerial up special.
    // Changes action, and sets up initial variable values.
    scope air_initial_: {
        addiu   sp, sp, 0xFFE0              // ~
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // original lines 1-3
        sw      r0, 0x0010(sp)              // argument 4 = 0
        lli     a1, 0xE0      // a1 = Action.USPA
        or      a2, r0, r0                  // a2 = float: 0.0
        jal     0x800E6F24                  // change action
        lui     a3, 0x3F80                  // a3 = float: 1.0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      a0, 0x0020(sp)              // ~
        lw      a0, 0x0084(a0)              // a0 = player struct
        sw      r0, 0x017C(a0)              // temp variable 1 = 0
        sw      r0, 0x0180(a0)              // temp variable 2 = 0
        ori     v1, r0, 0x0002              // ~
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
        addiu   sp, sp, 0x0020              // ~
        jr      ra                          // original return logic
        nop
    }

    // @ Description
    // Subroutine which runs when Ryu initiates a grounded up special.
    // Changes action, and sets up initial variable values.
    scope ground_initial_: {
        addiu   sp, sp, 0xFFE0              // ~
        sw      ra, 0x001C(sp)              // ~
        sw      a0, 0x0020(sp)              // original lines 1-3

        lw      a0, 0x0084(a0)              // a0 = player struct
        lw      t7, 0x014C(a0)              // t7 = kinetic state
        bnez    t7, _change_action          // skip if kinetic state !grounded
        nop
        jal     0x800DEEC8                  // set aerial state
        nop
        lw      a0, 0x0020(sp)

        _change_action:
        sw      r0, 0x0010(sp)              // argument 4 = 0
        lli     a1, 0xE0      // a1 = Action.USPG
        or      a2, r0, r0                  // a2 = float: 0.0
        jal     0x800E6F24                  // change action
        lui     a3, 0x3F80                  // a3 = float: 1.0
        jal     0x800E0830                  // unknown common subroutine
        lw      a0, 0x0020(sp)              // a0 = player object
        lw      a0, 0x0020(sp)              // ~
        lw      a0, 0x0084(a0)              // a0 = player struct
        sw      r0, 0x017C(a0)              // temp variable 1 = 0
        sw      r0, 0x0180(a0)              // temp variable 2 = 0
        ori     v1, r0, 0x0002              // ~
        sw      v1, 0x0184(a0)              // temp variable 3 = 0x1(BEGIN)
        lw      ra, 0x001C(sp)              // ~
        addiu   sp, sp, 0x0020              // ~
        jr      ra                          // original return logic
        nop
    }

}
scope PholderSpecial {
    scope UTILT: {
        constant A_PRESSED(0x8000)  // bitmask for a press

        // tmp variable 3 0x0184 -- used to check if A was ever pressed down during the move

        scope main: {
            OS.routine_begin(0x20)

            lw      v0, 0x0084(a0)  // v0 = player struct

            lw      t0, 0x0078(a0)  // t0 = current animation frame
            lui     t1, 0x4000      // t1 = 1.0F

            // if frame != 1, skip
            bne     t0, t1, main_continue
            nop
            
            sw      r0, 0x0184(v0)              // reset tmp variable 3 = 0

            main_continue:
            sw      a0, 0x0010(sp)
            
            lw      v0, 0x0084(a0)              // loads player struct into v0
            lhu     t1, 0x01BE(v0)              // load button press buffer
            andi    t2, t1, A_PRESSED           // t2 = 0x80 if (A_PRESSED); else t2 = 0
            bne     t2, r0, register_press            // if A is pressed
            nop

            b   normal
            nop

            register_press:
            lli     t0, 0x1
            sw      t0, 0x0184(v0)

            b       normal
            nop

            normal:
            lw      t0, 0x0078(a0)  // t0 = current animation frame
            mtc1    t0, f6
            lui     t1, 0x41A0      // t1 = 20.0F
            mtc1    t1, f8

            c.eq.s  f6, f8
            nop
            bc1fl   main_normal
            nop

            lw      t0, 0x0184(v0)          // was A or B ever pressed during the move?
            beq     t0, r0, main_normal     // If not, main_normal
            nop

            // all conditions are met
            b cancel_utilt_2
            nop

            cancel_utilt_2:
            OS.save_registers()
            lli     a1, Pholder.Action.JAB_L    // a1 = Action.SWEEP1
            or      a2, r0, r0                  // a2(starting frame) = 0.0
            lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
            lli     t6, 0x0003                  // ~
            sw      t6, 0x0010(sp)              // argument 4 = 0x0003 keep hitboxes
            jal     0x800E6F24                  // change action
            nop
            OS.restore_registers()
            OS.routine_end(0x20)

            main_normal:
            jal     0x800D94C4          // original routine
            nop
            OS.routine_end(0x20)
        }
    }

    scope RR3KICKS: {
        constant A_PRESSED(0x8000)  // bitmask for a press
        constant B_PRESSED(0x4000)  // bitmask for b press

        // tmp variable 3 0x0184 -- used to check if A or B was ever pressed down during the move

        scope main: {
            OS.routine_begin(0x20)

            lw      v0, 0x0084(a0)  // v0 = player struct

            lw      t0, 0x0078(a0)  // t0 = current animation frame
            lui     t1, 0x4000      // t1 = 1.0F

            // if frame != 1, skip
            bne     t0, t1, main_continue
            nop
            
            sw      r0, 0x0184(v0)              // reset tmp variable 3 = 0

            main_continue:
            sw      a0, 0x0010(sp)
            
            lw      v0, 0x0084(a0)              // loads player struct into v0
            lhu     t1, 0x01BE(v0)              // load button press buffer
            andi    t2, t1, A_PRESSED           // t2 = 0x80 if (A_PRESSED); else t2 = 0
            bne     t2, r0, register_press            // if A is pressed
            nop

            andi    t2, t1, B_PRESSED           // t2 = 0x80 if (A_PRESSED); else t2 = 0
            bne     t2, r0, register_press            // if A is pressed
            nop

            b   normal
            nop

            register_press:
            lli     t0, 0x1
            sw      t0, 0x0184(v0)

            b       normal
            nop

            normal:
            lw     t3, 0x0024(v0)              // t3 = current action

            // Here, we load into t1 the frame in which each step of the move should check for a transition
            lli    t2, Action.FTiltMidHigh
            beq    t2, t3, normal_continue
            lui    t1, 0x41A0      // t1 = 20.0F

            lli    t2, Action.FTiltHigh
            beq    t2, t3, normal_continue
            lui    t1, 0x41A0      // t1 = 20.0F

            lli    t2, Pholder.Action.JAB_L
            beq    t2, t3, normal_continue
            lui    t1, 0x4198      // t1 = 19.0F

            lli    t2, Pholder.Action.JAB_L
            beq    t2, t3, normal_continue
            lui    t1, 0x41B0      // t1 = 22.0F

            normal_continue:
            lw      t0, 0x0078(a0)  // t0 = current animation frame
            mtc1    t0, f6
            mtc1    t1, f8

            c.eq.s  f6, f8
            nop
            bc1fl   main_normal
            nop

            lw      t0, 0x0184(v0)          // was A or B ever pressed during the move?
            beq     t0, r0, main_normal     // If not, main_normal
            nop

            // all conditions are met
            b cancel_next
            nop

            cancel_next:
            lw     t1, 0x0024(v0)              // t1 = current action

            // we'll use t2 to store the next action as we jump

            lli    t2, Action.FTiltMidHigh
            beq    t1, t2, cancel_next_change_action
            lli    t2, Pholder.Action.JAB_L

            lli    t2, Action.FTiltHigh
            beq    t1, t2, cancel_next_change_action
            lli    t2, Pholder.Action.JAB_L

            lli    t2, Pholder.Action.JAB_L
            beq    t1, t2, cancel_next_change_action
            lli    t2, Pholder.Action.JAB_L

            lli    t2, Pholder.Action.JAB_L
            beq    t1, t2, cancel_next_change_action
            lli    t2, Pholder.Action.JAB_L

            cancel_next_change_action:
            OS.save_registers()
            or      a1, r0, t2                  // a1 = t2 = next action
            or      a2, r0, r0                  // a2(starting frame) = 0.0
            lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
            sw      r0, 0x0010(sp)              // argument 4 = 0
            jal     0x800E6F24                  // change action
            nop
            OS.restore_registers()
            OS.routine_end(0x20)

            main_normal:
            jal     0x800D94C4          // original routine
            nop
            OS.routine_end(0x20)
        }
    }


    scope TSUNAMI: {
        constant A_PRESSED(0x8000)  // bitmask for a press

        // tmp variable 3 0x0184 -- used to check if A was ever pressed down during the move

        scope main: {
            OS.routine_begin(0x20)

            lw      v0, 0x0084(a0)  // v0 = player struct

            lw      t0, 0x0078(a0)  // t0 = current animation frame
            lui     t1, 0x4000      // t1 = 1.0F

            // if frame != 1, skip
            bne     t0, t1, main_continue
            nop
            
            sw      r0, 0x0184(v0)              // reset tmp variable 3 = 0

            main_continue:
            sw      a0, 0x0010(sp)
            
            lw      v0, 0x0084(a0)              // loads player struct into v0
            lhu     t1, 0x01BE(v0)              // load button press buffer
            andi    t2, t1, A_PRESSED           // t2 = 0x80 if (A_PRESSED); else t2 = 0
            bne     t2, r0, register_press            // if A is pressed
            nop

            b   normal
            nop

            register_press:
            lli     t0, 0x1
            sw      t0, 0x0184(v0)

            b       normal
            nop

            normal:
            lw      t0, 0x0078(a0)  // t0 = current animation frame
            mtc1    t0, f6
            lui     t1, 0x4180      // t1 = 16.0F
            mtc1    t1, f8

            c.eq.s  f6, f8
            nop
            bc1fl   main_normal
            nop

            lw      t0, 0x0184(v0)          // was A or B ever pressed during the move?
            beq     t0, r0, main_normal     // If not, main_normal
            nop

            // all conditions are met
            b cancel_tsunami_2
            nop

            cancel_tsunami_2:
            OS.save_registers()
            lli     a1, Pholder.Action.JAB_L  // a1 = Action.SWEEP1
            or      a2, r0, r0                  // a2(starting frame) = 0.0
            lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
            lli     t6, 0x0003                  // ~
            sw      t6, 0x0010(sp)              // argument 4 = 0x0003 keep hitboxes
            jal     0x800E6F24                  // change action
            nop
            OS.restore_registers()
            OS.routine_end(0x20)

            main_normal:
            jal     0x800D94C4          // original routine
            nop
            OS.routine_end(0x20)
        }
    }

    scope DASH: {
        // tmp variable 3 0x0184 -- used to keep track of the wavedash input
        // in the first frame, we set it to 0
        // check for neutral stick to set it to 1
        // then check for a diagonal (down-forward) input to trigger an action change

        scope main: {
            OS.routine_begin(0x20)

            lw      v0, 0x0084(a0)  // v0 = player struct

            lw      t0, 0x0078(a0)  // t0 = current animation frame
            lui     t1, 0x4000      // t1 = 1.0F

            // if frame != 1, skip
            bne     t0, t1, main_continue
            nop
            
            sw      r0, 0x0184(v0)              // reset tmp variable 3 = 0

            main_continue:
            sw      a0, 0x0010(sp)
            
            lw      t0, 0x0184(v0)

            lli    t1, 0x0
            beq    t0, t1, check_neutral
            nop

            lli    t1, 0x1
            beq    t0, t1, check_diagonal
            nop

            b   main_normal
            nop

            check_neutral:
            lb      t2, 0x01C2(a2)                          // t2 = stick_x
            bgez    t2, check_neutral_continue			    // branch if positive value
            nop
            subu    t2, r0, t2					            // t2 = abs(stick.x)
            check_neutral_continue:
            slti    t1, t2, 70                             // t1 = 1 if abs(stick_x) < 70
            beq     t1, r0, main_normal                         // stick must be neutral in X
            nop

            // lb      t2, 0x01C3(a2)                          // t0 = stick_y
            // mtc1    t2, f6                                  // f6 = stick_y
            // abs.s   f6, f6                                  // f6 = abs(stick_y)
            // mfc1    t2, f6                                  // t0 = abs(stick_y)

            // slti    t1, t2, 70                             // t1 = 1 if abs(stick_y) < 70
            // beq     t1, r0, main_normal                         // stick must be neutral in Y
            // nop

            lli     t0, 0x1                             // ~
            sw      t0, 0x0184(v0)                      // X and Y are neutral, set tmp var to 1

            b main_normal
            nop

            check_diagonal:

            // Check Y
            lb      t0, 0x01C3(v0)              // t0 = stick_y
            slti    t1, t0, -39                 // at = 1 if stick_y < -39, else at = 0
            beql    t1, r0, main_normal              // branch if stick_y >= -40
            nop

            // Check X
            lb      t0, 0x01C2(a2)                          // t0 = stick_x
            lli     t1, 40                                  // t1 = stick range
            lw      t2, 0x0044(v0)                          // t2 = facing direction (1 = right, -1 = left)

            slti    t3, t2, 0
            beq     t3, r0, facing_right
            nop

            facing_left:
            slti    t1, t0, -10                 // t1 = 1 if stick_x < -39, else at = 0
            beql    t1, r0, main_normal              // branch if stick_x >= -40
            nop

            b check_diagonal_success // check ok
            nop

            facing_right:
            slti    t1, t0, 10                 // t1 = 1 if stick_y < -39, else at = 0
            bnel    t1, r0, main_normal              // branch if stick_x >= -40
            nop

            b check_diagonal_success // check ok
            nop

            check_diagonal_success:
            // all conditions are met
            b cancel_wavedash
            nop

            cancel_wavedash:
            OS.save_registers()
            lli     a1, Pholder.Action.JAB_L    // a1 = Action.SWEEP1
            or      a2, r0, r0                  // a2(starting frame) = 0.0
            lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
            lli     t6, 0x0003                  // ~
            sw      t6, 0x0010(sp)              // argument 4 = 0x0003 keep hitboxes
            jal     0x800E6F24                  // change action
            nop
            OS.restore_registers()
            OS.routine_end(0x20)

            main_normal:
            jal     0x800D94C4          // original routine
            nop
            OS.routine_end(0x20)
        }
    }

}