.global _start

_start:
    mov r0 #N
    bl itoa

@ conversion en décimal
@ r0: nombre 
@ r1: chaîne
itoa:
    stmfd sp!, {r0, r2}

    mov r2, r0  @ nombre
    mov r3, r1  @ chaine

itoa_boucle:
    cmp r2, #0
    bls itoa_boucle_end

    mov r0, nombre
    mov r1, #10
    bl division      @ r0 = nombre % 10;  r1 = nombre / 10

    mov r2, r1       @ nombre = nombre / 10

    add r0, 

    b itoa_boucle
itoa_boucle_end:

    ldmfd sp!, {r0, r2}
    mov pc, lr


@ division euclidienne
@ r0, r1 : dividende, diviseur (entrées)
@ r0 : reste, r1 : quotient (sortie)
division:
    stmfd sp!, {r2}

    mov r2, #0
boucle:
    cmp r0, r1
    blo end_bcl
    sub r0, r0, r1
    add r2, r2, #1
    b boucle
end_bcl:
    mov r1, r2

    ldmfd sp!, {r2}
    mov pc, lr








@@ CORRECTION


itoa:
    stmfd sp!, {...}
    mov r2, r1
itoa_boucle:
    cmp r0, #0
    beq itoa_boucle_end

    mov r1, #10
    bl division
    add r0, r0, #'0'
    strb r0, [r2], #1
    mov r0, r1
    b itoa_boucle
itoa_boucle_end:
    mov r1, r2
    mov r0, r2
    bl invert
    mov r0, #0  @ '\0'
    strb r0, [r2]

    ldmfd sp!, {r0, r3, pc}
