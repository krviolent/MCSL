	.syntax unified
	.cpu cortex-m4
	.thumb

.text
    //.global main
	.equ N, 30

fib:
    //TODO
    cmp r0, #1
    blt L1
    cmp r0, #100
    bgt L1
    cmp r0, #46
    bgt L2
    cmp r0, #1
	beq L3
	cmp r0, #2
	beq L3
	b L4
L1: movs r4, #0
	subs r4, #1
	bx lr				//return -1
L2: movs r4, #0
	subs r4, r4, #2
    bx lr				//return -2
L3: movs r4, #1			//return 1
	bx lr				//return to caller
L4:	adds sp, sp, -12	//adiust stack for 3 items
    adds r6, sp, #8
    str r5,[r6]
	adds r6, sp, #4
	str lr,[r6]			//save the return address
	str r0, [sp]		//save the argument n
	adds r0, r0, -1		//n >= 2, argument gets (n-1)
	bl fib				//call fib with (n-1)
	ldr r0,[sp]			//return from jal, restore argument n
	adds r6, sp, #4
	ldr lr,[r6]			//restore the return address
	adds r6, sp, #8
	ldr r5,[r6]
	adds sp, sp, 12	 	//adiust stack for 3 items
	movs r5, r4
	adds sp, sp, -12	//adiust stack for 3 items
    adds r6, sp, #8
    str r5,[r6]
	adds r6, sp, #4
	str lr,[r6]			//save the return address
	str r0, [sp]		//save the argument n
	adds r0, r0, -2
	bl fib				//call fib with (n-2)
	ldr r0,[sp]			//return from jal, restore argument n
	adds r6, sp, #4
	ldr lr,[r6]			//restore the return address
	adds r6, sp, #8
	ldr r5,[r6]
	adds sp, sp, 12
	adds r4, r5, r4		//return fib(n-1) + fin(n-2)
	bx lr				//return to the caller

main:
    movs r0, #N
    bl fib

L: b L
