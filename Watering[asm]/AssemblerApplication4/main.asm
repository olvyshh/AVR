	.include "Defines.inc"
	.include "Macro.inc"
	.include "Display.inc"
	.include "Encoder.inc"
	.list
;DATA SEG;;;;;;;;;;;;;;;;;;;;;;;

	.dseg
	.org SRAM_START
temp:				.byte 2
tempAddr:			.byte 2
selected:			.byte 1
WisOn:				.byte 1
curPos:				.byte 1
scrPos:				.byte 1
curMax:				.byte 1
BWT:				.byte 2
EWT:				.byte 2
DWT:				.byte 2
WCR:				.byte 1
OneMinTime:			.byte 3
TimerM0:			.byte 2
TimerM1:			.byte 2
TimerM2:			.byte 2
TimerM3:			.byte 2
TimerM4:			.byte 2
TimerM5:			.byte 2
TimerM6:			.byte 2
T1:					.byte 7*2
T2:					.byte 7*2

;CODE SEG;;;;;;;;;;;;;;;;;;;;;;;

;Interupt====================================================================================================================================================================================
	.cseg
	.org 0x00
	rjmp init
	reti
	reti
	reti
	reti
	reti
	reti
	reti
	reti
	rjmp timer
	reti
	reti
	reti
	reti
	reti
	reti
	reti
	reti
	reti

;Таблицы переходов

MenuList:		.dw ShowMainMenu,ShowSetMenu,ShowM0,ShowM1,ShowM2,ShowM3,ShowM4,ShowM5,ShowM6,ShowW
BInMenuList:	.dw BInMainMenu,BInSetMenu,BInM0,BInM1,BInM2,BInM3,BInM4,BInM5,BInM6,BInW
BSetMenuList:	.dw SetCurWindowM0,SetCurWindowM1,SetCurWindowM2,SetCurWindowM3,SetCurWindowM4,SetCurWindowM5,SetCurWindowM6,SetCurWindowW,SetCurWindowMain

;InteruptHandler===============================================================================================================================================================================
timer:
	push r17
	push SysReg1

	ldi r17,0x45
	out TCNT0,r17
	
	in r17,sreg
	;======================	
	inc3bVar OneMinTime
	inc2bVar DWT
TNext1:
	mov SysReg1,Status
	andi SysReg1,0b01000000
	breq TNext2
	sbic EncPort,0
	inc2bVar BWT
TNext2:
	;======================
	out sreg,r17
	pop SysReg1
	pop r17
	reti





;Init Program========================================================================================================================================================================






init:
	RamErase
	initStack
	initVar
	initPort
	initDisp
	initEEPROM
	timer0On

	rjmp main

;MainCycle============================================
main:
	OneMinCheck
	displayCheck
	EncoderCheck	
	ButtonCheck




	sbrc Status,0
	rcall DispRefresh	
	sbrc Status,3
	rcall ButtonClick
	rcall EncHandler
    rjmp main










;Other=======================================================================================================================================================================

DispRefresh:
	andi Status,0b11111110
	clrDisp
	getAddr MenuList,CurrentWindow	
	icall
	ret


;========================================================================================================================================================================


EncHandler:
;Проверка на нулевое окно
	cpi CurrentWindow,0
	breq EncHandlerJumpToEnd
	rjmp EncHandlerStatus
	EncHandlerJumpToEnd:
	rjmp EncHandlerEnd

;ПРоверка статуса	
EncHandlerStatus:						
	sbrc Status,1
	rjmp EncHandlerLeft
	sbrc Status,2
	rjmp EncHandlerRight
	rjmp EncHandlerEnd

EncHandlerLeft:
	andi Status,0b11111101
	ldi SysReg4,1
	rjmp EncHandlerSelect
EncHandlerRight:
	andi Status,0b11111011
	ldi SysReg4,-1
	rjmp EncHandlerSelect
							
