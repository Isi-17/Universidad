package es.uma.informatica.sii.jpa.proyectos;

import java.io.Closeable;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

/**
 * Esta clase servirá para centralizar todas las operaciones relacionadas con la 
 * gestión de los datos relativos a los proyectos y sus tareas. 
 * Recuerde que las operaciones que modifiquen la base de datos deben ejecutarse dentro
 * de una transacción.
 * @author francis
 *
 *CREATE TABLE PROYECTO (ID BIGINT NOT NULL, DETALLE VARCHAR, FECHAALTA DATE, NOMBRE VARCHAR, PRIMARY KEY (ID))
 *CREATE TABLE TAREA (ID BIGINT NOT NULL, DESCRIPCION VARCHAR, ESFUERZO DOUBLE, FECHAFIN DATE, FECHAINICIO DATE, NOMBRE VARCHAR, PROYECTO_ID BIGINT NOT NULL, PRIMARY KEY (ID, PROYECTO_ID))
 *ALTER TABLE TAREA ADD CONSTRAINT FK_TAREA_PROYECTO_ID FOREIGN KEY (PROYECTO_ID) REFERENCES PROYECTO (ID)
 */
public class AccesoDatos implements Closeable {
	
	private EntityManagerFactory emf;
	private EntityManager em;
	
	/**
	 * Constructor por defecto. Crea un contexto de persistencia.
	 */
	public AccesoDatos() {
		emf = Persistence.createEntityManagerFactory("p2-jpa");
		em = emf.createEntityManager();
	}
	
	/**
	 * Cierra el contexto de persistencia.
	 */
	@Override
	public void close() {
		em.close();
		emf.close();
	}	
}
