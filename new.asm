include irvine32.inc
BUFFER_SIZE = 5000
.Data
Index Byte 1
Key Byte ?
ending_promt Byte "THANK YOU-FOR HAVING US",0
Promp11 Byte "GENERIC SORTING",0
Prompt12 Byte "===============",0
Sort1 Byte "SORT INTEGERS",0
Sort2 Byte "SORT CHARACTERS",0
Sort3 Byte "SORT WORDS ALPHABETICALLY",0
Sort4 Byte "SORT SENTENCE ALPHABETICALLY",0
Exitt Byte "EXIT",0

Prompt0 BYTE "Please Enter The Strings To Be Sorted",0
Prompt0_1 BYTE "String should be in the range of 20 words",0
Prompt1 BYTE "PLEASE ENTER THE NUMBER OF INPUTS TO BE SORTED",0
Prompt1_1 byte "INPUT NUMBER SHOULD BE IN THE RANEG OF 2-99:  ",0
Prompt2 BYTE "Result After Sorting: ",0
Input0 Byte "TAKE INPUT FROM USER",0
Input1 Byte "TAKE INPUT FROM FILE",0

;String Sort Data
Arr1 Byte 100 DUP(?)
Arr2D Byte 1000 DUP(?)
Str_array DWORD 100 DUP(?)
Row DWORD 100
Column DWORD 0
COUNT DWORD 0
Swap Byte 0
breaks DWORD 0
;String Sort File
fileee byte "INPUT FILE : ",0
fileee1 byte "OUTPUT STORED IN OUTPUT FILE",0
content BYTE 256 dup(?),0
temp BYTE 16 dup (?),0
smallest Byte 16 dup ('?'),0
target byte " ",0
countt byte 0 
start dword 0
current dword 0
end1 Dword 0
ascending byte 256 dup (?),0
stindex dword 0

filename2 BYTE "Output_File.txt",0
buffer BYTE 500 DUP(?)
fileHandle dword ?
filename BYTE "file.txt",0
CRR byte 13
LF byte 10


;Integer Sort Data
array SDword 100 DUP(?)
Num_Elements Dword ?
temp1 SDWORD ? ; for swapping


;Character Sort Data
chararray Byte 100 DUP(?)
Numof_words Dword ?
temp2 Dword ? ;for swapping


;WORD SORT DATA
Num_Word Dword ? ;number of word 
Array_STR Dword 100 DUP(?)
ARRAY2D byte 1000 DUP(?)
INN DWORD 0

.Code
Main Proc

Call INTRO
Call HomePage

cmp index,1
jne elsee_if
Call INTERFACE_FOR_CONSOLE_INPUT 

elsee_if:
cmp index,2
jne elsee
mov index,1
Call INTERFACE_FOR_FILE_INPUT 

elsee:
call ending_proc
mov ecx,12
ENDING_PROCESS:
Call Crlf
LOOP ENDING_PROCESS
EXIT

Main Endp

ending_proc proc

    Call Clrscr
    call box
    mov eax , 12
    call SetTextColor
    mov esi , offset ending_promt
    mov ecx , 23
    mov dl,45
    mov dh,13
    l1:
        mov al , [esi]
        cmp al , 45
        JNE normal
        inc esi
        mov al , [esi]
        mov dl , 43
        inc dh
        normal:
        call gotoxy
        call writechar
        mov eax , 250
        call Delay 
        inc esi
        inc dl
        loop l1
    ret

ending_proc endp


