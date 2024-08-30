package buffer;

import java.util.ArrayList;
import java.util.List;


public class Buffer<T> {
	private List<T> lista = null;
	private int readIndex, writeIndex; //índice de lectura y de escritura
	private int nelem; //nº elementos que tiene la lista
	
	
	public Buffer(int size) { //constructor con tamaño del buffer
		lista = new ArrayList<T>(size);
		
		for (int i=0; i<size; i++)
			lista.add(null); // [NULL | NULL | ... | NULL ]
		
		nelem = 0;
		readIndex = writeIndex = 0;
	}
	
	public void put(T element) throws BufferLlenoException { //inserta un elemento
		if (isFull())
			throw new BufferLlenoException("Buffer lleno!!");
		
		lista.set(writeIndex, element); //en la posicion indice de escritura, añadimos element
		writeIndex = (writeIndex+1) % lista.size(); //aumentamos el indice de escritura que siempre es <lista.size()
		nelem++;
	}
	
	public T get() throws BufferVacioException {  //devuelve y extrae el último elemento del buffer y avanza el índice de lectura
		T elem = null;
		
		if (isEmpty())
			throw new BufferVacioException("Buffer vacío!!");

		elem = lista.get(readIndex); //extrae el elemento de la posicion readindex
		readIndex = (readIndex+1) % lista.size(); //aumentamos el indice de lectura
		nelem--;
		
		return elem;
	}
	
	public T peek() throws BufferVacioException { //devuelve el elemento del buffer del indice de lectura
		T elem = null;
		
		if (isEmpty())
			throw new BufferVacioException("Buffer vacío!!");
		
		elem = lista.get(readIndex);
		return elem;
	}
	
	public boolean isFull() {
		return nelem >= lista.size();		
	}
	
	public boolean isEmpty() {
		return nelem == 0;		
	}
	
	public String toString() {
		String content = "Buffer = [";
		
		for (int i=0; i<nelem; i++)
			content += lista.get((readIndex+i) % lista.size()).toString() + "; ";
		
		return content;
	}
}