EncHandlerSelect:
	lds SysReg1,Selected
	sbrc SysReg1,0
	breq EncHandlerIsSelected

								EncHandlernotSelected:
									lds SysReg1,curPos
									lds SysReg2,scrPos
									lds SysReg3,curMax
									inc SysReg3
									sub SysReg1,SysReg4	
									sts curPos,SysReg1				
								curOwf:
									cp SysReg1,SysReg3
									breq curOwfUp
									cpi SysReg1,-1
									breq curOwfdown
									rjmp scrOwf
														curOwfdown:
														lds SysReg1,curMax
														sts curPos,SysReg1
														dec SysReg1
														sts scrPos,SysReg1
														rjmp scrOwf
														curOwfUp:
														stsi curPos,0
														stsi scrPos,0 
														rjmp scrOwf



								scrOwf:
									sub SysReg1,SysReg2
									cpi SysReg1,-1
									breq scrOwfDown
									cpi SysReg1,2
									breq scrOwfUp
									rjmp EncHandlerEnd
														scrOwfDown:
														dec SysReg2
														sts scrPos,SysReg2
														rjmp EncHandlerEnd
														scrOwfUp:
														inc SysReg2
														sts scrPos,SysReg2
														rjmp EncHandlerEnd


								rjmp EncHandlerEnd



								EncHandlerIsSelected:
									lds SysReg1,temp
									lds SysReg2,temp+1
									
									cpi SysReg4,1
									breq EncHandlerIsSelectedSub
									rjmp EncHandlerIsSelectedAdd

					
															EncHandlerIsSelectedSub:
																
															EncHandlerIsSelectedSubCheckb0:							
																cpi SysReg1,0
																breq EncHandlerIsSelectedSubCheckb1
																rjmp EncHandlerIsSelectedSubing
															EncHandlerIsSelectedSubCheckb1:
																cpi SysReg2,0
																breq EncHandlerEnd
																rjmp EncHandlerIsSelectedSubing
															EncHandlerIsSelectedSubing:
																ldi SysReg3,0
																subi SysReg1,1
																sbc SysReg1,SysReg3
																sts temp,SysReg1
																sts temp+1,SysReg2
																rjmp EncHandlerEnd







															EncHandlerIsSelectedAdd:
																ldi SysReg3,1
																add SysReg1,SysReg3
																ldi SysReg3,0
																adc SysReg1,SysReg3
																sts temp,SysReg1
																sts temp+1,SysReg2
																rjmp EncHandlerEnd






								rjmp EncHandlerEnd
							

			rjmp EncHandlerEnd


EncHandlerinMainMenu:
EncHandlerEnd:
	ret


;========================================================================================================================================================================
;========================================================================================================================================================================
ButtonClick:	
	andi Status,0b11110111
	getAddr BInMenuList,CurrentWindow
	icall
	ButtonClickend:
	ret
;========================================================================================================================================================================

DispSendData:
	push SysReg1
	mov SysReg1,dispDataReg
	swap SysReg1
	andi SysReg1,$0F
	lsl SysReg1
	lsl SysReg1
	ori SysReg1,3
	out DispPort,SysReg1
	nop
	andi SysReg1,0b11111100
	out DispPort,SysReg1

	delay5 40


	mov SysReg1,dispDataReg
	andi SysReg1,$0F
	lsl SysReg1
	lsl SysReg1
	ori SysReg1,3
	out DispPort,SysReg1
	nop
	andi SysReg1,0b11111100
	out DispPort,SysReg1

	delay5 40

	pop SysReg1
ret
;========================================================================================================================================================================

DispSendComnd:
	push SysReg1
	mov SysReg1,dispDataReg
	swap SysReg1
	andi SysReg1,$0F
	lsl SysReg1
	lsl SysReg1
	ori SysReg1,2
	out DispPort,SysReg1
	nop
	andi SysReg1,0b11111101
	out DispPort,SysReg1

	delay5 40


	mov SysReg1,dispDataReg
	andi SysReg1,$0F
	lsl SysReg1
	lsl SysReg1
	ori SysReg1,2
	out DispPort,SysReg1
	nop
	andi SysReg1,0b11111101
	out DispPort,SysReg1

	delay5 40

	pop SysReg1
