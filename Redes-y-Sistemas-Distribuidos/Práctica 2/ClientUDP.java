package es.uma.rysd2021.Bloque2.vacios;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.*;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;

/**
 *
 * @author Isidro Javier Garcia Fernandez
 */
// Si no hay conexion el programa se queda pillado (Estamos utilizando UDP)
public class ClientUDP {
    public static void main(String[] args) {
    	
    	if(args.length < 2) {
    		System.err.println("Espero IP y puerto y no los encuentro");
    		System.exit(1);
    	}
    	
    	// DATOS DEL SERVIDOR:
    	
    	String serverName = "127.0.0.1";
        int serverPort = 12345;
    	
        //String serverName = args[0]; //direccion local (127.0.0.1)       
        //int serverPort = Integer.parseInt(args[1]);   //54322;
  

        DatagramSocket serviceSocket = null;

        //* COMPLETAR: crear socket
        try {
			serviceSocket = new DatagramSocket();
		} catch (SocketException e) {
			// TODO Auto-generated catch block
			System.err.println("Error al crear el socket");
			System.exit(1);
		}
        

        // INICIALIZA ENTRADA POR TECLADO
        BufferedReader stdIn = new BufferedReader( new InputStreamReader(System.in) );
        System.out.println("Introduzca un texto a enviar (END para acabar): ");
        String userInput = null;
		try {
			userInput = stdIn.readLine();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			System.err.println("No puedo leer de teclado");
			System.exit(1);
		} /*CADENA ALMACENADA EN userInput*/

        //* COMPLETAR: Comprobar si el usuario quiere terminar servicio
        while (userInput != null && !"END".equals(userInput))
        {
        	byte[] datosEnvio = userInput.getBytes(StandardCharsets.UTF_8); //convierte el string (array de caracteres) a array de bytes
            
        	//* COMPLETAR: Crear datagrama con la cadena escrito en el cuerpo
        	DatagramPacket evioInfo = null;
			try {
				evioInfo = new DatagramPacket(datosEnvio, datosEnvio.length, InetAddress.getByName(serverName), serverPort);
			} catch (UnknownHostException e) {
				// TODO Auto-generated catch block
				System.err.println("La IP " + serverName + " no es valida.");
				System.exit(1);
			}
           
        	//* COMPLETAR: Enviar datagrama a traves del socket
        	try {
				serviceSocket.send(evioInfo);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				System.err.println("No puedo enviar el datagrama");
				System.exit(1);
			}
        	
            System.out.println("STATUS: Waiting for the reply");

           
            byte[] datosRecibidos = new byte [500];
            
            //* COMPLETAR: Crear e inicializar un datagrama VACIO para recibir la respuesta de máximo 500 bytes
            DatagramPacket recepcion = new DatagramPacket(datosRecibidos, datosRecibidos.length);
            
            //* COMPLETAR: Recibir datagrama de respuesta
            try {
				serviceSocket.receive(recepcion);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				System.err.println("No puedo recibir el datagrama");
				System.exit(1);
			}

            
             //* COMPLETAR: Extraer contenido del cuerpo del datagrama en variable line
            String line = new String(recepcion.getData(), recepcion.getOffset(), recepcion.getLength(), StandardCharsets.UTF_8);
            

            
            
            System.out.println("Respuesta del servidor: " + line);
            System.out.println("Introduzca un texto a enviar (END para acabar): ");
            try {
				userInput = stdIn.readLine();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				System.err.println("No puedo leer de teclado.");
				System.exit(1);
			}
        }

        System.out.println("STATUS: Closing client");

        //* COMPLETAR Cerrar socket cliente
        serviceSocket.close();

        System.out.println("STATUS: closed");
    }
}
