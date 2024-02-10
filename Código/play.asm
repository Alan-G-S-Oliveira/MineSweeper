.include "macros.asm"

.globl play

play:
	save_context	#Salva os valores dos resgitradores na memória
	
	#Move os valores dos registradores de argumentos da função para os registradores do tipo $s
	move $s0, $a0	#$s0 recebe o começo da matriz
	move $s1, $a1	#$s1 recebe a coordenada i
	move $s2, $a2	#$s2 recebe a coordenada j
	
	#Calcula a posição da matriz
	sll $t0, $s1, 5		#A Coordenada i é multiplicada por 32, que é igual a 8 x 4 
	sll $t1, $s2, 2		#A Coordenada j é multiplicada por 4
	add $t0, $t0, $t1	#As duas coordenadas são somadas para calcular a posição da célula da matriz na memória
	
	add $s3, $t0, $s0	#É calculado o endereço do número em relação ao começo da matriz
	lw $s4, 0($s3)		#O número na posição calculada é carregado para o registrador $s4
	
	addi $t2, $0, -1	#É atribuido o valor -1 ao registtrador $t2
	bne $t2, $s4, else1	#if(board[row][column] == -1)
	move $v0, $0		#Move o valor de retorno para $v0
	restore_context		#Restaura os valores dos registradores
	jr $ra			#return 0
	
else1:

	addi, $t2, $0, -2	#É atribuidoo valor -2 ao registrador $t2
	bne $t2, $s4, else2	#if(board[row][column] == -2)
	
	#Move os argumentos para a chamada da função countAdjacentBombs
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal countAdjacentBombs
	
	move $t4, $v0		#Move o valor retornado para o registrador $t4
	sw $t4, 0($s3)		#board[row][column] = x
	
	bne $t4, $0, else3	#if(x == 0), em C equivale a if(!x)
	
        #Move os argumetos para a chamada  da função revealNeighboringCells
        move $a0, $s0
        move $a1, $s1
        move $a2, $s2
	jal revealNeighboringCells
	
else3:	
else2:

restore_context		#Restaura os valores dos registradores

addi $v0, $0, 1		#Carrega o valor de retorno em $v0
jr $ra			#return 1
