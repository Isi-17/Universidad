/**
 * Práctica 6 - Arboles binarios de búsqueda aumentados
 * Estructuras de Datos.
 *
 * APELLIDOS, NOMBRE:
 *
 * Binary Search trees implementation using augmented nodes storing weight of nodes
 */


/**
 * Search tree implemented using an unbalanced binary search tree augmented with
 * weight on nodes. Note that elements should define an order relation (
 * {@link java.lang.Comparable}).
 *
 * @param <T>
 *            Type of keys.
 */
public class AugmentedBST<T extends Comparable<? super T>> {

    // class for implementing one node in a search tree
	private static class Tree <E > {
		E key ; // key stored in node
		int weight ; // weight of node ( number of keys in tree )
		Tree <E > left ; // left child
		Tree <E > right ; // right child

        public Tree(E k) {
            key = k;
            weight = 1;
            left = null;
            right = null;
        }
    }

    private Tree<T> root; // reference to root node of binary search tree
 
    public AugmentedBST() {
        root = null;
    }
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
            if (current.left != null) {
                sb.append(String.format("%s -> %s [label=%d];\n", current.key, current.left.key, weight(current.left)));
                toDotRec(current.left, sb);
            } else {
                sb.append(String.format("l%s [shape=circle, style=invis];\n", current.key));
                sb.append(String.format("%s -> l%s;\n", current.key, current.key));
            }
            if (current.right != null) {
                sb.append(String.format("%s -> %s [label=%d];\n", current.key, current.right.key, weight(current.right)));
                toDotRec(current.right, sb);
            } else {
                sb.append(String.format("r%s [shape=circle, style=invis];\n", current.key));
                sb.append(String.format("%s -> r%s;\n", current.key, current.key));
            }
        }
    }

    /**
     * <p>
     * Time complexity: O(1)
     */
    public boolean isEmpty() {
        return root == null;
    }

    private static <T> int weight(Tree<T> node) {
    	if (node == null) {
    		return 0;
    	} else {
        return node.weight;
    	}
    }

    /**
     * <p>
     * Time complexity: O(1)
     */
    public int size() {
        return weight(root);
    }

    /**
     * <p>
     * Time complexity: from O(log n) to O(n)
     */
    public void insert(T k) {
        root = insertRec(root, k);
    }

    // returns modified tree
    private Tree<T> insertRec(Tree<T> node, T key) {
        if (node == null) {
            node = new Tree<T>(key);
        } else if (key.compareTo(node.key) < 0)
            node.left = insertRec(node.left, key);
        else if (key.compareTo(node.key) > 0)
            node.right = insertRec(node.right, key);
        else
            node.key = key;

        // recompute weight for this node after insertion
        node.weight = 1 + weight(node.left) + weight(node.right);

        return node;
    }

    /**
     * <p>
     * Time complexity: from O(log n) to O(n)
     */
    public T search(T key) {
        return searchRec(root, key);
    }

    private static <T extends Comparable<? super T>> T searchRec(Tree<T> node, T key) {
        if (node == null)
            return null;
        else if (key.compareTo(node.key) < 0)
            return searchRec(node.left, key);
        else if (key.compareTo(node.key) > 0)
            return searchRec(node.right, key);
        else
            return node.key;
    }

    /**
     * <p>
     * Time complexity: from O(log n) to O(n)
     */
    public boolean isElem(T key) {
        return search(key) != null;
    }

    /**
     * precondition: node and temp are non-empty trees Removes node with minimum
     * key from tree rooted at node. Before deletion, key is saved into temp
     * node. returns modified tree (without min key)
     */
    private static <T extends Comparable<? super T>> Tree<T> split(
            Tree<T> node, Tree<T> temp) {
        if (node.left == null) {
            // min node found, so copy min key in temp node
            temp.key = node.key;
            return node.right; // remove node
        } else {
            // remove min from left subtree
            node.left = split(node.left, temp);
            return node;
        }
    }

    /**
     * <p>
     * Time complexity: from O(log n) to O(n)
     */
    public void delete(T key) {
        root = deleteRec(root, key);
    }

    // returns modified tree
    private Tree<T> deleteRec(Tree<T> node, T key) {
        if (node == null)
            ; // key not found; do nothing
        else {
            if (key.compareTo(node.key) < 0)
                node.left = deleteRec(node.left, key);
            else if (key.compareTo(node.key) > 0)
                node.right = deleteRec(node.right, key);
            else {
                if (node.left == null)
                    node = node.right;
                else if (node.right == null)
                    node = node.left;
                else
                    node.right = split(node.right, node);
            }
            // recompute weight for this node after deletion
            node.weight = 1 + weight(node.left) + weight(node.right);
        }
        return node;
    }

    /**
     * Returns representation of tree as a String.
     */
    @Override
    public String toString() {
        String className = getClass().getName().substring(
                getClass().getPackage().getName().length() + 1);
        return className + "(" + toStringRec(this.root) + ")";
    }

    private static String toStringRec(Tree<?> tree) {
        return tree == null ? "null" : "Node<" + toStringRec(tree.left) + ","
                + tree.key + "," + tree.weight + "," + toStringRec(tree.right)
                + ">";
    }

    // You should provide EFFICIENT implementations for the following methods

    // returns i-th smallest key in BST (i=0 means returning the smallest value
    // in tree, i=1 the next one and so on).
    public T select(int i) {
    	if ( i < 0 || i >= weight (root)) {
    		return null;
    	}
    	else {
    		
    	return selectRec(root, i);
    	}
    }
			    private static <T extends Comparable <? super T >> T selectRec (Tree <T> current, int i) {
					if( i == weight (current.left)) {
						return current.key;
					}
					else if (i < weight(current.left)) {
						return selectRec(current.left, i);
					}
					else {
						return selectRec(current.right, i - weight (current.left) -1);
					}
			    	
			    }

    // returns largest key in BST whose value is less than or equal to k.
    public T floor(T k) {
        return floorRec(root, k);
    }
			    private static <T extends Comparable <? super T>> T floorRec (Tree <T> current, T k) {
			    	if( current == null) {
			    		return null;
			    	}
			    	else if (current.key.compareTo(k) == 0) {
			    		return current.key;
			    	}
			    	else if (current.key.compareTo(k) < 0) {
			    		return choose(current.key, floorRec(current.right, k));
			    	}
			    	else {
			    		return floorRec(current.left, k);
			    	}
			    }
    private static <T extends Comparable <? super T>> T choose (T candidate, T maybeBetter) {
    	if (maybeBetter != null) {
    		return maybeBetter;
    	}
    	else {
    	return candidate;
    	}
    }
    
    
    

    // returns smallest key in BST whose value is greater than or equal to k.
    public T ceiling(T k) {
        return ceilingRec(root, k);
    }
			    private static <T extends Comparable <? super T>> T ceilingRec (Tree <T> current, T k) {
			    	if( current == null) {
			    		return null;
			    	}
			    	else if (current.key.compareTo(k) == 0) {
			    		return current.key;
			    	}
			    	else if (current.key.compareTo(k) > 0) {
			    		return choose(current.key, floorRec(current.left, k));
			    	}
			    	else {
			    		return floorRec(current.right, k);
			    	}
			    }

    // returns number of keys in BST whose values are less than k.
    public int rank(T k) {
        return rankRec(root, k);
    }
		    private static <T extends Comparable <? super T >> int rankRec (Tree <T> current, T k) {
		    	if(current == null) {
		    		return 0;
		    	}
		    	else if (current.key.compareTo(k) == 0) {
		    		return weight(current.left);
		    	}
		    	else if (current.key.compareTo(k) < 0){
		    		return weight(current.left) + 1 + rankRec(current.right, k);
		    	}
		    	else {
		    		return rankRec(current.left, k);
		    	}
		    }

    // returs number of keys in BST whose values are in range lo to hi.
    public int size(T low, T high) {    	
    	return sizeRec(root, low, high);
    }
    		private static <T extends Comparable <? super T >> int sizeRec (Tree <T> current, T bajo, T alto){
    			
    			if (current == null) {
    				return 0;
    			}
    			else if (current.key.compareTo(bajo) < 0) {
    				return sizeRec(current.right, bajo, alto);
    			}
    			else if (current.key.compareTo(alto) > 0) {
    				return sizeRec(current.left, bajo, alto);
    			}
    			else {
    				return 1 + sizeRec(current.left, bajo, alto) + sizeRec(current.right, bajo, alto);
    			}
    		}
}