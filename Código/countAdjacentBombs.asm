.include "macros.asm"

.globl countAdjacentBombs

countAdjacentBombs:
	save_context	#Salva os valores dos registradores na memória
	
	move $s0, $a0	#$s0 recebe o começo da matriz
	move $s1, $a1	#$s1 recebe a coordenada i
	move $s2, $a2	#$s2 recebe a coordenada 
	
	move $s3, $0	#count = 0
	
	addi $s4, $0, -1	#$s4 é usado para armazenar o valor de -1 que será uasdo em um if mais adiante
	
	#Calcula a posição da matriz
	sll $t0, $s1, 5		#A Coordenada i é multiplicada por 32, que é igual a 8 x 4
	sll $t1, $s2, 2		#A Coordenada j é multiplicada por 4
	add $t0, $t0, $t1	#As duas coordenadas são somadas para calcular a posição da célula da matriz na memória
	
	add $t1, $t0, $s0	#É calculado o endereço do número em relação ao começo da matriz
	lw $s5, 0($t1)		#O número na posição calculada é carregado para o registrador $s5, ele será usado em um if mais adiante
	
	#Prepara o início do for1
	addi $t1, $s1, -1	#i = row - 1
	addi $t2, $s1, 1	#Valor limite para o for = row + 1
for1:
	bgt $t1, $t2, fim_for1	#Verifica se a condição de saída do for foi atingida
	
	#Prepara o for2
	addi $t3, $s2, -1	#j = column - 1
	addi $t4, $s2, 1	#Valor limite para o for = column + 1
	
for2:
	bgt $t3, $t4, fim_for2	#Verifica se a condição de saída do for foi atingida
	
	#Representa o if(i >= 0 && i < SIZE && j >= 0 && j < SIZE && board[i][j] == -1)
	blt $t1, $0 else		#if(i >= 0)
	bge $t1, SIZE, else		#if(i < SIZE)
	blt $t3, $0 else		#if(j >= 0)
	bge $t3, SIZE, else		#if(j < SIZE)
	bne $s5, $s4, else		#if(board[i][j] == -1)
	
	addi $s3, $s3, 1	#count++
	
else:
	addi $t3, $t3, 1	#j++
	j for2		#Volta para o loop do for2
	
fim_for2:
	addi $t1, $t1, 1	#i++
	j for1		#Volta para o loop do for1
	
fim_for1:
	move $v0, $s3		#Move o valor de retorno para $v0
	restore_context		#Restaura os valores dos registradores
	jr $ra		#return count
	