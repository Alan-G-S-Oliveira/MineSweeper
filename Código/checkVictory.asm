.include "macros.asm"

.globl checkVictory

checkVictory:
	save_context #salva os $s e pega a referencia e traz para o $s0
	move $s0, $a0
li $s1, 0 #cria o cont
li $s2, 0 #cria o i
li $s3, 0 #cria o j
beginning_for_i: #inicio o primeiro for
li $t0, SIZE	#pego o size
bge $s2, $t0,end_for_i #condisão de saida do for

beginning_for_j: #inicio o segundo for
bge $s3, $t0,end_for_j #condisão de saida do for
sll $t1, $s2, 5		#A Coordenada i é multiplicada por 32, que é igual a 8 x 4 
sll $t2, $s3, 2		#A Coordenada j é multiplicada por 4
add $t2, $t0, $t1	#As duas coordenadas são somadas para calcular a posição da célula da matriz na memória
add $s2, $t2, $s0	#Soma com o inicio só pra ter certesa
lw $t3, 0($t2)		#Pega o valor da possisão
bgez $t3, lar_c #pular para add 1 no contador
volta: #volta do lar_c
addi $s3, $s3, 1 #add 1 no j
j  beginning_for_j #volta para o inicio do laso
end_for_j: #fim do laso
addi $s2, $s2, 1 #add 1 no i
j beginning_for_j #volta para o inicio do laso
end_for_i: #fim do laso
mul $t4, $t0, $t0 #multiplica o size pelo zise
li $t5, BOMB_COUNT #pega o valor do BOMB_COUNT
sub $t4, $t4, $s5 #sub o valor do quadrado do size com o BOMB_COUNT
blt $s1, $4, good_end #leva para o final bom que e vencer o jogo 
restore_context #restaura os $s
li $v0, 0 #volta 0
jr $ra #final ruín 
good_end: #entra no final bom
restore_context #restaura os $s
li $v0, 1 #volta 1
jr $ra #final bom :)
lar_c: #entra no almento do contador
addi $s1, $s1, 1 #add 1 no cont
j volta #volta para onde parou