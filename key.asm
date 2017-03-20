;--------------------------------------------------------------
;  program:    Key *MASM* version. program to change all letters from input to upper case letters
;              Takes a period to exit the program.
;              run by compiling with: ml /c /Zi /Fl key.asm
;              is linked by: link /CO key.obj
;              after running, input is expected from the keyboard
;              Not expected to write any characters outside 
;  function:   Takes the input of characters and writes upper case letters to standard output.
;              If lower case, then converts to upper case (by subtracting 20h)and writes to standard output.
;              Blank and period characters are printed to standard output. Do not write anything else.
;  owner:      Marshall Skelton
;  date:       Changes
;  2/10/2017   Original Version
;  2/10/2017   Program just mimics characters written
;  2/10/2017   Implemented to convert lower case characters to upper case
;  2/13/2017   Changed for more efficiency
;--------------------------------------------------------
    .model    small                                ;64k code and 64k data
    .8086                                          ;8086 instructions only
;-------------------------------------------------------
    .data                                          ;start of the data segment
;-----------------------------------------------------------
period   db     2Eh                                ;byte variable for period
lz       db     7ah                                ;lower case char for z
la       db     61h                                ;lower case char for a
uz       db     5ah                                ;upper case Z
ua       db     41h                                ;upper case A
tran     db     65   dup('1')                      ;translates every other character to 1
         db     'ABCDEFGHIJKLMNOPQRSTUVWXYZ111111' ;translates upper case to upper case replacing other characters with 1
         db     'ABCDEFGHIJKLMNOPQRSTUVWXYZ'       ;and lower case to upper case 
         db     122     dup('1')                   ;translating other characters to 1
;-----------------------------------------------------------------
 .code                                             ;start the code segment
;-----------------------------------------------------------------
; starts the programs execution
;-------------------------------------------------------------
start:                                             ;start program execution
         mov ax,@data                              ;creates the register from the data
         mov ds,ax                                 ;moves the register to data segment
;----------------------------------------------------------------------
; the main block that is responsible for reading a character
; responsible for initializing the translation table
; checks for space and period and if not translates other characters to either a 1 or upper case
;-------------------------------------------------------------------
main:                                              ;starts reading the character
         mov bx, offset tran                       ;translate table for the bx register
         mov ah,08h                                ;character to be read with no echo
         int 21h                                   ;read in the character
         mov dl, al                                ;move character read to dl
         cmp dl,20h                                ;check if it is a space
         je print                                  ;if it is, print
         cmp dl,[period]                           ;otherwise, check for a period
         je print                                  ;if it is, print
         xlat                                      ;if neither translate the other characters
         mov dl, al                                ;move what what translated back into dl
         cmp dl, 31h                               ;if the character was a 1
         je main                                   ;disregard the character
;----------------------------------------------------------------------------
;responsible for printing the character out
;if the period is found the program exits
;----------------------------------------------------------------------------
print:                                             ;prints out the character and checks for period
         mov ah,02h                                ;gets the character to be written
         int 21h                                   ;writes the character
         cmp dl,[period]                           ;compare to the '.' character
         jne main                                  ;if not the character read another character
;-----------------------------------------------------------------------------
; terminate program execution
;-----------------------------------------------------------------------------
exit:                                              ;exits the code
         mov ax,4c00h                              ;set dos code to terminate program
         int 21h                                   ;return to dos
         end start                                 ;marks the end of the source code
;-------------------------------------------------------------------------------------------