SORT_STRING PROC
	
	call clrscr
	mov ecx , 100 
	mov edx,offset prompt0
	call writestring
	mov edx , offset arr1 
    call crlf
	call readstring						; taking input from the user 
	invoke Str_length , ADDR arr1		; lenght of the input string 
	mov ecx , eax						; loop until string termination 
	mov esi , offset arr1		
	mov edi , offset arr2D				
	outer_loop:							; loop to count the number of words in the string 
					
		inner_loop:						; loop to convert the input string into 2D array so that each word is seperated 
			mov al , [esi]
			cmp al , 32					; compairing with space
			JE outt
			cmp al , 0
			JE outt
			mov [edi] , al
			inc esi 
			inc edi
			inc count
			jmp inner_loop

		outt:
		inc breaks
		mov bl , 0
		mov [edi] , bl
		add edi , 10
		sub edi , count
		mov count , 0
		inc esi
		cmp al , 0
		JNE outer_loop			
        mov ecx , 1
        cmp breaks , ecx 
        JE DONEE

		mov ecx,  breaks		        ; loop to save the offset of the words into the single string to sort the data		
		mov esi,offset arr2D
		mov edi,offset str_array
		breaking: 
			mov [edi],esi
			add edi,4
			add esi,10
		loop breaking

		mov ECX , DWORD PTR breaks
		dec ecx
		outer_loop1:					; bubble sort loops for swapping the word according to the alphabetical order
		push ECX
		mov EAX , 0 
		inner_loop1:				
			MOV ESI, [str_array + EAX * 4]			; string compare function 
			inc EAX 
			MOV EDI , [str_array + EAX * 4]
			L1:							
				mov bl , [esi]
				mov dl , [edi]
				cmp bl , 0
				JNE L2
				cmp dl , 0 
				JNE l2
				JMP l3
			L2:
				inc esi 
				inc edi
				cmp bl , dl 
				JE L1
			L3:
			JZ continue
			JC continue
			dec EAX									; swapping the words if word1 > word2
			MOV ESI, [str_array + EAX * 4]
			inc EAX 
			MOV EDI , [str_array + EAX * 4]
			MOV [str_array + EAX * 4] , ESI
			dec EAX 
			MOV [str_array + EAX * 4] , EDI
			inc EAX
			continue:
		loop inner_loop1
		pop ECX
		loop outer_loop1
		
		mov EAX , 0
		mov ecx , DWORD PTR breaks
		WRITE_STRINGS:
		MOV EDX, [str_array + EAX * 4]
		CALL WriteString
		Call Crlf
		INC EAX
		LOOP WRITE_STRINGS

		mov count,0
		mov eax,0
		mov ecx,100
		mov esi,offset arr1
		mov edi,offset str_array
		DONEE:
		mov [esi] , eax
		mov [edi] , eax
		inc esi
		inc edi
		LOOP DONEE

		mov ecx , 200
		mov edi , offset arr2D
		DONE1:
		mov [edi] , eax
		inc edi
		LOOP DONE1

		call waitmsg
		ret
		

SORT_STRING  endp


Box PROC
    mov ecx,80
    mov dl,10               ; dl = x-axis 
                            ; dh = y-axis
    mov dh,4
    LOOPS:
    call gotoxy
    mov al,61
    call writechar
    mov eax , 3
    call delay
    inc dl
    LOOP LOOPS

    mov ecx,20
    dec dl
    inc dh
    LOOPSS:
    call gotoxy
    mov al,124
    call writechar
    mov eax , 3
    call delay
    inc dh
    LOOP LOOPSS

    mov ecx,80
    LOOPPSS:
    call gotoxy
    mov al,61
    call writechar
    mov eax , 3
    call delay
    dec dl
    LOOP LOOPPSS


    mov ecx,20
    inc dl
    dec dh
    LOOPPSSS:
    call gotoxy
    mov al,124
    call writechar
    mov eax , 3
    call delay
    dec dh
    LOOP LOOPPSSS
    ret
Box endp


HomePage PROC

    Call clrscr

    Call box 

    being_while:

    mov eax,15
    call SetTextColor

    mov dh,7
    mov dl,42
    call gotoxy
    mov edx,offset promp11
    call writestring

    mov dh,8
    mov dl,42
    call gotoxy
    mov edx,offset prompt12
    call writestring

    mov eax,15
    call SetTextColor

    mov al , 32
    cmp index,1
    jne next
    mov eax,12
    call SetTextColor
    mov al , 62
    next:
    mov dh,10
    mov dl,35
    call gotoxy
    call writechar
    mov edx,offset input0
    call writestring


    mov eax,15
    call SetTextColor

    mov al , 32
    cmp index,2
    jne next1
    mov eax,12
    call SetTextColor
    mov al , 62
    next1:
    mov dh,12
    mov dl,35
    call gotoxy
    call writechar
    mov edx,offset input1
    call writestring


    mov eax,15
    call SetTextColor

    mov al , 32
    cmp index,3
    jne next13
    mov eax,12
    call SetTextColor
    mov al , 62
    next13:
    mov dh,14
    mov dl,35
    call gotoxy
    call writechar
    mov edx,offset exitt
    call writestring

    mov eax,15
    call SetTextColor


    call readchar

    cmp eax,18432           ; 18432 = up
    jne down
    dec index
    down:
    cmp eax,20480           ; 20480 = down 
    jne up
    inc index
    up:
    cmp index,4
    jne loww
    mov index,1
    loww:
    cmp index,0
    jne lowww
    mov index,3
    lowww:
    cmp al,13
    jne being_while


    call crlf
    ret
HomePage ENDP

Intro Proc

    Call Clrscr

    Call Box

    mov eax,10
    call SetTextColor

    mov dl,40
    mov dh,13
    call gotoxy
    mov edx,offset promp11
    call writestring

    mov eax,14
    call SetTextColor


    mov dl,40
    mov dh,14
    call gotoxy
    mov edx,offset prompt12
    call writestring

    mov eax,15
    call SetTextColor


    mov ecx,13
    CR:
    call crlf
    LOOP CR
    call waitmsg
    ret
