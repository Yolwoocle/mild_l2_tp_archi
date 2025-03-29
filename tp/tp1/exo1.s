/*
	a = nb1;
	b = nb2;
	while (a != b) {
		if (a > b)
			b = b + nb2;
		else
			if (a < b)
				a = a + nb1;
	}
	// a est le ppcm
	
	Exemples pour tester :
	- le PPCM de 9 et 6 est 18
	- le PPCM de 9 et 15 est 45
	- le PPCM de 10 et 20 est 20
*/

.global _start
.equ nb1, 10
.equ nb2, 20
_start:
	mov		r1, #nb1
	mov		r2, #nb2

while:
	cmp		r1, r2
	beq		endwhile
	addgt	r2, r2, #nb2
	addlt	r1, r1, #nb1
	b		while

endwhile:
	mov		r0, r1
end:
	b 		end
	