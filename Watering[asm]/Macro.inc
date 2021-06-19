.def t0=r17
.def t1=r18
.def t2=r19
.equ t=100000


.macro delay
	push t0
	push t1
	push t2

	ldi t0,low(@0)
	ldi t1,high(@0)
	ldi t2,byte3(@0)
 w1:

	subi t0,1
	sbci t1,0
	sbci t2,0
	brcc w1  

	pop t2
	pop t1
	pop t0
.endm

.macro StackSet
    ldi r16,low(RAMEND)
	out SPL,tp
	ldi r16,high(RAMEND)
	out SPH,tp
.endm
