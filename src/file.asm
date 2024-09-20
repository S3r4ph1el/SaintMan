.data

FILE: .asciz "src/ranking.bin"

.text

READ_RANKING_FILE:

    li a7, 1024
    la a0, FILE
    li a1, 0
    ecall

    bgez a0, ep29
    
    li a7, 1024
    la a0, FILE
    li a1, 1
    ecall

    li a7, 57
    ecall
    ret

    ep29:

    li a7, 63
    # fp em a0
    addi sp, sp, -4
    sw a0, (sp)
    la a1, HIGHSCORE
    li a2, 4
    ecall

    li a7, 57
    lw a0, (sp)
    addi sp, sp, 4
    ecall

    ret
    
UPDATE_HIGHSCORE:
    
    la t0, HIGHSCORE
    lw t1, 0(t0)

    blt s1, t1, NO_UPDATE

    sw s1, 0(t0)

    li a7, 1024
    la a0, FILE
    li a1, 1
    ecall
  

    li a7, 64
    # fp already in a0
    addi sp, sp, -4
    sw a0, (sp)
    la a1, HIGHSCORE
    li a2, 4
    ecall

    li a7, 57
    lw a0, (sp)
    addi sp, sp, 4
    ecall


NO_UPDATE:
    addi sp, sp, -4
    sw ra, (sp)
    call print_high_score
    lw ra, (sp)
    addi sp, sp, 4

    ret