ret
;========================================================================================================================================================================
;========================================================================================================================================================================
;========================================================================================================================================================================
;Обработка отображения разных окон
ShowMainMenu:
	DispSendDataI 'M'
	DispSendDataI '0'
	DispSendDataI 'M'
	DispSendDataI '1'

	DispSendDataI 'M'
	DispSendDataI '2'
	DispSendDataI 'M'
	DispSendDataI '3'

	DispSendDataI 'M'
	DispSendDataI '4'
	DispSendDataI 'M'
	DispSendDataI '5'

	DispSendDataI 'M'
	DispSendDataI '6'

	DispSendComndi 0xC0

	DispSendDataI ' '
	in dispDataReg,WatPin
	andi dispDataReg,0b00000001
	subi dispDataReg,-48
	rcall DispSendData



		DispSendDataI ' '
	in dispDataReg,WatPin
	andi dispDataReg,0b00000010
	lsr dispDataReg
	subi dispDataReg,-48 
	rcall DispSendData

		DispSendDataI ' '
	in dispDataReg,WatPin
	andi dispDataReg,0b00000100
	lsr dispDataReg
	lsr dispDataReg
	subi dispDataReg,-48 
	rcall DispSendData



		DispSendDataI ' '
	in dispDataReg,WatPin
	andi dispDataReg,0b00001000
	lsr dispDataReg
	lsr dispDataReg
	lsr dispDataReg
	subi dispDataReg,-48 
	rcall DispSendData

		DispSendDataI ' '
	in dispDataReg,WatPin
	andi dispDataReg,0b00010000
	swap dispDataReg
	subi dispDataReg,-48 
	rcall DispSendData

		DispSendDataI ' '
	in dispDataReg,WatPin
	andi dispDataReg,0b00100000
	swap dispDataReg
	lsr dispDataReg
	subi dispDataReg,-48 
	rcall DispSendData
		
		
		DispSendDataI ' '
	in dispDataReg,WatPin
	andi dispDataReg,0b01000000
	swap dispDataReg
	lsr dispDataReg
	subi dispDataReg,-48 
	rcall DispSendData



 
	ret
;===========================================

ShowSetMenu:
lds SysReg1,scrPos
lds SysReg3,curPos
cpi SysReg1,6
brcs ShowSetMenuIsland
rjmp ShowSetMenuScrMore5
ShowSetMenuIsland:
rjmp ShowSetMenuScrLow6


ShowSetMenuScrMore5:
cpi SysReg1,6
breq ShowSetMenuScr6
brne ShowSetMenuScr7

ShowSetMenuScr6:
				cp SysReg1,SysReg3
				breq ShowSetMenuScr6IsL1
										DispSendDataI ' '
										rjmp ShowSetMenuScrDrowL1
										ShowSetMenuScr6IsL1:
										DispSendDataI '>'
										ShowSetMenuScr6NotL1:
										rjmp ShowSetMenuScrDrowL1
				ShowSetMenuScrDrowL1:
				DispSendDataI 'M'
				DispSendDataI '6'
				DispSendComndi 0xC0
					cp SysReg1,SysReg3
					brne ShowSetMenuScr6IsL2
										ShowSetMenuScr6NotL2:
										DispSendDataI ' '
										rjmp ShowSetMenuScrDrowL2
										ShowSetMenuScr6IsL2:
										DispSendDataI '>'
										rjmp ShowSetMenuScrDrowL2
				ShowSetMenuScrDrowL2:
				DispSendDataI 'W'
				DispSendDataI ':'

				lds DispDataReg,WisOn
				subi DispDataReg,-48
				rcall DispSendData

				rjmp ShowSetMenuEnd

ShowSetMenuScr7:

				cp SysReg1,SysReg3
				breq ShowSetMenuScr7IsL1
										DispSendDataI ' '
										rjmp ShowSetMenuScr7DrowL1
										ShowSetMenuScr7IsL1:
										DispSendDataI '>'
										rjmp ShowSetMenuScr7DrowL1
				ShowSetMenuScr7DrowL1:
				DispSendDataI 'W'
				DispSendDataI ':'

				lds DispDataReg,WisOn
				subi DispDataReg,-48
				rcall DispSendData
				DispSendComndi 0xC0

					cp SysReg1,SysReg3
					brne ShowSetMenuScr7IsL2
										DispSendDataI ' '
										rjmp ShowSetMenuScr7DrowL2
										ShowSetMenuScr7IsL2:
										DispSendDataI '>'
										rjmp ShowSetMenuScr7DrowL2
				ShowSetMenuScr7DrowL2:
				DispSendDataI 'E'
				DispSendDataI 'x'
				DispSendDataI 'i'
				DispSendDataI 't'

				rjmp ShowSetMenuEnd





