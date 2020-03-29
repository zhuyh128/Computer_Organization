main:
    addi $a0, $zero, 10 # n = 10
    addi $a1, $zero, 5  # m = 5
    jal pascal          # call pascal(10, 5)
    j exit

pascal:
    addi $sp, $sp, -4
    sw $ra, 0($sp)    # Save $ra register into stack
    #--------------------------------------#
    #  \^o^/   Write your code here~  \^o^/#
    addi $sp, $sp, -12
    sw $a0,0($sp)
    sw $a1,4($sp)
    sw $s0,8($sp)
    beq $a0,$a1,re #test m==n
    beq $a1,$zero,re #test m==0
    lw $a0,0($sp)
    lw $a1,4($sp)
    add $t0, $zero,$a0   # n
    add $t1, $zero,$a1   # m
    addi $a0,$t0,-1	#n-1
    add $a1, $zero,$t1 # m
    jal pascal
    add $s0,$zero,$v0
    sw $s0,8($sp)
    lw $a0,0($sp)
    lw $a1,4($sp)
    add $t0, $zero,$a0   # n
    add $t1, $zero,$a1   # m
    addi $a0,$t0,-1	#n-1
    addi $a1, $t1,-1    # m-1
    jal pascal      
    lw $s0,8($sp)
    add $v0, $v0,$s0  
    addi $sp ,$sp ,12 
    #--------------------------------------#
    lw $ra, 0($sp)    # Load $ra register from stack
    addi $sp, $sp, 4
    jr $ra
    
 re: 
    addi $v0, $zero, 1   # else return 1
    addi $sp ,$sp ,12
    lw $ra, 0($sp) 
    addi $sp ,$sp ,4
    jr $ra   

exit:
