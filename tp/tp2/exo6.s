/*
    Exo 6

    On veut trier un tableau de N entiers signés dans l’ordre croissant, selon l’algorithme du 
    tri par sélection.
    Ce tri consiste à chercher le plus petit élément du tableau et à l’échanger avec le 
    premier élément, puis à recommencer à partir de l’élément suivant, et ce jusqu’à 
    l’avant-dernier élément. L’algorithme est donné ci-dessous :

    for (i=0; i<N-1 ; i++) {
        minindex = i;
        for (j=i+1; j<N ; j++)
            if (tab[j] < tab[minindex])
                minindex = j;
        
        if (minindex != i){
            // échanger tab[i] et t[minindex]
            tmp = tab[i];
            tab[i] = t[minindex];
            tab[minindex] = tmp;
        }
    }

    Ecrire ce programme.
    On pourra le tester avec le tableau suivant (10 éléments):
    tab: .word 22, -12, 0, 9, 5, -1, 5, 43, 10, -10
*/

.global _start
.equ N, 10

@ r0: i
@ r1: j
@ r2: &tab
@ r3: tab[j]
@ r4: tab[minindex]
@ r5: minindex
@ r8: tmp1
@ r9: tmp2

_start:
    mov r0, #0
    adr r2, tab                 @ r2 <- &tab
	
    tri_for1:
        mov r8, #N
        sub r8, r8, #1
        cmp r0, r8
        bhs tri_for1_end        @ i >= N-1 ?

        mov r5, r0              @ minindex <- i

		mov r1, r0       
        add r1, r1, #1      @ j <- i + 1    
        tri_for2:
            cmp r1, #N
            bhs tri_for2_end    @ j >= N ?

            ldr r3, [r2, r1, lsl #2]    @ r3 <- tab[j]
            ldr r4, [r2, r5, lsl #2]    @ r4 <- tab[minindex]
            cmp r3, r4
            movlt r5, r1        @ if (tab[j] < tab[minindex])  minindex = j 

            add r1, r1, #1
            b tri_for2
        tri_for2_end:


        @ if (minindex != i){
        @     // échanger tab[i] et t[minindex]

        cmp r5, r0
        beq tri_endif1          @ minindex == i ?

            @ On inverse tab[i] et tab[minindex]
            ldr r8, [r2, r0, lsl #2]        @ tmp1 <- tab[i]
            ldr r9, [r2, r5, lsl #2]        @ tmp2 <- tab[minindex]
            str r9, [r2, r0, lsl #2]        @ tab[i]        <- tmp2
            str r8, [r2, r5, lsl #2]        @ tab[minindex] <- tmp1

        tri_endif1:

        add r0, r0, #1
        b tri_for1
    tri_for1_end:

_end:
    b _end


tab: .word 22, -12, 0, 9, 5, -1, 5, 43, 10, -10
