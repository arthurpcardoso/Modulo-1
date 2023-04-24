delay: 					.equ 1000

			bic.b 		#BIT1,&P2DIR ; configuração do botão s1
			bis.b 		#BIT1,&P2REN
			bis.b 		#BIT1,&P2OUT
			bic.b 		#BIT1,&P1DIR ; configuração do botaão s2
			bis.b 		#BIT1,&P1REN
			bis.b 		#BIT1,&P1OUT
			bis.b		#BIT0,&P1DIR
			bic.b 		#BIT0,&P1OUT ; configuração led vermelho
			bis.b		#BIT7,&P4DIR
			bic.b 		#BIT7,&P4OUT ; configuração led verde

loop:
			bit.b		#BIT1,&P2IN
			jz			fechour
			bic.b		#BIT0,&P1OUT
verde:		bit.b		#BIT1,&P1IN
			jz			fechoug
			bic.b		#BIT7,&P4OUT
			jmp			loop

fechour:	bis.b		#BIT0,&P1OUT
			jmp			verde

fechoug:	bis.b		#BIT7,&P4OUT
			jmp			loop


atz:		mov			#delay,R10
atz1:		dec			R10
			jnz			atz1
			ret