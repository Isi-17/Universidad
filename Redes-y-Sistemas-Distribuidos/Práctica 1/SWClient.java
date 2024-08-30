package es.uma.rysd.app;

import javax.net.ssl.HttpsURLConnection;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;

import com.google.gson.Gson;

import es.uma.rysd.entities.*;

public class SWClient {
	// TODO: Complete el nombre de la aplicación
    private final String app_name = "IsidroJavierGarciaFernandez";
    private final int year = 2021;
    
    private final String url_api = "https://swapi.dev/api/";

    // Métodos auxiliares facilitados
    
    // Obtiene la URL del recurso id del tipo resource
	public String generateEndpoint(String resource, Integer id){
		return url_api + resource + "/" + id + "/";
	}
	
	// Dada una URL de un recurso obtiene su ID
	public Integer getIDFromURL(String url){
		String[] parts = url.split("/");

		return Integer.parseInt(parts[parts.length-1]);
	}
	
	// Consulta un recurso y devuelve cuántos elementos tiene
	public int getNumberOfResources(String resource){    	
		// TODO: Trate de forma adecuada las posibles excepciones que pueden producirse
		
    	// TODO: Cree la URL correspondiente: https://swapi.dev/api/{recurso}/ reemplazando el recurso por el parámetro 
		URL url = null;
		try {
		url = new URL(url_api + resource + "/" );
		} catch (Exception e) {
			System.err.println(e.getMessage()); //url incorrecta
		}
		
    	// TODO: Cree la conexión a partir de la URL		
		HttpsURLConnection connection = null;
		try {
			connection =  (HttpsURLConnection) url.openConnection();
		}catch (IOException e) {
			System.err.println(e.getMessage());
		}

    	// TODO: Añada las cabeceras User-Agent y Accept (vea el enunciado)
    	connection.setRequestProperty("Accept", "application/json");
		connection.setRequestProperty("User-Agent", app_name + "-" + year);


    	// TODO: Indique que es una petición GET
		try {
			connection.setRequestMethod("GET");
		} catch (ProtocolException e) {
			// TODO Auto-generated catch block
			System.err.println(e.getMessage());
		}
    	
    	// TODO: Compruebe que el código recibido en la respuesta es correcto
		boolean correcto = false;
		int codigo = 0;
		try {
			codigo = connection.getResponseCode();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			System.err.println(e1.getMessage());
		}
		String mensajeRespuesta = null;
		try {
			mensajeRespuesta = connection.getResponseMessage();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			System.err.println(e1.getMessage());
		}
		if ((200 <= codigo) && (codigo < 300)) {
			System.out.println("Codigo de respuesta correcto: " + codigo);
			System.out.println("Mensaje de respuesta: " + mensajeRespuesta);
			correcto = true;
		} else {
			System.err.println("Codigo de respuesta incorrecto: " + codigo);
			System.err.println("Mensaje de respuesta: " + mensajeRespuesta);
		}
	
    	if(correcto == true) {
    	// TODO: Deserialice la respuesta a ResourceCountResponse
        Gson parser = new Gson();
        InputStream in = null;
		try {
			in = connection.getInputStream();
		} catch (IOException e) {
			System.err.println(e.getMessage());
		} 
		// TODO: Obtenga el InputStream de la conexión
        ResourceCountResponse c = parser.fromJson(new InputStreamReader(in), ResourceCountResponse.class);
        // TODO: Devuelva el número de elementos
        return c.count;
    	} else {
    		return 0;
    	}
    }
	