Intro Endp


INTERFACE_FOR_CONSOLE_INPUT Proc

    Call clrscr

    Call box

    being_while:

    mov eax,15
    call SetTextColor

    mov dh,7
    mov dl,35
    call gotoxy
    mov edx,offset promp11
    call writestring

    mov dh,8
    mov dl,35
    call gotoxy
    mov al , 32
    mov edx,offset prompt12
    call writestring

    mov eax,15
    call SetTextColor

    mov al , 32
    cmp index,1
    jne next
    mov eax,12
    call SetTextColor
    mov al , 62
    next:
    mov dh,10
    mov dl,35
    call gotoxy
    call writechar
    mov edx,offset Sort1
    call writestring


    mov eax,15
    call SetTextColor

    mov al , 32
    cmp index,2
    jne next1
    mov eax,12
    call SetTextColor
    mov al , 62
    next1:
    mov dh,12
    mov dl,35
    call gotoxy
    call writechar
    mov edx,offset Sort2
    call writestring


    mov eax,15
    call SetTextColor

    mov al , 32
    cmp index,3
    jne next11
    mov eax,12
    call SetTextColor
    mov al , 62
    next11:
    mov dh,14
    mov dl,35
    call gotoxy
    call writechar
    mov edx,offset Sort3
    call writestring


    mov eax,15
    call SetTextColor

    mov al , 32
    cmp index,4
    jne next12
    mov eax,12
    call SetTextColor
    mov al , 62
    next12:
    mov dh,16
    mov dl,35
    call gotoxy
    call writechar
    mov edx,offset Sort4
    call writestring


    mov eax,15
    call SetTextColor

    mov al , 32
    cmp index,5
    jne next13
    mov eax,12
    call SetTextColor
    mov al , 62
    next13:
    mov dh,18
    mov dl,35
    call gotoxy
    call writechar
    mov edx,offset exitt
    call writestring

    mov eax,15
    call SetTextColor


    mov dh,20
    mov dl,35
    call gotoxy
    call readchar

    cmp eax,18432
    jne down
    dec index
    jmp up
    down:
    cmp eax,20480
    jne up
    inc index
    up:
    cmp index,6
    jne loww
    mov index,1
    loww:
    cmp index,0
    jne lowww
    mov index,5
    lowww:
    cmp al,13
    jne being_while

    cmp index,1
    jne char_sort
    call Integer_Sort
    call INTERFACE_FOR_CONSOLE_INPUT
    jmp ending

    char_sort:
    cmp index,2
    jne WORDD_sort
    call Character_Sort
    call INTERFACE_FOR_CONSOLE_INPUT
    jmp ending

    WORDD_sort:
    cmp index,3
    jne STRING_SORT
    CALL WORD_SORT
    call INTERFACE_FOR_CONSOLE_INPUT
    jmp ending

    STRING_SORT:
    cmp index,4
    jne end_jump
    call SORT_STRING
    call INTERFACE_FOR_CONSOLE_INPUT
    jmp ending

    end_jump:
    cmp index,5
    jne ending
    mov index,1
    call HomePage

    ending:
    call crlf
    ret
INTERFACE_FOR_CONSOLE_INPUT Endp


Nulling PROC
    mov al,0
    mov ecx,256
    mov esi,offset content
    mov edi,offset ascending
    NULLING0:
    mov [esi],al
    mov [edi],al
    inc esi
    inc edi
    loop NULLING0


    mov ecx,16
    mov al,0
    mov esi,offset temp
    mov edi,offset smallest
    NULLING12:
    mov [esi],al
    mov [edi],al
    inc esi
    inc edi
    LOOP NULLING12
    ret
Nulling endp


