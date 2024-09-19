.data
.include "../art/main_art/data/GameOver.data"
.include "../sprites/data/items/Eucharist.data"
.include "../sprites/data/items/Rosary.data"
.include "../art/main_art/data/LevelCompleteScreen.data"
.include "../sprites/data/items/Lives_1.data"
.include "../sprites/data/items/Lives_2.data"
.include "../sprites/data/items/Lives_3.data"
.include "../sprites/data/zenon/ZenonDead1.data"
.include "../sprites/data/zenon/ZenonDead2.data"
.include "../sprites/data/zenon/ZenonDead3.data"
.include "../sprites/data/saintzenon/SlashUp.data"
.include "../sprites/data/saintzenon/SlashDown.data"
.include "../sprites/data/saintzenon/SlashRight.data"
.include "../sprites/data/saintzenon/SlashLeft.data"

boost: .word 0
vidas: .word 3
frame_animacao: .word 0
pontos: .word 0

.eqv MMIO 0xff200000
.eqv FRAME_SELECTOR 0xff200604
.eqv FRAME0 0xff000000
.eqv FRAME1 0xff100000

.text
# funcao para cada nivel
# implementa logica do jogo
# args:
# salvar posicao personagens na memoria 8(player) = x 10(player) = y
# s2 -> quantidade de pontos no mapa
# s3 -> map
# s4 -> populated_map
# s5 -> collision_map
jogo:
  addi sp, sp, -4
  sw ra, (sp)

  li s0, 0 # frame variavel global
  la t0, pontos
  sw zero, (t0)

  call start_game_map

  # print player and enemies
  call render_all
 
  main_loop: 
    # move player
    la a0, player
    li a1, 1
    li a2, 0
    call move_sprite

    # move enemies
    call move_enemies  

    # print screen
    call render_all

    call check_collisions

    # sleep
    li a7, 32
    li a0, 20
    ecall

    # change enemies directions
    call change_dir_enemies

    # check if key pressed and handle it
    call change_dir
   
    # play music
    call PLAY
    j main_loop

  game_loop_exit:
  lw ra, (sp)
  addi sp, sp, 4
  ret


# change directions of all enemies
change_dir_enemies:
  addi sp, sp, -16
  sw ra, (sp)
  sw a0, 4(sp)
  sw a1, 8(sp)
  sw a2, 12(sp)

  la a0, blue
  li a1, 0
  li a2, 0
  call change_dir_enemy

  la a0, red
  li a1, 30
  call change_dir_enemy

  la a0, orange
  li a1, -30
  call change_dir_enemy

  la a0, purple
  li a1, 0
  li a2, 20
  call change_dir_enemy

  lw ra, (sp)
  lw a0, 4(sp)
  lw a1, 8(sp)
  lw a2, 12(sp)
  addi sp, sp, 16
  ret

