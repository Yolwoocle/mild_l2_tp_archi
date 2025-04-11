@ Ecrire un programme qui commence par les déclarations suivantes :
@     a: .byte 8
@     b: .byte 12
@     somme: .fill 1,1
@ et qui écrit dans la variable somme la somme des variables a et b. Toutes les variables sont 
@ des nombres compris entre 0 et 255 et codés sur un octet.
@ Verifier que le résultat est correct dans l’onglet Memory.

.global _start

_start:
	adr r0, a
	adr r1, b
	ldrb r2, [r0]
	ldrb r3, [r1]
	add r2, r2, r3
	adr r4, somme
	strb r2, [r4]

a: .byte 8
b: .byte 12
somme: .fill 1,1