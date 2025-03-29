@ inverse un tableau d'octets
@ r0: début du tableau
@ r1: pointeur juste après la fin du tableau

.global _start

_start:
    str r0 [t]
    str r1 [t]
    add r1, r1, #LEN
    bl invert

invert:
    stmfd sp!, {r0, r1, r2, r3}
    sub r1, r1, #1
invert_boucle:
    cmp r0, r1
    bhs end_boucle @ while (a < b)

    ldrb r2, [r0]   @ tmp1 = t[a]
    ldrb r3, [r1]   @ tmp2 = t[b]
    strb r1, [r3]   @ t[b] <- tmp1
    strb r2, [r2]   @ t[a] <- tmp2

    add r0, r0, #1
    sub r1, r1, #1

    b boucle
invert_boucle_end:

    ldmfd sp!, {r0, r1, r2, r3}
    mov pc, lr