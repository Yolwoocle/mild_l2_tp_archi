@ division euclidienne
@ r0, r1 : dividende, diviseur (entrées)
@ r0 : reste, r1 : quotient (sortie)

.global _start
.equ A 25
.equ B 6

_start:
	mov	r0, #A
	mov	r1, #B
    bl sous_prog

div:
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