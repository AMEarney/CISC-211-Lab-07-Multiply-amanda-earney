/*** asmMult.s   ***/
/* Tell the assembler to allow both 16b and 32b extended Thumb instructions */
.syntax unified

#include <xc.h>

/* Tell the assembler that what follows is in data memory    */
.data
.align
 
/* define and initialize global variables that C can access */
/* create a string */
.global nameStr
.type nameStr,%gnu_unique_object
    
/*** STUDENTS: Change the next line to your name!  **/
nameStr: .asciz "Amanda Earney"  

.align   /* realign so that next mem allocations are on word boundaries */
 
/* initialize a global variable that C can access to print the nameStr */
.global nameStrPtr
.type nameStrPtr,%gnu_unique_object
nameStrPtr: .word nameStr   /* Assign the mem loc of nameStr to nameStrPtr */

.global a_Multiplicand,b_Multiplier,rng_Error,a_Sign,b_Sign,prod_Is_Neg,a_Abs,b_Abs,init_Product,final_Product
.type a_Multiplicand,%gnu_unique_object
.type b_Multiplier,%gnu_unique_object
.type rng_Error,%gnu_unique_object
.type a_Sign,%gnu_unique_object
.type b_Sign,%gnu_unique_object
.type prod_Is_Neg,%gnu_unique_object
.type a_Abs,%gnu_unique_object
.type b_Abs,%gnu_unique_object
.type init_Product,%gnu_unique_object
.type final_Product,%gnu_unique_object

/* NOTE! These are only initialized ONCE, right before the program runs.
 * If you want these to be 0 every time asmMult gets called, you must set
 * them to 0 at the start of your code!
 */
a_Multiplicand:  .word     0  
b_Multiplier:    .word     0  
rng_Error:       .word     0  
a_Sign:          .word     0  
b_Sign:          .word     0 
prod_Is_Neg:     .word     0  
a_Abs:           .word     0  
b_Abs:           .word     0 
init_Product:    .word     0
final_Product:   .word     0

 /* Tell the assembler that what follows is in instruction memory    */
.text
.align

    
/********************************************************************
function name: asmMult
function description:
     output = asmMult ()
     
where:
     output: 
     
     function description: The C call ..........
     
     notes:
        None
          
********************************************************************/    
.global asmMult
.type asmMult,%function
asmMult:   

    /* save the caller's registers, as required by the ARM calling convention */
    push {r4-r11,LR}
 
.if 0
    /* profs test code. */
    mov r0,r0
.endif
    
    /** note to profs: asmMult.s solution is in Canvas at:
     *    Canvas Files->
     *        Lab Files and Coding Examples->
     *            Lab 8 Multiply
     * Use it to test the C test code */
    
    /*** STUDENTS: Place your code BELOW this line!!! **************/
    LDR r2, =0 /* resets all variables to 0 */
    LDR r3, =rng_Error
    LDR r4, =a_Sign
    LDR r5, =b_Sign
    LDR r6, =prod_Is_Neg
    LDR r7, =a_Abs
    LDR r8, =b_Abs
    LDR r9, =init_Product
    LDR r10, =final_Product
    STR r2, [r3]
    STR r2, [r4]
    STR r2, [r5]
    STR r2, [r6]
    STR r2, [r7]
    STR r2, [r8]
    STR r2, [r9]
    STR r2, [r10]
    
    LDR r2, =a_Multiplicand /* puts the value in r0 into a_Multiplicand */
    STR r0, [r2]
    LDR r3, =b_Multiplier /* puts the value in r1 into b_Multiplier */
    STR r1, [r3]
    
    LDR r5, =32767 /* max value for multiplication to work */
    LDR r6, =-32768 /* min value for multiplication to work */
    CMP r0, r5 /* checks if the multiplicand is too big */
    BGT error_handling
    CMP r0, r6 /* checks if the multiplicand is too small */
    BLT error_handling
    
    CMP r1, r5 /* does the same thing for the multiplier */
    BGT error_handling
    CMP r1, r6
    BLT error_handling
    B mult_ok
    
error_handling:
    LDR r3, =1
    LDR r4, =rng_Error
    STR r3, [r4] /* sets rng_Error to 1 */
    MOV r0, 0 /* puts 0 in r0 */
    B done
    
