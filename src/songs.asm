.data
LENGTH1: .word 120
NOTES1: .word 76,178,77,178,74,178,76,178,72,178,74,178,71,178,72,178,69,178,71,178,67,356,76,178,77,178,74,178,76,178,72,178,74,178,71,178,72,178,69,178,71,178,67,356,76,178,77,178,74,178,76,178,72,178,74,178,71,178,72,178,69,178,71,178,67,356,76,178,77,178,74,178,76,178,72,178,74,178,71,178,81,356,79,711,76,356,77,356,74,356,76,356,73,356,70,356,79,356,77,711,79,356,81,356,79,711,77,356,79,356,77,711,76,356,74,356,78,711,77,356,78,356,79,711,78,356,74,356,77,711,81,889,76,178,77,178,74,178,76,178,72,178,74,178,71,178,72,178,69,178,71,178,67,356,76,178,77,178,74,178,76,178,72,178,74,178,71,178,72,178,69,178,71,178,67,356,76,178,77,178,74,178,76,178,72,178,74,178,71,178,72,178,69,178,71,178,67,356,76,178,77,178,74,178,76,178,72,178,74,178,71,178,81,356,79,356,77,711,76,356,74,356,78,711,77,356,78,356,79,711,78,356,74,356,77,711,81,356,77,356
LENGTH2: .word 96
NOTES2: .word 72,183,73,183,72,183,74,183,72,183,74,183,76,183,74,183,72,183,74,183,72,183,74,183,72,183,73,183,72,183,74,183,73,183,72,183,77,183,74,183,76,183,72,183,74,183,72,183,72,183,74,183,72,183,74,183,72,183,74,183,76,183,74,183,72,183,74,183,76,183,77,183,76,183,74,183,72,183,74,183,73,183,77,183,79,183,77,183,76,183,77,183,79,183,81,183,72,183,73,183,72,183,74,183,72,183,74,183,76,183,74,183,72,183,74,183,72,183,74,183,72,183,73,183,72,183,74,183,73,183,72,183,77,183,74,183,76,183,72,183,74,183,72,183,72,183,74,183,72,183,74,183,72,183,74,183,76,183,74,183,72,183,74,183,76,183,77,183,76,183,74,183,72,183,74,183,73,183,77,183,79,183,77,183,76,183,77,183,79,183,81,91
LENGTH3: .word 58
NOTES3: .word 67,220,67,110,67,549,67,220,69,220,69,220,69,989,64,110,67,220,67,220,67,440,67,110,67,220,69,329,69,110,69,769,67,110,69,440,69,329,69,110,69,329,69,440,67,220,67,440,65,440,67,220,67,2198,64,110,67,110,67,440,67,220,67,440,67,220,69,440,69,220,71,549,69,110,72,329,72,329,72,440,72,110,72,110,72,329,72,110,74,769,72,110,74,220,74,329,74,549,74,220,76,440,76,220,76,440,74,220,74,329,72,1648,64,220,67,440
LENGTH4: .word 28
NOTES4: .word 67,824,66,275,67,275,69,275,67,824,62,824,67,1098,65,275,64,275,62,1647,60,275,67,275,65,275,64,275,62,275,60,275,61,275,67,275,65,275,64,275,62,275,60,275,62,824,67,824,69,824,61,275,60,275,62,275
LENGTH5: .word 52
NOTES5: .word 79,122,76,122,74,122,76,122,79,122,76,122,74,122,76,122,81,122,76,122,74,122,76,122,79,122,76,122,74,122,76,122,79,122,76,122,72,122,76,122,79,122,76,122,72,122,76,122,81,122,76,122,72,122,76,122,79,122,76,122,72,122,76,122,79,122,74,122,71,122,74,122,79,122,74,122,71,122,74,122,81,122,74,122,71,122,74,122,79,122,74,122,71,122,74,122,79,489,77,489,79,489,81,489
LENGTH6: .word 33
NOTES6: 65,120,67,120,69,120,71,120,69,120,71,120,72,240,67,120,64,360,65,120,67,120,69,120,71,120,69,120,71,120,72,360,64,360,65,120,67,120,69,120,71,120,69,120,71,120,72,240,67,120,64,240,79,120,77,240,76,120,74,240,76,120,72,360,84,360
ENDTIME: .word 0

.text

SETUP:
	li a7, 1
	beq s6, a7, SETUP1
	addi a7, a7, 1
	beq s6, a7, SETUP2
	addi a7, a7, 1
	beq s6, a7, SETUP3
	addi a7, a7, 1
	beq s6, a7, SETUP4
	addi a7, a7, 1
	beq s6, a7, SETUP5
	ret
PLAY:
	li a7, 1
	beq s6, a7, PLAY1
	addi a7, a7, 1
	beq s6, a7, PLAY2
	addi a7, a7, 1
	beq s6, a7, PLAY3
	addi a7, a7, 1
	beq s6, a7, PLAY4
	addi a7, a7, 1
	beq s6, a7, PLAY5
	ret
START:
	li a7, 1
	beq s6, a7, START1
	addi a7, a7, 1
	beq s6, a7, START2
	addi a7, a7, 1
	beq s6, a7, START3
	addi a7, a7, 1
	beq s6, a7, START4
	addi a7, a7, 1
	beq s6, a7, START5
	ret
	
SETUP1:	la s11,LENGTH1				# fase 1
	lw s9,0(s11)
	la s11,NOTES1
	li s10,0			
	ret
