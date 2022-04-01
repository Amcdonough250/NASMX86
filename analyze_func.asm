;------------------------------------------------------------------------------
;
; FILE:           analyze_func.asm
;
; DESCRIPTION:    NASM program for Linux, Intel, IA-32
;                 analyzes polynomial and gets derivative
;
;
; ASSEMBLY:       nasm -f elf analyze_fun.asm
; 
; TO LINK:        ld -m elf_i386 -s -o analyze_func analyze_func.0 cs219_io.o
; TO RUN:         ./analyze_func
;
; INPUT:          integers from user
; OUTPUT:         output the evaluation of f(x) and f'(x)
;
;
; Author                 Date          Version
;------------------------------------------------------------------------------
; Annette McDonough     2020-05-06     1.0 original version
; Annette McDonough     2020-05-07     1.1 fixing display format 
;-----------------------------------------------------------------------------

%include "cs219_io.mac"      ; include library class built together

section .data                ; segment for initialized data
                                       
   msg1  db  'f(x) = a*x^2 + b*x + c', 0 
   msg2  db  'f(x)  = ', 0
   msg3  db  "f'(x) = ", 0
   msg4  db  '*x^2 + ', 0
   msg5  db  '*x + ', 0
   msg6  db  ' = ', 0 
   msg7  db  'f(', 0
   msg8  db  ')  = ', 0
   msg9  db  '*(', 0
   msg10 db  ')^2 + ', 0
   msg11 db  ') + ', 0
   msg12 db  "f'(", 0
   msg13 db  ') = ', 0

   pMsg1 db  "Enter coefficient [0]: ", 0
   pMsg2 db  "Enter input value [x]: ", 0
   SIZE  EQU 3                  ; size of array
   

section .bss                    ; segment for uninitialized variables

   x         resd   1           ; var to store x value
   y         resd   1           ; var for y to store values
   f_coef    resd  SIZE         ; array for f(x) coefficients
   fp_coef   resd  SIZE         ; array for f'(x) coefficients
   a         resd   1           ; reserve one byte for char


section .text                   ; segment for code
   global _start

_start:

   nwln
   PutStr    msg1               ; display f(x) = a*x^2 + b*x + c
   nwln
   nwln
   call      get_input          ; call to get_input procedure      
   call      display_f_of_x     ; call to displayf(x)
   call      display_fp_of_x    ; call to display f'(x) 
   call      eval_f_of_x        ; call to evaluate f(x)
   call      eval_fp_of_x       ; call to evaluate f'(x)

   exit

;------------------------------------------------------------------------
; Procedure Name:   eval_fp_of_x
; Description:      evaluates f'(x)
;------------------------------------------------------------------------

eval_fp_of_x:

   push    EAX                ; push EAX onto the stack to use
   mov     EAX, [x]           ; move x value into EAX
   imul    EAX, [fp_coef]     ; multiply x by fp_coef[0]
   mov     [y], EAX           ; place EAX into y
   mov     EAX, [fp_coef+4]   ; place fp_coef[1] into EAX
   add     EAX, [y]           ; add fp_coef[0]*x + fp_coef[1]
   mov     [y], EAX           ; Place value of EAX into y

   PutStr   msg12             ; display f'(
   PutLInt  [x]               ; display x value
   PutStr   msg13             ; display ) =
   PutLInt  [fp_coef]         ; display fp_coef[0]
   PutStr   msg9              ; display *(
   PutLInt  [x]               ; display x value
   PutStr   msg11             ; display ) +
   PutLInt  [fp_coef+4]       ; display fp_coef[1]
   PutStr   msg6              ; display =
   PutLInt  [y]               ; display the the y value

   nwln
   nwln

   pop EAX                    ; pop EAX

   ret

;-------------------------------------------------------------------------
; Procedure Name:   eval_f_of_x
; Description:      evaluates f(x)
;-------------------------------------------------------------------------

