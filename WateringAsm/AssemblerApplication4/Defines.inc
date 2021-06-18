	;Status
	;0b-DispRefresh
	;1b-TurnLeft
	;2b-TurnRighr
	;3b-ButtonClick
	;4b-d1First
	;5b-d2First
	;6b-ButtonWasOn
	;7b- second enc pin ready	


	.equ DispRefreshTime=100;ms
	.equ ButtonWaitTime=100;ms
	.equ WatTime1M0=1;min
	.equ WatTime1M1=1;min
	.equ WatTime1M2=1;min
	.equ WatTime1M3=1;min
	.equ WatTime1M4=1;min
	.equ WatTime1M5=1;min
	.equ WatTime1M6=1;min
	.equ WatTime1M7=1;min

	.equ WatTime2M0=1;min
	.equ WatTime2M1=2;min
	.equ WatTime2M2=3;min
	.equ WatTime2M3=1;min
	.equ WatTime2M4=1;min
	.equ WatTime2M5=1;min
	.equ WatTime2M6=1;min
	.equ WatTime2M7=1;min

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