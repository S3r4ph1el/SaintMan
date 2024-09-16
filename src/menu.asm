.data
.include "../art/main_art/data/MenuScreen.data"
.include "../art/main_art/data/HistoryScreen_1.data"
.include "../art/main_art/data/HistoryScreen_2.data"
.include "../art/main_art/data/HistoryScreen_3.data"
.include "../art/main_art/data/HistoryScreen_4.data"
.include "../art/main_art/data/HistoryScreen_5.data"

.text

MENU:
		li s6, 1
		addi sp, sp, -4
		sw ra, (sp)
    la a0, MenuScreen
    mv a1, s0
    li a4, 0
		call render
	
		li t1,0xFF200000		
LOOP: 	lw t0,0(t1)			
		andi t0,t0,0x0001
		call PLAY4
		beq t0,zero,LOOP		
		lw t2,4(t1)			
		li t3, '1'
		beq t2, t3, CONTINUE
		li t3, '2'
		beq t2, t3, main_exit
		j LOOP

		
CONTINUE:
	
		la a0, HistoryScreen_1
		call PRINTHISTORY
		la a0, HistoryScreen_2
		call PRINTHISTORY
		la a0, HistoryScreen_3
		call PRINTHISTORY
		la a0, HistoryScreen_4
		call PRINTHISTORY
		la a0, HistoryScreen_5
		call PRINTHISTORY
		
		lw ra, (sp)
		addi sp, sp, 4
		ret

# Mostrar história do jogo e espera tecla E para continuar
# ARGS:
# a0 -> endereço imagem para mostrar					
PRINTHISTORY:
		
		addi sp, sp, -4
		sw ra, (sp)
    mv a1, s0
		li a4, 0
		call render
		
		li t1,0xFF200000		
LOOP_H: lw t0,0(t1)		
		andi t0,t0,0x0001
		call PLAY4
		beq t0,zero,LOOP_H		
		lw t2,4(t1)			
		li t3, 'e'
		beq t2, t3, CONTINUE_H
		j LOOP_H

CONTINUE_H:
		
		lw ra, (sp)
		addi sp, sp, 4
		ret