	public Person getPerson(String urlname) {
    	Person p = null;
    	// Por si acaso viene como http la pasamos a https
    	urlname = urlname.replaceAll("http:", "https:");

    	// TODO: Trate de forma adecuada las posibles excepciones que pueden producirse
		 
    	// TODO: Cree la conexión a partir de la URL recibida
    	HttpsURLConnection connection = null;
    	try {
			connection = (HttpsURLConnection) new URL (urlname).openConnection();
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			System.err.println(e.getMessage());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			System.err.println(e.getMessage());
		}
    	
    	// TODO: Añada las cabeceras User-Agent y Accept (vea el enunciado)
		connection.setRequestProperty("Accept", "application/json");
		connection.setRequestProperty("User-Agent", app_name+ "-" + year);

    	// TODO: Indique que es una petición GET
		try {
			connection.setRequestMethod("GET");
		} catch (ProtocolException e) {
			// TODO Auto-generated catch block
			System.err.println(e.getMessage());
		}
    	// TODO: Compruebe que el código recibido en la respuesta es correcto
		boolean correcto = false;
		int codigo = 0;
		try {
			codigo = connection.getResponseCode();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			System.err.println(e1.getMessage());
		}
		String mensajeRespuesta = null;
		try {
			mensajeRespuesta = connection.getResponseMessage();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			System.err.println(e1.getMessage());
		}
		if ((200 <= codigo) && (codigo < 300)) {
			System.out.println("Codigo de respuesta correcto: " + codigo);
			System.out.println("Mensaje de respuesta: " + mensajeRespuesta);
			correcto = true;
		} else {
			System.err.println("Codigo de respuesta incorrecto: " + codigo);
			System.err.println("Mensaje de respuesta: " + mensajeRespuesta);
		}
    	// TODO: Deserialice la respuesta a Person
		if (correcto == true) {
		Gson parser = new Gson();
        InputStream in = null;
		try {
			in = connection.getInputStream();
		} catch (IOException e) {
			System.err.println(e.getMessage());
		} 
		p = parser.fromJson(new InputStreamReader(in), Person.class);
		
				
        // TODO: Para las preguntas 2 y 3 (no necesita completar esto para la pregunta 1)
    	// TODO: A partir de la URL en el campo homreworld obtenga los datos del planeta y almacénelo en atributo homeplanet
		p.homeplanet = getPlanet(p.homeworld);
		}
		return p;
	}

	public Planet getPlanet(String urlname) {
    	Planet p = null;
    	// Por si acaso viene como http la pasamos a https
    	urlname = urlname.replaceAll("http:", "https:");

    	// TODO: Trate de forma adecuada las posibles excepciones que pueden producirse
		    	
    	// TODO: Cree la conexión a partir de la URL recibida
    	HttpsURLConnection connection = null;
    	try {
			connection = (HttpsURLConnection) new URL (urlname).openConnection();
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			System.err.println(e.getMessage());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			System.err.println(e.getMessage());
		}
    	// TODO: Añada las cabeceras User-Agent y Accept (vea el enunciado)
    	connection.setRequestProperty("Accept", "application/json");
		connection.setRequestProperty("User-Agent", app_name + "-" + year);


    	// TODO: Indique que es una petición GET
		try {
			connection.setRequestMethod("GET");
		} catch (ProtocolException e) {
			// TODO Auto-generated catch block
			System.err.println(e.getMessage());
		}
    	
    	// TODO: Compruebe que el código recibido en la respuesta es correcto
		boolean correcto = false;
		int codigo = 0;
		try {
			codigo = connection.getResponseCode();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			System.err.println(e1.getMessage());
		}
		String mensajeRespuesta = null;
		try {
			mensajeRespuesta = connection.getResponseMessage();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			System.err.println(e1.getMessage());
		}
		if ((200 <= codigo) && (codigo < 300)) {
			System.out.println("Codigo de respuesta correcto: " + codigo);
			System.out.println("Mensaje de respuesta: " + mensajeRespuesta);
			correcto = true;
		} else {
			System.err.println("Codigo de respuesta incorrecto: " + codigo);
			System.err.println("Mensaje de respuesta: " + mensajeRespuesta);
		}
    	// TODO: Deserialice la respuesta a Planet
		if (correcto == true) {
    	Gson parser = new Gson();
        InputStream in = null;
		try {
			in = connection.getInputStream();
		} catch (IOException e) {
			System.err.println(e.getMessage());
		} 
    	p = parser.fromJson(new InputStreamReader(in), Planet.class);
		}
    	return p;
	}

