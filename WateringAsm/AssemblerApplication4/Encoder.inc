.macro timer0On
	outi TCCR0,1
	outi SFIOR,1
	outi TIMSK,1	
	SEI
.endm





;=============================================================================================================================================================================================================


.macro EncoderCheck

rjmp checkZero



						checkZero:
						sbrc Status,7
						brne waitZero


						sbrc Status,4
						rjmp d1wasFirst
						sbrc Status,5
						rjmp d2wasFirst
						rjmp idle

											d1wasFirst:
											in SysReg1,EncPin
											andi SysReg1,0b00000110
											cpi SysReg1,0b00000100
											brne end
											ori Status,0b10000000
											rjmp end



											d2wasFirst:
											in SysReg1,EncPin
											andi SysReg1,0b00000110
											cpi SysReg1,0b00000010
											brne end
											ori Status,0b10000000
											rjmp end


											idle:
											in SysReg1,EncPin
											andi SysReg1,0b00000110
											cpi SysReg1,0b00000010	
											breq setd1First
											cpi SysReg1,0b00000100	
											breq setd2First
											rjmp end
											setd1First:
											ori Status,0b00010000
											rjmp end
											setd2First:
											ori Status,0b00100000
											rjmp end

					waitZero:
					sbis EncPin,1
					rjmp end
					sbis EncPin,2
					rjmp end

					left:
					sbrs Status,4
					rjmp right
					andi Status,0b01101111
					ori Status,0b00000010
					right:
					sbrs Status,5
					rjmp end
					andi Status,0b01011111
					ori Status,0b00000100
					rjmp end

					end:
.endm



;=============================================================================================================================================================================================================

.macro ButtonCheck

sbrs Status,6
rjmp wasOff
rjmp wasOn
			wasOn:
			sbis EncPin,0
			rjmp end
			lds XL,BWT
			lds XH,BWT+1
			cpi XL,0x4F
			brcs end
			cpi XH,0x01
			breq check
			brcs end
							check:
							andi Status,0b10111111
							ori Status,0b00001000
							rjmp end




			rjmp end


			wasOff:
			sbic EncPin,0
			rjmp end
			clr2bVar BWT
			ori Status,0b01000000
			rjmp end


end:
.endm












;=============================================================================================================================================================================================================

.macro OneMinCheck

	lds SysReg1,OneMinTime
	lds SysReg2,OneMinTime+1
	lds SysReg3,OneMinTime+2

	cpi SysReg1,0x00
	brcs gotoend

	cpi SysReg2,0x60
	brcs gotoend

	cpi SysReg3,0x00
	brne gotoend
	rjmp start
gotoend:
	rjmp endOneMinCheck

start:
	clr SysReg1
	sts OneMinTime+0,SysReg1
	sts OneMinTime+1,SysReg1
	sts OneMinTime+2,SysReg1


M0:
		
	inc2bVar TimerM0	
	lds XL,TimerM0
	lds XH,TimerM0+1

	sbis WatPort,0
	rjmp elseM0
;=========
	cpi XL,low(WatTime1M0)
	brne M1
	cpi XH,high(WatTime1M0)
	brne M1
	cbi WatPort,0
	clr2bVar TimerM0
	rjmp M1
;=========
elseM0:
	cpi XL,low(WatTime2M0)
	brne M1
	cpi XH,high(WatTime2M0)
	brne M1
	sbi WatPort,0
	clr2bVar TimerM0

M1:
		
	inc2bVar TimerM1	
	lds XL,TimerM1
	lds XH,TimerM1+1

	sbis WatPort,1
	rjmp elseM1
;=========
	cpi XL,low(WatTime1M1)
	brne M2
	cpi XH,high(WatTime1M1)
	brne M2
	cbi WatPort,1
	clr2bVar TimerM1
	rjmp M2
;=========
elseM1:
	cpi XL,low(WatTime2M1)
	brne M2
	cpi XH,high(WatTime2M1)
	brne M2
	sbi WatPort,1
	clr2bVar TimerM1
M2:
		
	inc2bVar TimerM2	
	lds XL,TimerM2
	lds XH,TimerM2+1

	sbis WatPort,2
	rjmp elseM2
;=========
	cpi XL,low(WatTime1M2)
	brne M3
	cpi XH,high(WatTime1M2)
	brne M3
	cbi WatPort,2
	clr2bVar TimerM2
	rjmp M3
;=========
elseM2:
	cpi XL,low(WatTime2M2)
	brne M3
	cpi XH,high(WatTime2M2)
	brne M3
	sbi WatPort,2
	clr2bVar TimerM2
M3:
	inc2bVar TimerM3	
	lds XL,TimerM3
	lds XH,TimerM3+1

	sbis WatPort,3
	rjmp elseM3
;=========
	cpi XL,low(WatTime1M3)
	brne M4
	cpi XH,high(WatTime1M3)
	brne M4
	cbi WatPort,3
	clr2bVar TimerM3
	rjmp M4
;=========
elseM3:
	cpi XL,low(WatTime2M3)
	brne M4
	cpi XH,high(WatTime2M3)
	brne M4
	sbi WatPort,3
	clr2bVar TimerM3
M4:
	
M5:
M6:
M7:

	endOneMinCheck:

.endm