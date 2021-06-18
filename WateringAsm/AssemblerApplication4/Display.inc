	;Status
	;0b-DispRefresh
	;1b-TurnLeft
	;2b-TurnRighr
	;3b-ButtonClick
	;4b-d1First
	;5b-d2First
	;6b-ButtonWasOn
;========================================================================================================================================================================

.macro DispSendDataI
	push dispDataReg

	ldi dispDataReg,@0
	rcall DispSendData

	pop dispDataReg
.endm

;========================================================================================================================================================================

.macro DispSendComndi
	push dispDataReg

	ldi dispDataReg,@0
	rcall DispSendComnd

	pop dispDataReg
.endm

;========================================================================================================================================================================

.macro initDisp
	ldi CurrentWindow,0

	DispSendComndi 0x02
	DispSendComndi 0x08
	DispSendComndi 0x0C
	DispSendComndi 0x06
	DispSendComndi 0x01
	delay5 600
.endm
;========================================================================================================================================================================

.macro clrDisp
	DispSendComndi 0x01
	delay5 600
.endm

;========================================================================================================================================================================

.macro getWindowAddr 
	lsl @0
	clr SysReg1
	ldi ZL,low(MenuList)
	ldi ZH,high(MenuList)
	lsl ZL
	rol ZH
	add ZL,@0
	adc ZH,r17
	lpm XL,Z+
	nop
	lpm XH,Z
	nop


	mov ZL,XL
	mov ZH,XH
.endm

;========================================================================================================================================================================











.macro displayCheck
	push XL
	push XH
;==========================================

	lds XL,DWT
	lds XH,DWT+1

	cpi XL,low(DispRefreshTime*10/2)
	brcs displayCheckEnd
	cpi XH,high(DispRefreshTime*10/2)
	brcs displayCheckEnd
	
	clr XL
	sts DWT,XL
	sts DWT+1,XL
	ori Status,1
	
;==========================================
displayCheckEnd:
	pop XH
	pop XL

.endm


.macro InitSetWindowSet
	stsi curPos,0
	stsi scrPos,0
	stsi curMax,8
.endm

.macro InitMXWindowSet
	stsi curPos,0
	stsi scrPos,0
	stsi curMax,3
.endm

.macro InitWWindowSet
	stsi curPos,0
	stsi scrPos,0
	stsi curMax,1
.endm


.macro DispSendDataR
mov @0,DispDataReg
rcall DispSendData
.endm

.macro DispSendTime
hexToAscii XL ;
DispSendDataR ZL
DispSendDataR ZH
DispSendDataI 'h'
hexToAscii XH 
DispSendDataR ZL
DispSendDataR ZH
DispSendDataI 'm'

.endm