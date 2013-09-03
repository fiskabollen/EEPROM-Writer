 title  "EEPROM WRITER TEMPLATE"

; 8-bit data bus is RA5 RA4 RC5 RC4 RC3 RC2 RC1 RC0
;                 bit 7   6   5   4   3   2   1   0
;
; Wire the PICkit1 pins on JP3 thus:
;   1-D7, 2-D6, 3-n/c, 4-D5, 5-D4, 6-D3, 7-n/c
;   8-CLK, 9-~WE, 10-D0, 11-D1, 12-D2, 13-+5v, 14-gnd
;
; RA0 is not used
; CLK (INC) is RA1
; RA2 connects to ~WE, starts high

; Connect LED to RDY/BUSY if available

; Wire ¬OE to high to write!
; An error or end of data stops incrementing
; Read the address to see where it stopped
;
; Usage
; 1. run tclsh translate.tcl <binary_object_file>
; 2. paste the output into the 'Start' section below
; 3. Compile this program and send to the PIC
; 4. Connect ~OE to high
; 5. Connect ~WE to RA2
; 6. Reset the address counter
; 7. Press SW1 on PICkit1

  LIST R=DEC
 INCLUDE "p16f684.inc"

 __CONFIG _FCMEN_OFF & _IESO_OFF & _BOD_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTOSCIO

;  Variables
 CBLOCK 0x020
COUNT1
COUNT2
WSTORE			; temp store for W
RBYTE			; The byte we are building
 ENDC
		org	0
; Initialise ports, etc.
		nop                           ;  For ICD Debug
		clrf    PORTA                 ;  Initialize I/O Bits to Off
		movlw   7                     ;  Turn off Comparators
		movwf   CMCON0
		bsf     STATUS, RP0			; switch to Bank 1
		clrf    ANSEL ^ 0x080         ;  All Bits are Digital
		movlw	b'000000'         ;Set RA0-5 as outputs (RA0/3 are not used)
		movwf	TRISA             ;RA0,1,2 to outputs - 0 is output, 1 is input
		movlw	b'000000'         ;all of Port C to outputs
		movwf	TRISC             ;
		bcf		STATUS, RP0       ;Switch back to Bank 0

; Clear the outputs
		movlw	0x0
		movwf	PORTA
		movwf	PORTC

; Set RA2 (¬WE) to high (ie. not writing currently)
		bsf		PORTA,2


Start
; Move value into W then call Output
; Generate this bit with the tcl routine




; Set data outputs to hi-impedance
		bsf     STATUS, RP0		; Bank 1
		movlw	0x3f            ;Set the RC0:5 to input
		movwf	TRISC
		movlw	0x30			; Set RA4,5 to input
		movwf	TRISA
		bcf		STATUS, RP0     ;Switch back to Bank 0		
FIN		goto	FIN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The byte to store is in W
; Move byte to PORTC

; Test bits 6 and 7 of w and set RA4 and RA5 accordingly
; pulse CLK high
Output
		; Build the byte to present on the data bus in RBYTE

		movwf	RBYTE
		; first set RC0-5
		movwf	PORTC
		; now set RA4 and 5 to RBYTE bits 6 and 7
		bcf		PORTA,4		; Clear them first
		bcf		PORTA,5


		btfsc	RBYTE,6		; Skip next instruction if bit 6 is clear
		bsf		PORTA,4		; Set RA4 (if RBYTE bit 6 was set)
		btfsc	RBYTE,7		; Skip next if bit 7 is clear
		bsf		PORTA,5		; SET RA5 (if RBYTE bit 7 was set)

				
		; pulse RA2 low to write		
		bcf		PORTA,2		

		call 	Delay
		call	Delay
		call	Delay
		call	Delay
		bsf		PORTA,2



		; pulse RA1 high to increment (clk)
		bsf		PORTA,1		
		call 	Delay
		call	Delay
		bcf		PORTA,1
		return

		
; Delay subroutine
Delay
		movwf	WSTORE
		movlw	16			; This is set very slow so we can see it
		movwf	COUNT1
		movwf	COUNT2
Loop	decfsz	COUNT1,1
		goto	Loop 
		decfsz	COUNT2,1
		goto	Loop
		movfw	WSTORE
		return

;****End of the program**** 
END
