.include "macros.asm"

.globl revealNeighboringCells

revealNeighboringCells:
		save_context #salva os registradores $s
		move $s0, $a0 #pega o size e coloca no $s0
		move $s1, $a1 #pega a cordenada x
		move $s2, $a2 #pega a cordenada y
	subi $s3, $s1, 1 #inicio do for i=x-1
	beginning_for_x:
	addi $t0, $s1, 1
	bgt $s3, $t0, end_for_x
	
	subi $s4, $s2, 1 #inicio do for j=y-1
	beginning_for_y:
	addi $t1, $s2, 1
	bgt $s4, $t1, end_for_y
	
	blt $s3, $zero, cont_for_y #se for menor que 0 n�o entra
	li $t2,SIZE #guarda o valor de size
	bge $s3, $t2, cont_for_y #se for maior que size n�o entra 
	blt $s4, $zero, cont_for_y  #se for maior que size n�o entra
	bge $s4, $t2, cont_for_y #se for maior que size n�o entra
	sll $t3, $s3, 5		#A Coordenada i � multiplicada por 32, que � igual a 8 x 4 
	sll $t4, $s4, 2		#A Coordenada j � multiplicada por 4
	add $t3, $t3, $t4	#As duas coordenadas s�o somadas para calcular a posi��o da c�lula da matriz na mem�ria
	add $s5, $t3, $s0	#Soma com o inicio s� pra ter certesa 
	lw $t3, 0($s5)	
	li $t8, -2	#Pega o valor da possis�o

	bne $t3, $t8, cont_for_y #se for diferente de -2 n�o entra

	move $a0, $s0
	move $a1, $s3 #pega o valor de $s3 e coloca em $a1 para chamar a funs�o
	move $a2, $s4 #pega o valor de $s4 e coloca em $a2 para chamar a funs�o
	jal countAdjacentBombs #chama a funs�o countAdjacentBombs
	sw $v0, 0($s5) #board[i][j] = x;
	move $t7, $v0

	bne $t7, $zero, cont_for_y #Se for diferente de 0 sai
	move $a0, $s0 #joga os valores de $s0, $s1 e $s2 na funs�o revealNeighboringCells
	move $a1, $s3
	move $a2, $s4
	jal revealNeighboringCells
	
	cont_for_y:
	addi $s4, $s4, 1 #add um no y e retorna o for
	j beginning_for_y
	
	end_for_y: #add um no x e retorna o for
	addi $s3, $s3, 1
	j beginning_for_x
	
	end_for_x: #restaura as variaveis e finaliza a funs�o
	restore_context
	jr $ra
	
	
	