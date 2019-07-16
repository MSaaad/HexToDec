
.data
    inputstr: .space 9
    str1: .asciiz "\nEnter string in Hexadecimal : "
    str2: .asciiz "\nYou have entered an invalid hexadecimal string !"
    str3: .asciiz "\nThe decimal equivalent is :"
    str4: .asciiz "\nPress 1 to continue or any other key to exit:"
    str5: .asciiz "\nThe program has been terminated! :)"

.text

# s6 ---------- load string for loop
# s4 ---------- load first byte
# t2 ----------  for checking
# t3 ---------- load string for counterstring
# t4 ---------- load newline value
# t5 ---------- load first byte of string
# t6 ---------- for output if length < 0
# s5 ---------- concatenating value
# s7 ---------- indexing
# s0 ---------- load user input
# t1 ----------  initialized with 1 for continuation
# t0 ---------- checking condition for continuation
# s3 ---------- checking for ascii code
# s4 ---------- checking variable for ascii
# s5 ---------- load argument with decimal number
# s6 ---------- loading string for loop
# s7 ---------- initialized with -1th index
.globl main
.ent main
main:
    la $a0,str1                  #load argument
    li $v0,4                     #print a string
    syscall

    li $v0,8        #taking input
    la $a0,inputstr   #load argument
    li $a1,9        #allocating for string
    add $s0,$0,$a0  #load user input
    syscall

    add $s6,$0,$s0 #load string for loop
    add $t3,$0,$s0 #load string for counterstring
    addi $t4,$0,10 #load newline value

counterstring:
    
    lb $t5,0($t3) #load first byte of string
    beq $t4,$t5,counterstringexit   #checking to see if it is the end of the string
    beq $0,$t5,counterstringexit  #checking condition
    addi $t6,$t6,1 #increment char counter
    addi $t3,$t3,1 #change current byte
    j counterstring

counterstringexit:
    
    addi $s7,$t6,-1   #initialize index to length -1

loop:
    
    lb $s4,0($s6)          #load first byte
    beq $t4,$s4,loop_exit      #checking to see if it is the end of the string
    beq $0,$s4,loop_exit       #Checking condition  
    blt $s4,48,invalid       #checking if character is less than 48, if true goes to invalid
    blt $s4,58,checking_num      #goes to get value of char since it's valid
    blt $s4,65,invalid          #checking if character is less than 65, if true goes to invalid
    blt $s4,71,checking_uppercase     #goes to get value of char since it's valid
    blt $s4,97,invalid              #checking if character is less than 97, if true goes to invalid
    blt $s4,103,checking_lowercase       #goes to get value of char since it's valid
    j invalid
    
    jal check_function
 
loop_exit:
    
    la $a0,str3                  #load argument 
    li $v0,4                     #printing string
    syscall

    addi $s4,$0,7                  #initializing with 7
    li $v0,1                          #printing integer
    add $a0,$0,$s5                  #load argument with decimal number
    syscall

repeat:
    add $s5,$0,$0

    la $a0,str4                  #load argument --continue
    li $v0,4                     #print string
    syscall

    li $v0,5
    syscall
    move $t0,$v0

    addi $t1,$0,1
    beq $t0,$t1,main          #press 1 to continue
    
end:
    la $a0,str5                  #load argument --invalid
    li $v0,4                     #print string
    syscall

    li $v0,10                     #ending logic     
    syscall


invalid:
    
    la $a0,str2                  #load argument --invalid
    li $v0,4                     #print string
    syscall

    j repeat

.ent check_function
.globl check_function

check_function:
       
    checking_num:
        
        addi $s3,$s4,-48        #convert 0-9 ascii to 0-9 hex
        j compute_sum           #compute exponent

    checking_uppercase:
        
        addi $s3,$s4,-55        #convert A-F ascii to 10-15 hex
        j compute_sum           #compute exponent

    checking_lowercase:
        
        addi $s3,$s4,-87          #convert a-f ascii to 10-15 hex
        j compute_sum             #compute exponent
        
    compute_sum:
        
        sll $s5,$s5,4
        add $s5,$s5,$s3
        
        addi $s6,$s6,1                #incrementing string pointer by 1 => point next char
        addi $s7,$s7,-1               #decrement by 1
        addi $t3,$t3,-4               #decrement shift amount by 4
        
        jal loop                        #jumps back to loop
.end check_function
