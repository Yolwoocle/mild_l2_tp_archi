/*
	Exercice 2
	Question 2.
Ecrire un programme qui dispose d’un entier N dans le registre r1, tel que N est une puissance de 2, et calcule dans
r0 la valeur log2(N).
Par exemple, si r1 contient 32, le programme doit mettre 5 dans r0.
*/


.global _start
.equ N, 32
_start:
	mov 	r1, #N  @ N
	mov 	r0, #0  @ log
	mov		r2, r1  @ i
	
boucle:
	cmp 	r2, #1
	ble		end_boucle
	mov		r2, r2, LSR #1
	add		r0, r0, #1
	b		boucle
	
end_boucle:
	b		end_boucle