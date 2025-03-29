/*
	Exercice 2
	Question 1.
Ecrire un programme qui dispose d’un entier N dans le registre r1 et calcule dans r0 la valeur 2^N . On suppose que
la valeur dans r 1 est inf´erieure ou ´egale `a 31.

	Par exemple, si r1 contient 5, le programme doit mettre 32 (=2^5) dans r0.
	La valeur 2N peut ˆetre obtenue en partant de 1 que l’on d´ecale N fois vers la gauche, puisque 2N est repr´esent´e en
	binaire par un 1 en position N. Par exemple, si on d´ecale 1 cinq fois vers la gauche, on obtient (100000)2 = (32)10.
	Ecrire ce programme en utilisant une boucle (faire effectivement N d´ecalages de une position).
*/


.global _start
.equ N, 5
_start:
	mov 	r1, #N  @ N
	mov 	r0, #1  @ product
	mov		r2, #N  @ i
	
boucle:
	cmp 	r2, #0
	beq		end_boucle
	mov		r0, r0, LSL #1
	sub		r2, r2, #1
	b		boucle
	
end_boucle:
	b		end_boucle