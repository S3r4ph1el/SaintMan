.data
.include "levels/placeholder_map.data"
.include "sprites/Zenon.data"

.eqv MMIO 0xff200000
.eqv FRAME_SELECTOR 0xff200604
.text 

    # render map both frames
    la a0, map
    li a1, 0
    call render
    li a1, 1
    call render
	
    main_loop:
    
		xori s0, s0, 1

        # render player
        la a0, player
        mv a1, s0
        call render
        
        li t0, FRAME_SELECTOR
		sw s0, 0(t0)


        # erase player
        la a0, player
        mv a1, s0
        xori a1, a1, 1
        call erase_sprite
        
        # sleep
        li a7, 32
        li a0, 40
        ecall

        # move player
        la a0, player
        li a1, 1 # 1 rars da erro, fpgrars funciona
        call move_sprite
        
        # check if key pressed and handle it
        call change_dir

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
	# t0 = endereco bitmap
	# t6 = endereco imagem
	li t0, 0xff0
	add t0, t0, a1
	slli t0, t0, 20
	mv t6, a0

    # checa tipo de sprite para renderizar
    lw t1, (a0)
    li t2, 4
    beq t1, t2, bg
    li t2, 12
    beq t1, t2, static
    li t2, 20
    beq t1, t2, moving

    # render background
    bg: 
        addi t6, t6, 4
        li t1, 0x12c00
        add t1, t1, t0

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
        lhu t1, 4(a0)
        lhu t2, 6(a0)
        mul t3, t1, t2
        
        # seleciona imagem certa
        lw t4, 8(a0)
        addi t6, t6, 20
        mul t3, t3, t4
        add t6, t6, t3
        
        # pega x e y
        lhu t3, 12(a0) # x
        lhu t4, 14(a0) # y
        
        # t4 = primeiro pixel
        li t5, 320
        mul t5, t5, t4
        add t5, t5, t3
        add t0, t0, t5

        # loop linha y
        li t3, 0
        l2:
            bge t3, t2, e2
        
            # loop coluna x
            li t4, 0
            l3:
                bge t4, t1, e3
                lw t5, (t6)
                sw t5, (t0)
                addi t6, t6, 4
                addi t0, t0, 4
                addi t4, t4, 4
                j l3
            e3:
            addi t0, t0, 320
            sub t0, t0, t1
            addi t3, t3, 1
            j l2
        e2:

        ret


# erase sprite
# args:
# a0 -> sprite image address
# a1 -> frame
# registradores usados:
# t0 - t6
erase_sprite:
    # get x e y
    lhu t0, 16(a0) # x
    lhu t1, 18(a0) # y

    # t0 = primeiro pixel bg
    # t1 = primeiro pixel bitmap
    li t4, 0xff0
    add t4, t4, a1
    slli t4, t4, 20
    la t2, map
    addi t2, t2, 4
    li t3, 320
    mul t3, t3, t1
    add t3, t3, t0
    add t0, t2, t3
    add t1, t4, t3

    # pega imagem e tamanho
    lhu t2, 4(a0) # colunas x
    lhu t3, 6(a0) # linhas y

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
# registradores usados:
# t0 - t6
move_sprite:
	# salva ultima posicao
	lw t0, 12(a0)
	sw t0, 16(a0)
	
	# inicializa registradores
	lhu t0, 12(a0) # x
	lhu t1, 14(a0) # y
	la t2, map
	addi t2, t2, 4 # word information beggining
	li t3, 320
	mul t3, t3, t1
	add t3, t3, t0
	add t2, t2, t3

	# checa direcao
    lw t3, 8(a0)
    li t4, 0
    beq t3, t4, w
    li t4, 1
    beq t3, t4, a
    li t4, 2
    beq t3, t4, s
    li t4, 3
    beq t3, t4, d

    w:    
    sub t1, t1, a1
   
    # checa se pode ir para cima
    
    # checa se fora do mapa
    bltz t1, ep2
    
    # checa se eh parede
    li t3, 320
    mul t3, t3, a1   
    sub t2, t2, t3
    lbu t3, 2(t2) # 2 colunas pixels transparentes
    li t4, 88
    beq t3, t4, ep2
    lbu t3, 13(t2) # 16 largura personagem # 2 colunas pixels transparentes
    beq t3, t4, ep2
   
    # change player position
    sh t1, 14(a0)
    j ep2

    a:
    sub t0, t0, a1
   
    # checa se pode ir para esquerda
    
    # checa se fora do mapa
    li t6 46
    ble t0, t6, ep2
    
    # checa se eh parede
    sub t2, t2, a1
    addi t2, t2, 1 # 1 coluna pixels transparentes
    lbu t3, (t2)
    li t4, 88
    beq t3, t4, ep2
    li t5, 320
    li t6, 15
    mul t5, t5, t6
    add t2, t2, t5
    lbu t3, (t2)
    beq t3, t4, ep2
   
    # change player position
    sh t0, 12(a0)
    j ep2

    s:
    add t1, t1, a1
   
    # checa se pode ir para baixo
    
    # checa se eh fora do mapa
    li t5 224 # 240 - 16
    bge t1, t5, ep2
    
    # checa se eh parede
    li t3, 320
    mul t3, t3, a1
    add t2, t2, t3
    li t5, 320
    li t6, 15
    mul t5, t5, t6
    add t2, t2, t5
    lbu t3, 2(t2) # 2 colunas pixels transparentes
    li t4, 88
    beq t3, t4, ep2
    lbu t3, 13(t2) # 2 colunas pixels transparentes
    beq t3, t4, ep2
   
    # change player position
    sh t1, 14(a0)
    j ep2

    d:
    add t0, t0, a1
   
    # checa se pode ir para direita
    
   	# checa se eh fora do mapa
    li t5 306 # 320 - 14
    bge t0, t5, ep2
    
    # checa se eh parede
    add t2, t2, a1
    addi t2, t2, 14 # 1 coluna de pixeis transparentes
    lbu t3, (t2)
    li t4, 88
    beq t3, t4, ep2
    li t5, 320
    li t6, 15
    mul t5, t5, t6
    add t2, t2, t5
    lbu t3, (t2)
    beq t3, t4, ep2
   
    # change player position
    sh t0, 12(a0)
    
    ep2:
    ret


# handle key press
# change direction player
# registradores usados:
# t0 - t3
change_dir:
	
	# checa se tecla pressionada
	li t0, MMIO
	lw t1, (t0)
	andi t1, t1, 1
	beqz t1, ep1 # se nao tiver retorna
	
	# le tecla pressionada
	lw t1, 4(t0)

    # muda direcao
    la t0, player
    li t2, 'w'
    beq t1, t2, w_
    li t2, 'k'
    beq t1, t2, w_
    li t2, 'a'
    beq t1, t2, a_
    li t2, 'h'
    beq t1, t2, a_
    li t2, 's'
    beq t1, t2, s_
    li t2, 'j'
    beq t1, t2, s_
    li t2, 'd'
    beq t1, t2, d_
    li t2, 'l'
    beq t1, t2, d_
    j ep1
    
    # muda direcao jogador
    w_:
    li t1, 0
    sw t1, 8(t0)
    j ep1

    a_:
    li t1, 1
    sw t1, 8(t0)
    j ep1

    s_:
    li t1, 2
    sw t1, 8(t0)
    j ep1

    d_:
    li t1, 3
    sw t1, 8(t0)

    ep1:
	ret
	
