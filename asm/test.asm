test:

	LD IX, _worm2
	call draw_sprite

	call delay_anim
	LD IX, _worm3
	call draw_sprite

	call delay_anim
	LD IX, _worm4
	call draw_sprite
	
	
	call delay_anim
	LD IX, _worm3
	call draw_sprite

	call delay_anim
	LD IX, _worm2
	call draw_sprite
	call delay_anim

	call clear_sprite

	;;  test test test
	LD IX, _worm2
	INC (IX)
	LD IX, _worm3
	INC (IX)
	LD IX, _worm4
	INC (IX)
	
	jp test



delay_anim:
	ld BC, 0x5FFF
	ld A, #0
_delay_loop:
	dec C
	cp C
	jp nz, _delay_loop
_delay_loop_2:
	ld C, 0xFF
	dec B
	cp B
	jp nz, _delay_loop
	ret
	
	
