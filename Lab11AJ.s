/* Programa Laboratorio no.10 */

/* Autor: José Rodolfo Pérez  */
/* Carné: 16056 */
/* Autor: Ana Lucia Leppe  */
/* Carné: 151378 */

/* Descripcion del Porgrama: programa que enciende 3 leds consecutivamente */ 

.text
.align 2
.global main
main:
	@utilizando la biblioteca GPIO (gpio0_2.s)
	bl GetGpioAddress @solo se llama una vez

	@GPIO para lectura (entrada) puerto 14 
	mov r0,#14
	mov r1,#0
	bl SetGpioFunction

	@GPIO para escritura (salida) puerto 15
	mov r0,#15
	mov r1,#1
	bl SetGpioFunction

	@GPIO para escritura (salida) puerto 18 
	mov r0,#18
	mov r1,#1
	bl SetGpioFunction

	@GPIO para escritura (salida) puerto 23 
	mov r0,#23
	mov r1,#1
	bl SetGpioFunction

	@Apagar GPIO 15
	mov r0,#15
	mov r1,#0
	bl SetGpio

	@Apagar GPIO 18
	mov r0,#18
	mov r1,#1
	bl SetGpio

	@Apagar GPIO 23
	mov r0,#23
	mov r1,#1
	bl SetGpio

	bl wait

loop:
	ldr r6, =myloc
 	ldr r0, [r6]		@ obtener direccion de la memoria virtual 
	ldr r5,[r0,#0x34]	@Direccion r0+0x34:lee en r5 estado de puertos de entrada
	mov r7,#1
	lsl r7,#14
	and r7,r5,r7 		@se revisa el bit 14 (puerto de entrada)

	@Si el boton esta en alto (1), fue presionado y enciende GPIO 15
	teq r7,#0

	bne paso2
	@bl wait
	b loop

paso2:
	ldr r6, =myloc
 	ldr r0, [r6]		@ obtener direccion de la memoria virtual 
	ldr r5,[r0,#0x34]	@Direccion r0+0x34:lee en r5 estado de puertos de entrada
	mov r7,#1
	lsl r7,#15
	and r7,r5,r7 		@se revisa el bit 15 (puerto de salida)

	teq r7, #0
	beq salida1
	bne paso3
	b loop

paso3:
	ldr r6, =myloc
 	ldr r0, [r6]		@ obtener direccion de la memoria virtual 
	ldr r5,[r0,#0x34]	@Direccion r0+0x34:lee en r5 estado de puertos de entrada
	mov r7,#1
	lsl r7,#23
	and r7,r5,r7 		@se revisa el bit 18 (puerto de salida)

	teq r7, #0
	beq salida2
	bne paso4
	b loop

paso4:
	ldr r6, =myloc
 	ldr r0, [r6]		@ obtener direccion de la memoria virtual 
	ldr r5,[r0,#0x34]	@Direccion r0+0x34:lee en r5 estado de puertos de entrada
	mov r7,#1
	lsl r7,#18
	and r7,r5,r7 		@se revisa el bit 23 (puerto de salida)

	teq r7, #0
	beq salida3
	bne loop
	b loop

salida1:
	mov r0,#15		@instrucciones para encender GPIO 15
	mov r1,#1
	bl SetGpio

	mov r0,#23		@instrucciones para encender GPIO 15
	mov r1,#0
	bl SetGpio
		
	b loop

salida2:
	mov r0,#23		@instrucciones para encender GPIO 18
	mov r1,#1
	bl SetGpio

	mov r0,#18		@instrucciones para encender GPIO 18
	mov r1,#0
	bl SetGpio
		
	b loop

salida3:
	mov r0,#18		@instrucciones para encender GPIO 23
	mov r1,#1
	bl SetGpio

	mov r0,#15		@instrucciones para encender GPIO 23
	mov r1,#0
	bl SetGpio
		
	b loop

wait:
 mov r0, #0x4000000 @ big number
sleepLoop:
 subs r0,#1
 bne sleepLoop @ loop delay
 mov pc,lr

 .data
 .align 2
.global myloc
myloc: .word 0

 .end
<<<<<<< HEAD

=======
>>>>>>> origin/master
