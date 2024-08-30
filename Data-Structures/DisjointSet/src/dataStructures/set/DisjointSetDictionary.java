/**
 * Estructuras de Datos. Grados en Informatica. UMA.
 * Examen de febrero de 2018.
 *
 * Apellidos, Nombre:
 * Titulacion, Grupo:
 */

package dataStructures.set;

import dataStructures.dictionary.AVLDictionary;
import dataStructures.dictionary.Dictionary;
import dataStructures.list.ArrayList;
import dataStructures.list.List;
import dataStructures.tuple.Tuple2;
public class DisjointSetDictionary<T extends Comparable<? super T>> implements DisjointSet<T> {

    private Dictionary<T, T> dic;

    /**
     * Inicializa las estructuras necesarias.
     */
    public DisjointSetDictionary() {
        // TODO
    	dic = new AVLDictionary<>();
    }

    /**
     * Devuelve {@code true} si el conjunto no contiene elementos.
     */
    @Override
    public boolean isEmpty() {
        // TODO
        return dic.isEmpty();
    }

    /**
     * Devuelve {@code true} si {@code elem} es un elemento del conjunto.
     */
    @Override
    public boolean isElem(T elem) {
        // TODO
        return dic.isDefinedAt(elem);
    }

    /**
     * Devuelve el numero total de elementos del conjunto.
     */

    @Override
    public int numElements() {
        // TODO
        return dic.size();
    }

    /**
     * Agrega {@code elem} al conjunto. Si {@code elem} no pertenece al
     * conjunto, crea una nueva clase de equivalencia con {@code elem}. Si
     * {@code elem} pertencece al conjunto no hace nada.
     */
    @Override
    public void add(T elem) {
        // TODO
    	if (!isElem(elem)) {
    		dic.insert(elem, elem);
    	}
    }

    /**
     * Devuelve el elemento canonico (la raiz) de la clase de equivalencia la
     * que pertenece {@code elem}. Si {@code elem} no pertenece al conjunto
     * devuelve {@code null}.
     */
    private T root(T elem) {
        // TODO
        if (!isElem(elem)) {
        	return null;
        }
        else {
        	T root = dic.valueOf(elem);
        	if (root != elem) {
        		root(root);
        	}
        	return root;
       	}
    }

    /**
     * Devuelve {@code true} si {@code elem} es el elemento canonico (la raiz)
     * de la clase de equivalencia a la que pertenece.
     */
    private boolean isRoot(T elem) {
        // TODO
        return root(elem).equals(elem);
    }

    /**
     * Devuelve {@code true} si {@code elem1} y {@code elem2} estan en la misma
     * clase de equivalencia.
     */
    @Override
    public boolean areConnected(T elem1, T elem2) {
        // TODO
        return dic.isDefinedAt(elem1) && dic.isDefinedAt(elem2) && root(elem1) == root(elem2);
    }

    /**
     * Devuelve una lista con los elementos pertenecientes a la clase de
     * equivalencia en la que esta {@code elem}. Si {@code elem} no pertenece al
     * conjunto devuelve la lista vacia.
     */
    @Override
    public List<T> kind(T elem) {
        // TODO
    	List<T> lista = new ArrayList <>();
    	if (dic.isDefinedAt(elem)) {
    		T raiz = root(elem);
    		for (Tuple2<T,T> tupla : dic.keysValues()) {
    			if (raiz == root(tupla._1())) {
    				lista.append(tupla._2());
    			}
    		}
    	}
        return lista;
    }

    /**
     * Une las clases de equivalencias de {@code elem1} y {@code elem2}. Si
     * alguno de los dos argumentos no esta en el conjunto lanzara una excepcion
     * {@code IllegalArgumenException}.
     */
    @Override
    public void union(T elem1, T elem2) {
        // TODO
    	if (!dic.isDefinedAt(elem1) || !dic.isDefinedAt(elem2)) {
    		throw new IllegalArgumentException();
    	} else {
    		T raiz1 = root(elem1);
    		T raiz2 = root(elem2);
    		assert raiz1 != null;
    		assert raiz2 != null;
    		if (raiz1.compareTo(raiz2) <= 0) {
    			dic.insert(raiz2, raiz1);
    		} else {
    			dic.insert(raiz1, raiz2);
    		}
    	}
    	
    	
    }



    /**
     * Devuelve una representacion del conjunto como una {@code String}.
     */
    @Override
    public String toString() {
        return "DisjointSetDictionary(" + dic.toString() + ")";
    }

	@Override
	public void flatten() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public List<List<T>> kinds() {
		// TODO Auto-generated method stub
		return null;
	}
}
