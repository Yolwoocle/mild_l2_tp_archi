/*
	Exercice 3
	Ecrire un programme qui calcule dans r0 la racine carr´ee enti`ere d’un nombre N pr´esent dans r1 selon l’algorithme
	suivant :
	
	racine = 0;
	while ( (racine+1)^2 ≤ N )
		racine = racine + 1;
	
	1
	Exemples pour tester :
	- la racine enti`ere de 16 est 4
	- la racine enti`ere de 19 est 4
	- la racine enti`ere de 79 est 8
*/


.global _start
.equ N, 79
_start:
	mov 	r1, #N  @ N
	mov 	r0, #0  @ racine
	
boucle:
	mov 	r2, r0       @ r2 <- racine
	add		r2, r2, #1   @ r2 <- racine + 1
	mov		r3, r2       @ r3 <- r2
	mul 	r2, r3, r2   @ r2 <- (racine + 1)^2
	cmp 	r2, #N
	bgt		end_boucle
	add		r0, r0, #1
	b		boucle
	
end_boucle:
	b		end_boucle
	
