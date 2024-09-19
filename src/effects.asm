.data
GAMEOVERLENGTH: .word 31
GAMEOVERNOTES: .word 60,639,65,426,60,213,59,639,65,426,59,213,58,107,51,107,58,107,57,107,50,107,57,107,56,107,49,107,56,107,55,107,48,107,55,107,63,107,60,107,59,107,61,107,57,107,58,107,55,107,56,107,53,107,52,107,51,107,50,107,51,1278
GAMEOVERENDTIME: .word 0
DEATHLENGTH: .word 6
DEATHNOTES: .word 66,152,67,152,66,152,67,152,67,304,55,304
DEATHENDTIME: .word 0
ENDGAMELENGTH: .word 9
ENDGAMENOTES: .word 84,110,84,110,84,110,84,331,82,331,83,331,84,221,83,110,84,331
ENDGAMEENDTIME: .word 0

.text

COIN:   li a2, 104
        li a3, 62	
        li a0, 76
        li a1, 100
        li a7,31
        ecall
        ret

SLASH:   li a2, 127
        li a3, 62	
        li a0, 76
        li a1, 100
        li a7,31
        ecall
        ret

GAMEOVERSETUP:	la s11,GAMEOVERLENGTH			
                lw s9,0(s11)
                la s11,GAMEOVERNOTES
                li s10,0		
GAMEOVERPLAY:	beq s10, zero, GAMEOVERSTART		
                li a7, 30
                ecall
                lw s7, GAMEOVERENDTIME
                blt a0, s7, RETURN1
GAMEOVERSTART:	beq s10,s9, START_MAIN		
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
                sw s7, GAMEOVERENDTIME, a7
                addi s11,s11,8			
                addi s10,s10,1
                ret
DEATHSETUP:	la s11,DEATHLENGTH			
                lw s9,0(s11)
                la s11,DEATHNOTES
                li s10,0		
DEATHPLAY:	beq s10, zero, DEATHSTART		
                li a7, 30
                ecall
                lw s7, DEATHENDTIME
                blt a0, s7, RETURN1
DEATHSTART:	beq s10,s9, START_MAIN		
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
                sw s7, DEATHENDTIME, a7
                addi s11,s11,8			
                addi s10,s10,1
                ret
ENDGAMESETUP:	la s11,ENDGAMELENGTH			
                lw s9,0(s11)
                la s11,ENDGAMENOTES
                li s10,0		
ENDGAMEPLAY:	beq s10, zero, ENDGAMESTART		
                li a7, 30
                ecall
                lw s7, ENDGAMEENDTIME
                blt a0, s7, RETURN1
ENDGAMESTART:	beq s10,s9, RETURN1		
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
                sw s7, ENDGAMEENDTIME, a7
                addi s11,s11,8			
                addi s10,s10,1
                ret
                
RETURN1:	ret
