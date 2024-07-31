.data
.include "levels/placeholder_map.data"
.include "sprites/Zenon.data"

.text

    # config keyboard interrupt
    la tp, change_dir
    csrrw zero, utvec, tp
    csrrsi zero, ustatus, 1
    li tp, 0x100
    csrrw zero, 66, tp
    li t1, 0xff200000
    li t0, 2
    sw t0, (t1)

    # render map
    la a0, map
    jal render

	
    li s0, 100
    li s1, 100
    main_loop:

        # render player
        la a0, player
        jal render
		
        # sleep
        li a7, 32
        li a0, 5000
        # ecall
		
        # erase player
        la a0, player
        jal erase_sprite
		
        # move player
        la a0, player
        li a1, 4
        jal move_sprite

        j main_loop

    main_exit:
    li a7, 10
    ecall

# render image according to images type
# 4 background
# 12 static image
# 24 image with direction, and position
# args:
# a0 -> endereco imagem tamanho multiplo de 4
# a1 -> frame
# registradores usados:
# t0 - t6
render:
    # checa tipo de sprite para renderizar
    lw t0, (a0)
    li t1, 4
    beq t0, t1, bg
    li t1, 12
    beq t0, t1, static
    li t1, 24
    beq t0, t1, moving

    # render background
    bg: 
        mv t6, a0
        addi t6, t6, 4
        li t0, 0xff000000
        li t1, 0xff012c00

        l4:
            beq t0, t1, e4
            lw t2, (t6)
            sw t2, (t0)
            addi t0, t0, 4
            addi t6, t6, 4
            j l4
            
        e4:
        ret
    # render static image (fix)
    static:
        # t0 = primeiro pixel
        li t0, 0xff000000
        li t1, 320
        mul t1, t1, a2
        add t1, t1, a1
        add t0, t0, t1

        # pega imagem e tamanho
        mv t6, a0
        lw t1, 4(t6) # colunas x
        lw t2, 8(t6) # linhas y
        addi t6, t6, 12

        # loop linha y
        li t3, 0
        l5:
            bge t3, t2, e2
        
            # loop coluna x
            li t4, 0
            l6:
                bge t4, t1, e3
                lw t5, (t6)
                sw t5, (t0)
                addi t6, t6, 4
                addi t0, t0, 4
                addi t4, t4, 4
                j l3
            e6:
            addi t0, t0, 320
            sub t0, t0, t1
            addi t3, t3, 1
            j l2
        e5:

        ret
	
    moving:
        # pega largura e altura e calcula tamanho
        lw t0, 4(a0)
        lw t1, 8(a0)
        mul t2, t0, t1
        
        # seleciona imagem certa
        lw t3, 12(a0)
        mv t6, a0
        addi t6, t6, 24
        mul t2, t2, t3
        add t6, t6, t2
        
        # pega x e y
        lw t2, 16(a0) # x
        lw t3, 20(a0) # y
        
        # t4 = primeiro pixel
        li t4, 0xff000000
        li t5, 320
        mul t5, t5, t3
        add t5, t5, t2
        add t4, t4, t5

        # loop linha y
        li t2, 0
        l2:
            bge t2, t1, e2
        
            # loop coluna x
            li t3, 0
            l3:
                bge t3, t0, e3
                lw t5, (t6)
                sw t5, (t4)
                addi t6, t6, 4
                addi t4, t4, 4
                addi t3, t3, 4
                j l3
            e3:
            addi t4, t4, 320
            sub t4, t4, t0
            addi t2, t2, 1
            j l2
        e2:

        ret


# erase sprite
# args:
# a0 -> sprite image address
# a3 -> frame
# registradores usados:
# t0 - t6
erase_sprite:
    # get x e y
    lw t0, 16(a0) # x
    lw t1, 20(a0) # y

    # t0 = primeiro pixel bg
    # t1 = primeiro pixel bitmap
    li t4, 0xff000000
    la t2, map
    addi t2, t2, 4
    li t3, 320
    mul t3, t3, t1
    add t3, t3, t0
    add t0, t2, t3
    add t1, t4, t3

    # pega imagem e tamanho
    lw t2, 4(a0) # colunas x
    lw t3, 8(a0) # linhas y

    # loop linha y
    li t4, 0
    l7:
        bge t4, t3, e7
        # loop coluna x
        li t5, 0
        l8:
            bge t5, t2, e8
            lw t6, (t0)
            sw t6, (t1)
            addi t0, t0, 4
            addi t1, t1, 4
            addi t5, t5, 4
            j l8
        e8:
        addi t0, t0, 320
        sub t0, t0, t2
        addi t1, t1, 320
        sub t1, t1, t2
        addi t4, t4, 1
        j l7
    e7:
    ret

# move sprite
# a0 -> sprite address
# a1 -> pixels to move, velocity
move_sprite:
    # checa direcao
    lw t0, 12(a0)
    li t1, 0
    beq t0, t1, w
    li t1, 1
    beq t0, t1, a
    li t1, 2
    beq t0, t1, s
    li t1, 3
    beq t0, t1, d

    w:
    lw t0, 20(a0)
    sub t0, t0, a1
    sw t0, 20(a0)
    ret

    a:
    lw t0, 16(a0)
    sub t0, t0, a1
    sw t0, 16(a0)
    ret

    s:
    lw t0, 20(a0)
    add t0, t0, a1
    sw t0, 20(a0)
    ret

    d:
    lw t0, 16(a0)
    add t0, t0, a1
    sw t0, 16(a0)
    ret


# handle key press
# change direction player
change_dir:
    csrrci zero, ustatus, 1

    la s2, player
    li s3, 0xff200000
    # le  e checa tecla pressionada
    lw s4, 4(s3)
    li s5, 'w'
    beq s4, s5, w_
    li s5, 'k'
    beq s4, s5, w_
    li s5, 'a'
    beq s4, s5, a_
    li s5, 'h'
    beq s4, s5, a_
    li s5, 's'
    beq s4, s5, s_
    li s5, 'j'
    beq s4, s5, s_
    li s5, 'd'
    beq s4, s5, d_
    li s5, 'l'
    beq s4, s5, d_
    
    # muda direcao jogador
    w_:
    li s3, 0
    sw s3, 12(s2)
    j ep1

    a_:
    li s3, 1
    sw s3, 12(s2)
    j ep1

    s_:
    li s3, 2
    sw s3, 12(s2)
    j ep1

    d_:
    li s3, 3
    sw s3, 12(s2)



    ep1:
    csrrsi zero, ustatus, 0x10
    uret
