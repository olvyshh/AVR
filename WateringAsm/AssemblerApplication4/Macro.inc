

.macro RamErase
	clr SysReg1
	clr SysReg2
	clr SysReg3
	clr SysReg4
	clr CurrentWindow
	clr Status
	clr dispDataReg

	ldi ZL,low(SRAM_START)
	ldi ZH,high(SRAM_START)

raminit:
	ldi SysReg1,0x00
	st Z+,SysReg1
	ldi SysReg1,low(RAMEND)
	cp ZL,SysReg1
	brne raminit
	ldi SysReg1,high(RAMEND)
	cp ZH,SysReg1
	brne raminit
.endm


.macro delay5
	push SysReg1
	push SysReg2
	push SysReg3


	ldi SysReg1,low(@0)
	ldi SysReg2,high(@0)
	ldi SysReg3,byte3(@0)

 delay5w1:
	subi SysReg1,1
	sbci SysReg2,0
	sbci SysReg3,0
	brcc delay5w1  

	pop SysReg3
	pop SysReg2
	pop SysReg1
.endm





.macro initStack
    ldi SysReg1,low(RAMEND)
	out SPL,SysReg1
	ldi SysReg1,high(RAMEND)
	out SPH,SysReg1
.endm
















.macro outi 
	push SysReg1
	ldi SysReg1,@1
	out @0,SysReg1
	pop SysReg1
.endm






.macro mldi
	ldi SysReg1,@1
	mov @0,SysReg1
.endm






.macro stsi
ldi SysReg1,@1
sts @0,SysReg1
.endm



.macro inc2bVar
	push SysReg1
	push SysReg2
	push SysReg3
	push SysReg4

;==========================================

	clr SysReg1
	ldi SysReg2,1

	lds SysReg3,@0
	lds SysReg4,@0+1

	add SysReg3,SysReg2
	adc SysReg4,SysReg1

	sts @0,SysReg3
	sts @0+1,SysReg4

;==========================================
	pop SysReg4
	pop SysReg3
	pop SysReg2
	pop SysReg1
.endm


.macro inc3bVar
	push SysReg1
	push SysReg2
	push SysReg3
	push SysReg4
	push r18


;==========================================

	clr SysReg1
	ldi SysReg2,1

	lds SysReg3,@0
	lds SysReg4,@0+1
	lds r18,@0+2

	add SysReg3,SysReg2
	adc SysReg4,SysReg1
	adc r18,SysReg1

	sts @0,SysReg3
	sts @0+1,SysReg4
	sts @0+2,r18
;==========================================

	pop r18
	pop SysReg4
	pop SysReg3
	pop SysReg2
	pop SysReg1
.endm



.macro initVar 
	ldi SysReg1,0xFF
	mov WatCR,SysReg1
	clr r0
	clr r1
	clr r2
	clr r3
	ldi r16,0
	mov r3,r16
	clr r4
	clr r5
	clr r6
	clr r7
	clr r8
	clr r9
	clr r10
	clr r11
	clr r12
	clr r13
	clr r14
	clr r15
.endm


.macro initPort 
	outi DDRC,$FF
	outi DispPort,$00
	outi DDRB,$00
	outi PORTB,$FF
	outi DDRD,$FF
	outi WatPort,$00
.endm

.macro initEEPROM

.endm


.macro clr2bVar
	push SysReg1


;==========================================

	clr SysReg1
	sts @0,SysReg1
	sts @0+1,SysReg1

;==========================================

	pop SysReg1
.endm


.macro getAddr

	ldi r16,0
	mov r17,@1
	lsl r17
	ldi ZL,low(@0)
	ldi ZH,high(@0)
	lsl ZL
	ROL ZH
	add ZL,r17
	adc ZH,r16
	lpm XL,Z+
	lpm XH,Z
	mov ZL,XL
	mov ZH,XH


.endm


.macro hexToAscii 
;********************ƒŒœ»—¿“‹
subi @0,-48
ldi ZL,6
ldi ZH,9
.endm

.macro cpmemi ;Var,value
;********************ƒŒœ»—¿“‹
lds SysReg1,@0
cpi SysReg1,@1
.endm

.macro cpmemwi ;Var,value

;********************ƒŒœ»—¿“‹
lds SysReg1,@0
cpi SysReg1,@1
.endm

.macro cpmem ;Var,value
;********************ƒŒœ»—¿“‹
lds SysReg1,@0
lds SysReg3,@0+1
lds SysReg4,@1
lds SysReg5,@1+1


.endm

.macro wordToTime
;********************ƒŒœ»—¿“‹
ldi XL,2
ldi XH,3
.endm

.macro getBit
;********************ƒŒœ»—¿“‹
ldi SysReg1,69
.endm


.macro getBitmem
;********************ƒŒœ»—¿“‹
ldi SysReg1,69
.endm