INTERFACE_FOR_FILE_INPUT Proc
    
    Call clrscr

    Call Box

    whilee:

    mov eax,15
    Call SetTextColor

    mov dh,7
    mov dl,35
    Call gotoxy
    mov edx,offset promp11
    Call writestring

    mov dh,8
    mov dl,35
    Call gotoxy
    mov edx,offset prompt12
    Call writestring

    mov eax,15
    Call SetTextColor


    cmp index,1
    jne next
    mov eax,12
    Call SetTextColor
    next:
    mov dh,10
    mov dl,35
    Call gotoxy
    mov edx,offset Sort1
    Call writestring

    mov eax,15
    Call SetTextColor

    cmp index,2
    jne next1
    mov eax,12
    Call SetTextColor
    next1:

    mov dh,12
    mov dl,35
    Call gotoxy
    mov edx,offset Sort2
    Call writestring


    mov eax,15
    Call SetTextColor


    cmp index,3
    jne next11
    mov eax,12
    Call SetTextColor
    next11:

    mov dh,14
    mov dl,35
    Call gotoxy
    mov edx,offset Sort3
    Call writestring


    mov eax,15
    Call SetTextColor

    cmp index,4
    jne next12
    mov eax,12
    Call SetTextColor
    next12:

    mov dh,16
    mov dl,35
    Call gotoxy
    mov edx,offset Sort4
    Call writestring

    mov eax,15
    Call SetTextColor

    mov eax,15
    Call SetTextColor

    cmp index,5
    jne next13
    mov eax,12
    Call SetTextColor
    next13:

    mov dh,18
    mov dl,35
    Call gotoxy
    mov edx,offset exitt
    Call writestring

    mov eax,15
    Call SetTextColor


    mov dh,20
    mov dl,35
    Call gotoxy
    Call readchar

    cmp eax,18432
    jne down
    dec index
    jmp up
    down:
    cmp eax,20480
    jne up
    inc index
    up:
    cmp index,6
    jne loww
    mov index,1
    loww:
    cmp index,0
    jne lowww
    mov index,5
    lowww:
    cmp al,13
    jne whilee

    cmp index,1
    jne character
    Call Integer_Sort_FILE
    Call INTERFACE_FOR_FILE_INPUT
    jmp ending

    character:
    cmp index,2
    jne WORDD
    Call Character_Sort_FILE
    Call waitmsg
    Call Nulling

    Call INTERFACE_FOR_FILE_INPUT
    jmp ending

    WORDD:
    cmp index,3
    jne STRINGSS
    CALL WORD_SORT_FILE
    Call Waitmsg
    Call Nulling

    call INTERFACE_FOR_FILE_INPUT
    jmp ending

    Stringss:
    cmp index,4
    jne endss
    Call SORT_STRING_FILE
    Call WaitMsg
    Call Nulling

    call INTERFACE_FOR_FILE_INPUT
    jmp ending

    endss:
    cmp index,5
    jne ending
    mov index,1
    call HomePage

    ending:

    call crlf
    ret
INTERFACE_FOR_FILE_INPUT Endp

INTEGER_SORT Proc

    Call Clrscr
    Mov Edx,Offset Prompt1
    Call WriteString
    again_int:
    Call Crlf
    Mov Edx,Offset Prompt1_1
    Call writestring            
    Call ReadDec                ; taking input from the user
    cmp eax , 1
    JBE again_int               ; validation of the input
    cmp eax , 100
    JAE again_int
    Mov count,eax
    Mov ecx,count

    mov esi,offset array
    Insert:
    call readint
    mov [esi],eax
    add esi,4
    LOOP Insert



        mov ecx , count
        dec ecx
        L1_int:
        push ECX
        mov esi , offset array
        L2_int:
        mov eax , [esi]
        mov ebx , [esi+4]
        cmp eax , ebx
        JLE continue
        mov [esi] , ebx
        mov [esi+4] , eax
        continue:
        add esi , type array
        loop L2_int
        pop ECX
        loop L1_int

    call crlf
    mov edx,offset prompt2
    call writestring
    call crlf
 
    mov ecx,count
    mov ebx , 0
    mov esi,offset Array
    Print:
    mov eax,[esi]
    call writeint
    mov [esi] , ebx 
    add esi,4
    call crlf
    loop Print
    mov count , 0

    call crlf
    call Waitmsg
    ret
INTEGER_SORT Endp



CHARACTER_SORT Proc

    Call Clrscr
    Mov Edx,Offset Prompt1
    Call WriteString
    again_char:
    Call crlf
    Mov Edx, Offset Prompt1_1
    Call writestring 
    Call crlf
    Call ReadDec
    cmp EAX , 1
    JBE again_char
    cmp EAX , 100
    JAE again_char
    Mov Count ,Eax
   
    Mov Ecx,Eax                     ; inserting the Data into the array 
    mov esi,offset Arr1
    Insert:
    Call Readchar
    Call writechar
    Call crlf
    mov [esi],al
    inc esi
    LOOP Insert
    
    mov ecx , count
    dec ecx
    L1_char:
    push ECX
    mov esi , offset Arr1
    L2_char:
    mov al , [esi]
    mov ah , [esi+1]
    cmp al , ah
    JBE continue
    mov [esi] , ah
    mov [esi+1] , al
    continue:
    inc esi
    loop L2_char
    pop ECX
    loop L1_char

	call crlf
	mov edx,offset prompt2
	call writestring
	call crlf


	mov esi,offset Arr1
	mov ecx,Count
    print:
	mov al,[esi]
	call writeCHAR
	inc esi
	call crlf
	loop print
	call crlf
    mov ecx , count
	mov count,0
	mov eax,0
	mov esi,offset arr1
	DONE_Char:
		mov [esi] , eax
		inc esi
	LOOP DONE_Char

    call waitmsg
    ret

