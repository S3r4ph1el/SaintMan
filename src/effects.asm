.data
GAMEOVERLENGTH: .word 31
GAMEOVERNOTES: .word 60,639,65,426,60,213,59,639,65,426,59,213,58,107,51,107,58,107,57,107,50,107,57,107,56,107,49,107,56,107,55,107,48,107,55,107,63,107,60,107,59,107,61,107,57,107,58,107,55,107,56,107,53,107,52,107,51,107,50,107,51,1278
GAMEOVERENDTIME: .word 0
SLASHENDTIME: .word 0
SLASHLENGTH: .word 0    # ADICIONAR .DATA DO SLASH
SLASHNOTES: .word 0
.text

COIN:   li a2, 104
        li a3, 62	
        li a0, 76
        li a1, 100
        li a7,31
        ecall
        ret

SLASH: j SLASHSETUP
          LOOP: blt s10, s9, SLASHPLAY
          beq s10, s9, RETURN
          j LOOP

SLASHSETUP:	la s11,SLASHLENGTH			
                lw s9,0(s11)
                la s11,SLASHNOTES
                li s10,0		
SLASHPLAY:	beq s10, zero, SLASHSTART		
                li a7, 30
                ecall
                lw s7, SLASHENDTIME
                blt a0, s7, RETURN
SLASHSTART:	beq s10,s9, RETURN		
                li a2, 55               # MUDAR INSTRUMENTO
                li a3, 127	
                lw a0,0(s11)		
                lw a1,4(s11)		
                li a7,31
                ecall
                mv s7, a1
                li a7, 30
                ecall
                add s7, s7, a0
                sw s7, SLASHENDTIME, s6
                addi s11,s11,8			
                addi s10,s10,1
                ret
                
GAMEOVER: j GAMEOVERSETUP
          LOOP: blt s10, s9, GAMEOVERPLAY
          beq s10, s9, RETURN
          j LOOP

GAMEOVERSETUP:	la s11,GAMEOVERLENGTH			
                lw s9,0(s11)
                la s11,GAMEOVERNOTES
                li s10,0		
GAMEOVERPLAY:	beq s10, zero, GAMEOVERSTART		
                li a7, 30
                ecall
                lw s7, GAMEOVERENDTIME
                blt a0, s7, RETURN
GAMEOVERSTART:	beq s10,s9, RETURN		
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
                sw s7, GAMEOVERENDTIME, s6
                addi s11,s11,8			
                addi s10,s10,1
                ret
                
RETURN:	ret