eval_f_of_x:

   push     EAX               ; push EAX onto stack to use
   mov      EAX, [x]          ; mov x into EAX
   imul     EAX, [x]          ; multiply x*x = x^2
   imul     EAX, [f_coef]     ; multiply x^2 by f_coef[0]
   mov      [y], EAX          ; move EAX into y
   mov      EAX, [x]          ; mov x value to EAX
   imul     EAX, [f_coef+4]   ; multiply x value by f_coef[1]
   add      EAX, [y]          ; add ax^2 to bx
   mov      [y], EAX          ; move ax^2+bx into y
   mov      EAX, [f_coef+8]   ; move f_coef[2] to EAX
   add      EAX, [y]          ; add the contents of y to f_coef[2]
   mov      [y], EAX          ; move EAX into y
 
   PutStr   msg7              ; display f(
   PutLInt  [x]               ; display x value
   PutStr   msg8              ; display ) =
   PutLInt  [f_coef]          ; display f_coef[0]
   PutStr   msg9              ; display *(
   PutLInt  [x]               ; display x value
   PutStr   msg10             ; display )^2 +
   PutLInt  [f_coef+4]        ; display f_coef[1]
   PutStr   msg9              ; display *(
   PutLInt  [x]               ; display x value
   PutStr   msg11             ; displays ) +
   PutLInt  [f_coef+8]        ; display f_coef[2]
   PutStr   msg6              ; display =
   PutLInt  [y]               ; display value in y
  
   nwln
 
   pop      EAX               ; pop EAX

   ret
;--------------------------------------------------------------------------
; Procedure Name:    display_fp_of_x
; Description:       displays f'(x)
;--------------------------------------------------------------------------
display_fp_of_x:

   push     EAX                   ; push EAX onto the stack to use
   mov      EAX, [f_coef]         ; move the value of f_coef[0] to EAX
   imul     EAX, 2                ; multiply value in EAX by 2
   mov      [fp_coef], EAX        ; move EAX into fp_coef
   mov      EAX, [f_coef+4]       ; move value of f_coef[1] to EAX
   mov      [fp_coef+4], EAX      ; move value of EAX into fp_coef[1]

   PutStr   msg3                  ; display f'(x) = 
   PutLInt  [fp_coef]             ; display fp_coef[0]
   PutStr   msg5                  ; display *x +
   PutLInt  [fp_coef+4]           ; display fp_coef[1]

   nwln
   nwln

   pop      EAX                   ; pop EAX
 
   ret

;---------------------------------------------------------------------------
; Procedure Name:    display_f_of_x
; Descripton:        displays f(x)
;---------------------------------------------------------------------------
display_f_of_x:

    PutStr   msg2                    ; display f(x) =
    PutLInt  [f_coef]                ; display f_coef[o]
    PutStr   msg4                    ; display *x^2
    PutLInt  [f_coef+4]              ; display f_coef[1]
    PutStr   msg5                    ; display *x +
    PutLInt  [f_coef+8]              ; display f_coef[2]

    nwln  

    ret  
;---------------------------------------------------------------------------
; Procedure Name:     get_input
; Description:        gets input from user
;---------------------------------------------------------------------------
get_input:
    mov     [a], byte 'a'            ; ascii value for a letter
    mov     EBX, f_coef              ; store array address to register EBX
    mov     ECX, SIZE                ; store array size to register ECX

coef_loop:
    mov     AL, [a]                  ; move a to AL
    mov     [pMsg1+19], AL           ; write char to prompt [26]
    PutStr  pMsg1                    ; prompt for input
    GetLInt EAX                      ; read in long int
    mov     [EBX], EAX               ; copy value into array
    add     EBX, 4                   ; increment array address
    inc     byte [a]                 ; increment char in ascii value
    loop    coef_loop                ; iterate size times

    PutStr  pMsg2                    ; prompt for x input
    GetLInt [x]                      ; store value in x

    nwln   

    ret 



