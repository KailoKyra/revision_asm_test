g_screenLineAddressTable:	ds	200*2	
	;; 0x28*2
CRTC_R1_VAL: equ 0x50 
	
init_screen_address_table:
	ld IX, g_screenLineAddressTable
	ld IY, 0xC000
	ld H, 0
_get_next_address_line:
	push IY  ; save the current 0xC000 + j * CRTC_R1_VAL (currentLineAddress)
	ld L, 0	 ; i
_get_address_line:
	ld B,iyl
	ld C,iyh
	ld (IX+0),  B		; g_screenLineAddressTable[i + (j << 3)] = currentLineAddress;
	ld (IX+1),  C
	inc IX			; + 2o (sizeof(char *))
	inc IX
	ld D, 0x8
	ld E, 0x00
	add IY, DE	     ; currentLineAddress += 0x800
	inc L			; ++i
	ld A, 8
	cp L	
	jp nz, _get_address_line
_get_address_line_end:
	pop IY			; get back the previous currentLine address
	ld BC, CRTC_R1_VAL	; set to next line block
	add IY, BC		; currentLineAddress += CRTC_R1_VAL;
	inc H			;++j
	ld A, 25
	cp H
	jp nz, _get_next_address_line
_get_next_address_line_end:
_init_screen_address_table_end:
	ret





	  ;Pass the sprite address in reg ix as param
draw_sprite:
	ld HL, g_screenLineAddressTable
	ld B, 0
	ld C, (IX+1)		; sprite.y for the line pos table offset (needs to be put in a 16 bit reg)
	ld A, (IX+3)		; sprite.h for the row loop
	add HL, BC		; select starting line on the screen (line[sprite.y])
	add HL, BC		;  as the line index array is of type short, we have to jump over 2 bytes / index
	ex HL, DE		; -> set as DE
	push IX
	pop HL			; ld HL, IX (set the pointer on the sprite struct)
	ld BC, #4
	add HL,	BC		; address of the sprite data in the struct
_draw_next_row:
	push DE			; As we will increment DE while copying the sprite line, we save it for the next round
	ex HL, DE		; Swap HL and DE to be able to apply the x offset to DE.. (cannot add with DE)
	;; need to deference DE..
	push HL
	pop IY
	ld H, (IY+1)
	ld L, (IY+0)
	
	ld B, 0			
	ld C, (IX+0) 
	add HL, BC		;  pos dest += sprite.x
	ex HL, DE		;	
	ld C, (IX+2) 		; sprite.w for ldir
_draw_next_line:
	ldir
draw_next_line_end:
	pop DE
	inc DE
	inc DE
	dec A
	jp nz, _draw_next_row
draw_next_row_end:
	ret



	

;Pass the sprite address in reg ix as param
clear_sprite:
	ld HL, g_screenLineAddressTable
	ld B, 0
	ld C, (IX+1)		; sprite.y for the line pos table offset (needs to be put in a 16 bit reg)
	ld D, (IX+3)		; sprite.h for the row loop
	add HL, BC		; select starting line on the screen (line[sprite.y])
	add HL, BC		;  as the line index array is of type short, we have to jump over 2 bytes / index
_erase_next_row:
	push HL			; As we will increment HL while copying the sprite line, we save it for the next round
	;; need to get a pointer to the pixel in the line..
	push HL
	pop IY
	ld H, (IY+1)
	ld L, (IY+0)
	
	ld B, 0			
	ld C, (IX+0) 
	add HL, BC		;  pos dest += sprite.x
	ld C, (IX+2) 		; sprite.w
_erase_next_line:
	ld A, #00
	ld (HL), A
	inc HL
	dec C
	jp nz, _erase_next_line
erase_next_line_end:
	pop HL
	inc HL
	inc HL
	dec D
	jp nz, _erase_next_row
erase_next_row_end:
	ret



set_palette:
	LD HL, _worm_palette	;test, use param
	LD D, #16
	LD E, #00
	LD BC, 0x7F00		;select pen reg
_pen_change_loop:
	LD, C, E
	out (C), C		; select pen ixh

	LD A, (HL)		; load palette color from HL
	out (C), A

	inc HL			; next palette color
	inc E			; next pen
	dec D
	jp nz, _pen_change_loop
_pen_change_loop_end:	
	ret



set_border_black:
	LD BC, 0x7F10		;select border reg	
	out (C), C
	LD C, 0x54		;set pen color	
	out (C), C
	ret
	

_worm2:
	db 0, 0, (17), 32			; x,y,w/2,h
	incbin '../assets/gfx/worm2b.spr'
_worm3:
	db 0, 0, (17), 32			; x,y,w/2,h
	incbin '../assets/gfx/worm3b.spr'
_worm4:
	db 0, 0, (17), 32			; x,y,w/2,h
	incbin '../assets/gfx/worm4b.spr'

_worm_palette:
	incbin '../assets/gfx/worm.pal'
