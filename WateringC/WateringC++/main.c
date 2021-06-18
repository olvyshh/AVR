/*
 * WateringC++.c
 *
 * Created: 09.06.2021 00:22:14
 * Author : steam
 */ 

#include <avr/io.h>
volatile int i=0;

int main(void)
{
    /* Replace with your application code */
    while (1) 
    {
		if(1){
			
			PORTC=0<<4;
			PORTC=1<<4;
						PORTC=1<<4;
									PORTC=1<<4;			PORTC=1<<4;
			i++;
		}
    }
}