CHARACTER_SORT Endp

WORD_SORT PROC
CALL Clrscr		
    MOV EDX , offset prompt1
	CALL writestring							; take input from the user number of words
    againnn:
    CALL crlf
    MOV EDX , offset prompt1_1                  ; Input validation
    CALL writestring
	CALL READDEC
    cmp eax , 1
    JBE againnn
    cmp eax , 100
    JAE againnn
	mov count, EAX                              ; ccount of words 
	mov EBX , EAX

	mov EDX,OFFSET arr2D
	mov EDI,OFFSET str_array

	Lp1:
	mov ECX,100
	CALL READSTRING
	mov [EDI],EDX                               ; saving offsets of the strings
	add edx , 10                                ; moving to the next row in 2d array
	add EDI,4                                   ; maximum offset can be of dword
	dec EBX                                     ; count of words 
	cmp ebx , 0
	jne Lp1

	mov ecx , count
	dec ecx 

	outer_loop1_1:					; bubble sort loops for swapping the word according to the alphabetical order
		push ECX
		mov EAX , 0 
		inner_loop1_1:				
			MOV ESI, [str_array + EAX * 4]			; string compare function 
			inc EAX 
			MOV EDI , [str_array + EAX * 4]
			L1:							
				mov bl , [esi]
				mov dl , [edi]
				cmp bl , 0
				JNE L2
				cmp dl , 0 
				JNE l2
				JMP l3
			L2:
				inc esi 
				inc edi
				cmp bl , dl 
				JE L1
			L3:
			JZ continue                             ; no need to swap the words
			JC continue
			dec EAX									; swapping the words if word1 > word2
			MOV ESI, [str_array + EAX * 4]
			inc EAX 
			MOV EDI , [str_array + EAX * 4]
			MOV [str_array + EAX * 4] , ESI
			dec EAX 
			MOV [str_array + EAX * 4] , EDI
			inc EAX
			continue:
		loop inner_loop1_1
		pop ECX
		loop outer_loop1_1


        mov edx , offset prompt2
        call writestring
        Call Crlf
		MOV ECX,count							; Number of strings to display
		MOV EAX,0									; Current string to dislay
		WRITE_SORTED_WORDS:
		MOV EDX, [str_array + EAX * 4]
		CALL WriteString
		Call Crlf
		INC EAX
		LOOP WRITE_SORTED_WORDS

		mov count,0
		mov eax,0
		mov ecx,100
		mov esi,offset arr1
		mov edi,offset str_array
		DONEEE:
		mov [esi] , eax
		mov [edi] , eax
		inc esi
		inc edi
		LOOP DONEEE

		mov ecx , 200
		mov edi , offset arr2D
		DONE2:
		mov [edi] , eax
		inc edi
		LOOP DONE2

call waitmsg
ret
WORD_SORT ENDP

INTEGER_SORT_FILE Proc
Call Clrscr

mov edx,offset fileee              
call writestring

mov edx,OFFSET filename              ;Opening existing File
call OpenInputFile
mov filehandle,eax

mov eax,filehandle
mov edx,OFFSET buffer            ; reading data from file
mov ecx,BUFFER_SIZE
call ReadFromFile

mov edx,OFFSET buffer
call writestring

mov ecx,BUFFER_SIZE                   ;total buffer size
mov esi,0
mov edi,0
L:                                     ;moving elements from the buffer to the array
mov bl,[esi+buffer]
mov BYTE PTR [edi+array], bl
cmp [esi+buffer],0                      ; If there are no elements ahead then no need to iterate buffer_size times. Just break the loop. iterates only array_size times
JE continue 
add esi,1
add edi,4
LOOP L

;mov ecx,lengthof buffer        ;display the buffer
;mov ebx,type buffer
;mov esi,offset buffer
;call dumpmem



continue:

mov ecx,lengthof array           ;counting the number of elements in the array which have been retrieved from file
mov ebx,0
mov esi,0
sizeee:
cmp [array+esi],0               ; stop counting when all the elements are counted
JA increment
jmp loopend
increment:
inc ebx
add esi,4
LOOP sizeee
loopend:
mov ecx,ebx
mov Num_Elements,ecx

dec ecx                       ;ecx now contains the actual length of the array (total elements retrieved from the file)


L1:                         ;sorting
mov esi,OFFSET array
mov edx,ecx
 
