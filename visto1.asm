NUM				 			.equ 3999 		;Indicar número a ser convertido
;
 			mov 			#NUM,R5 		;R5 = número a ser convertido
 			mov 			#RESP,R6 		;R6 = ponteiro para escrever a resposta
 			call 			#ALG_ROM 		;chamar subrotina
 			jmp 			$ 				;travar execução
			nop 							;exigido pelo montador
;
ALG_ROM:
; R5 - Número
; R7 - Unidade
; R8 - Dezena
; R9 - 	Centena
; R10 - Milhar

; --------------- Decompor o numero ----------------------

			clr				R7				;unidade
			clr				R8				;dezena
			clr				R9				;centena
			clr				R10				;milhar

			cmp				#1000,R5
			jhs				milhar
			cmp				#100,R5
			jhs				centena
			cmp				#10,R5
			jhs				dezena
			jmp				unidade

milhar:		inc				R10
			sub				#1000,R5
			jn				centena
			cmp				#1000,R5
			jhs				milhar

centena:	inc				R9
			sub				#100,R5
			jn				dezena
			cmp				#100,R5
			jhs				centena

dezena:		inc				R8
			sub				#10,R5
			jn				unidade
			cmp				#10,R5
			jhs				dezena

unidade:	mov				R5,R7

; ------------------ MILHAR -----------------------
mil:		cmp				#0,R10
			jeq				cen
			mov				#0x4D,0(R6)		;Escreve M
			incd			R6
			dec				R10
			jmp				mil

; ------------------ CENTENA -----------------------
cen:		cmp				#5,R9
			jl				menor5c
			jmp				maior5c



menor5c:	cmp				#4,R9
			jl				menor4c
			mov				#0x43,0(R6)		;Escreve C
			inc				R6
			mov				#0x44,0(R6)		;Escreve D
			incd			R6
			jmp				dez

menor4c:	cmp				#0,R9
			jz				dez
			mov				#0x43,0(R6)		;Escreve C
			incd			R6
			dec				R9
			jmp				menor4c

maior5c:	cmp				#9,R9
			jl				menor9c
			mov				#0x43,0(R6)		;Escreve C
			incd			R6
			mov				#0x4D,0(R6)		;Escreve M
			incd			R6
			jmp				dez

menor9c:	mov				#0x44,0(R6)		;Escreve D
			incd			R6
loop5c:		cmp				#5,R9
			jeq				dez
			mov				#0x43,0(R6)		;Escreve C
			incd			R6
			dec				R9
			jmp				loop5c

; ------------------ DEZENA -----------------------

dez:		cmp				#5,R8
			jl				menor5d
			jmp				maior5d



menor5d:	cmp				#4,R8
			jl				menor4d
			mov				#0x58,0(R6)		;Escreve X
			inc				R6
			mov				#0x4C,0(R6)		;Escreve L
			incd			R6
			jmp				uni

menor4d:	cmp				#0,R8
			jz				uni
			mov				#0x58,0(R6)		;Escreve X
			incd			R6
			dec				R8
			jmp				menor4d

maior5d:	cmp				#9,R8
			jl				menor9d
			mov				#0x58,0(R6)		;Escreve X
			incd			R6
			mov				#0x43,0(R6)		;Escreve C
			incd			R6
			jmp				uni

menor9d:	mov				#0x4C,0(R6)		;Escreve L
			incd			R6
loop5d:		cmp				#5,R8
			jeq				uni
			mov				#0x58,0(R6)		;Escreve X
			incd			R6
			dec				R8
			jmp				loop5d

;------------------- UNIDADE ----------------------
uni:			cmp				#5,R7
			jl				menor5u
			jmp				maior5u



menor5u:	cmp				#4,R7
			jl				menor4u
			mov				#0x49,0(R6)		;Escreve I
			inc				R6
			mov				#0x56,0(R6)		;Escreve V
			incd			R6
			jmp				final

menor4u:	cmp				#0,R7
			jz				final
			mov				#0x49,0(R6)		;Escreve I
			incd			R6
			dec				R7
			jmp				menor4u

maior5u:	cmp				#9,R7
			jl				menor9u
			mov				#0x49,0(R6)		;Escreve I
			incd			R6
			mov				#0x58,0(R6)		;Escreve X
			incd			R6
			jmp				final

menor9u:	mov				#0x56,0(R6)		;Escreve V
			incd			R6
loop5u:		cmp				#5,R7
			jeq				final
			mov				#0x49,0(R6)		;Escreve I
			incd			R6
			dec				R7
			jmp				loop5u

final: 		mov				#0x00,0(R6)
			ret


 			.data
; Local para armazenar a resposta (RESP = 0x2400)
RESP: 		.byte			"AAAAAAAAAAAAAAAAAAAAAAAA"