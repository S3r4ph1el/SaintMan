#########################################################
#						                                          #
# Universidade de Brasilia			                      #
# Departamento de Ciencia da Computacao		       	    #
# Introducao aos Sistemas Computacionais - 2024.1	    #
# Professor Marcus Vinicius Lamar			                #
# Alunos Victor Martinez, Enzo Teles e Lucas Mendes   #
# Nome do jogo: SaintMan				                      #
#							                                        #
#########################################################

.data
.include "../levels/maps_data/map1.data"
.include "../levels/maps_data/map2.data"
.include "../levels/maps_data/map3.data"
.include "../levels/maps_data/map1_original.data"
.include "../levels/maps_data/map2_original.data"
.include "../levels/maps_data/map3_original.data"
.include "../art/main_art/data/FinalScreen.data"
.include "../sprites/Zenon.data"
.include "../sprites/Zenon_orig.data"
.include "../sprites/SaintZenon.data"
.include "../sprites/Blue.data"
.include "../sprites/Red.data"
.include "../sprites/Orange.data"
.include "../sprites/Purple.data"
.include "../sprites/Blue_orig.data"
.include "../sprites/Red_orig.data"
.include "../sprites/Orange_orig.data"
.include "../sprites/Purple_orig.data"
.include "../sprites/Scared.data"
nivel: .word 1
HIGHSCORE: .word 0

.include "MACROSv24.s"

.text
  li s1, 0
  li s0, 0
  call READ_RANKING_FILE
START_MAIN:
  call SETUP4
  call MENU
PHASE1:
  call ENDBOOST
  call SETUP1
  li s6, 1
  sw s6, nivel, t0

  la t0, vidas
  li t2, 3
  sw t2, (t0)

  call set_phase1

  # argumentos dos mapas
  li s2, 121 # quantidade de pontos na fase (121)
  la s3, map1 
  la s4, populated_map1
  la s5, collision_map1
  call jogo

PHASE2:
  call ENDBOOST
  call SETUP2
  li s6, 2
  sw s6, nivel, t0

  la t0, vidas
  li t2, 3
  sw t2, (t0)

  call set_phase1

  # argumentos dos mapas
  li s2, 119 # quantidade de pontos na fase (119)
  la s3, map2
  la s4, populated_map2
  la s5, collision_map2
  call jogo

PHASE3:
  call ENDBOOST
  call SETUP3
  li s6, 3
  sw s6, nivel, t0

  la t0, vidas
  li t2, 3
  sw t2, (t0)

  call set_phase1

  # argumentos dos mapas
  li s2, 115 # quantidade de pontos na fase (115)
  la s3, map3
  la s4, populated_map3
  la s5, collision_map3
  call jogo

  ENDGAME:
  la a0, FinalScreen
  li a4, 0
  mv a1, s0
  call render

  call ENDGAMESETUP
  LOOP_ENDGAME:
  call ENDGAMEPLAY
  blt s10, s9, LOOP_ENDGAME
  li a7, 32
  li a0, 8000
  ecall

  main_exit:
  li a7, 10
  ecall

# posiciona sprites para fase 1
set_phase1:
  addi sp, sp, -4
  sw ra, (sp)
  call SETUP
  lw ra, (sp)
  addi sp, sp, 4
  # inicializa posicoes sprites
  la t0, player
  li t1, 176
  sh t1, 8(t0)
  sh t1, 12(t0)
  li t1, 96  
  sh t1, 10(t0)
  sh t1, 14(t0)
  li t1, 0
  sw t1, 4(t0)

  la t0, blue
  li t1, 64
  sh t1, 8(t0)
  sh t1, 12(t0)
  li t1, 16
  sh t1, 10(t0)
  sh t1, 14(t0)
  li t1, 3
  sw t1, 4(t0)

  la t0, red
  li t1, 288
  sh t1, 8(t0)
  sh t1, 12(t0)
  li t1, 16
  sh t1, 10(t0)
  sh t1, 14(t0)
  li t1, 1
  sw t1, 4(t0)

  la t0, orange
  li t1, 64
  sh t1, 8(t0)
  sh t1, 12(t0)
  li t1, 208
  sh t1, 10(t0)
  sh t1, 14(t0)
  li t1, 3
  sw t1, 4(t0)

  la t0, purple
  li t1, 287
  sh t1, 8(t0)
  sh t1, 12(t0)
  li t1, 208
  sh t1, 10(t0)
  sh t1, 14(t0)
  li t1, 1
  sw t1, 4(t0)

  ret

.include "file.asm"
.include "jogo.asm"
.include "menu.asm"
.include "songs.asm"
.include "SYSTEMv24.s"