PLAY1:	beq s10, zero, START1		# fase 1
	li a7, 30
	ecall
	lw s7, ENDTIME
	blt a0, s7, RETURN
START1:	beq s10,s9, SETUP1			#fase 1
	li a2, 1
	li a3, 100	
	lw a0,0(s11)		
	lw a1,4(s11)		
	li a7,31
	ecall
	mv s7, a1
	li a7, 30
	ecall
	add s7, s7, a0
	sw s7, ENDTIME, a7
	addi s11,s11,8			
	addi s10,s10,1
	ret
SETUP2:	la s11,LENGTH2				# fase 2
	lw s9,0(s11)
	la s11,NOTES2	
	li s10,0			
	ret
PLAY2:	beq s10, zero, START2		# fase 2
	li a7, 30
	ecall
	lw s7, ENDTIME
	blt a0, s7, RETURN
START2:	beq s10,s9, SETUP2			#fase 2
	li a2, 1
	li a3, 100	
	lw a0,0(s11)		
	lw a1,4(s11)		
	li a7,31
	ecall
	mv s7, a1
	li a7, 30
	ecall
	add s7, s7, a0
	sw s7, ENDTIME, a7
	addi s11,s11,8			
	addi s10,s10,1
	ret
SETUP3:	la s11,LENGTH3				# fase 3
	lw s9,0(s11)
	la s11,NOTES3	
	li s10,0			
	ret
PLAY3:	beq s10, zero, START3		# fase 3
	li a7, 30
	ecall
	lw s7, ENDTIME
	blt a0, s7, RETURN
START3:	beq s10,s9, SETUP3			# fase 3
	li a2, 1
	li a3, 100	
	lw a0,0(s11)		
	lw a1,4(s11)		
	li a7,31
	ecall
	mv s7, a1
	li a7, 30
	ecall
	add s7, s7, a0
	sw s7, ENDTIME, a7
	addi s11,s11,8			
	addi s10,s10,1
	ret
SETUP4:	la s11,LENGTH4				# menu
	lw s9,0(s11)
	la s11,NOTES4	
	li s10,0			
	ret
PLAY4:	beq s10, zero, START4		# menu
	li a7, 30
	ecall
	lw s7, ENDTIME
	blt a0, s7, RETURN
START4:	beq s10,s9, SETUP4			# menu
	li a2, 1
	li a3, 100	
	lw a0,0(s11)		
	lw a1,4(s11)		
	li a7,31
	ecall
	mv s7, a1
	li a7, 30
	ecall
	add s7, s7, a0
	sw s7, ENDTIME, a7
	addi s11,s11,8			
	addi s10,s10,1
	ret
SETUP5:	la s11,LENGTH5				# boost
	lw s9,0(s11)
	la s11,NOTES5
	li s10,0			
  li s6, 5
	ret
PLAY5:	beq s10, zero, START5		# boost
	li a7, 30
	ecall
	lw s7, ENDTIME
	blt a0, s7, RETURN
START5:	beq s10,s9, ENDBOOST		# boost
	li a2, 1
	li a3, 100	
	lw a0,0(s11)		
	lw a1,4(s11)
	li a7,31
	ecall
	mv s7, a1
	li a7, 30
	ecall
	add s7, s7, a0
	sw s7, ENDTIME, a7
	addi s11,s11,8			
	addi s10,s10,1
	ret
SETUP6:	la s11,LENGTH6				# levelcomplete
	lw s9,0(s11)
	la s11,NOTES6
	li s10,0			
	ret
PLAY6:	beq s10, zero, START6		# levelcomplete
	li a7, 30
	ecall
	lw s7, ENDTIME
	blt a0, s7, RETURN
START6:	beq s10,s9, RETURN		# levelcomplete
	li a2, 1
	li a3, 100
	lw a0,0(s11)	
	lw a1,4(s11)
	li a7,31
	ecall
	mv s7, a1
	li a7, 30
	ecall
	add s7, s7, a0
	sw s7, ENDTIME, a7
	addi s11,s11,8			
	addi s10,s10,1
	ret

ENDBOOST: 
  la t0, boost
  sw zero, (t0)
  
  addi sp, sp, -4
  sw ra, (sp)

  la a0, player
  la a1, player_orig
  call change_sprite

  la a0, blue
  la a1, blue_orig
  call change_sprite
  la a0, orange
  la a1, orange_orig
  call change_sprite
  la a0, red
  la a1, red_orig
  call change_sprite
  la a0, purple
  la a1, purple_orig
  call change_sprite


  li t5, 176
  li t6, 96

  la t0, blue
  lw t1, 4(t0)
  li t2, 4
  bne t1, t2, ep25
    sw zero, 4(t0)
    sh t5, 8(t0)
    sh t6, 10(t0)

  ep25:
  la t0, orange
  lw t1, 4(t0)
  li t2, 4
  bne t1, t2, ep26
    sw zero, 4(t0)
    sh t5, 8(t0)
    sh t6, 10(t0)

  ep26:
  la t0, red
  lw t1, 4(t0)
  li t2, 4
  bne t1, t2, ep27
    sw zero, 4(t0)
    sh t5, 8(t0)
    sh t6, 10(t0)

  ep27:
  la t0, purple
  lw t1, 4(t0)
  li t2, 4
  bne t1, t2, ep28
    sw zero, 4(t0)
    sh t5, 8(t0)
    sh t6, 10(t0)

  ep28: 
  lw ra, (sp)
  addi sp, sp, 4

  lw s6, nivel
  j SETUP

RETURN:	ret
