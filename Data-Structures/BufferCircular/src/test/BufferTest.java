package test;


import static org.junit.Assert.*;

import org.junit.After;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.ExpectedException;

import buffer.Buffer;
import buffer.BufferVacioException;
import buffer.BufferLlenoException;

public class BufferTest { //para ejecutar, click derecho sobre BufferTest.java, Run As, JUnitTest
	private static final int CAPACIDAD = 3;
	private Buffer<Integer> buf;
	
	@Rule
	public ExpectedException excepcionEsperada = ExpectedException.none();
	//en un metodo de prueba esperamos esta excepción.
	//esto se usa para los test donde esperamos que salte una excepción
	
	@Before //antes de que se ejecuten las pruebas, se ejecuta setUp() (before)
	public void setUp() throws Exception{
		buf = new Buffer<Integer>(CAPACIDAD); //creamos un buffer de tamaño CAPACIDAD con readIndex = writeIndex = 0
	}
	
	@After //Se ejecuta después de cada prueba (after)
	public void tearDown() throws Exception{
		buf = null;
	}
	
	@Test //Prueba que al inicializar un buffer, éste está vacío
	public void bufferInicializadoVacio() {
		assertTrue("Error: el buffer debería estar vacío", buf.isEmpty()); 
		//confirma que debe ocurrir el segundo argumento. Si no, aparece el primer argumento.
	}
	
	@Test //Prueba que al inicializar un buffer, éste no puede estar lleno
	public void bufferInicializadoNoLleno() {
		assertFalse("Error: el buffer no puede estar lleno", buf.isFull());
		//confirma que NO ocurre lo segundo. Si sí ocurre, aparece el primer argumento.
	}

	@Test //Prueba que si insertamos tantos elementos como la capacidad del buffer, éste debe estar lleno
	public void bufferLleno() throws BufferLlenoException {
		//Llenamos el buffer:
		for(int i = 0; i < CAPACIDAD; i++) {
			buf.put(i);
		}
		//Comprobamos que está lleno
		assertTrue("Error: el buffer debería estar lleno", buf.isFull());
		//confirma que ocurre lo segundo (está lleno). Si no ocurre, aparece el primer argumento.
	}

	@Test //Prueba que al llenar un buffer y luego vaciarlo, el buffer debe estar vacío
	public void bufferLlenoVacio() throws BufferLlenoException, BufferVacioException {
		//Llenamos el buffer:
		for(int i = 0; i < CAPACIDAD; i++) {
			buf.put(i);
		}
		//Extraemos todos los elementos del buffer:
		for(int i = 0; i < CAPACIDAD; i++) {
			buf.get();
		}
		assertTrue("Error: el buffer debería estar vacío", buf.isEmpty());
		//confirma que ocurre lo segundo. Si no ocurre, aparece el primer argumento.
	}
	
	@Test //Prueba que al introducir un elemento y luego leerlo, se lee el valor que se ha introducido
	public void insertarEelemento() throws BufferVacioException, BufferLlenoException {
		//Insertamos un elemento
		buf.put(1);
		//Comprobamos que se ha insertado el elemento indicado
		assertEquals("Error: el elemento debería ser 1", Integer.valueOf(1), buf.peek());
		assertEquals("Error: el elemento debería ser 1", Integer.valueOf(1), buf.get());
		//Comprueba que el argumento 2 y 3 coinciden. Si no, muestra el primer argumento.
		
		//Si hicieramos primero el assert de con buf.get y luego con buf.peek nos saltaría un error, ya que el get toma el valor 1
		// y avanza en el indice de lectura, por lo que luego el metodo peek nos dará el siguiente elemento, no 1
		
	}
	@Test //Prueba que al añadir varios elementos y extraerlos, estos coinciden
	public void insertarYLeerVariosElementos() throws BufferLlenoException, BufferVacioException {
		//Llenamos el buffer
		for (int i = 0; i < CAPACIDAD; i++) {
			buf.put(i);
		} // ahora el buffer es [0, 1, 2]
		//Consultamos y extraemos los elementos, comprobando que son los que deben ser:
		for (int i = 0; i< CAPACIDAD; i++) {
			assertEquals("El elemento debería ser " + i, Integer.valueOf(i), buf.peek());
			assertEquals("El elemento debería ser " + i, Integer.valueOf(i), buf.get());
		} //de nuevo si ponemos el assert del get antes del de peek nos dará error.
		  //si sólo ponemos el assert del peek tambien nos da error, ya que necesitamos el del get para que avance el indice de lectura
		  //funciona tambien si sólo ponemos el assert del get (sin el assert del peek)
	}		
	
	@Test //Prueba que al intentar consultar un buffer vacío, salta la excepción BufferVacioException
	public void peekDeBufferVacio() throws BufferVacioException{
		excepcionEsperada.expect(BufferVacioException.class); //instancio la clase de la excepcion que espero que salte
		//en el código que viene luego, debería de saltar la excepcion que hemos pedido en la linea de arriba
		buf.peek(); //debe salir una excepcion de BufferVacioException
		//Si no salta la excepción dará un fallo en el test y sale:
		// java.lang.AssertionError: Expected test to throw an instance of buffer.BufferVacioException

	}
	@Test //Prueba que al intentar extraer de un buffer vacío, salta la excepción BufferVacioException
	public void getDeBufferVacio() throws BufferVacioException{
		excepcionEsperada.expect(BufferVacioException.class); //instancio la clase de la excepcion que espero que salte
		//en el código que viene luego, debería de saltar la excepcion que hemos pedido en la linea de arriba
		buf.get(); //debe salir una excepcion de BufferVacioException
		//Si no salta la excepción dará un fallo en el test y sale:
		// java.lang.AssertionError: Expected test to throw an instance of buffer.BufferVacioException

	}
	@Test //Prueba que al insertar CAPACIDAD-1 elementos y extraer CAPACIDAD elementos, salta la excepcion BufferVacioException
	public void insertoLuegoExtraigo() throws BufferVacioException, BufferLlenoException{
		excepcionEsperada.expect(BufferVacioException.class); //instancio la clase de la excepcion que espero que salte
		//en el código que viene luego, debería de saltar la excepcion que hemos pedido en la linea de arriba
		
		for(int i = 0; i < CAPACIDAD-1; i++) {
			buf.put(i);
		}
		for(int i=0; i < CAPACIDAD; i++) {
			buf.peek(); //debe salir una excepcion de BufferVacioException
			buf.get(); //debe salir una excepcion de BufferVacioException
			//si sólo ponemos peek nos da error, ya que necesitamos el del get para que avance el indice de lectura
			//funciona tambien si sólo ponemos el get (sin el peek)
			
		//Si no salta la excepción dará un fallo en el test y sale:
		// java.lang.AssertionError: Expected test to throw an instance of buffer.BufferVacioException
		}
	}
	
}
