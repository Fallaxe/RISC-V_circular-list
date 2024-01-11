# TEST
# 1 "ADD(1)~PRINT~ADD(a)~PRINT~ADD(a)~PRINT~ADD(B)~PRINT~ADD(;)~PRINT~ADD(9)~PRINT~SSX~PRINT~SORT~PRINT~DEL(b)~PRINT~DEL(B)~PRINT~PRI~ SDX ~PRINT~ REV ~PRINT~ PRINT"
# 2 "ADD(1)  ~ SSX ~ ADD(a) ~ add(B) ~ ADD(B)~   ADD ~ ADD(9) ~PRINT ~ SORT(a)  ~ PRINT ~ DEL(bb) ~DEL(B) ~PRINT~ REV ~SDX ~PRINT"
# 3 "ADD(K)~ADD(2)~AD~~~ADD(4)~ADD(d)~PRINT~REV~PRINT~PRI~A~REV~PRINT~  ~ADD(8)~PRINT"
# 4 "    ADD(6)      ~ADD(7)   ~REV  K~ADD(f)~PRINT ~SORT~PRINT"
# 5 "ADD(1)~ADD(2)~ADD(4)~REV~PRINT~SORT~ADD(F)~ADD(})~ADD(U)~ADD(*)~ADD(G)~ADD(f)~ADD(x)~REV~ADD(D)~ADD(a)~ADD(q)~ADD(8)~ADD(/)~ADD(1)~ADD(1)~ADD(1)~ADD(1)~ADD(1)~ADD(1)~ADD(1)~ADD(1)~PRINT~ADD(1)~ADD(1)~PRINT~SORT~REV~PRINT"
# 6 "ADD(a)~ADD(8)~ADD(a)~ADD(a)~ADD(a)~REV~DEL(8)~PRINT~DEL(a)~ADD(1)~SSX~PRINT~ADD(0)~PRINT~SORT~PRINT~ADD(A)~ADD(F)~~ADD(*)~ADD(F)~ADD([)~SORT~SDX~PRINT~DEL(0)~A ~ PRI~PRINT~ADD(<)~ADD(})~SORT~PRINT~SORT~PRINT"

.data
    input: .string ""
    print_Str: .string "print{"
    head:  .word 0xffffffff #0 elelmenti
.text

    li a1,0 #numero istruzioni usate
    li a2,30 #MAX ISTRUZIONI
    la t1, input
    la t3, head
    
    li t5,0xffffffff
    
    
    li s1,125 #limite
    li s2,32  #limite e spazio " "
    li s6, 126 #tilde
   
    la a3,head

   #caricamento prima lettera
    lb t0, 0(t1)
    bne t0,s6,no_intialize_tilde
    jal next_letter
    
no_intialize_tilde:
    beq t0,s2,gotoValidLetter #first controll exemple: "   add(4) ~" [blankspaces before the 1st command]
    
analize_string:
    
    bge a1,a2,end #MAX ISTRUZIONI RAGGIUNTE?
    
    beq t0,s2,gotoValidLetter #se inizia con " "
    beq t0,s6,gotoValidLetter #se inizia con "~"
    li s3,65 #A
    bne t0,s3,others
        
        li s3,68 #D
      
        #check D x2
        jal next_letter
        bne t0,s3,ignore_until_tilde
    
        jal next_letter
        bne t0,s3,ignore_until_tilde
    
    
    
        li s3,40 #parentesi aperta
        jal next_letter
        bne t0,s3,ignore_until_tilde
    
    
        #lettera da inserire
        jal next_letter
        bgt t0,s1,ignore_until_tilde
        blt t0,s2,ignore_until_tilde
    
        #sposta la lettera "inseribile" perche va ancora controllato
        # che add si chiuda add(*)
        addi s4,t0,0
    
        jal next_letter
        li s3,41 #parentesi chiusa
        bne t0,s3,ignore_until_tilde
        
        jal after_brackets
        
        addi sp,sp,-4
        sw ra,0(sp) 
        jal add
        lw ra, 0(sp)
        addi sp,sp,4
        
        
        jal next_letter
        
        j analize_string