rjmp ShowSetMenuEnd



ShowSetMenuScrLow6:
cp SysReg1,SysReg3
breq ShowSetMenuIsL1
						DispSendDataI ' '
						rjmp ShowSetMenuDrowL1
						ShowSetMenuIsL1:
						DispSendDataI '>'
						rjmp ShowSetMenuDrowL1


ShowSetMenuDrowL1:
DispSendDataI 'M'
mov SysReg2,SysReg1
subi SysReg2,-48
mov DispDataReg,SysReg2
rcall DispSendData

DispSendComndi 0xC0
rjmp ShowSetMenuLine2



ShowSetMenuLine2:
cp SysReg1,SysReg3
brne ShowSetMenuIsL2
						DispSendDataI ' '
						rjmp ShowSetMenuDrowL2
						ShowSetMenuIsL2:
						DispSendDataI '>'
						rjmp ShowSetMenuDrowL2

ShowSetMenuDrowL2:

DispSendDataI 'M'
mov SysReg2,SysReg1
subi SysReg2,-49
mov DispDataReg,SysReg2
rcall DispSendData
rjmp ShowSetMenuend



ShowSetMenuend:
ret


;===========================================
ShowM0:

	DispSendDataI 'M'
	DispSendDataI '0'
	DispSendDataI ' '
	DispSendDataI ' '
	DispSendDataI 'T'
	DispSendDataI '1'
	DispSendDataI '='

	;если Т1 выбрано отображаю temp , в.п.с. Т1

						ShowM0T1sel:
							wordToTime temp ;получаю значения XL минут XH часов
							DispSendTime
							rjmp ShowM0W
						ShowM0T1notsel:
							wordToTime T1 ;получаю значения XL минут XH часов
							DispSendTime
							rjmp ShowM0W


ShowM0W:
	DispSendComndi 0xC0
	DispSendDataI 'W'
	DispSendDataI ':'

	;если W выбрано отображаю temp , в.п.с. WCR.b
						ShowM0Wsel:
							wordToTime temp ;получаю значения XL минут XH часов
							getBitmem temp,0
							DispSendDataR SysReg1
							rjmp ShowM0T2

						ShowM0Wnotsel:
							getBitmem WCR,0
							DispSendDataR SysReg1
							rjmp ShowM0T2
ShowM0T2:
	DispSendDataI ' '
	DispSendDataI 'T'
	DispSendDataI '2'
	DispSendDataI '='

	;если Т2 выбрано отображаю temp , в.п.с. Т2

						ShowM0T2sel:
							wordToTime temp ;получаю значения XL минут XH часов
							DispSendTime
							rjmp ShowM0End
						ShowM0T2notsel:
							wordToTime T1 ;получаю значения XL минут XH часов
							DispSendTime
							rjmp ShowM0End

ShowM0End:

lds DispDataReg,curPos
hexToAscii DispDataReg
rcall DispSendData

lds DispDataReg,Selected
hexToAscii DispDataReg
rcall DispSendData
ret

ShowM1:
	DispSendDataI 'I'
	DispSendDataI 'n'
	DispSendDataI 'M'
	DispSendDataI '1'
	ret
;===========================================
ShowM2:
	DispSendDataI 'I'
	DispSendDataI 'n'
	DispSendDataI 'M'
	DispSendDataI '2'
	ret
;===========================================
ShowM3:
	DispSendDataI 'I'
	DispSendDataI 'n'
	DispSendDataI 'M'
	DispSendDataI '3'
	ret
;===========================================
ShowM4:
	DispSendDataI 'I'
	DispSendDataI 'n'
	DispSendDataI 'M'
	DispSendDataI '4'
	ret
