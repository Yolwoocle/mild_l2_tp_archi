.global _start

.equ WAIT, 0xffff
.equ LEDS, 0xff200000
.equ SEVENSEG, 0xff200020
.equ CUVE_WAIT, 5
.equ TEMPERATURE_WAIT, 5

nombres: .byte 0b0111111, 0b0000110, 0b1011011, 0b1001111, 0b1100110, 0b1101101, 0b1111101, 0b0000111, 0b1111111, 0b1101111
.align
positions_tambour: .word 0x3000, 0x2100, 0x0101, 0x0003, 0x0006, 0x000c, 0x0808, 0x1800, 0x3000
.align
.equ LEN_POSITIONS_TAMBOUR, 9

_start:
    @ bl remplir
    @ bl vider

    bl reset

    mov r1, #5
    bl chauffer

    mov r1, #0
    mov r2, #0
    mov r3, #5
    bl tourner_tambour

	b _end


reset:
    stmfd sp!, {r0-r1, lr}

    @ Reset les quatre 7-segments de droite
    ldr r0, =SEVENSEG
    mov r1, #0
    str r1, [r0]

    @ Reset les 7-segments de gauche
    add r0, r0, #16
    str r1, [r0]

    @ Reset les LEDs
    ldr r0, =LEDS @ r1: adresse des LEDs
    mov r1, #0
    str r1, [r0] @ reset les LEDs à 111...111
    
    ldmfd sp!, {r0-r1, pc}


@ simule la rotation du tambour sur les deux afficheurs 7-segments de droite 
@ selon le sch´ema pr´esent´e un peu plus haut. Les param`etres de ce sous-programme sont :
@ - dans r1, le sens de rotation : vers la droite (0) ou vers la gauche (1),
@ - dans r2, la vitesse de rotation : lente (0) ou rapide (1),
@ - dans r3, le nombre de rotations compl`etes.
tourner_tambour:
    stmfd sp!, {r0-r11, lr}

    @ r0 : indice for2 
    @ r1 : sens de rotation / vers la droite (0) ou vers la gauche (1)
    @ r2 : la vitesse de rotation / lente (0) ou rapide (1)
    @ r3 : le nombre de rotations à effectuer
    @ r5 : image à afficher sur le 7-segment
    @ r6 : indice de l'image à afficher sur les 7-segment
    @ r7 : tmp
    @ r8 : nombre de ms à attendre entre chaque position
    @ r10 : &positions_tambour
    @ r11 : SEVENSEG

    adr r10, positions_tambour
    ldr r11, =SEVENSEG

    @ Sens de rotation 

    @ Vitesse
    cmp r2, #0    
    moveq r8, #5
    movne r8, #1

    @ Nombre de rotations
    
    
	tourner_tambour_for1:
        cmp r3, #0
        bls tourner_tambour_for1_end   @  nb_rotations <= 0 ?

	    mov r0, #0 @ i_frame = 0
	    tourner_tambour_for2:
            cmp r0, #LEN_POSITIONS_TAMBOUR
            bhs tourner_tambour_for2_end

            @ r6 <- indice frame à afficher 
            mov r6, r0

            @ Inverser indice si sens de rotation gauche (i := LEN_POSITIONS_TAMBOUR - i - 1)
            mov r7, #-1
            cmp r1, #0
            beq tourner_tambour_if1_end 
            mul r6, r7, r6 @ i *= -1 
            add r6, r6, #LEN_POSITIONS_TAMBOUR
            sub r6, r6, #1
            tourner_tambour_if1_end:

            @ *SEVENSEG <- positions_tambour[i_frame]
            ldr r5, [r10, r6, lsl #2]
            str r5, [r11]

            bl waitn

            add r0, r0, #1
            b tourner_tambour_for2
	    tourner_tambour_for2_end:
        
        sub r3, r3, #1
        b tourner_tambour_for1
	tourner_tambour_for1_end:

    ldmfd sp!, {r0-r11, pc}


chauffer:
	stmfd sp!, {r0-r2, r8, lr}
	
    mov r2, r1
	mov r0, #0 @ i = 0
	chauffer_for1:
		cmp r0, r2
		bhi chauffer_for1_end

        mov r1, r0
        bl afficher_temperature

        @ Wait 0.5 secs
        mov r8, #TEMPERATURE_WAIT
        bl waitn

        add r0, r0, #1
        b chauffer_for1
	chauffer_for1_end:
	
	ldmfd sp!, {r0-r2, r8, pc}


@ affiche sur les deux afficheurs 7-segments de gauche une temp´erature pass´ee 
@ en param`etre dans r1 et exprim´ee en dizaines de degr´es comprise entre 0 et 6 inclus.
@ Par exemple, si le param`etre vaut 2, le sous-programme doit afficher 20.
afficher_temperature:
    stmfd sp!, {r0-r5, lr}

    @ Load les adresses 
    ldr r2, =SEVENSEG
    add r2, r2, #16
    adr r3, nombres

    @ Load le code binaire du nombre
    ldrb r4, [r3, r1]    @ r4 <- nombres[temperature]
    mov r4, r4, lsl #8
    ldrb r5, [r3, #0]    @ r4 <- nombres[temperature]
    add r4, r4, r5

    str r4, [r2]

    ldmfd sp!, {r0-r5, pc}


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
