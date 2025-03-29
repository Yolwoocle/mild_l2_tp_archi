.global _start

.equ WAIT, 0xffff
.equ LEDS, 0xff200000
.equ SEVENSEG, 0xff200020
.equ CUVE_WAIT, 5

nombres: .byte 0b0111111, 0b0000110, 0b1011010, 0b1001111, 0b1100110, 0b1101101, 0b1111101, 0b0000111, 0b1111111, 0b1101111
.align

_start:
    @ bl remplir
    @ bl vider

    bl reset_7seg

    mov r8, #0
    mov r9, #0
    bl afficher_7seg

	b _end


afficher_temperature:
    stmfd sp!, {lr}

    mov r8, r1
    mov r9, #5
    bl afficher_7seg

    mov r8, #0
    mov r9, #4
    bl afficher_7seg

    ldmfd sp!, {pc}


reset_7seg:
    stmfd sp!, {r0-r1, lr}

    ldr r0, =SEVENSEG
    mov r1, #0
    str r1, [r0]

    add r0, r0, #16
    str r1, [r0]
    
    ldmfd sp!, {r0-r1, pc}


@ Affiche le nombre r8 à la position r9 de l'afficheur 7-seg.
afficher_7seg:
    stmfd sp!, {r0-r3, lr}

    @ Load les adresses 
    ldr r0, =SEVENSEG
    adr r1, nombres
    
    cmp r9, #4
    addhs r0, r0, #16
    subhs r9, r9, #4

    @ Load le code binaire du nombre
    ldrb r2, [r1, r8]    @ r2 <- nombres[r8]
    mov r3, #8
    mul r3, r9, r3
    mov r2, r2, lsl r3

    str r2, [r0]

    ldmfd sp!, {r0-r3, pc}


wait1:
    stmfd sp!, {r0, lr}

    ldr r0, =WAIT
    wait1_for1:
        cmp r0, #0
        bls wait1_for1_end

        sub r0, r0, #1

        b wait1_for1
    wait1_for1_end:

    ldmfd sp!, {r0, pc}


waitn:
	stmfd sp!, {r0, lr}
	
	mov r0, r8
	waitn_for1:
        cmp r0, #0
        bls waitn_for1_end

        bl wait1

        sub r0, r0, #1
		b waitn_for1
	waitn_for1_end:
	
	ldmfd sp!, {r0, pc}


remplir:
	stmfd sp!, {r0-r2, r8, lr}
	
    ldr r1, =LEDS @ r1: adresse des LEDs

    mov r2, #0x0
    str r2, [r1] @ reset les LEDs à 111...111

	mov r0, #0 @ i = 0
	remplir_for1:
		cmp r0, #10
		bhs remplir_for1_end

        mov r2, #2
        mov r2, r2, lsl r0  @ valeur des LEDs
        sub r2, #1
        str r2, [r1]  @ *LEDS <- 0b011...(i bits)...11

        @ Wait 0.5 secs
        mov r8, #CUVE_WAIT
        bl waitn

        add r0, r0, #1
        b remplir_for1
	remplir_for1_end:
	
    @ cuve_pleine <- 1
    adr r0, cuve_pleine
    mov r1, #1
    str r1, [r0] 

	ldmfd sp!, {r0-r2, r8, pc}


vider:
	stmfd sp!, {r0-r2, r8, lr}
	
    ldr r1, =LEDS @ r1: adresse des LEDs

    mov r2, #0x3ff
    str r2, [r1] @ reset les LEDs

	mov r0, #9   @ i = 9
	vider_for1:
		cmp r0, #0
		blt vider_for1_end

        mov r2, #2
        mov r2, r2, lsl r0  @ valeur des LEDs
        sub r2, #1
        str r2, [r1]  @ *LEDS <- 0b011...(i bits)...11

        mov r8, #CUVE_WAIT
        bl waitn

        sub r0, r0, #1
        b vider_for1
	vider_for1_end:
	
    mov r2, #0
    str r2, [r1] @ reset les LEDs à 0

    @ cuve_pleine <- 0
    adr r0, cuve_pleine
    mov r1, #0
    str r1, [r0]

	ldmfd sp!, {r0-r2, r8, pc}


_end:
	b _end

cuve_pleine: .byte 0

@              0          1          2          3          4          5          6          7          8          9
@ nombres: .byte 0b0111111, 0b0000110, 0b1011010, 0b1001111, 0b1100110, 0b1101101, 0b1111101, 0b0000111, 0b1111111, 0b1101111
