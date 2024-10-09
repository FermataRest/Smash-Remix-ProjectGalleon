// UziSpecial.asm

// This file contains subroutines used by Uzi's special moves.

// @ Description
// Subroutines for Neutral Special
scope UziNSP {

    // @ Description
    // based on Fox's at 0x8015BC78
    scope kirby_ground_begin_initial: {
        addiu   sp, sp, -0x20
        sw      ra, 0x001C(sp)
        sw      a0, 0x0020(sp)
        sw      r0, 0x0010(sp)
        addiu   a1, r0, Kirby.Action.SLIPPY_NSP_Ground
        addiu   a2, r0, 0x0000
        jal     0x800E6F24          // change action
        lui     a3, 0x3F80
        jal     0x800E0830
        lw      a0, 0x0020(sp)
        jal     0x8015BC68
        lw      a0, 0x0020(sp)
        lw      ra, 0x001C(sp)
        jr      ra
        addiu   sp, sp, 0x20
    }

    // based on Fox's at 0x8015BCB8
    scope kirby_air_begin_initial: {
        addiu   sp, sp, -0x20
        sw      ra, 0x001C(sp)
        sw      a0, 0x0020(sp)
        addiu   t6, r0, 0x0008
        sw      t6, 0x0010 (sp)
        addiu   a1, r0, Kirby.Action.SLIPPY_NSP_Air
        addiu   a2, r0, 0x0000
        jal     0x800E6F24          // change action
        lui     a3, 0x3F80
        jal     0x800E0830
        lw      a0, 0x0020(sp)
        jal     0x8015BC68
        lw      a0, 0x0020(sp)
        lw      ra, 0x001C(sp)
        jr      ra
        addiu   sp, sp, 0x20
    }

    // @ Description
    // Main subroutine for Uzi's neutral special.
    // a0 = player object
    scope main_: {
        addiu   sp, sp,-0x0028              // allocate stack space
        sw      ra, 0x0014(sp)              // ~
        sw      a0, 0x0028(sp)              // store ra, a0
        lw      v0, 0x0084(a0)              // v0 = player struct
        lw      t6, 0x017C(v0)              // t6 = temp variable 1
        beql    t6, r0, _continue           // branch if temp variable 1 is not set
        mtc1    r0, f6                      // f6 = 0
        
        // if temp variable 1 is set
        addiu   a1, sp, 0x0018              // 0x0018(sp) = offset coordinates
        sw      r0, 0x017C(v0)              // reset temp variable 1
        sw      r0, 0x0018(sp)              // x offset = 0
        lui     at, 0x4200                  // ~
        sw      at, 0x001C(sp)              // y offset = 32
        lui     at, 0x43AA                  // ~
        sw      at, 0x0020(sp)              // z offset = 340
        jal     0x800EDF24                  // returns x/y/z coordinates of the model part in a0 to a1, a1 can also contain offset coordinates
        lw      a0, 0x092C(v0)              // a0 = weapon part struct
        lw      a0, 0x0028(sp)              // a0 = player object
        jal     laser_stage_setting_        // create projectile
        addiu   a1, sp, 0x0018              // a1 = coordinates to create projectile at
        lw      a0, 0x0028(sp)              // a0 = player object
        mtc1    r0, f6                      // f6 = 0
        
        _continue:
        lwc1    f8, 0x0078(a0)              // ~
        c.le.s  f8, f6                      // ~
        nop                                 // ~
        bc1fl   _end                        // branch if animation end hasn't been reached
        lw      ra, 0x0014(sp)              // load ra
        
        jal     0x800DEE54                  // idle/fall transition
        nop
        lw      ra, 0x0014(sp)              // load ra
        
        _end:
        jr      ra                          // return
        addiu   sp, sp, 0x0028              // deallocate stack space
    }

    // @ Description
    // Subroutine which handles air collision for neutral special actions
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
    // Subroutine which handles ground to air transition for neutral special actions
    scope air_to_ground_: {
        addiu   sp, sp,-0x0038              // allocate stack space
        sw      ra, 0x001C(sp)              // store ra
        sw      a0, 0x0038(sp)              // 0x0038(sp) = player object
        lw      a0, 0x0084(a0)              // a0 = player struct
        jal     0x800DEE98                  // set grounded state
        sw      a0, 0x0034(sp)              // 0x0034(sp) = player struct
        lw      v0, 0x0034(sp)              // v0 = player struct
        lw      a0, 0x0038(sp)              // a0 = player object
        
        lw      a2, 0x0008(v0)              // load character ID
        lli     a1, Character.id.KIRBY      // a1 = id.KIRBY
        beql    a1, a2, _change_action      // if Kirby, load alternate action ID
        lli     a1, Kirby.Action.SLIPPY_NSP_Ground
        lli     a1, Character.id.JKIRBY     // a1 = id.JKIRBY
        beql    a1, a2, _change_action      // if J Kirby, load alternate action ID
        lli     a1, Kirby.Action.SLIPPY_NSP_Ground
        
        
        addiu   a1, r0, 0x00E1              // a1 = equivalent ground action for current air action
        _change_action:
        lw      a2, 0x0078(a0)              // a2(starting frame) = current animation frame
        lui     a3, 0x3F80                  // a3(frame speed multiplier) = 1.0
        jal     0x800E6F24                  // change action
        sw      r0, 0x00010(sp)             // argument 4 = 0
        lw      ra, 0x001C(sp)              // load ra
        jr      ra                          // return
        addiu   sp, sp, 0x0038              // deallocate stack space
    }
    
    // @ Description
    // Initial subroutine for Uzi's laser.
    scope laser_stage_setting_: {
        addiu   sp, sp,-0x0030              // allocate stack space
        sw      a1, 0x0024(sp)              // ~
        sw      ra, 0x0014(sp)              // store ra, a1
        li      a1, projectile_struct       // a1 = projectile struct
        lw		a2, 0x0024(sp)              // a2 = create coordinates
        jal     0x801655C8                  // general projectile creation
        lui     a3, 0x8000                  // a3 = 0x80000000
        beq     v0, r0, _end_stage_setting  // if 801655C8 returns 0, there's no space to create a new projectile object, so skip to end
        nop
        
        lw      v1, 0x0084(v0)              // v0 = projectile special struct
        lui     at, 0x4396                  // ~
        mtc1    at, f8                      // projectile speed = 300
        lwc1    f12, 0x0024(v1)             // f12 = y speed? argument for 0x8001863C?
        lwc1    f6, 0x0018(v1)              // ~
        cvt.s.w f6, f6                      // v0 = DIRECTION
        mul.s   f14, f6, f8                 // f14 = speed * DIRECTION
        swc1    f14, 0x0020(v1)             // store projectile speed
        jal     0x8001863C                  // unknown subroutine
        sw      v0, 0x0018(sp)              // 0x0018(sp) = projectile object
        lw      t7, 0x0018(sp)              // t7 = projectile object
        lw      t8, 0x0074(t7)              // t8 = projectile first part struct
        swc1    f0, 0x0038(t8)              // update projectile rotation (returned by 0x8001863C)
        jal     create_green_blast_gfx_     // unknown subroutine (pink ball graphic?)
        lw      a0, 0x0024(sp)              // a0 = creation coordinates
        lw      v0, 0x0018(sp)              // v0 = projectile object
        
        _end_stage_setting:
        lw      ra, 0x0014(sp)              // load ra
        jr      ra                          // return    
        addiu   sp, sp, 0x0030              // deallocate stack space
    }

    // @ Description
    // Based on 0x80103320
    scope create_green_blast_gfx_: {
        addiu          sp, sp, -0x18
        or             a2, a0, r0
        sw             ra, 0x0014(sp)

        lui            a0, 0x8013
        lw             a0, 0x13C4(a0)
        sw             a2, 0x0018(sp)
        jal            0x800CE870
        addiu          a1, r0, 0x0097       // gfx routine index
        lw             a2, 0x0018(sp)
        beqz           v0, _end
        or             v1, v0, r0
        lwc1           f4, 0x0000(a2)
        swc1           f4, 0x0020(v0)
        lwc1           f6, 0x0004(a2)
        swc1           f6, 0x0024(v0)
        lwc1           f8, 0x0008(a2)
        swc1           f8, 0x0028(v0)

        _end:
        lw             ra, 0x0014(sp)
        addiu          sp, sp, 0x18
        jr             ra
        or             v0, v1, r0
    }    
    
    // @ Description
    // Projectile struct for Uzi's laser.
    OS.align(16)
    projectile_struct:
    dw 0x00000000
    dw 0x00000001
    dw Character.UZI_file_6_ptr
    OS.copy_segment(0x10391C, 0x28)
}