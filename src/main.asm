.data
.include "../levels/maps_data/map1.data"
.include "../levels/maps_data/map2.data"
.include "../levels/maps_data/map3.data"
.include "../levels/maps_data/map1_original.data"
.include "../levels/maps_data/map2_original.data"
.include "../levels/maps_data/map3_original.data"
.include "../art/main_art/data/LevelCompleteScreen.data"
.include "../sprites/Zenon.data"
.include "../sprites/Blue.data"

.include "MACROSv24.s"

.text
  li s0, 0
START_MAIN:
  call SETUP4
  call MENU

  call SETUP1
  li s6, 1
  # inicializa posicoes sprites
  la t0, player
  li t1, 176
  sh t1, 8(t0)
  sh t1, 12(t0)
  li t1, 96  
  sh t1, 10(t0)
  sh t1, 14(t0)

  la t0, blue
  li t1, 64
  sh t1, 8(t0)
  sh t1, 12(t0)
  li t1, 16
  sh t1, 10(t0)
  sh t1, 14(t0)

  # argumentos dos mapas
  li s2, 10 # quantidade de pontos na fase
  la s3, map1 
  la s4, populated_map1
  la s5, collision_map1
  call jogo


  call SETUP2
  li s6, 2

  # inicializa posicoes sprites
  la t0, player
  li t1, 176
  sh t1, 8(t0)
  sh t1, 12(t0)
  li t1, 96  
  sh t1, 10(t0)
  sh t1, 14(t0)

  la t0, blue
  li t1, 64
  sh t1, 8(t0)
  sh t1, 12(t0)
  li t1, 16
  sh t1, 10(t0)
  sh t1, 14(t0)

  # argumentos dos mapas
  li s2, 10 # quantidade de pontos na fase
  la s3, map2
  la s4, populated_map2
  la s5, collision_map2
  call jogo

  main_exit:
  li a7, 10
  ecall


.include "jogo.asm"
.include "menu.asm"
.include "songs.asm"
.include "SYSTEMv24.s"