# muda direcao inimigo
# args:
# a0 -> inimigo
# a1 -> offset x do player
# a2 -> offset y do player
change_dir_enemy:
  lw t0, 4(a0)
  li t1, 4
  blt t0, t1, ep15
    ret
  ep15:
  # inicializa registradores
  mv t2, s5
  lhu t0, 8(a0) # x
  lhu t1, 10(a0) # y
  li t3, 320
  mul t3, t3, t1
  add t3, t3, t0
  add t2, t2, t3 # t2 posicao no mapa

  li t5, -1 # direcao
  addi sp, sp, -12
  sw t5, 4(sp)
  sw t2, 8(sp)

  # checa se pode ir para cima
  addi t1, t1, -1
  lw t6, 4(a0)
  li t5, 2
  beq t6, t5 ep7
  bltz t1, ep7

  # checa se eh parede
  addi t2, t2, -320
  addi t2, t2, 2 # 2 colunas pixels transparentes
  lbu t3, (t2) 
  beqz t3, ep7
  addi t2, t2, 11 # 16 largura personagem # 2 colunas pixels transparentes
  lbu t3, (t2) 
  beqz t3, ep7
  addi t2, t2, -5 # meio personagem
  lbu t3, (t2) 
  beqz t3, ep7

  # calcula distancia
  la t3, player
  lhu t4, 8(t3)
  add t4, t4, a1
  lhu t3, 10(t3)
  add t3, t3, a2
  sub t4, t4, t0
  sub t3, t3, t1
  mul t4, t4, t4
  mul t3, t3, t3
  add t3, t3, t4
  sw t3, (sp)
  li t5, 0
  sw t5, 4(sp)

  ep7:

  # checa se pode ir para esquerda
  addi t1, t1, 1
  addi t0, t0, -1

  # checa se fora do mapa
  lw t6, 4(a0)
  li t5, 3
  beq t6, t5 ep8
  li t6, 46
  ble t0, t6, ep8

  # checa se eh parede
  lw t2, 8(sp)
  lbu t3, (t2)
  beqz t3, ep8
  li t5, 320
  li t6, 15
  mul t5, t5, t6
  add t2, t2, t5
  lbu t3, (t2)
  beqz t3, ep8
  li t5, 320
  li t6, 8 # meio personagem
  mul t5, t5, t6
  sub t2, t2, t5
  lbu t3, (t2)
  beqz t3, ep8

  # calcula discancia
  la t3, player
  lhu t4, 8(t3)
  add t4, t4, a1
  lhu t3, 10(t3)
  add t3, t3, a2
  sub t4, t4, t0
  sub t3, t3, t1
  mul t4, t4, t4
  mul t3, t3, t3
  add t3, t3, t4
  lw t5, 4(sp)
  bltz t5, ep12
    lw t6, (sp)
    bge t3, t6, ep8
      ep12:
      sw t3, (sp)
      li t5, 1
      sw t5, 4(sp)

  ep8:

  # checa se pode ir para baixo
  addi t1, t1, 1
  addi t0, t0, 1
  lw t6, 4(a0)
  li t5, 0
  beq t6, t5 ep9

  # checa se eh fora do mapa
  li t5 224 # 240 - 16
  bge t1, t5, ep9

  # checa se eh parede
  lw t2, 8(sp)
  addi t2, t2, 320
  li t5, 320
  li t6, 15
  mul t5, t5, t6
  add t2, t2, t5
  addi t2, t2, 2 # 2 colunas pixels transparentes
  lbu t3, (t2) 
  beqz t3, ep9
  addi t2, t2, 11 # 2 colunas pixels transparentes
  lbu t3, (t2)
  beqz t3, ep9
  addi t2, t2, -5 # meio personagem
  lbu t3, (t2) 
  beqz t3, ep9


  # calcula discancia
  la t3, player
  lhu t4, 8(t3)
  add t4, t4, a1
  lhu t3, 10(t3)
  add t3, t3, a2
  sub t4, t4, t0
  sub t3, t3, t1
  mul t4, t4, t4
  mul t3, t3, t3
  add t3, t3, t4
  lw t5, 4(sp)
  bltz t5, ep13
    lw t6, (sp)
    bge t3, t6, ep9
      ep13:
      sw t3, (sp)
      li t5, 2
      sw t5, 4(sp)

  ep9:
  # checa se pode ir para direita
  addi t1, t1, -1
  addi t0, t0, 1
  lw t6, 4(a0)
  li t5, 1
  beq t6, t5 ep10

  # checa se eh fora do mapa
  li t5 306 # 320 - 14
  bge t0, t5, ep10

  # checa se eh parede
  lw t2, 8(sp)
  addi t2, t2, 15 # 1 coluna de pixeis transparentes
  lbu t3, (t2)
  beqz t3, ep10
  li t5, 320
  li t6, 15
  mul t5, t5, t6
  add t2, t2, t5
  lbu t3, (t2)
  beqz t3, ep10
  li t5, 320
  li t6, 8 # meio personagem
  mul t5, t5, t6
  sub t2, t2, t5
  lbu t3, (t2)
  beqz t3, ep10

  # calcula discancia
  la t3, player
  lhu t4, 8(t3)
  add t4, t4, a1
  lhu t3, 10(t3)
  add t3, t3, a2
  sub t4, t4, t0
  sub t3, t3, t1
  mul t4, t4, t4
  mul t3, t3, t3
  add t3, t3, t4
  lw t5, 4(sp)
  bltz t5, ep14
    lw t6, (sp)
    bge t3, t6, ep10
      ep14:
      sw t3, (sp)
      li t5, 3
      sw t5, 4(sp)
  ep10:

  lw t5 4(sp) 
  addi sp, sp, 12
  bltz t5, ep11
    la t0, boost
    lw t0, (t0)
    beqz t0, ep21
      addi t5, t5, 2
      li t4, 4
      remu t5, t5, t4
    ep21:
    sw t5, 4(a0)
  ep11:

  ret


# move all enemies
move_enemies:
  addi sp, sp, -16
  sw ra, (sp)
  sw a0, 4(sp)
  sw a1, 8(sp)
  sw a2, 12(sp)

  la a0, blue
  li a1, 1
  li a2, 1
  call move_sprite

  la a0, red
  call move_sprite

  la a0, orange
  call move_sprite

  la a0, purple
  call move_sprite
  

  lw ra, (sp)
  lw a0, 4(sp)
  lw a1, 8(sp)
  lw a2, 12(sp)
  addi sp, sp, 16
  ret

# check collision with all enemies
check_collisions:
  addi sp, sp, -8
  sw ra, (sp)
  sw a0, 4(sp)

  la a0, blue
  call check_collision

  la a0, red
  call check_collision

  la a0, orange
  call check_collision

  la a0, purple
  call check_collision

  lw ra, (sp)
  lw a0, 4(sp)
  addi sp, sp, 8
  
  ret

