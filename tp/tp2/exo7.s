/*
	Exercice 7
	Le code de C´esar permet de chiffrer un message (texte) en rempla¸cant chaque lettre par la lettre qui se trouve n
	positions plus loin dans l’alphabet (circulairement : apr`es Z, on revient `a A).
	Ecrire un programme qui d´echiffre le message qui se trouve `a l’adresse message qui a ´et´e cod´e avec un d´ecalage
	(n) indiqu´e par la variable dec, et qui ne comporte que des lettres majuscules. Le message d´ecod´e sera ´ecrit `a la
	place du message cod´e.
	On rappelle que les lettres majuscules sont plac´ees les unes `a la suite des autres, dans l’ordre alphab´etique, dans la
	table des codes ASCII.
	Utiliser ce programme pour d´echiffrer le message suivant qui a ´et´e produit avec un d´ecalage de 2 (la lettre A a ´et´e
	transform´ee en C) :
*/

@ r0: i
@ r1: &message
@ r2: char
@ r3: dec

_start:
    adr r4, dec
    ldrb r3, [r4] @ r3 <- *dec 

	adr r1, message	 @ r1 <- &message
	mov r0, #0       @ r0 <- 0
    cesar_for1:
        ldrb r2, [r1, r0] @ char <- message[i]

		cmp r2, #0   @ char == '\0' ?
        beq cesar_for1_end
        
        sub r2, r2, r3    @ char -= dec
        cmp r2, #'A'      @ char < 'A' ?
        addlt r2, r2, #26 @ char += 26
        
        strb r2, [r1, r0]

        add r0, r0, #1
        b cesar_for1
    cesar_for1_end:
		

_end:
	b _end


message: .asciz "DTCXQXQWURQWXGBRCUUGTCNGZGTEKEGUWKXCPV"
dec: .word 2
