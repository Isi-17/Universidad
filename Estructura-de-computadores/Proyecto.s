/*Suena la melodía "JoJo's Bizarre Adventure: Golden Wind OST: ~Giorno's Theme ~ Il vento d'oro" a través del SPEAKER (GPIO 4), de manera que a cada nota se le asocie una led diferente  (GPIO 9, 10, 11, 17, 22, 27).
Dicha canción se emite estableciendo las frecuencias de las distintas notas de la melodía.*/

.include "inter.inc"
.include "notas.inc"
.include "Melodia.inc"

controlSON : .word 0 @ Bit 0 = Estado del altavoz
ledst: .word 0
controlB: .word 2
controlLED : .word 1 @ Entre 1 y 109, LED a encender del array
indice: .word 0
array :
	.word 0b0000000000000000010000000000		@ GPIO10
	.word 0b0000000000100000000000000000		@ GPIO17
	.word 0
	.word 0b0000010000000000000000000000		@ GPIO22
	.word 0
	.word 0b1000000000000000000000000000		@ GPIO27
	.word 0
	.word 0b0000010000000000000000000000		@ GPIO22
	.word 0b0000000000000000100000000000		@ GPIO11
	.word 0b0000000000000000010000000000		@ GPIO10
	.word 0b0000000000000000100000000000		@ GPIO11
	.word 0
	.word 0b0000000000000000100000000000		@ GPIO11
	.word 0
	.word 0b0000000000000000100000000000		@ GPIO11		@2º parte*
	.word 0b0000000000000000010000000000		@ GPIO10
	.word 0b0000000000000000001000000000		@ GPIO9
	.word 0
	.word 0b0000000000000000100000000000		@ GPIO11
	.word 0
	.word 0b0000010000000000000000000000		@ GPIO22
	.word 0
	.word 0b0000000000000000100000000000		@ GPIO11
	.word 0
	.word 0b0000000000000000010000000000		@ GPIO10
	.word 0b0000000000000000100000000000		@ GPIO11
	.word 0
	.word 0b0000000000000000100000000000		@ GPIO11		@2º vez
	.word 0
	.word 0b0000000000000000100000000000		@ GPIO11
	.word 0b0000000000000000010000000000		@ GPIO10
	.word 0b0000000000100000000000000000		@ GPIO17
	.word 0
	.word 0b0000010000000000000000000000		@ GPIO22
	.word 0
	.word 0b1000000000000000000000000000		@ GPIO27
	.word 0
	.word 0b0000000000000000100000000000		@ GPIO11
	.word 0
	.word 0b0000000000000000010000000000		@ GPIO10
	.word 0b0000000000000000100000000000		@ GPIO11
	.word 0
	.word 0b0000000000000000100000000000		@ GPIO11		@2º parte
	.word 0
	.word 0b0000000000000000100000000000		@ GPIO11
	.word 0b0000000000000000010000000000		@ GPIO10
	.word 0b0000000000000000001000000000		@ GPIO9
	.word 0
	.word 0b0000000000000000100000000000		@ GPIO11
	.word 0
	.word 0b0000010000000000000000000000		@ GPIO22
	.word 0
	.word 0b0000000000000000100000000000		@ GPIO11
	.word 0
	.word 0b0000000000000000010000000000		@ GPIO10
	.word 0b0000000000000000100000000000		@ GPIO11
	.word 0
	.word 0b0000000000000000100000000000		@ GPIO11		@Tema Grave
	.word 0b0000010000000000000000000000		@ GPIO22
	.word 0b0000000000100000000000000000		@ GPIO17
	.word 0b1000000000000000000000000000		@ GPIO27
	.word 0b0000000000000000010000000000		@ GPIO10
	.word 0b0000000000000000100000000000		@ GPIO11
	.word 0b0000000000100000000000000000		@ GPIO17
	.word 0b1000000000000000000000000000		@ GPIO27
	.word 0b0000010000000000000000000000		@ GPIO22
	.word 0b0000000000100000000000000000		@ GPIO17		@Transición
	.word 0
	.word 0b1000000000000000000000000000		@ GPIO27
	.word 0b0000000000100000000000000000		@ GPIO17
	.word 0
	.word 0b0000000000100000000000000000		@ GPIO17
	.word 0b0000000000000000100000000000		@ GPIO11
	.word 0b0000000000000000010000000000		@ GPIO10
	.word 0b0000000000000000001000000000		@ GPIO9
	.word 0b0000000000000000010000000000		@ GPIO10
	.word 0b0000000000000000100000000000		@ GPIO11
	.word 0b0000000000100000000000000000		@ GPIO17
	.word 0b0000000000000000100000000000		@ GPIO11
	.word 0b0000000000000000010000000000		@ GPIO10
	.word 0
	.word 0b0000000000000000010000000000		@ GPIO10
	.word 0
	.word 0b0000000000100000000000000000		@ GPIO17		@2º vez
	.word 0b0000010000000000000000000000		@ GPIO22
	.word 0b1000000000000000000000000000		@ GPIO27
	.word 0b0000000000000000010000000000		@ GPIO10
	.word 0b0000000000000000100000000000		@ GPIO11
	.word 0b0000000000100000000000000000		@ GPIO17
	.word 0b0000000000000000100000000000		@ GPIO11
	.word 0b0000000000000000010000000000		@ GPIO10
	.word 0b0000000000000000001000000000		@ GPIO9
	.word 0b1000000000000000000000000000		@ GPIO27
	.word 0b0000000000100000000000000000		@ GPIO17
	.word 0
	.word 0b0000000000100000000000000000		@ GPIO17
	.word 0b0000000000000000100000000000		@ GPIO11
	.word 0b0000000000000000010000000000		@ GPIO10
	.word 0b0000000000000000001000000000		@ GPIO9
	.word 0b0000000000000000010000000000		@ GPIO10
	.word 0b0000000000000000100000000000		@ GPIO11
	.word 0b0000000000100000000000000000		@ GPIO17
	.word 0b0000000000000000100000000000		@ GPIO11
	.word 0b0000000000000000010000000000		@ GPIO10
	.word 0
	.word 0b0000000000000000010000000000		@ GPIO10
	.word 0
	.word 0b0000000000100000000000000000		@ GPIO17
	.word 0

