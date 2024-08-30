package es.uma.informatica.sii.jpa.proyectos;

import java.util.Date;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.OneToMany;

/* Autor: Isidro Javier Garcia Fernandez
 * CREATE TABLE PROYECTO (ID BIGINT NOT NULL, DETALLE VARCHAR, FECHAALTA DATE, NOMBRE VARCHAR, PRIMARY KEY (ID))
 * CREATE TABLE TAREA (ID BIGINT NOT NULL, DESCRIPCION VARCHAR, ESFUERZO DOUBLE, FECHAFIN DATE, FECHAINICIO DATE, NOMBRE VARCHAR, PROYECTO_ID BIGINT NOT NULL, PRIMARY KEY (ID, PROYECTO_ID))
 * ALTER TABLE TAREA ADD CONSTRAINT FK_TAREA_PROYECTO_ID FOREIGN KEY (PROYECTO_ID) REFERENCES PROYECTO (ID)
*/
@Entity
public class Proyecto {
	@Id
	private Long id;
	
	private String nombre;
	@Column(name = "DETALLE")
	private String descripcion;
	@Temporal(TemporalType.DATE)
	private Date fechaAlta;
	@OneToMany(mappedBy = "proyecto")
	private Set<Tarea> tareas;
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((id == null) ? 0 : id.hashCode());
		return result;
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Proyecto other = (Proyecto) obj;
		if (id == null) {
			if (other.id != null)
				return false;
		} else if (!id.equals(other.id))
			return false;
		return true;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public Set<Tarea> getTareas() {
		return tareas;
	}
	public void setTareas(Set<Tarea> tareas) {
		this.tareas = tareas;
	}
	public Date getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

}