L2:
mov eax,[esi]
mov ebx,[esi+4]
cmp eax,ebx
JA swap1
jmp noswap
swap1:
mov temp1,eax
mov eax,ebx
mov ebx,temp1
mov [esi],eax
mov [esi+4],ebx

noswap:
add esi,4
dec edx
JNZ L2
Loop L1

;mov esi,offset array
;mov ecx,lengthof array
;mov ebx,type array
;call dumpmem

 mov edi,offset array             ;print the array
 mov ecx,Num_Elements
 call crlf
 Print:
 mov eax,[edi]
 call crlf
 call writechar
 add edi,4
 loop Print
 call crlf
 call waitmsg

ret
INTEGER_SORT_FILE Endp


CHARACTER_SORT_FILE Proc

Call Clrscr

mov edx,offset fileee              
call writestring

mov edx,OFFSET filename              ;Opening existing File
call OpenInputFile
mov filehandle,eax

mov eax,filehandle
mov edx,OFFSET buffer            ; reading data from file
mov ecx,BUFFER_SIZE
call ReadFromFile

mov edx,OFFSET buffer
call writestring

mov ecx,BUFFER_SIZE                   ;total buffer size
mov esi,0
mov edi,0
L:                                     ;moving char elements from the buffer to the array
mov bl,[esi+buffer]
mov BYTE PTR [edi+chararray], bl
cmp [esi+buffer],0                      ; If there are no elements ahead then no need to iterate buffer_size times. Just break the loop. iterates only array_size times
JE continue 
add esi,1
add edi,4
LOOP L

;mov ecx,lengthof buffer        ;display the buffer
;mov ebx,type buffer
;mov esi,offset buffer
;call dumpmem



continue:

mov ecx,lengthof chararray           ;counting the number of char elements in the array which have been retrieved from file
mov ebx,0
mov esi,0
sizeee:
cmp [chararray+esi],0               ; stop counting when all the elements are counted
JA increment
jmp loopend
increment:
inc ebx
add esi,4
LOOP sizeee
loopend:
mov ecx,ebx
mov Numof_words,ecx

dec ecx                       ;ecx now contains the actual length of the array (total elements retrieved from the file)


L1:                         ;sorting
mov esi,OFFSET chararray
mov edx,ecx
 
L2:
mov eax,[esi]
mov ebx,[esi+4]
cmp eax,ebx
JA swap1
jmp noswap
swap1:
mov temp2,eax
mov eax,ebx
mov ebx,temp2
mov [esi],eax
mov [esi+4],ebx

noswap:
add esi,4
dec edx
JNZ L2
Loop L1

;mov esi,offset chararray
;mov ecx,lengthof chararray
;mov ebx,type chararray
;call dumpmem

 mov edi,offset chararray             ;print the array
 mov ecx,Numof_words
 call crlf
 Print:
 mov eax,[edi]
 call crlf
 call writechar
 add edi,4
 loop Print
 call crlf
 call waitmsg

 ret

CHARACTER_SORT_FILE Endp

WORD_SORT_FILE PROC

call clrscr

mov edx,offset fileee
call writestring
mov edx , OFFSET filename
call OpenInputFile
mov fileHandle,eax

mov edx,OFFSET buffer
mov ecx,BUFFER_SIZE
call ReadFromFile

INVOKE Str_length, ADDR Buffer
mov buffer[eax],0

mov edx,OFFSET buffer ; display the buffer
call WriteString
call Crlf

   mov num_word,0
   mov inn,0
   mov dl,13
   mov esi,offset buffer
   mov edi,offset array2D
   mov ebx,offset array_str

   
   INSERTING:
   mov eax,0
   cmp [esi],dl
   je nexes
   cmp [esi],eax
   je nexes
   mov al,[esi]
   mov [edi],al
   inc inn
   inc esi
   inc edi
   jmp newer
   nexes:
   sub edi,inn
   mov [ebx],edi
   inc num_word
   add ebx,4
   add edi,inn
   add edi,20
   inc esi
   inc esi
   mov inn,0
   newer:
   mov eax,0
   cmp [esi],eax
   jne INSERTING

   sub edi,inn
   mov [ebx],edi
   inc num_word
   
dec NUM_WORD ;NUMBER OF TIMES TO PERFORM SORT

       ; Strings are all loaded into memory, time to sort
BEGIN_SORT:
       MOV swap, 0                       ; Flag for if we make a swap this pass
       MOV EAX, 0                        ; Current string in str_array

COMPARE_LOOP:
; Loads two string addresses to compare into registers
       MOV EDX, [array_str + EAX * 4]   
       INC EAX
       MOV ECX, [array_str + EAX * 4]

       MOV EBX, 0                        ; Initial location in string
