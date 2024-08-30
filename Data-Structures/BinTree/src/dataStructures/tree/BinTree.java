/* 
 * Estructuras de Datos
 * 2.º Grado en Ingeniería Informática, del Software y Computadores. UMA.
 *
 * Práctica evaluable 7. Enero 2021.
 *
 * Apellidos, Nombre: Garcia Fernandez, Isidro Javier
 * Grupo: 2º Ing Informatica + Matematicas
 */

package dataStructures.tree;

import dataStructures.list.List;
import dataStructures.list.LinkedList;

public class BinTree<T extends Comparable<? super T>> {

    private static class Tree<E> {
        private E elem;
        private Tree<E> left;
        private Tree<E> right;

        public Tree(E e, Tree<E> l, Tree<E> r) {
            elem = e;
            left = l;
            right = r;
        }
    }

    private Tree<T> root;

    public BinTree() {
        root = null;
    }

    public BinTree(T x) {
        root = new Tree<>(x, null, null);
    }

    public BinTree(T x, BinTree<T> l, BinTree<T> r) {
        root = new Tree<>(x, l.root, r.root);
    }

    public boolean isEmpty() {
        return root == null;
    }

    /**
     * Returns representation of tree as a String.
     */
    @Override
    public String toString() {
        return getClass().getSimpleName() + "(" + toStringRec(this.root) + ")";
    }

    private static String toStringRec(Tree<?> tree) {
        return tree == null ? "null" : "Node<" + toStringRec(tree.left) + ","
                + tree.elem + "," + toStringRec(tree.right)
                + ">";
    }

    /**
     * Returns a String with the representation of tree in DOT (graphviz).
     */
    public String toDot(String treeName) {
        final StringBuffer sb = new StringBuffer();
        sb.append(String.format("digraph %s {\n", treeName));
        sb.append("node [fontname=\"Arial\", fontcolor=red, shape=circle, style=filled, color=\"#66B268\", fillcolor=\"#AFF4AF\" ];\n");
        sb.append("edge [color = \"#0070BF\"];\n");
        toDotRec(root, sb);
        sb.append("}");
        return sb.toString();
    }

    private void toDotRec(Tree<T> current, StringBuffer sb) {
        if (current != null) {
            final int currentId = System.identityHashCode(current);
            sb.append(String.format("%d [label=\"%s\"];\n", currentId, current.elem));
            if (!isLeaf(current)) {
                processChild(current.left, sb, currentId);
                processChild(current.right, sb, currentId);
            }
        }
    }

    private static <T extends Comparable<? super T>> boolean isLeaf(Tree<T> current) {
        return current != null && current.left == null && current.right == null;
    }

    private void processChild(Tree<T> child, StringBuffer sb, int parentId) {
        if (child == null) {
            sb.append(String.format("l%d [style=invis];\n", parentId));
            sb.append(String.format("%d -> l%d;\n", parentId, parentId));
        } else {
            sb.append(String.format("%d -> %d;\n", parentId, System.identityHashCode(child)));
            toDotRec(child, sb);
        }
    }

    // Ejercicio 1

	public T maximum() { //  devuelve el maximo valor almacenado en un arbol binario
		// TODO
		return maximumRec(root);
	}
		private T maximumRec(Tree<T> node) {
	        if (node == null) {
	            throw new BinTreeException("Maximum on an empty tree");
	        }
	        
	        T elem = node.elem;
	        
	       if (isLeaf(node)) { // hoja, no sigo bajando
	            return elem;
	        }
	       else if (node.left == null) {
	         T maxDer = maximumRec(node.right); // miro en la rama derecha
	            if (elem.compareTo(maxDer) > 0) {
	                return elem;
	            }
	            else {
	                return maxDer;
	            	}
	           }  else if (node.right == null) {
	        	
	         T maxIzq = maximumRec(node.left); // miro en la rama izq
	            if (elem.compareTo(maxIzq) > 0) {
	                return elem;
	            } else {
	                return maxIzq;
	            	}
	            }
	        else {
	         T maxIzq = maximumRec(node.left); // miro en rama izquierda y en derecha
	         T maxDer = maximumRec(node.right);
	          if ((maxDer.compareTo(elem) > 0) && (maxDer.compareTo(maxIzq) > 0)) {
	                return maxDer;
	          } else if ((maxIzq.compareTo(elem) > 0) && (maxIzq.compareTo(maxDer) > 0)) {
	        	    return maxIzq;
	          }
	            else {
	                return elem; // el padre es mayor que sus hijos
	        }}
	    }
    // Ejercicio 2

    public int numBranches() { //  devuelve el numero de ramas que forman un arbol
    	// TODO
        if (root == null) {
            throw new BinTreeException("Number of Branches on an empty Tree");
        }

        if (isLeaf(root)) { //  Caso base (Nodo inicial es un nodo hoja = no hay mas hijos)
            return 0;
        } else if (root.right == null) {
            return numBranchesRec(root.left); //miramos rama izquierda
        } else if (root.left == null) {
            return numBranchesRec(root.right);  //miramos rama derecha
        } else {
            return numBranchesRec(root.left) + numBranchesRec(root.right); //miramos rama izquierda y derecha
        }
    }

	    private int numBranchesRec(Tree<T> node) {
	        
	    	if (isLeaf(node)) { // Nodo hoja = no tiene hijos
	            return 1; // contamos la rama que lo une a su padre
	        } else if (node.right == null) {
	            return numBranchesRec(node.left); //miramos rama izquierda
	        } else if (node.left == null) {
	            return numBranchesRec(node.right); //miramos rama derecha
	        } else {
	        	return numBranchesRec(node.left) + numBranchesRec(node.right); //Miramos rama izquierda y derecha
	        }}

    // Ejercicio 3

    public List<T> atLevel(int i) {
        // TODO
    	if (root == null) {
    		throw new BinTreeException("List of elems in an empty Tree");
    	}
    	
        return null;
    }

    // Ejercicio 4

    public void rotateLeftAt(T x) {
        // TODO
    	if (root == null) {
    		throw new BinTreeException("List of elems in an empty Tree");
    	}
    }

    // Ejercicio 5

    public void decorate (T x) { //  todos los hijos del arbol han de tener nuevos hijos con valor de x
    	// TODO
        if (root == null) {
            throw new BinTreeException("Decorate an empty Tree");
        }

        if (isLeaf(root)) { //  Caso base (Nodo inicial es un nodo hoja = no hay mas hijos)
          root = new Tree<>(x, null, null);;
        } else if (root.right == null) {
            decorateRec(root.left, x); //miramos rama izquierda
        } else if (root.left == null) {
            decorateRec(root.right, x);  //miramos rama derecha
        } else {
            decorateRec(root.left, x);
            decorateRec(root.right, x); //miramos rama izquierda y derecha
        }
    }

	    private void decorateRec(Tree<T> node, T x) {
	        
	    	if (isLeaf(node)) { // Nodo hoja = no tiene hijos
	            node.right = new Tree<>(x, null, null); // a�adimos nuevo nodo
	            node.left = new Tree<>(x, null, null);
	        } else if (node.right == null) {
	            decorateRec(node.left, x); //miramos rama izquierda
	        } else if (node.left == null) {
	            decorateRec(node.right, x); //miramos rama derecha
	        } else {
	        	decorateRec(node.left, x);
	        	decorateRec(node.right, x); //miramos rama izquierda y derecha
	        }}
}
