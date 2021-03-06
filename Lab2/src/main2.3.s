	.syntax unified
	.cpu cortex-m4
	.thumb

.data
	arr1: .byte 0x19, 0x34, 0x14, 0x32, 0x52, 0x23, 0x61, 0x29
	arr2: .byte 0x18, 0x17, 0x33, 0x16, 0xFA, 0x20, 0x55, 0xAC

.text
    //.global main

do_sort:
    //TODO
	movs r1, 1
for1tst:
	cmp r1, 8
	bge exit1
	adds r2, r1, -1
for2tst:
	cmp r2, 0
	blt exit2
	ldrb r3,[r0,r2]			// load word v[j] into r3
	adds r7, r2, 1
	ldrb r4,[r0,r7]			//load word v[j+1] into r4
	cmp r4, r3
	ble exit2
	ldrb r5, [r0,r2]
	adds r7, r2, 1
	ldrb r6, [r0,r7]
	strb r6, [r0,r2]
	adds r7, r2, 1
	strb r5, [r0,r7]
	adds r2, r2, -1
	b for2tst
exit2:
	adds r1, 1
	b for1tst
exit1:  bx lr

main:
    ldr r0, =arr1
    bl do_sort
    ldr r0, =arr2
    bl do_sort

L: b L
