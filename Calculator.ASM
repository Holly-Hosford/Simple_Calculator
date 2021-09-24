;The program reads two 2-digit operands from the kbd.
;It reads a character, representing an operator, applies 
;the operator to the numbers previously read.
;The result is printed to the 7 segment display if the result does not exceed 2 digits, Otherwise EE is 
;printed on the 7 segment display. 
;This program does not take account of negative numbers that might result from calculation.
;If negative numbers are produced EE will be printed on the 7 segment display
;For the minus operator, the second operand is taken from the first.
;For the division operator, the second operand is divided into the first.
;Operands less than 10 should be entered with a leading 0

start:
;read the first 2-digit operand
 
in 00      ; read the character representing the 10s 
sub al, 30 ; convert ascii value to number
mul al, 0a ; multiply the number by 10
push al    ; place this number, representing th number of 10s onto the stack
	   ; temporarily so that the al register can be reused to read the units
in 00      ; read the character representing the units
sub al, 30 ; convert ascii value to number
pop bl     ; retrieve the number of 10s from the stack and place in bl
add bl, al ; add the 10s to units and leave the result in bl

;read the second 2-digit operand
in 00      ; read the character representing the 10s 
sub al, 30 ; convert ascii value to number
mul al, 0a ; multiply the number by 10
push al    ; place this number, representing th number of 10s onto the stack
	   ; temporarily so that the al register can be reused to read the units
in 00      ; read the character representing the units
sub al, 30 ; convert ascii value to number
pop cl     ; retrieve the number of 10s from the stack and place in cl
add cl, al ; add the 10s to units and leave the result in cl


;Read an operator 
in 00
cmp al, 2B ; compare with +
jz addThem

cmp al, 2D ; compare with -
jz subThem

cmp al, 2A ; compare with *
jz mulThem

cmp al, 2F ; compare with /
jz divThem

Opdone:
  
  jmp repeat ; jump to repeat to put numbers on 7 segment display

addThem:
  add bl, cl ; result in bl
  js error   ; if there is a negative sign the s flag will go up and it will jump to error
jmp Opdone   ; jump to Opdone

subThem:
  sub bl, cl ; result in bl
  js error   ; if there is a negative sign the s flag will go up and it will jump to error
jmp Opdone   ; jump to Opdone

mulThem:
  mul bl, cl ; result in bl
  js error   ; if there is a negative sign the s flag will go up and it will jump to error
jmp Opdone   ; jump to Opdone

divThem:
  div bl, cl ; result in bl
  js error   ; if there is a negative sign the s flag will go up and it will jump to error
jmp Opdone   ; jump to Opdone



repeat:
  push bl        ; put the value on bl onto the stack
  pop al	 ; put the value on the stack into al
  push bl	 ; put the value on bl onto the stack
  pop cl	 ; put the value on the stack into cl

  div al, 64	 ; divide al by 100 (64) to see if the number is over 100
  jnz error	 ; if the number is greater than 1 it will jump to error

  push cl	 ; put the value on cl onto the stack
  pop al 	 ; put the value on the stack into al
  div al, 0a     ; divide ascii value of 10 to get numberic value of key
  add al, 90     ; index into the translation table by adding the numberic kbd key 
                 ; value to the base address of the translation table.
  mov al, [al]   ; copy the 7-seg code at address given in al into al
  out 02         ; write to 7-seg display

  push cl	 ; put the value on bl onto the stack
  pop al	 ; put the value on the stack into al
  mod al, 0a 	 ; divide ascii value of 10 to get the numeric value of key
  add al, 90	 ; index into the translation table by adding the numberic kbd key value to the base address of the translation table.

  mov al, [al] 	 ; copy the 7-seg code at address given in al into al
  add al, 01	 ; add 01 to move to right hand side
  out 02	 ; write to 7-seg display
  jmp endd	 ; jump to endd to end program
  
org 90

DB FA ; 7-seg code for symbol for 0
DB 0A ; 7-seg code for symbol for 1
DB B6 ; 7-seg code for symbol for 2
DB 9E ; 7-seg code for symbol for 3
DB 4E ; 7-seg code for symbol for 4
DB DC ; 7-seg code for symbol for 5
DB FC ; 7-seg code for symbol for 6
DB 8A ; 7-seg code for symbol for 7
DB FE ; 7-seg code for symbol for 8
DB CE ; 7-seg code for symbol for 9
DB F4 ; 7-seg code for symbol for E



error:
  
  mov al, F4  ;move the 7-seg code for symbol for E (F4) into al
  out 02      ;write to 7-seg display

  mov al, F4  ;move the 7-seg code for symbol for E (F4) into al
  add al, 01  ;add 01 to move to right hand side
  out 02      ;write to 7-seg display
  jmp endd    ;jump to endd to end program
    
   


endd:
end