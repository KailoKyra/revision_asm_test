	org  0x170 ;; Start from address &170
	jp  init
	
	org  0x180
init:
	di
	ld HL, 0xC9FB       	    ;; Disable the system interrupts handlers (and put a ret there)
	ld (0x38), HL

;; mode 0
	ld BC, 0x7F8C
	out (C), C
	ei

	call init_screen_address_table
main:
	call set_palette
	call set_border_black
	call test
	jp main

include "scr_uti.asm"
include "test.asm"