others:
    li s3,83 #S
    bne t0,s3,continue_check
    
        li s3,79 #O
        jal next_letter
        bne s3,t0,S_commands
        
            li s3,82 #R
            jal next_letter
            bne s3,t0,ignore_until_tilde
    
            li s3,84 #T
            jal next_letter
            bne s3,t0,ignore_until_tilde
            jal after_brackets
          
            jal sort
            
            li s2,32
            
            jal next_letter
        
        j analize_string
            
        

S_commands:
    
    li s3,68 #D
    #jal next_letter
    bne s3,t0,ssx_check
        li s3,88 #X
        jal next_letter
        bne s3,t0,ignore_until_tilde
        
        jal after_brackets
       
        addi sp,sp,-4
        sw ra,0(sp)
        jal sdx
        lw ra, 0(sp)
        addi sp,sp,4
        
        jal next_letter
        
        j analize_string
ssx_check:       
    li s3,83 #S
    #jal next_letter
    bne s3,t0,ignore_until_tilde
    
    li s3,88 #X
    jal next_letter
    bne s3,t0,ignore_until_tilde
    
    jal after_brackets
    
    addi sp,sp,-4
    sw ra,0(sp)
    jal ssx
    lw ra, 0(sp)
    addi sp,sp,4
    
    jal next_letter
        
    j analize_string


continue_check:
    li s3,68 #D
    #jal next_letter
    bne s3,t0,continue_check_2
        li s3,69 #E
        jal next_letter
        bne s3,t0,ignore_until_tilde
        li s3,76 #L
        jal next_letter
        bne s3,t0,ignore_until_tilde
        
        li s3,40 #parentesi aperta
        jal next_letter
        bne t0,s3,ignore_until_tilde
        
        #elemento da cancellare
        jal next_letter
        bge t0,s1,ignore_until_tilde
        ble t0,s2,ignore_until_tilde
        
        #metto in s4 l'elemento da cancellare
        addi s4,t0,0
    
        jal next_letter
        li s3,41 #parentesi chiusa
        bne t0,s3,ignore_until_tilde
        
        jal after_brackets
        
        addi sp,sp,-4
        sw ra,0(sp)
        jal del
        lw ra, 0(sp)
        addi sp,sp,4

        jal next_letter
        
        j analize_string
        

continue_check_2:       
    li s3,82 #R
    #jal next_letter
    bne s3,t0,continue_check_3
        li s3,69 #E
        jal next_letter
        bne s3,t0,ignore_until_tilde
        li s3,86 #V
        jal next_letter
        bne s3,t0,ignore_until_tilde
        
        jal after_brackets
        
        addi sp,sp,-4
        sw ra,0(sp) 
        jal rev
        lw ra, 0(sp)
        addi sp,sp,4
        jal next_letter
        
        j analize_string

continue_check_3:
    
    ###############print################
    li s3,80 #P
    #jal next_letter
    bne s3,t0,ignore_until_tilde
        li s3,82 #R
        jal next_letter
        bne s3,t0,ignore_until_tilde
        li s3,73 #I
        jal next_letter
        bne s3,t0,ignore_until_tilde
        li s3,78 #N
        jal next_letter
        bne s3,t0,ignore_until_tilde
        li s3,84 #T
        jal next_letter
        bne s3,t0,ignore_until_tilde
        
        jal after_brackets        
        
         addi sp,sp,-4
        sw ra,0(sp) 
        jal print
        lw ra, 0(sp)
        addi sp,sp,4
        
        jal next_letter
        
        j analize_string
    


#ignore_until_tilde + check the first valid paramether not a " " [blanckspace]

ignore_until_tilde:
beq t0,s6,analize_string

loop_tilde:
    beq t0,zero,end #####fine se \0
    addi t1,t1,1 #next letter
    lb t0, 0(t1)
    bne t0,s6,loop_tilde

gotoValidLetter:
    beq t0,zero,end
    jal next_letter
    
    beq t0,s2,gotoValidLetter
    j analize_string
    

    

######################################################################################
################## MAIN METHODS ######################################################
######################################################################################

