/* 
    Ecrire un programme qui recopie la chaˆıne de caract`eres chaine1 `a l’adresse chaine2 en supprimant tous les
    caract`eres qui repr´esentent des chiffres.
    chaine1: .asciz "JLkd2nj345bnzApdd0j9"
    chaine2: .fill 255,1
    Le r´esultat attendu est ”JLkdnjbnzApddj”.
*/ 

@ r0 : char
@ r1 : &chaine1
@ r2 : &chaine2
@ r3 : i1
@ r4 : i2

_start:
    adr r1, chaine1   @ r1 <- &chaine1 
    adr r2, chaine2   @ r2 <- &chaine2
    mov r3, #0
    mov r4, #0

    exo8_for1:
        ldrb r0, [r1, r3]   @ char <- chaine1[i1] 
        cmp r0, #0          @ char == '\0' ?
        beq exo8_for1_end 

        cmp r0, #'0'        @ char < '0' ?
        blo exo8_if1 
        cmp r0, #'9'        @ char > '9' ?
        bhi exo8_if1 
        b exo8_if1_end
        exo8_if1: 
            strb r0, [r2, r4]  @ chaine2[i2] <- char
            add r4, r4, #1     @ i2 += 1
        exo8_if1_end: 

        add r3, r3, #1      @ i1 += 1
        b exo8_for1
    exo8_for1_end:



_end:
    b _end

chaine1: .asciz "JLkd2nj345bnzApdd0j9"
chaine2: .fill 255,1
    