;===========================================
ShowM5:
	DispSendDataI 'I'
	DispSendDataI 'n'
	DispSendDataI 'M'
	DispSendDataI '5'	
	ret
;===========================================
ShowM6:
	DispSendDataI 'I'
	DispSendDataI 'n'
	DispSendDataI 'M'
	DispSendDataI '6'	
	ret
;===========================================
ShowW:

	DispSendDataI 'I'
	DispSendDataI 'n'
	DispSendDataI 'W'
	ret
;========================================================================================================================================================================
;========================================================================================================================================================================
;========================================================================================================================================================================
;Обработка при нажатии в разных меню
BInMainMenu:
	stsi curPos,0
	stsi scrPos,0
	stsi curMax,8
	ldi CurrentWindow,1
	ret
;===========================================
BInSetMenu:
	lds SysReg1,curPos
	getAddr BSetMenuList,SysReg1
	icall
	ret

;===========================================
BInM0:
	lds SysReg1,Selected
	cpi SysReg1,1
	brne BInM0NoSelecting
						BInM0Selecting:
						stsi Selected,0
						;ДОПИСАТЬ ЗАПИСЬ В НУЖНУЮ ПЕРЕМЕНУЮ**
						lds ZL,tempAddr
						lds ZH,tempAddr+1



						rjmp BInM0End



						BInM0NoSelecting:				
						lds SysReg1,curPos
						cpi SysReg1,0
						breq BInM0T1
						cpi SysReg1,1
						breq BInM0T2
						cpi SysReg1,2
						breq BInM0W
						cpi SysReg1,3
						breq BInM0Exit

											BInM0T1:
											stsi Selected,1
										
											stsi tempAddr,	low(T1)
											stsi tempAddr+1,high(T1)
											;lds temp,T1
											;lds temp,T1+1


											rjmp BInM0End



											BInM0T2:
											stsi Selected,1
											stsi tempAddr,	low(T2)
											stsi tempAddr+1,high(T2)
											;lds temp,T2
											;lds temp,T2+1
											rjmp BInM0End

											BInM0W:
											stsi Selected,1
											stsi tempAddr,	low(WCR)
											stsi tempAddr+1,high(WCR)
											rjmp BInM0End

											BInM0Exit:
											ldi CurrentWindow,1
											InitSetWindowSet
											rjmp BInM0End

						rjmp BInM0End




BInM0End:
ret
;===========================================
BInM1:
ldi CurrentWindow,1
ret
;===========================================
BInM2:
ldi CurrentWindow,1
ret
;===========================================
BInM3:
ldi CurrentWindow,1
ret
;===========================================
BInM4:
ldi CurrentWindow,1
ret
;===========================================
BInM5:
ldi CurrentWindow,1
ret
;===========================================
BInM6:
ldi CurrentWindow,1
ret
;===========================================
BInW:
ldi CurrentWindow,1
ret
;========================================================================================================================================================================
;========================================================================================================================================================================
;========================================================================================================================================================================
;НАЖАТИЕ В SETMENU
SetCurWindowM0:
InitMXWindowSet
ldi CurrentWindow,2
ret
;===========================================
SetCurWindowM1:
InitMXWindowSet
ldi CurrentWindow,3
ret
;===========================================
SetCurWindowM2:
InitMXWindowSet
ldi CurrentWindow,4
ret
;===========================================
SetCurWindowM3:
InitMXWindowSet
ldi CurrentWindow,5
ret
;===========================================
SetCurWindowM4:
InitMXWindowSet
ldi CurrentWindow,6
ret
;===========================================
SetCurWindowM5:
InitMXWindowSet
ldi CurrentWindow,7
ret
;===========================================
SetCurWindowM6:
InitMXWindowSet
ldi CurrentWindow,8
ret
;===========================================
SetCurWindowW:
InitWWindowSet
ldi CurrentWindow,9
ret
;===========================================
SetCurWindowMain:
ldi CurrentWindow,0
ret
;========================================================================================================================================================================
;========================================================================================================================================================================
;========================================================================================================================================================================