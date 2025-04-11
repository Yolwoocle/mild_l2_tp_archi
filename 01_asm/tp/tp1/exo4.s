/*
	Exercice 4
	
	Ecrire un programme qui extrait un ”champ de bits”du contenu de r1 et le place dans les bits de poids faible de r0.
	La position du 1er bit (celui de poids le plus fort) et celle du dernier bit (celui de poids le plus faible) `a extraire
	sont donn´ees respectivement dans r2 et r3.
	
	Exemples :
	- si r1=0b111000101011, r2=7, r3=2, on veut placer dans r0 (align´es sur la droite, c’est-`a-dire `a partir du
	bit 0) les bits 7-2 du registre r1, c’est-`a-dire les bits color´es en rouge ici : r1=0b1110[001010]10. On doit donc
	obtenir r0=0b001010, soit r0=0x0a.
	- si r1=0b111000101011, r2=3, r3=0, on doit obtenir r0=0b1011, soit r0=0x0b.
*/


.global _start
.equ N, 79
_start:
	mov 	r1, #0b111000101011  @ 0b1110[001010]10
	mov 	r2, #3 		@ a
	mov 	r3, #0		@ b
	mov		r0, r1		@ output <- r1
	
	@ On décale à droite pour éliminer les bits de poids faible
	mov		r0, r0, LSR r3

	@ On construit un masque dans r4 (1 << (r2 - r3 + 1)) - 1
	sub		r4, r2, r3		@ n <- a-b
	add		r4, r4, #1		@ n <- a-b+1
	mov 	r5, #1			@ mask <- 1
	mov		r5, r5, LSL r4	@ mask <- 1 << n
	sub		r5, r5, #1		@ mask <- (1 << n) - 1
	
	@ On applique le masque
	and		r0, r0, r5
	
end_bcl1:
	b 		end_bcl1