STR_CMP:
; Pull off a byte from the string and load it into EDI
       MOVZX EDI, BYTE PTR [EDX + EBX]         

; If we hit the end of the first string here, assume we are less than the other string
CMP EDI, 0
       JE LESS_THAN
       MOVZX ESI, BYTE PTR [ECX + EBX] ; Same thing, but for ESI
       CMP ESI, 0           ; If we hit the end of the second string here, assume we are greater than
       JE GREATER_THAN
       CMP EDI, ESI         ; Else we just do a comparison on the ASCII value of the indexed character in the string
       JL LESS_THAN
       JG GREATER_THAN
       INC EBX              ; Both characters are equal, move to the next one in the strings and do it again
       JMP STR_CMP
LESS_THAN:
       JMP CHECK_END_SORT   ; If the first string is less than the second, they are in order, no swapping needed
GREATER_THAN:
       DEC EAX
       MOV [array_str + EAX * 4], ECX
       INC EAX
       MOV [array_str + EAX * 4], EDX ; Swap entries
       MOV swap, 1
CHECK_END_SORT:
       CMP EAX,NUM_WORD
       JNE COMPARE_LOOP     ; We are not at the end of str_array yet, loop again with next two elements

       ; If we are here, we are at end of str_array
       CMP [swap], 0
       JNE BEGIN_SORT       ; If we made a swap in this pass of str_array, do another pass from the very beginning

       ; END OF SORTING

	   ;WRITING SORTED STRING
	   call crlf
	   inc NUM_WORD
 
	   mov edx,offset fileee1
	   call writestring
	   call crlf

mov edx , OFFSET filename2
call CreateOutputFile
mov fileHandle,eax

mov eax,fileHandle

MOV ECX,NUM_WORD	; Number of strings to write on file
       MOV ESI,0		; Current string to write on file

WRITE_SORTED_WORDS_In_FILE:
       mov ebx,ecx 
	   MOV EDX, [array_str + ESI * 4]
	   INVOKE Str_length,EDX
	   mov ecx,eax
	   mov eax,fileHandle
	   CALL WriteToFile
	   mov eax,fileHandle
	   mov ecx,1
	   mov edx,offset CRR
	   call WriteToFile
	   mov eax,fileHandle
	   mov ecx,1
	   mov edx,offset LF
	   call WriteToFile
	   mov ecx,ebx
       INC ESI
       LOOP WRITE_SORTED_WORDS_IN_FILE

call CloseFile




mov eax,0
mov ecx,1000
mov edi,offset array2D
DONE12:
mov [edi],eax
inc edi
LOOP DONE12

mov ecx,100
mov edi,offset array_str
DON:
MOV [edi],eax
inc edi
LOOP DON


call crlf
call waitmsg
ret
WORD_SORT_FILE ENDP


SORT_STRING_FILE PROC
local tcx:dword

call clrscr
mov edx,offset fileee
call writestring
mov edx , OFFSET filename
call OpenInputFile
mov fileHandle,eax

mov edx,OFFSET buffer
mov ecx,BUFFER_SIZE
call ReadFromFile

mov buffer[eax],0

mov edx,OFFSET buffer ; display the buffer
call WriteString
call Crlf

mov eax,fileHandle
call CloseFile

INVOKE Str_copy, ADDR buffer, addr content
INVOKE Str_length, ADDR content
mov esi, eax
mov content[esi],' '
inc esi
mov content[esi],'z'
inc esi
mov content[esi],' '
inc esi

mov ecx,lengthof content
mov esi,0
mov al,target
counttWords:
 cmp content[esi],al
 jne inccountt
 inc countt
  inccountt:
    inc esi
 loop counttWords 
mov eax,0

mov ecx,0
mov cl,countt
mov esi,0

l2:
 mov tcx,ecx
 INVOKE Str_length, ADDR content
 mov ecx,eax
 mov eax,0
 dec ecx
 mov al,target
 mov esi,0
 mov start,0
 mov end1,0

 call empty_temp
 

 l1: 
   cmp content[esi],al
   je l3
   inc esi
 loop l1

 
mov ecx,tcx
 cmp ecx,1
 ja con
 jmp del
 con:
 call concat
 del:
 call delete


loop l2

call exi


l3:
mov end1,esi
call tokenize
INVOKE Str_compare, ADDR temp, addr smallest
jb calc
jmp el
calc:
call calc_min

el:
inc esi
dec ecx
jmp l1


exi:
mov edx,offset fileee1
call writestring
call crlf

mov edx , OFFSET filename2   ;string written in output file
call CreateOutputFile
mov fileHandle,eax