add:
    lw t3 head
    lw s10,head
    beq t3,t5, first_add    #controllo lista vuota
 loop_to_last:
     addi s11,t3,0
     lw t3,1(t3)
     bne t3,s10,loop_to_last
     addi a3,s11,0
     addi a6,s11,0
     
     addi sp,sp,-4
     sw ra,0(sp) 
     jal find_space
     lw ra, 0(sp)
     addi sp,sp,4

    sw a3,1(a6)             #upd puntatore in memoria
    sb s4,0(a3)             #metto il valore 
    lw t3,head
    sw t3,1(a3)
    j end_ADD
 first_add:
    la a3,head
    addi a6,a3,0
  
    addi sp,sp,-4
    sw ra,0(sp) 
    jal find_space
    lw ra, 0(sp)
    addi sp,sp,4
    
    sw a3,0(a6)             #upd head in memoria
    sb s4,0(a3)             #metto il valore 
    sw a3,1(a3)
 end_ADD:  
    addi a1,a1,1
    jr ra


rev:
    lw t3, head
    lw s11,head
    beq s11, t5, end_rev
    
  push_rev:
      
    lb a0, 0(s11) #character to save
    
    #salvataggio del char nella pila
    addi sp,sp,-1
    sb a0,0(sp)
    
    
    lw s11,1(s11)
    beq s11,t3,pop_rev
    j push_rev
    
  pop_rev:
    lw s11,head
    
  ciclo_rev:
    
    lb a0,0(sp)
    addi sp,sp,1
    
    sb a0,0(s11)
    lw s11,1(s11)
    beq s11,t3,end_rev
    j ciclo_rev
  end_rev:
     addi a1,a1,1  
     jr ra   
    
  

print: 
    lw t3,head
    li a7,4
    la a0, print_Str
    ecall
    
    li a7,11
    lw s11, head
    #li s9, 0
    
    beq s11, t5, fine_stampa #vuoto
    
    stampa:
        
    lb a0, 0(s11)
    ecall
    
    lw s11,1(s11)
    beq s11,t3,fine_stampa
    
    j stampa
    
    fine_stampa:
        
    li a0,125 #}
    ecall
    
    li a0,32
    ecall
    
    addi a1,a1,1
    jr ra

del:
    lw t3, head                 #s4 conterra' l'elemento da togliere
    la s10,head #phead
    lw s11,head
    beq t3,t5,end_del
    
find_rem:
    lb s9,0(s11) #letter
    lw s7,1(s11)
    beq s9,s4,rem
update_pointers:
    
    lw s10,0(s10)               #scorro il predecessore
    addi s10,s10,1
    
    lw s7,1(s11)                #scorro l'elemento attuale
    beq s7,t3,upd_coda
    lw s11,1(s11)
    j find_rem
rem:
    lw s11,1(s11)
    lb s7,0(s11)
    
    beq t3,s11,end_rem
    beq s7,s4,rem
end_rem:
    lw s7,1(s11)
    sw s11,0(s10)
    lw t3,head
    j update_pointers
    
upd_coda:
    
    lw t3,head
    lb s7,0(t3)
    
    bne s7,s4,upd_not_void
    la t3,head
    sw t5,0(t3)
    j end_del
    
upd_not_void:
    sw t3,1(s11)
        
end_del:
    addi a1,a1,1
    jr ra



    
      
ssx: 
  #modificata la testa:
    lw s11, head
    #addi s11,s11,1
    lw s11,1(s11)
    la s10,head
    
    sw s11,0(s10)

    addi a1,a1,1
    jr ra
    
sdx: 
    lw s11,head
    
    lw s10, head
    la s9,head
    
   loop_sdx:
           
      addi s8,s11,0
       lw s11,1(s11)
       beq s11, s10,end_ssx
       
       j loop_sdx
       
   end_ssx:
       sw s8,0(s9)
       addi a1,a1,1
        
     jr ra
     
  
  
     
sort:
    #simbolo<numeri<minuscole<maiuscole
    #s10 posizione fin dove sono arrivato a confermare l'ordinamento
    #s11 scorrimento generale
    lw s10,head 
    lw s11,head 
    addi t3,s11,0
    addi a6,s11,0
    
    beq t3,t5,end_rec #lista vuota
    lw s2,1(s10)
    beq t3,s2,end_rec ##1 solo elemento
    
###caratteri da space a '/'###
    li s5,32
    li s4,47
    addi sp,sp,-4
    sw ra,0(sp) 
    jal recorsive_label
    lw ra, 0(sp)
    addi sp,sp,4

###caratteri da ':' a '@'###   
    li s5,58
    li s4,64
    addi sp,sp,-4
    sw ra,0(sp) 
    jal recorsive_label
    lw ra, 0(sp)
    addi sp,sp,4
    