mult_ok:
    LDR r2, =a_Multiplicand
    LDR r3, [r2] /* puts the multiplicand into r3 */
    LDR r8, =a_Sign
    LDR r6, =0
    LDR r7, =1
    TST r3, 32768 /* checks to see if bit 15 is set */
    STREQ r6, [r8] /* puts the correct value into a_Sign */
    STRNE r7, [r8]
    
    LDR r4, =b_Multiplier /* does same thing with multiplier */
    LDR r5, [r4] 
    LDR r8, =b_Sign
    LDR r6, =0
    LDR r7, =1
    TST r5, 32768
    STREQ r6, [r8] 
    STRNE r7, [r8]
    
    LDR r2, =a_Sign
    LDR r3, [r2] /* puts the sign of the multiplicand into r3 */
    LDR r4, =b_Sign 
    LDR r5, [r4] /* puts the sign of the multiplier into r5 */
    LDR r7, =0
    LDR r8, =1
    LDR r9, =prod_Is_Neg
    EORS r6, r3, r5 /* if this sets the z flag, the product should be positive */
    STREQ r7, [r9] /* sets prod_Is_Neg accordingly */
    STRNE r8, [r9]
    
    LDR r2, =a_Multiplicand
    LDR r3, [r2]
    LDR r4, =b_Multiplier
    LDR r5, [r4] 
    CMP r3, 0 /* checks if multiplicand is 0 */
    STREQ r7, [r9] 
    CMP r5, 0 /* checks if multiplier is 0 */
    STREQ r7, [r9] /* if either number is 0, sets prod_Is_Neg to 0 */
    
    LDR r2, =a_Multiplicand
    LDR r3, [r2] /* puts the multiplicand into r3 */
    LDR r4, =a_Sign 
    LDR r5, [r4] /* gets the sign bit of the multiplicand */
    TST r5, 1
    BEQ multiplicand_Pos /* if sign bit is 0, the multiplicand is positive */
    NEG r6, r3 /* otherwise, negate the multiplicand and store the result into a_Abs */
    LDR r7, =a_Abs 
    STR r6, [r7]
    B abs_Multiplier
    
multiplicand_Pos:
    LDR r2, =a_Multiplicand
    LDR r3, [r2] /* puts the multiplicand into r3 */
    LDR r4, =a_Abs
    STR r3, [r4] /* stores the positive multiplicand into a_Abs */
    
abs_Multiplier:
    LDR r2, =b_Multiplier
    LDR r3, [r2] /* puts the multiplier into r3 */
    LDR r4, =b_Sign 
    LDR r5, [r4] /* gets the sign bit of the multiplier */
    TST r5, 1
    BEQ multiplier_Pos /* if sign bit is 0, the multiplier is positive */
    NEG r6, r3 /* otherwise, negate the multiplier and store the result into b_Abs */
    LDR r7, =b_Abs 
    STR r6, [r7]
    B shift_and_add
    
multiplier_Pos:
    LDR r2, =b_Multiplier
    LDR r3, [r2] /* puts the multiplier into r3 */
    LDR r4, =b_Abs
    STR r3, [r4] /* stores the positive multiplier into b_Abs */
    
shift_and_add:
    LDR r2, =a_Abs /* initilize values before loop starts */
    LDR r3, [r2] /* multiplicand is stored in r3 */
    LDR r4, =b_Abs
    LDR r5, [r4] /* multiplier is stored in r5 */
    LDR r6, =0 /* accumulated product will be in r6 */
    
loop: 
    CBZ r5, loop_end /* when the multiplier is 0, the loop is over */
    TST r5, 1 /* sets z flag if LSB is 0 */
    ADDNE r6, r6, r3 /* if the LSB is 1, adds the multiplicand to the product */
    LSL r3, r3, 1 /* shifts the multiplicand to the left 1 bit */
    LSR r5, r5, 1 /* shifts the multiplier to the right 1 bit */
    B loop
    
loop_end:
    LDR r7, =init_Product 
    STR r6, [r7] /* puts the result of the loop into init_Product */
    
    LDR r2, =prod_Is_Neg
    LDR r9, [r2] /* gets the value of prod_Is_Neg in r9 */
    CMP r9, 0
    BEQ positive_product /* if r9 is 0, the product should be positive */
    NEG r6, r6 /* if the product should be negative, negates the result of the loop */
    
positive_product:
    LDR r8, =final_Product
    STR r6, [r8] /* stores the correct sign result into final_Product */
    LDR r0, [r8] /* puts the final product into r0 */
    
    /*** STUDENTS: Place your code ABOVE this line!!! **************/

done:    
    /* restore the caller's registers, as required by the 
     * ARM calling convention 
     */
    mov r0,r0 /* these are do-nothing lines to deal with IDE mem display bug */
    mov r0,r0 

screen_shot:    pop {r4-r11,LR}

    mov pc, lr	 /* asmMult return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




