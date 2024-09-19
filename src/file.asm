.data

FILE: .asciz "ranking.bin"

FP: .word 0

.text

OPEN_FILE:

    li a7, 1024
    la a0, FILE
    li a1, 0
    ecall

    sw a0, FP, t0 

    li a7, 63
    mv a0, t0
    la a1, HIGHSCORE
    li a2, 4
    ecall

    ret

CLOSE_FILE:

    li a7, 57
    mv a0, t0
    ecall

    ret
    
UPDATE_HIGHSCORE:

    la a0, HIGHSCORE
    lw a1, 0(a0)
    
    blt s1, a1, NO_UPDATE

    call OPEN_FILE

    li a7, 64
    mv a0, t0
    mv a1, s1
    li a2, 4
    ecall

NO_UPDATE:
    ret