###caratteri da 'parentesi quadrata' a '`'###    
    li s5,91
    li s4,96
    addi sp,sp,-4
    sw ra,0(sp) 
    jal recorsive_label
    lw ra, 0(sp)
    addi sp,sp,4

###caratteri da '{' a '}' ###   
    li s5,123
    li s4,125
    addi sp,sp,-4
    sw ra,0(sp) 
    jal recorsive_label
    lw ra, 0(sp)
    addi sp,sp,4
    
###Numeri###    
    li s5,48
    li s4,57
    addi sp,sp,-4
    sw ra,0(sp) 
    jal recorsive_label
    lw ra, 0(sp)
    addi sp,sp,4

###caratteri minuscoli###   
    li s5,97
    li s4,122
    addi sp,sp,-4
    sw ra,0(sp) 
    jal recorsive_label
    lw ra, 0(sp)
    addi sp,sp,4
    
###caratteri maiuscole###    
    li s5,65
    li s4,90
    addi sp,sp,-4
    sw ra,0(sp) 
    jal recorsive_label
    lw ra, 0(sp)
    addi sp,sp,4
    
    li s2,32
    addi a1,a1,1
    j end_rec

recorsive_label:
    
    lb s9,0(s10)
    lw s11,1(s10)
    li s2,0 #no exchanges
    
    #start with a valid letter
    blt s9,s5,loop
    bgt s9,s4,loop
    li s2,1
    ##confronto qui
loop:
    beq s11,t3,end_loop
    lb s7,0(s11)
    blt s7,s5,not_exc
    bgt s7,s4,not_exc
    
    blt s9,s5,exc_anyway
    bgt s9,s4,exc_anyway
    #sia s9 che s7 sono nel range se si arriva a questa parte del codice
    bgt s7,s9,not_exc
exc_anyway:
    #si ricerca il migliore da mettere in quella posizione scorrendo tutto e poi
    #Si passa al successivo e si sposta s10 di una casella
    addi a7,s9,0 #salva carattere scambio
    addi a6,s11,0 #indirizzo di scambio
    addi s9,s7,0 #exc
    sb a7,0(a6)
    sb s9,0(s10)
    li s2,1
        
not_exc:   
    lw s11,1(s11)
    j loop
    
end_loop:
    #se non ci sono stati scambi non mando avanti il puntatore dell' ordinamento-
    #-ne ciclo di nuovo per la stessa lettera
    beq s2,zero,end_rec 
    lw s10,1(s10)#mando avanti cursore
end_loop_no_upd: 
    beq s10,t3, end_rec ##S11
    addi sp,sp,-4
    sw ra,0(sp)
    jal recorsive_label
    lw ra, 0(sp)
    addi sp,sp,4
    
end_rec: 
    jr ra
    
    
#####################################################################################    
############### OTHER METHODS ################################################
#####################################################################################

## Trovare la lettera successiva nell'input
next_letter:
    addi t1,t1,1 #next letter
    lb t0, 0(t1)
    jr ra
    
## Serve per trovare i primi 5 byte vuoti contigui
## per l'add 
find_space:
                  #a3 conterra' il primo indirizzo da cui iniziare ad analizzare
    lb s11, 0(a3) #vedere se e' vuoto il primo byte che conterra l'elemento
    addi a3,a3,1  #byte successivo
    bne s11, zero,find_space #se non lo e' rianalizzo quello dopo
    lw s11,0(a3)  #4 byte successivi(notare sono gia andato avanti di uno quindi off=0)
    bne s11,zero,find_space
    addi a3,a3,-1
                  #a3 conterra' 5 byte liberi successivi
    jr ra


## Questo metodo serve per individuare se e' un reale comando o una istruzione tipo:
## ADD(A)AA ~ REV    A~
after_brackets: 
    addi sp,sp,-4
    sw ra,0(sp) 
    jal next_letter
    lw ra, 0(sp)
    addi sp,sp,4
    beq t0,zero,end_brackets ## l'ultima istruzione ha '\0'
    beq t0,s6,end_brackets   ## senn? ha '~'
    bne t0,s2,ignore_until_tilde
    j after_brackets
end_brackets:
    jr ra

end:
li a2,30