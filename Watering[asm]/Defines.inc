	;Status
	;0b-DispRefresh
	;1b-TurnLeft
	;2b-TurnRighr
	;3b-ButtonClick
	;4b-d1First
	;5b-d2First
	;6b-ButtonWasOn
	;7b-OneMin has gone - recalculate timers	
	.equ DispRefreshTime=300;ms
	.equ ButtonWaitTime=100;ms
	.equ WatTimeM0=1;min
	.equ WatTimeM1=1;min
	.equ WatTimeM2=1;min
	.equ WatTimeM3=1;min
	.equ WatTimeM4=1;min
	.equ WatTimeM5=1;min
	.equ WatTimeM6=1;min
	.equ WatTimeM7=1;min

	.def WatCR=r1

	.def dispDataReg=r19
	.def CurrentWindow=r20
	.def Status=r21	
	.def SysReg1=r22
	.def SysReg2=r23
	.def SysReg3=r24
	.def SysReg4=r25



	.equ DispPort=PORTC


	;0-RS
	;1-EN
	;2-D4
	;3-D5
	;4-D6
	;5-D7

	.equ WatPin=PIND
	.equ WatPort=PORTD
	;0-M0
	;1-M1
	;2-M2
	;3-M3
	;4-M4
	;5-M5
	;6-M6
	;7-M7

	.equ EncPin=PINB
	.equ EncPort=PORTB

	;0-Button
	;1-Enc+
	;2-Enc-