mov eax,fileHandle
mov edx,OFFSET ascending
mov ecx,lengthof ascending
call WriteToFile
call CloseFile


ret
SORT_STRING_FILE  ENDP

calc_min proc
INVOKE Str_copy, ADDR temp, addr smallest
ret 
calc_min endp


tokenize proc

 local tempecx:dword , tempesi:dword, tempal:dword,result:dword

mov tempecx,ecx
mov tempesi,esi
mov tempal,eax
push edi
INVOKE Str_length, ADDR temp

mov ecx,16
mov edi,0
l2:
mov al,temp[edi]
xor temp[edi],al
inc edi
loop l2



mov edi,0
mov ecx,end1
mov esi,start


sub ecx,start


l4:
mov al,content[esi]
mov temp[edi],al
inc edi
inc start
inc esi
loop l4

inc start
;mov edx,offset temp
;call writestring 
;call crlf

mov eax,tempal
mov esi,tempesi
mov ecx,tempecx
pop edi
ret
tokenize endp

concat PROC
local tempecx:dword , tempesi:dword, tempal:dword

mov tempecx,ecx
mov tempesi,esi
mov tempal,eax
push edi

INVOKE Str_length, ADDR smallest

mov ecx,eax
mov eax,0
mov edi,current
;call dumpregs
mov esi,0
l1:
mov al,smallest[esi]
mov ascending[edi],al
inc esi
inc edi
inc current
loop l1

mov al,target
mov ascending[edi],al
;inc esi
;inc edi
inc current

;mov edi,offset ascending
;call writestring
;call crlf

mov eax,tempal
mov esi,tempesi
mov ecx,tempecx
pop edi

ret
concat endp

delete proc
local tempecx:dword , tempesi:dword, tempal:dword, index1:dword ,lensmall:dword, subtr:dword

mov tempecx,ecx
mov tempesi,esi
mov tempal,eax
push edi

INVOKE Str_length, ADDR smallest
mov lensmall,eax
mov esi,0
mov edi,0


  mov al,smallest[edi]
  mov ecx,lengthof content
  l1:
    cmp al,content[esi]
    je comp
    inc esi
  loop l1
  jmp exitttt

 comp: 
 mov index1,esi
   push ecx
   push esi
   push edi
   push eax

   mov edi,0
   mov subtr,ecx
   mov esi,index1
   mov ecx,lensmall
   cmp ecx,subtr
   jbe l2
   jmp back

   l2:
    mov al,smallest[edi]
    cmp al,content[esi]
    jne back
	inc esi
	inc edi
   loop l2
   jmp afterfound

   back:
    pop eax
    pop edi
    pop esi
	pop ecx

    inc esi
    dec ecx
    jmp l1

	afterfound:
	 mov esi,index1
	 add esi,lensmall
	 mov al,target
	 cmp content[esi],al
	 jne back
     
	 beforefound:
	  mov esi,index1
	  cmp esi,0
	  je found
	  dec esi
	  mov al,target
	  cmp content[esi],al
	  jne back

	found:
	 mov eax,index1
	 ;call writeint
	 ;call crlf
	 mov esi,index1
	 mov al,content[esi]
	 ;call writechar
	 ;call crlf
    pop eax
    pop edi
    pop esi
	pop ecx
	jmp actual
  
  actual:
  mov eax,lensmall
  add eax,index1
  mov lensmall,eax
  mov ecx,lengthof content
  sub ecx,lensmall
  ;call dumpregs
    mov esi,lensmall
  mov edi,index1
  inc esi
  
   l3:
   mov al,content[esi]
    mov content[edi],al
   inc esi
   inc edi
   loop l3
   
   mov al,target
   mov content[edi],al
   inc edi
   
   INVOKE Str_length, ADDR smallest
   mov ecx,eax
   mov eax,0
   l4:
   mov al,content[edi]
   xor content[edi],al
   inc edi
   loop l4
 ; mov edx,offset content
  ;call writestring
 INVOKE Str_length, ADDR content
 ;call dumpregs
exitttt:
mov eax,tempal
mov esi,tempesi
mov ecx,tempecx
pop edi
ret
delete endp

empty_temp proc
local tempecx:dword , tempesi:dword, tempal:dword, index1:dword ,lensmall:dword, subtr:dword

mov tempecx,ecx
mov tempesi,esi
mov tempal,eax
mov ecx, 16

mov esi,0
l1:
mov al, temp[esi]
xor temp[esi],al
inc esi
loop l1

mov ecx,16
mov esi,0
l2:
mov smallest[esi],'z'
inc esi
loop l2

mov eax,tempal
mov esi,tempesi
mov ecx,tempecx

ret
empty_temp endp


end main