/*
 * WateringC++.c
 *
 * Created: 09.06.2021 00:22:14
 * Author : steam
 */ 
#define F_CPU 8000000UL
#define DispPort PORTC

#include <avr/io.h>
#include <util/delay.h>




void LCD_sendcomnd(unsigned char cmnd){
	unsigned char temp;
	temp=cmnd;
	temp=temp&0b11110000;
	temp=temp>>4;
}
void PortInit(){
	DDRC=0xFF;
	DispPort=0;
}

int main(void)
{
    PortInit();
	
	
	
	
    while (1) 
    {
		if(1){
		}
    }
}