# checa colisao do jogador com um inimigo
# sai do programa se tiver colisao
# args:
# a0 -> enemy to check collision with
check_collision:
  lw t0, 4(a0)
  li t1, 4
  blt t0, t1, ep16
    ret
  ep16:

  la t0, player
  mv t1, a0

  lhu t2, 8(t0)
  lhu t3, 8(t1)
  li t4, 12
  add t4, t4, t2
  bge t4, t3, ep3
    ret
  ep3:
  li t4, -12
  add t4, t4, t2
  ble t4, t3, ep4
    ret
  ep4:
  lhu t2, 10(t0)
  lhu t3, 10(t1)
  li t4, 14 # nao tenho idea do pq 14 nao 15, assim funciona
  add t4, t4, t2
  bge t4, t3, ep5
    ret
  ep5:
  li t4, -14
  add t4, t4, t2
  ble t4, t3, ep6
    ret
  ep6:
  
  # checa se player em boost 
  la t0, boost
  lw t1, (t0)
  bnez t1, slash_enemy
    
    addi sp, sp, -32
    sw ra, (sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    sw a3, 16(sp)
    sw a4, 20(sp)
    sw a5, 24(sp)
    sw a7, 28(sp)
    # anima morte player
    mv a0, s4
    
    mv a1, s0
    slli a1, a1, 20
    li t1, FRAME0
    add a1, a1, t1
    
    la t0, player
    lhu a4, (t0)
    lhu a5, 2(t0)
    lhu a2, 8(t0)
    lhu a3, 10(t0)
    
    call erase

    la a0, dead1
    mv a1, s0
    lw a4, (a0)
    lw a5, 4(a0)
    addi a0, a0, 8
    
    call render
    
    li a7, 32
    li a0, 80
    ecall

    mv a0, s4
    mv a1, s0
    slli a1, a1, 20
    li t1, FRAME0
    add a1, a1, t1
    li a4, 17
    li a5, 17 # hardcoded
    call erase

    la a0, dead2
    mv a1, s0
    lw a4, (a0)
    lw a5, 4(a0)
    addi a0, a0, 8
    
    call render

    li a7, 32
    li a0, 80
    ecall
    
    mv a0, s4
    mv a1, s0
    slli a1, a1, 20
    li t1, FRAME0
    add a1, a1, t1
    li a4, 14
    li a5, 21 # hardcoded
    call erase

    la a0, dead3
    mv a1, s0
    lw a4, (a0)
    lw a5, 4(a0)
    addi a0, a0, 8
    
    call render

    li a7, 32
    li a0, 100
    ecall

    lw ra, (sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    lw a3, 16(sp)
    lw a4, 20(sp)
    lw a5, 24(sp)
    lw a7, 28(sp)
    addi sp, sp, 32
    # diminui vidas
    la t0, vidas 
    lw t1, (t0)
    addi t1, t1, -1
    sw t1, (t0)

    blez t1, show_game_over 
    
    addi sp, sp, -24
    sw ra, (sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    sw a3, 16(sp)
    sw a7, 20(sp)
    
    call DEATHSETUP
    DEATHLOOP:
    call DEATHPLAY
    blt s10, s9, DEATHLOOP
    li a7, 32
    li a0, 1800
    ecall 

    call start_game_map
    
    call set_phase1
    lw ra, (sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    lw a3, 16(sp)
    lw a7, 20(sp)
    addi sp, sp, 24

    j ep18

  # mata inimigo
  slash_enemy:
    addi sp, sp, -32
    sw a5, 28(sp)
    sw a4, 24(sp)
    sw a0, 20(sp)
    sw a1, 16(sp)
    sw a2, 12(sp)
    sw a3, 8(sp)
    sw a7, 4(sp)
    sw ra, (sp)
    call SLASH           # efeito sonoro de matar inimigos
    
  
    # aumenta score
    addi s1, s1, 10
    call print_score
    call UPDATE_HIGHSCORE

    # erase player  
    mv a0, s4
    
    mv a1, s0
    slli a1, a1, 20
    li t1, FRAME0
    add a1, a1, t1
    
    la t0, player
    lhu a4, (t0)
    lhu a5, 2(t0)
    lhu a2, 8(t0)
    lhu a3, 10(t0)
    
    call erase

    # printa slash
    mv a1, s0
    la t0, player
    lhu a2, 8(t0) # x 
    lhu a3, 10(t0) # y
    lhu t3, 4(t0) # direcao
  
    li t4, 1
    beq t3, t4, slash_a
    li t4, 2
    beq t3, t4, slash_s
    li t4, 3
    beq t3, t4, slash_d
    
    slash_w:
      la a0, slash_up
      j ep22

    slash_a:
      la a0, slash_left
      j ep22

    slash_s:
      la a0, slash_down
      j ep22

    slash_d:
      la a0, slash_right

    ep22:

    lw a4, (a0)
    lw a5, 4(a0)
    addi sp, sp, -8
    sw a4, (sp)
    sw a5, 4(sp)
    addi a0, a0, 8
    call render

    li a7, 32
    li a0, 300
    ecall

    # erase slash
    mv a0, s4
    mv a1, s0
    slli a1, a1, 20
    li t1, FRAME0
    add a1, a1, t1

    la t0, player
    lhu a2, 8(t0)
    lhu a3, 10(t0)

    lw a4, (sp)
    lw a5, 4(sp)
    addi sp, sp 8
    call erase

    lw a5, 28(sp)
    lw a4, 24(sp)
    lw a0, 20(sp)
    lw a1, 16(sp)
    lw a2, 12(sp)
    lw a3, 8(sp)
    lw a7, 4(sp)
    lw ra, (sp)
    addi sp, sp, 32

    # representa inimigo morto
    li t0, 4
    sw t0, 4(a0) 
  ep18:
  ret

# mostra tela de game over
show_game_over:
    addi sp, sp, 12 # sai jogo, limpa sp
    
    # reseta pontuacao
    li s1, 0
    
    mv a0, s4
    mv a1, s0
    slli a1, a1, 20
    li t1, FRAME0
    add a1, a1, t1
    li a2, 10
    li a3, 156
    li a4, 29 # hardcoded
    li a5, 8
    call erase

    la a0, GameOver         # verificar bug da imagem de gameover
    mv a1, s0
    li a4, 0
    call render

    call reset_maps

    li t1, MMIO
    call GAMEOVERSETUP
    GAMEOVERLOOP:
      lw t0,0(t1)
      andi t0,t0,0x0001
      call GAMEOVERPLAY
      beq t0,zero, GAMEOVERLOOP
      lw t2,4(t1)
      li t3, '1'
      beq t2, t3, START_MAIN
      li t3, '2'
      beq t2, t3, main_exit
      li t3, 'x'
      beq t2, t3, PHASE1
      li t3, 'y'
      beq t2, t3, PHASE2
      li t3, 'z'
      beq t2, t3, PHASE3
      li t3, 'e'
		  beq t2, t3, ENDGAME
      li t3, 'l'
		  beq t2, t3, LEVEL_COMPLETE
      j GAMEOVERLOOP


# renders all sprites, players and enemies
render_all:
  # printa jogador
  addi sp, sp, -28
  sw ra, (sp)
  sw a0, 4(sp)
  sw a1, 8(sp)
  sw a2, 12(sp)
  sw a3, 16(sp)
  sw a4, 20(sp)
  sw a5, 24(sp)


  xori s0, s0, 1
  la a0, player
  mv a1, s0
  call render_sprite

  la a0, blue
  call render_sprite

  la a0, red
  call render_sprite

  la a0, orange
  call render_sprite

  la a0, purple
  call render_sprite

  la t4, frame_animacao
  lw t3, (t4)

  addi t3, t3, 1
  li t0, 15
  remu t3, t3, t0
  sw t3, (t4)


  li t0, FRAME_SELECTOR
  sw s0, 0(t0)
  
  la t0, player
  lhu t3, (t0)
  lhu t4, 2(a0)
  mv a0, s3
  mv a1, s0
  xori a1, a1, 1
  slli a1, a1, 20
  li t1, FRAME0
  add a1, a1, t1
  lhu a2, 12(t0)
  lhu a3, 14(t0)
  mv a4, t3
  mv a5, t4
  call erase

  la t0, blue
  lhu t3, (t0)
  lhu t4, 2(t0)
  mv a0, s4
  mv a1, s0
  xori a1, a1, 1
  slli a1, a1, 20
  li t1, FRAME0
  add a1, a1, t1
  lhu a2, 12(t0)
  lhu a3, 14(t0)
  mv a4, t3
  mv a5, t4
  call erase

  la t0, red
  lhu t3, (t0)
  lhu t4, 2(t0)
  mv a0, s4
  mv a1, s0
  xori a1, a1, 1
  slli a1, a1, 20
  li t1, FRAME0
  add a1, a1, t1
  lhu a2, 12(t0)
  lhu a3, 14(t0)
  mv a4, t3
  mv a5, t4
  call erase

  la t0, orange
  lhu t3, (t0)
  lhu t4, 2(t0)
  mv a0, s4
  mv a1, s0
  xori a1, a1, 1
  slli a1, a1, 20
  li t1, FRAME0
  add a1, a1, t1
  lhu a2, 12(t0)
  lhu a3, 14(t0)
  mv a4, t3
  mv a5, t4
  call erase

  la t0, purple
  lhu t3, (t0)
  lhu t4, 2(t0)
  mv a0, s4
  mv a1, s0
  xori a1, a1, 1
  slli a1, a1, 20
  li t1, FRAME0
  add a1, a1, t1
  lhu a2, 12(t0)
  lhu a3, 14(t0)
  mv a4, t3
  mv a5, t4

  call erase
  lw ra, (sp)
  lw a0, 4(sp)
  lw a1, 8(sp)
  lw a2, 12(sp)
  lw a3, 16(sp)
  lw a4, 20(sp)
  lw a5, 24(sp)
  addi sp, sp, 28

  ret


# render image in bitmap
# args:
# a0 -> endereco imagem
# a1 -> frame
# a2 -> x
# a3 -> y
# a4 -> largura | 0 print toda tela
# a5 -> altura
render:
  # t0 = endereco bitmap
  # t6 = endereco imagem
  li t0, 0xff0
  add t0, t0, a1
  slli t0, t0, 20
  mv t6, a0

  bnez a4, notbg
    # render background
    li t1, 0x12c00
      add t1, t1, t0
      l4:
        beq t0, t1, e4
        lb t2, (t6)
        sb t2, (t0)
        addi t0, t0, 1
        addi t6, t6, 1
        j l4
      e4:
      ret
  notbg:
    # t0 = primeiro pixel
    li t5, 320
    mul t5, t5, a3
    add t5, t5, a2
    add t0, t0, t5

    # loop linha y
    li t3, 0
    l2:
      bge t3, a5, e2

      # loop coluna x
      li t4, 0
      l3:
        bge t4, a4, e3
        lb t5, (t6)
        sb t5, (t0)
        addi t6, t6, 1
        addi t0, t0, 1
        addi t4, t4, 1
        j l3
      e3:
      addi t0, t0, 320
      sub t0, t0, a4
      addi t3, t3, 1
      j l2
    e2:
    ret

# render moving sprite
# a0 -> sprite image address
# a1 -> frame
render_sprite:
  addi sp, sp, -28
  sw a0, 24(sp)
  sw a1, 20(sp)
  sw a2, 16(sp)
  sw a3, 12(sp)
  sw a4, 8(sp)
  sw a5, 4(sp)
  sw ra, (sp)
  
  lhu a2, 8(a0) # x
  lhu a3, 10(a0) # y
  lhu a4, (a0) # largura
  lhu a5, 2(a0) # altura
  
  # seleciona imagem certa
  lw t1, 4(a0)
  li t2, 4
  bge t1, t2, ep17
    li t2, 3
    mul t0, t1, t2
    la t4, frame_animacao
    lw t3, (t4)
    li t5, 5
    divu t3, t3, t5
    
    add t0, t0, t3
    mul t1, a4, a5
    mul t0, t0, t1
    addi a0, a0, 16
    add a0, a0, t0

    call render

  ep17:
  lw a0, 24(sp)
  lw a1, 20(sp)
  lw a2, 16(sp)
  lw a3, 12(sp)
  lw a4, 8(sp)
  lw a5, 4(sp)
  lw ra, (sp)
  addi sp, sp, 28
  
  ret
  
# erase sprite
# args:
# a0 -> imagem para substituir (map)
# a1 -> endereco onde apagar
# a2 -> x
# a3 -> y
# a4 -> largura
# a5 -> altura
erase:
  # t0 = primeiro pixel bg
  # t1 = primeiro pixel apagar(bitmap)
  li t3, 320
  mul t3, t3, a3
  add t3, t3, a2
  add t0, a0, t3
  add t1, a1, t3

  # loop linha y
  li t4, 0
  l7:
    bge t4, a5, e7
    # loop coluna x
    li t5, 0
    l8:
      bge t5, a4, e8
      lb t6, (t0)
      sb t6, (t1)
      addi t0, t0, 1
      addi t1, t1, 1
      addi t5, t5, 1
      j l8
    e8:
    addi t0, t0, 320
    sub t0, t0, a4
    addi t1, t1, 320
    sub t1, t1, a4
    addi t4, t4, 1
    j l7
  e7:
  ret


# move sprite
# checa se o sprite pode se mover e colisoes
# se sim, muda sua posicao na memoria
# a0 -> sprite address
# a1 -> pixels to move, velocity
# a2 -> enemy? 1 = enemy
move_sprite:
  # inicializa registradores
  lhu t0, 8(a0) # x
  lhu t1, 10(a0) # y
  mv t2, s5
  li t3, 320
  mul t3, t3, t1
  add t3, t3, t0
  add t2, t2, t3 # t2 posicao no mapa
  
  # salva ultima posicao
  sh t0, 12(a0)
  sh t1, 14(a0)
  
  # checa direcao
  lw t3, 4(a0)
  li t4, 0
  beq t3, t4, w
  li t4, 1
  beq t3, t4, a
  li t4, 2
  beq t3, t4, s
  li t4, 3
  beq t3, t4, d
  ret

  w:    
    sub t1, t1, a1

    # checa se pode ir para cima
  
    # checa se fora do mapa
    bltz t1, ep2
    
    # checa se eh parede
    li t3, 320
    mul t3, t3, a1   
    sub t2, t2, t3
    addi t2, t2, 2 # 2 colunas pixels transparentes
    mv t4, t2
    lbu t3, (t2) 
    beqz t3, ep2
    addi t2, t2, 11 # 16 largura personagem # 2 colunas pixels transparentes
    lbu t3, (t2) 
    beqz t3, ep2
    addi t2, t2, -5 # meio personagem
    lbu t3, (t2) 
    beqz t3, ep2

    # change player position
    sh t1, 10(a0)

    bnez a2, ep2
      # checa se ponto
      mv t2, t4
      li t4, 63
      lbu t3, (t2)
      beq t3, t4, if_ponto
      li t4, 31
      beq t3, t4, if_boost
      li t4, 63
      addi t2, t2, 11 # 16 largura personagem # 2 colunas pixels transparentes
      lbu t3, (t2) 
      beq t3, t4, if_ponto
      li t4, 31
      beq t3, t4, if_boost
      li t4, 63
      addi t2, t2, -5 # meio personagem
      lbu t3, (t2)
      beq t3, t4, if_ponto
      li t4, 31
      beq t3, t4, if_boost

    j ep2

  a:
    # testa tunel
    li t3, 48
    bne t3, t0, ep19
    
      # teleporta jogador
      li t3, 304
      sh t3, 8(a0)

      # testa se tem ponto gambiarra
      bnez a2, ep2
        mv t2, s5
        li t3, 320
        li t1, 116
        mul t3, t3, t1
        add t2, t2, t3
        li t1, 308
        add t2, t2, t1

        lbu t3, (t2)
        li t4, 63 
        beq t3,t4, if_ponto 

        
        j ep2

    ep19:
    sub t0, t0, a1
   
    # checa se pode ir para esquerda

    # checa se fora do mapa
    li t6, 46
    ble t0, t6, ep2

    # checa se eh parede
    sub t2, t2, a1
    addi t2, t2, 1 # 1 coluna pixels transparentes
    mv t4, t2
    lbu t3, (t2)
    beqz t3, ep2
    li t5, 320
    li t6, 15
    mul t5, t5, t6
    add t2, t2, t5
    lbu t3, (t2)
    beqz t3, ep2
    li t5, 320
    li t6, 8 # meio personagem
    mul t5, t5, t6
    sub t2, t2, t5
    lbu t3, (t2)
    beqz t3, ep2

    # change player position
    sh t0, 8(a0)

    bnez a2, ep2
      # checa se ponto
      mv t2, t4
      lbu t3, (t2)
      li t4, 63
      beq t3, t4, if_ponto
      li t4, 31
      beq t3, t4, if_boost
      li t4, 63
      li t5, 320
      li t6, 15
      mul t5, t5, t6
      add t2, t2, t5
      lbu t3, (t2)
      beq t3, t4, if_ponto
      li t4, 31
      beq t3, t4, if_boost
      li t4, 63
      li t5, 320
      li t6, 8 # meio personagem
      mul t5, t5, t6
      sub t2, t2, t5
      lbu t3, (t2)
      beq t3, t4, if_ponto
      li t4, 31
      beq t3, t4, if_boost

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
    addi t2, t2, 2 # 2 colunas pixels transparentes
    mv t4, t2
    lbu t3, (t2) 
    beqz t3, ep2
    addi t2, t2, 11 # 2 colunas pixels transparentes
    lbu t3, (t2)
    beqz t3, ep2
    addi t2, t2, -5 # meio personagem
    lbu t3, (t2) 
    beqz t3, ep2

    # change player position
    sh t1, 10(a0)

    bnez a2, ep2
      # checa se ponto
      mv t2, t4
      li t4, 63
      lbu t3, (t2)
      beq t3, t4, if_ponto
      li t4, 31
      beq t3, t4, if_boost
      li t4, 63
      addi t2, t2, 11 # 2 colunas pixels transparentes
      lbu t3, (t2)
      beq t3, t4, if_ponto
      li t4, 31
      beq t3, t4, if_boost
      li t4, 63
      addi t2, t2, -5 # meio personagem
      lbu t3, (t2)
      beq t3, t4, if_ponto
      li t4, 31
      beq t3, t4, if_boost

      j ep2

  d:
    # testa tunel
    li t3, 304
    bne t3, t0, ep20
    
      # teleporta jogador
      li t3, 48
      sh t3, 8(a0)

      # testa se tem ponto gambiarra
      bnez a2, ep2
        mv t2, s5
        li t3, 320
        li t1, 116
        mul t3, t3, t1
        add t2, t2, t3
        li t1, 52
        add t2, t2, t1
      
        lbu t3, (t2)
        li t4, 63 
        beq t3,t4, if_ponto 

        
        j ep2

    ep20:
    add t0, t0, a1

    # checa se pode ir para direita

     # checa se eh fora do mapa
    li t5 306 # 320 - 14
    bge t0, t5, ep2

    # checa se eh parede
    add t2, t2, a1
    addi t2, t2, 14 # 1 coluna de pixeis transparentes
    mv t4, t2
    lbu t3, (t2)
    beqz t3, ep2
    li t5, 320
    li t6, 15
    mul t5, t5, t6
    add t2, t2, t5
    lbu t3, (t2)
    beqz t3, ep2
    li t5, 320
    li t6, 8 # meio personagem
    mul t5, t5, t6
    sub t2, t2, t5
    lbu t3, (t2)
    beqz t3, ep2

    # change player position
    sh t0, 8(a0)

    bnez a2, ep2
      # checa se ponto
      mv t2, t4
      li t4, 63
      lbu t3, (t2)
      beq t3, t4, if_ponto
      li t4, 31
      beq t3, t4, if_boost
      li t4, 63
      li t5, 320
      li t6, 15
      mul t5, t5, t6
      add t2, t2, t5
      lbu t3, (t2)
      beq t3, t4, if_ponto
      li t4, 31
      beq t3, t4, if_boost
      li t4, 63
      li t5, 320
      li t6, 8 # meio personagem
      mul t5, t5, t6
      sub t2, t2, t5
      lbu t3, (t2)
      beq t3, t4, if_ponto
      li t4, 31
      beq t3, t4, if_boost

      j ep2

  if_ponto:
    addi sp, sp, -24
    sw a0, 20(sp)
    sw a1, 16(sp)
    sw a2, 12(sp)
    sw a3, 8(sp)
    sw a7, 4(sp)
    sw ra, (sp)
    call COIN            # efeito sonoro da pontuação
    lw a0, 20(sp)
    lw a1, 16(sp)
    lw a2, 12(sp)
    lw a3, 8(sp)
    lw a7, 4(sp)
    lw ra, (sp)
    addi sp, sp, 24

    # find posicao inicio imagem t0 = x t1 = y 
    li t4, 63
    l9:
      addi t2, t2, -1
      lbu t3, (t2)
      bne t3, t4, e9
      j l9
    e9:
    addi t2, t2, 1
    l10:
      addi t2, t2, -320
      lbu t3(t2)
      bne t3, t4, e10
      j l10
    e10:
    addi t2, t2, 320
    mv t3, s5
    sub t5, t2, t3
    li t4, 320
    remu t0, t5, t4
    divu t1, t5, t4

    # apaga sprite do bitmap
    addi sp, sp, -36
    sw ra, 32(sp)
    sw t0, 28(sp)
    sw t1, 24(sp)
    sw a0, 20(sp)
    sw a1, 16(sp)
    sw a2, 12(sp)
    sw a3, 8(sp)
    sw a4, 4(sp)
    sw a5, (sp)

    mv a0, s3
    li a1, FRAME0
    mv a2, t0
    mv a3, t1
    la t2, rosary
    lhu a4, (t2)
    lhu a5, 2(t2)
    call erase

    li a1, FRAME1
    call erase

    mv a1, s4
    call erase

    lw ra, 32(sp)
    lw t0, 28(sp)
    lw t1, 24(sp)
    lw a0, 20(sp)
    lw a1, 16(sp)
    lw a2, 12(sp)
    lw a3, 8(sp)
    lw a4, 4(sp)
    lw a5, (sp)
    addi sp, sp, 36

    # apaga do mapa de colisoes
    addi sp, sp, -24
    sw a0, (sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw ra, 20(sp)

    la t2, rosary
    lhu a0, (t2) 
    lhu a1, 2(t2)
    mv a2, t0
    mv a3, t1
    call erase_collision

    lw a0, (sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24

    # print score
    addi sp, sp, -20
    sw ra, (sp)
    sw a7, 4(sp)
    sw a0, 8(sp)
    sw a1, 12(sp)
    sw a2, 16(sp)

    addi s1, s1, 1
    
    call print_score
    call UPDATE_HIGHSCORE
    lw ra, (sp)
    lw a7, 4(sp)
    lw a0, 8(sp)
    lw a1, 12(sp)
    lw a2, 16(sp)
    addi sp, sp, 20

    la t0, pontos
    lw t1, (t0)
    addi t1, t1, 1
    sw t1, (t0)
    beq t1, s2, LEVEL_COMPLETE

    j ep2

  if_boost:
    la t0, boost
    li t1, 1
    sw t1, (t0)

    addi sp, sp, -28
    sw, t2, 24(sp)
    sw a0, 20(sp)
    sw a1, 16(sp)
    sw a2, 12(sp)
    sw a3, 8(sp)
    sw a7, 4(sp)
    sw ra, (sp)

    la a0, player
    la a1, saint
    call change_sprite   # change to saint image

    la a0, blue
    la a1, scared
    call change_sprite   # change to saint image
    la a0, red
    la a1, scared
    call change_sprite   # change to saint image
    la a0, orange
    la a1, scared
    call change_sprite   # change to saint image
    la a0, purple
    la a1, scared
    call change_sprite   # change to saint image
    

    call SETUP5          # efeito sonoro da pontuação
    lw, t2, 24(sp)
    lw a0, 20(sp)
    lw a1, 16(sp)
    lw a2, 12(sp)
    lw a3, 8(sp)
    lw a7, 4(sp)
    lw ra, (sp)
    addi sp, sp, 28

    # find posicao inicio imagem t0 = x t1 = y 
    li t4, 31
    el9:
      addi t2, t2, -1
      lbu t3, (t2)
      bne t3, t4, ee9
      j el9
    ee9:
    addi t2, t2, 1
    el10:
      addi t2, t2, -320
      lbu t3(t2)
      bne t3, t4, ee10
      j el10
    ee10:
    addi t2, t2, 320
    mv t3, s5
    sub t5, t2, t3
    li t4, 320
    remu t0, t5, t4
    divu t1, t5, t4

    # apaga sprite do bitmap
    addi sp, sp, -36
    sw ra, 32(sp)
    sw t0, 28(sp)
    sw t1, 24(sp)
    sw a0, 20(sp)
    sw a1, 16(sp)
    sw a2, 12(sp)
    sw a3, 8(sp)
    sw a4, 4(sp)
    sw a5, (sp)

    mv a0, s3
    li a1, FRAME0
    mv a2, t0
    mv a3, t1
    la t2, eucharist
    lhu a4, (t2)
    lhu a5, 2(t2)
    call erase

    li a1, FRAME1
    call erase

    mv a1, s4
    call erase

    lw ra, 32(sp)
    lw t0, 28(sp)
    lw t1, 24(sp)
    lw a0, 20(sp)
    lw a1, 16(sp)
    lw a2, 12(sp)
    lw a3, 8(sp)
    lw a4, 4(sp)
    lw a5, (sp)
    addi sp, sp, 36

    # apaga do mapa de colisoes
    addi sp, sp, -24
    sw a0, (sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw ra, 20(sp)

    la t2, eucharist
    lhu a0, (t2) 
    lhu a1, 2(t2)
    mv a2, t0
    mv a3, t1
    call erase_collision

    lw a0, (sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24

  ep2:
  ret

LEVEL_COMPLETE:
  la a0, LevelCompleteScreen # Chama tela de LevelComplete
  li a4, 0
  mv a1, s0
  call render
  
  la t0, vidas
  lw t1, (t0)
  li t2, 20
  mul t1, t2, t1
  add s1, s1, t1

  call SETUP6
  PHASE_LOOP:
    call PLAY6
    blt s10, s9, PHASE_LOOP
  li a7, 32
  li a0, 2000
  ecall
  j game_loop_exit

# handle key press
# change direction player
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
  li t2, 'W'
  beq t1, t2, w_
  li t2, 'K'
  beq t1, t2, w_
  li t2, 'A'
  beq t1, t2, a_
  li t2, 'H'
  beq t1, t2, a_
  li t2, 'S'
  beq t1, t2, s_
  li t2, 'J'
  beq t1, t2, s_
  li t2, 'D'
  beq t1, t2, d_
  li t2, 'L'
  beq t1, t2, d_
  j ep1

  # muda direcao jogador
  w_:
    li t1, 0
    sw t1, 4(t0)
    j ep1

  a_:
    li t1, 1
    sw t1, 4(t0)
    j ep1

  s_:
    li t1, 2
    sw t1, 4(t0)
    j ep1

  d_:
    li t1, 3
    sw t1, 4(t0)

  ep1:
  ret

# printa score atual nos dois frames
print_score:
  addi sp, sp, -32
  sw a0, (sp)
  sw a1, 4(sp)
  sw a2, 8(sp)
  sw a3, 12(sp)
  sw a4, 16(sp)
  sw a5, 20(sp)
  sw a7, 24(sp)
  sw ra, 28(sp)

  mv a0, s3
  li a1, FRAME0
  li a2, 0
  li a3, 60
  li a4, 47
  li a5, 16
  call erase
  li a1, FRAME1
  call erase

  li t4, 100
  bge s1, t4, maior_100
  li t4, 10
  bge s1, t4, maior_10

  li a7, 101
  mv a0, s1
  li a1, 20
  li a2, 65
  li a3, 0xc7ff
  li a4, 0
  ecall
 
  li a7, 101
  mv a0, s1
  li a1, 20
  li a2, 65
  li a3, 0xc7ff
  li a4, 1
  ecall
  j ep24

  maior_10:
  li a7, 101
  mv a0, s1
  li a1, 16
  li a2, 65
  li a3, 0xc7ff
  li a4, 0
  ecall
 
  li a7, 101
  mv a0, s1
  li a1, 16
  li a2, 65
  li a3, 0xc7ff
  li a4, 1
  ecall
  j ep24
  
  maior_100:
  li a7, 101
  mv a0, s1
  li a1, 12
  li a2, 65
  li a3, 0xc7ff
  li a4, 0
  ecall
 
  li a7, 101
  mv a0, s1
  li a1, 12
  li a2, 65
  li a3, 0xc7ff
  li a4, 1
  ecall
  
  ep24:
  lw a0, (sp)
  lw a1, 4(sp)
  lw a2, 8(sp)
  lw a3, 12(sp)
  lw a4, 16(sp)
  lw a5, 20(sp)
  lw a7, 24(sp)
  lw ra, 28(sp)
  addi sp, sp, 32

  ret

# erase collision from map
# a0 -> largura
# a1 -> altura
# a2 -> x
# a3 -> y
erase_collision:
  mv t0, s5

  # first pixel t0
  li t1, 320
  mul t1, t1, a3
  add t1, t1, a2
  add t0, t0, t1

  # loop linha y
  li t1, 0
  l13:
    bge t1, a1, e13
    li t2, 0
    l14:
      bge t2, a0, e14
      li t3, 0xff
      sb t3, (t0)
      addi t0, t0, 1

      addi t2, t2, 1
      j l14
    e14:
    addi t0, t0, 320
    sub t0, t0, a0

    addi t1, t1, 1
    j l13
  e13:

  ret

# reseta para os mapas originais
reset_maps:
  addi sp, sp, -12
  sw ra, (sp)
  sw a0, 4(sp)
  sw a1, 8(sp)

  la a0, populated_map1_orig
  la a1, populated_map1
  call reset_map

  la a0, populated_map2_orig
  la a1, populated_map2
  call reset_map

  la a0, populated_map3_orig
  la a1, populated_map3
  call reset_map

  lw ra, (sp)
  lw a0, 4(sp)
  lw a1, 8(sp)
  addi sp, sp, 12
  ret


# copia mapa original para memoria do mapa usado
# args:
# a0 -> mapa para copiar
# a1 -> mapa para colar
reset_map:
  mv t3, a0
  mv t4, a1

  li t0, 153600 # 320 * 240 * 2
  li t1, 0

  l11:
    lw t2, (t3)
    sw t2, (t4)
    addi t3, t3, 4
    addi t4, t4, 4
    addi t1, t1, 4
    blt t1, t0, l11

  ret

# copia imagens sprite para .data de sprite
# salva na outra imagem, para depois trocar de volta
# args:
# a0 -> imagens para substituir, sprite, com posicoes
# a1 -> imagens para colar
change_sprite:
  mv t0, a0
  mv t1, a1
  addi t0, t0, 16

  li t2, 3072 # 16 * 16 * 3 * 4
  l15:
    lw t3, (t1)
    sw t3, (t0)
    addi t0, t0, 4
    addi t1, t1, 4
    addi t2, t2, -4
    bgtz t2, l15
  ret


# printa high_score no hud
print_high_score:
  addi sp, sp, -32
  sw a0, (sp)
  sw a1, 4(sp)
  sw a2, 8(sp)
  sw a3, 12(sp)
  sw a4, 16(sp)
  sw a5, 20(sp)
  sw a7, 24(sp)
  sw ra, 28(sp)

  
  mv a0, s3
  li a1, FRAME0
  li a2, 0
  li a3, 105
  li a4, 47
  li a5, 16
  call erase
  li a1, FRAME1
  call erase

  li t4, 100
  lw t0, HIGHSCORE
  bge t0, t4, maior_100_
  li t4, 10
  bge t0, t4, maior_10_

  li a7, 101
  la t0, HIGHSCORE
  lw a0, 0(t0)
  li a1, 20
  li a2, 107
  li a3, 0xc7ff
  li a4, 0
  ecall
 
  li a7, 101
  la t0, HIGHSCORE
  lw a0, 0(t0)
  li a1, 20
  li a2, 107
  li a3, 0xc7ff
  li a4, 1
  ecall
  j ep30

  maior_10_:
  li a7, 101
  la t0, HIGHSCORE
  lw a0, 0(t0)
  li a1, 16
  li a2, 107
  li a3, 0xc7ff
  li a4, 0
  ecall
 
  li a7, 101
  la t0, HIGHSCORE
  lw a0, 0(t0)
  li a1, 16
  li a2, 107
  li a3, 0xc7ff
  li a4, 1
  ecall
  j ep30
  
  maior_100_:
  li a7, 101
  la t0, HIGHSCORE
  lw a0, 0(t0)
  li a1, 12
  li a2, 107
  li a3, 0xc7ff
  li a4, 0
  ecall
 
  li a7, 101
  la t0, HIGHSCORE
  lw a0, 0(t0)
  li a1, 12
  li a2, 107
  li a3, 0xc7ff
  li a4, 1
  ecall
  
  ep30:
  lw a0, (sp)
  lw a1, 4(sp)
  lw a2, 8(sp)
  lw a3, 12(sp)
  lw a4, 16(sp)
  lw a5, 20(sp)
  lw a7, 24(sp)
  lw ra, 28(sp)
  addi sp, sp, 32

  ret


# printa mapa dois frames e HUD
start_game_map:
  addi sp, sp, -32
  sw ra, (sp)
  sw a0, 4(sp)
  sw a1, 8(sp)
  sw a2, 12(sp)
  sw a3, 16(sp)
  sw a4, 20(sp)
  sw a7, 24(sp)
  sw a5, 28(sp)

  # render map both frames
  mv a0, s4
  li a1, 0
  li a4, 0
  call render 
  li a1, 1
  call render

  call UPDATE_HIGHSCORE

  call print_score

  lw t0, vidas
  li t1, 1
  beq t0, t1, uma
  li t1, 2
  beq t0, t1, duas
  li t1, 3
  beq t0, t1, tres
  j ep23

  uma:
    la a0, lives_1
    j ep23
  duas:
    la a0, lives_2
    j ep23
  tres:
    la a0, lives_3
  
  ep23:
    li a1, 0
    li a2, 10
    li a3, 156 
    
    lw a4, (a0)
    lw a5, 4(a0)
    addi a0, a0, 8
    
    call render
    li a1, 1
    call render

  lw ra, (sp)
  lw a0, 4(sp)
  lw a1, 8(sp)
  lw a2, 12(sp)
  lw a3, 16(sp)
  lw a4, 20(sp)
  lw a7, 24(sp)
  lw a5, 28(sp)
  addi sp, sp, 32

  ret


.include "effects.asm"