.text
	
ADDEXC 0x18, irq_handler
ADDEXC 0x1c, fiq_handler

/*Codigo RPI3*/
/*
 mrs r0, cpsr
  mov r0, #0b11010011 @Modo SVC, FIQ&IRQ desact
  msr spsr_cxsf, r0
  add r0, pc, #4
  msr ELR_hyp, r0
  eret
*/

/* Inicializo la pila en modos FIQ, IRQ y SVC */
mov r0, # 0b11010001 @ Modo FIQ, FIQ & IRQ desact
msr cpsr_c, r0
mov sp, # 0x4000
mov r0, # 0b11010010 @ Modo IRQ, FIQ & IRQ desact
msr cpsr_c, r0
mov sp, # 0x8000
mov r0, # 0b11010011 @ Modo SVC, FIQ & IRQ desact
msr cpsr_c, r0
mov sp, # 0x8000000

/* Configuro GPIOs 4, 9, 10, 11, 17, 22 y 27 como salida */
ldr r0, = GPBASE
ldr r1, = 0b00001000000000000001000000000000
str r1, [ r0, # GPFSEL0 ]
/* guia bits xx999888777666555444333222111000 */
ldr r1, = 0b00000000001000000000000000001001
str r1, [ r0, # GPFSEL1 ]
ldr r1, = 0b00000000001000000000000001000000
str r1, [ r0, # GPFSEL2 ]

/* Programo C1 y C3 para dentro de 2 microsegundos */
ldr r0, = STBASE
ldr r1, [ r0, # STCLO ]
add r1, # 2
str r1, [ r0, # STC1 ]
add r1, #2
str r1, [ r0, # STC3 ]

/* Habilito C1 para IRQ */
ldr r0, = INTBASE
mov r1, # 0b0010
str r1, [ r0, # INTENIRQ1 ]
mov r1, #0b00000000001000000000000000000000

/* Habilito C3 para FIQ */
mov r1, # 0b10000011
str r1, [ r0, # INTFIQCON ]

/* Habilito interrupciones globalmente */
mov r0, # 0b00010011 @ Modo SVC, FIQ & IRQ activo
msr cpsr_c, r0

ldr r1, =controlB
mov r2, #1
mov r4, #2
ldr r0, =GPBASE

/* Vemos el valor de la variable controlB para saber que boton se pulsa */
bucle :
	
	ldr r3,[r0,#GPLEV0] @Boton GPIO2 izquierdo
	ands r3,#0b00000000000000000000000000000100 @Comprobamos boton1 (izq)
	streq r2, [r1]

	ldr r3,[r0,#GPLEV0] @Boton derecho GPIO3
	ands r3,#0b00000000000000000000000000001000 @Comprobamos boton2 (der)
	streq r4, [r1]
	
	b bucle
/* Rutina de tratamiento de interrupción IRQ */
irq_handler :
push { r0, r1, r2, r3, r4, r5, r6, r7 }

ldr r0, = GPBASE
ldr r6, =STBASE
ldr r2, =controlB

ldr r1, [r2]
cmp r1, #1 @Si r1 es 1 que pare la cancion
beq IRQOFF

recorrerArrayLuces:
	/* Apago todos LEDs */
	ldr r1, = controlLED
	ldr r2, = 0b00001000010000100000111000000000
	str r2, [ r0, # GPCLR0 ]
	ldr r2, [ r1 ] @ Leo variable controlLED
	subs r2, # 1 @ Decremento
	moveq r2, # 109 @ Si es 0, volver a 109
	str r2, [ r1 ] @ Escribo controlLED
	ldr r2, [ r1, r2, LSL #2 ] @ Leo secuencia
	str r2, [ r0, # GPSET0 ] @ Escribo secuencia en LEDs
	
/*Duracion del altavoz*/
altavoz:
	ldr r3, =indice @Leo variable notas
	ldr r5, =duratFS @Cargo duracion notas
	ldr r7, [r3]
	add r7, #1 @ incremento el contador
	cmp r7, #NUMNOTAS @Conpruebo si es 109 vuelve a 0
	moveq r7, #0
	ldr r4, [r5, r7, LSL #2]@leo secuencia notas
	str r7, [r3] @Guardo valor de la pila
	
IRQOFF:	@ FIN de la interrupción
/* Reseteo estado interrupción de C1 */
mov r2, # 0b0010
str r2, [ r6, # STCS ]


/* Programo siguiente interrupción dependiendo de la duracion de la nota */
ldr r2, [ r6, # STCLO ]
add r2, r4
str r2, [ r6, # STC1 ]


/* Recupero registros y salgo */
pop { r0, r1, r2, r3, r4, r5, r6, r7 }
subs pc, lr, #4

/* Rutina de tratamiento de interrupción FIQ */

fiq_handler :	@FIQ  se encarga de hacer funcionar el SPEAKER

ldr r7, = controlB	@ Comprobamos si controlB = 1 y saltamos
ldr r8,  [r7]
cmp r8, #1
beq FIQOFF

ldr r8, = GPBASE
ldr r9, = controlSON
ldr r11, =indice

/* Hago sonar altavoz invirtiendo estado de controlSON */
ldr r10, [ r9 ]
eors r10, #1
str r10, [ r9 ]

/* Leo notas y luego el elemento correspondiente en notaFS */
ldr r9, [r11]
ldr r10, =notaFS @Cargo nota correspondiente
ldr r12, [ r10, r9, LSL # 2]


/* Pongo estado altavoz según variable controlSON */
mov r10, # 0b10000 @ GPIO 4 ( altavoz )
streq r10, [ r8, # GPSET0 ]
strne r10, [ r8, # GPCLR0 ]



FIQOFF:	@FIN del tratamiento de la interrupcion
/* Reseteo estado interrupción de C3 */
saltoSilencio:
ldr r8, = STBASE
mov r10, # 0b1000
str r10, [ r8, # STCS ]

/* Programo retardo según valor de índice */
ldr r10, [ r8, # STCLO ]
add r10, r12
str r10, [ r8, # STC3 ]

/* Salgo de la RTI */
subs pc, lr, #4
