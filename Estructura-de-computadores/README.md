# ENLACE AL VÍDEO DEMO

https://youtu.be/o5ss09l_cd4

# INTENCIÓN DE PROYECTO

Voy a intentar reproducir la canción "JoJo's Bizarre Adventure:Golden Wind OST: Giorno's Theme "Il vento d'oro" (Main Theme)" (https://youtu.be/U0TXIXTzJEY)

Mi intención es que a cada nota (o nota cercana) se le asocie una luz en concreto y que al cambiar el sonido cambie el led (como si fuera un piano). Utilizaré interrupciones para que, pulsando un botón pueda pausar la canción, y pulsando de nuevo (o pulsando otro) se reproduzca de nuevo (con rutinas de tratamiento IRQ y FIQ).

# RESULTADO DEL PROYECTO

Suena la melodía "JoJo's Bizarre Adventure: Golden Wind OST: ~Giorno's Theme ~ Il vento d'oro" a través del SPEAKER (GPIO 4), de manera que a cada nota se le asocie una led diferente (GPIO 9, 10, 11, 17, 22, 27). Dicha canción se emite estableciendo las frecuencias de las distintas notas de la melodía. Mi intención es asociar a cada nota un led distinto y de manera que una nota grave tenga una led asociada más a la izquierda y las notas mas agudas luces más a la derecha. De esta manera quiero que se asemeje a lo que es un teclado o piano.

En el documento ```notas.inc```  establezco los valores de realizar la operación (1000000/Freq) donde _Freq_ es la frecuencia de cada una de las notas utilizadas en la canción. Además, establezco los distintos ritmos que se pueden encontrar en la melodía (Negras, Blancas, Semicorcheas, etc).

En el documento ```Melodia.inc``` hago dos arrays o listas: una consiste en la melodía de la canción incluyendo silencios y otra lista corresponde con el ritmo o duración de cada elemento del array de las notas.

Utilizo también el documento ```inter.inc``` como ayuda o guía.

En el documento del proyecto: ```proyecto.s``` la interrupción IRQ la utilizo simplemente para recorrer el array o lista de luces (GPIO's 9, 10, 11, 17, 22, 27). La interrupción FIQ la utilizo para que el SPEAKER funcione, otorgándole la frecuencia y duración de cada una de las notas, que vaya recorriendo el array de ```Melodia.inc```.

El fin del tratamiento de la interrupción IRQ consiste en que si el PUSH_BUTTON 1 se ha activado (variable _controlB_ = 1) se pausa la música y las luces, es decir, se deja de recorrer el array tanto de luces como el de las notas.

El fin de tratamiento de la interrupción FIQ consiste en programar el retardo o pausa según el valor de la variable _indice_.

# DIFICULTADES

En cuanto a dificultades durante la realización del proyecto, como la rapsberry emite el sonido el tiempo que viene dado por el ritmo asociado (negra, blanca), dura exactamente el tiempo de cada uno de los ritmos, de manera que si tengo la misma nota con una duración x, se escuchará la nota con una duración 2x. Por eso he declarado un nuevo ritmo denominado _SEPARANOTAS_ con un tiempo de 0,008 segundos de manera que se note una separación entre las notas que son iguales y se encuentran consecutivas entre sí.

También he tenido alguna dificultad no importante como que el array tanto de notas como de duraciones se leía de arriba a abajo (más intuitivo) y el array de las bombillas (LEDS) se recorre de abajo a arriba. Sin embargo no lo he modificado y eso me ha supuesto algunos quebraderos de cabeza al sincronizar qué bombilla asociar a cada sonido de la canción.
