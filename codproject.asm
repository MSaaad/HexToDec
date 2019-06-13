
.data
    input_string: .space 9
    str1: .asciiz "Enter string in Hexadecimal : "
    str2: .asciiz "Invalid hexadecimal string !"
    str3: .asciiz "The decimal equivalent is :"


.text

main:
    la $a0,str1                  #load argument
    li $v0,4                     #print a string
    syscall

    li $v0,8        #taking input
    la $a0,input_string   #load argument
    li $a1,9        #allocating for string
    add $s0,$zero,$a0  #load user input
    syscall

    add $t0,$zero,$s0 #load string for loop
    add $t3,$zero,$s0 #load string for counterstring
    addi $t4,$zero,10 #load newline value

counterstring:
    
    lb $t5,0($t3) #load first byte of string
    beq $t4,$t5,counterstringexit   #checking to see if it is the end of the string
    beq $zero,$t5,counterstringexit  #checking condition
    addi $t6,$t6,1 #increment char counter
    addi $t3,$t3,1 #change current byte
    j counterstring
counterstringexit:
    
    addi $t8,$t6,-1   #initialize index to length -1
loop:
    
    lb $t1,0($t0) #load first byte
    beq $t4,$t1,loop_exit #checking to see if it is the end of the string
    beq $zero,$t1,loop_exit #Checking condition  
    blt $t1,48,invalid #checking if character is less than 48, if true goes to invalid
    blt $t1,58,checking_num #goes to get value of char since it's valid
    blt $t1,65,invalid #checking if character is less than 65, if true goes to invalid
    blt $t1,71,checking_uppercase #goes to get value of char since it's valid
    blt $t1,97,invalid #checking if character is less than 97, if true goes to invalid
    blt $t1,103,checking_lowercase #goes to get value of char since it's valid
    j invalid
    
checking_num:
    
    addi $t2,$t1,-48  #convert 0-9 ascii to 0-9 hex
    j compute_sum  #compute exponent

checking_uppercase:
    
    addi $t2,$t1,-55   #convert A-F ascii to 10-15 hex
    j compute_sum   #compute exponent

checking_lowercase:
    
    addi $t2,$t1,-87     #convert a-f ascii to 10-15 hex
    j compute_sum   #compute exponent
    
compute_sum:
    
    sll $t7,$t7,4
    add $t7,$t7,$t2
    
    addi $t0,$t0,1                #incrementing string pointer by 1 => point next char
    addi $t8,$t8,-1               #decrement by 1
    addi $t3,$t3,-4               #decrement shift amount by 4
    
    j loop                        #jumps back to loop
loop_exit:
    
    la $a0,str3                  #load argument 
    li $v0,4                     #printing string
    syscall

    addi $s4,$zero,7                  #initializing with 7
    bgt $t6,$s4,output               #jumps to output if string length < 0
    li $v0,1                          #printing integer
    add $a0,$zero,$t7                  #load argument with decimal number
    syscall

end:
    
    li $v0,10                     #ending logic     
    syscall

invalid:
    
    la $a0,str2                  #load argument --invalid
    li $v0,4                     #print string
    syscall
    j end
    
output:

    addi $s5,$zero,10000         #initializing with 10,000 for output
    divu $t7,$s5                  #divide sum by 10,000
    mflo $s6                     #move quotient
    mfhi $s7                     #move remainder
    li $v0,1                     #print integer
    add $a0,$zero,$s6            #load argument with quotient
    syscall
    li $v0,1                     #print integer
    add $a0,$zero,$s7            #load argument with remainder
    syscall

    j end                        #jump to end