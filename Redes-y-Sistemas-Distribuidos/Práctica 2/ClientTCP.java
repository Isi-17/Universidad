package es.uma.rysd2021.Bloque2.vacios;

/**
 *
 * @author Isidro Javier Garcia Fernandez
 */
import java.io.*;
import java.net.*;
import java.util.Scanner;

public class ClientTCP {

    public static void main(String[] args){
        // DATOS DEL SERVIDOR:
        String serverName = "127.0.0.1"; // direccion local
        int serverPort = 12345;
        //String serverName = args[0];
        //int serverPort = Integer.parseInt(args[1]);

        // SOCKET
        Socket serviceSocket = null;

        // FLUJOS PARA EL ENV�?O Y RECEPCIÓN
        PrintWriter out = null;
        BufferedReader in = null;

        //* COMPLETAR: Crear socket y conectar con servidor
        try {
        	serviceSocket = new Socket(serverName, serverPort);
        } catch (IOException e) {
        	System.err.println("Error: No se pudo escuchar al servidor " + serverName + " con puerto " + serverPort);
        	System.exit(1);
        }
        //* COMPLETAR: Inicializar los flujos de entrada/salida del socket conectado en las variables PrintWriter y BufferedReader
        try {
    		out = new PrintWriter(serviceSocket.getOutputStream());
    		in = new BufferedReader(new InputStreamReader(serviceSocket.getInputStream()));
    	} catch (IOException e) {
    		System.err.println("No se pudo conseguir entrada/salida con "+ serviceSocket.getRemoteSocketAddress());
    		System.exit(1);
    	}
        //* COMPLETAR: Recibir mensaje de bienvenida del servidor y mostrarlo
        try {
        	System.out.println(in.readLine());
        } catch (IOException e) {
        	System.err.println("Error en la lectura de la l�nea");
        	System.exit(1);
        }
        
        // Obtener texto por teclado
        BufferedReader stdIn = new BufferedReader(new InputStreamReader(System.in));
        String userInput = null;

        System.out.println("Introduzca un texto a enviar (END para acabar)");
        try {
			userInput = stdIn.readLine();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
        	System.err.println("Error al leer linea de teclado");
        	System.exit(1);
		}

        //* COMPLETAR: Comprobar si el usuario ha iniciado el fin de la interacción
        while (userInput != null && !"END".equals(userInput)) { // bucle del servicio
            //* COMPLETAR: Enviar texto en userInput al servidor a través del flujo de salida del socket conectado
        	out.println(userInput);
        	out.flush();
        	
            //* COMPLETAR: Recibir texto enviado por el servidor a través del flujo de entrada del socket conectado
            String line = null;
            try {
            	line = in.readLine();
            	System.out.println(line);
            } catch (IOException e) {
            	System.err.println("Error al leer mensaje del servidor");
            	System.exit(1);
            }

            // Leer texto de usuario por teclado
            System.out.println("Introduzca un texto a enviar (END para acabar)");
            try {
				userInput = stdIn.readLine();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				System.err.println("Error al leer de teclado");
				System.exit(1);
			}
        } // Fin del bucle de servicio en cliente

        // Salimos porque el cliente quiere terminar la interaccion, ha introducido "TERMINAR"
        //* COMPLETAR: Enviar TERMINAR al servidor para indicar el fin deL Servicio
        out.println("END");
        out.flush();
        //* COMPLETAR: Recibir el VALE del Servidor
        String lineafinal = null;
        try {
        	lineafinal = in.readLine();
        } catch (IOException e) {
        	System.err.println("Error al leer linea de servidor");
        	System.exit(1);
        }
        //* COMPLETAR Cerrar flujos y socket
        if (lineafinal.compareTo("VALE") == 0) {
        	try {
				serviceSocket.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
	        	System.err.println("Error al acabar conexion con el servidor");
	        	System.exit(1);
			}
        	try {
				in.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
	        	System.err.println("Error al acabar conexion de entrada");
	        	System.exit(1);
			}
        	// iba a poner un try catch pero no me salta ningun error, imagino que es porque es una conexion de salida y al cliente le "da igual"
        	out.close();
        	}
       
    }
}