	public Person search(String name){
    	Person p = null;
    	// TODO: Trate de forma adecuada las posibles excepciones que pueden producirse
		    	
    	// TODO: Cree la conexión a partir de la URL (url_api + name tratado - vea el enunciado)
    	URL url = null;
    	try {
			url = new URL (url_api + "people/?search=" + URLEncoder.encode(name, StandardCharsets.UTF_8));
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			System.err.println(e.getMessage());
		}
    	HttpsURLConnection connection = null;
    	try {
			connection = (HttpsURLConnection) url.openConnection();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			System.err.println(e.getMessage());
		}

    	// TODO: Añada las cabeceras User-Agent y Accept (vea el enunciado)
		connection.setRequestProperty("Accept", "application/json");
		connection.setRequestProperty("User-Agent", app_name+ "-" +year);
    	// TODO: Indique que es una petición GET
		try {
			connection.setRequestMethod("GET");
		} catch (ProtocolException e) {
			// TODO Auto-generated catch block
			System.err.println(e.getMessage());
		}
    	// TODO: Compruebe que el código recibido en la respuesta es correcto
		boolean correcto = false;
		int codigo = 0;
		try {
			codigo = connection.getResponseCode();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			System.err.println(e1.getMessage());
		}
		String mensajeRespuesta = null;
		try {
			mensajeRespuesta = connection.getResponseMessage();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			System.err.println(e1.getMessage());
		}
		if ((200 <= codigo) && (codigo < 300)) {
			System.out.println("Codigo de respuesta correcto: " + codigo);
			System.out.println("Mensaje de respuesta: " + mensajeRespuesta);
			correcto = true;
		} else {
			System.err.println("Codigo de respuesta incorrecto: " + codigo);
			System.err.println("Mensaje de respuesta: " + mensajeRespuesta);
		}
    	// TODO: Deserialice la respuesta a SearchResponse -> Use la primera posición del array como resultado
    	if (correcto == true) {
    		Gson parser = new Gson();
    		InputStream in = null;
    		try {
    			in = connection.getInputStream();
    		} catch (IOException e) {
    			System.err.println(e.getMessage());
    		} 
    		SearchResponse sr = parser.fromJson(new InputStreamReader(in), SearchResponse.class);
        if(sr.results.length > 0) {
        	p = sr.results[0]; //primera posición del array
        }
        
    		
    		
    		// TODO: Para las preguntas 2 y 3 (no necesita completar esto para la pregunta 1)
    	// TODO: A partir de la URL en el campo homreworld obtenga los datos del planeta y almacénelo en atributo homeplanet
    	
        if (p!= null) { //no se si es necesario compronar si p!=null porque la primera posición del array sea null o si ha habdo error en el codigo del mensaje
    		p.homeplanet = getPlanet(p.homeworld);
    	}
    	}
        return p;
    }
	public Vehicle getVehicle (String urlname) {
    	Vehicle v = null;
    	// Por si acaso viene como http la pasamos a https
    	urlname = urlname.replaceAll("http:", "https:");

    	// TODO: Trate de forma adecuada las posibles excepciones que pueden producirse
		    	
    	// TODO: Cree la conexión a partir de la URL recibida
    	HttpsURLConnection connection = null;
    	try {
			connection = (HttpsURLConnection) new URL (urlname).openConnection();
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			System.err.println(e.getMessage());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			System.err.println(e.getMessage());
		}
    	// TODO: Añada las cabeceras User-Agent y Accept (vea el enunciado)
    	connection.setRequestProperty("Accept", "application/json");
		connection.setRequestProperty("User-Agent", app_name + "-" + year);


    	// TODO: Indique que es una petición GET
		try {
			connection.setRequestMethod("GET");
		} catch (ProtocolException e) {
			// TODO Auto-generated catch block
			System.err.println(e.getMessage());
		}
    	
    	// TODO: Compruebe que el código recibido en la respuesta es correcto
		boolean correcto = false;
		int codigo = 0;
		try {
			codigo = connection.getResponseCode();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			System.err.println(e1.getMessage());
		}
		String mensajeRespuesta = null;
		try {
			mensajeRespuesta = connection.getResponseMessage();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			System.err.println(e1.getMessage());
		}
		if ((200 <= codigo) && (codigo < 300)) {
			System.out.println("Codigo de respuesta correcto: " + codigo);
			System.out.println("Mensaje de respuesta" + mensajeRespuesta);
			correcto = true;
		} else {
			System.err.println("Codigo de respuesta incorrecto" + codigo);
			System.err.println("Mensaje de respuesta" + mensajeRespuesta);
		}
    	// TODO: Deserialice la respuesta a Planet
		if (correcto == true) {
    	Gson parser = new Gson();
        InputStream in = null;
		try {
			in = connection.getInputStream();
		} catch (IOException e) {
			System.err.println(e.getMessage());
		} 
    	v = parser.fromJson(new InputStreamReader(in), Vehicle.class);
		}
    	return v;
	}

}
