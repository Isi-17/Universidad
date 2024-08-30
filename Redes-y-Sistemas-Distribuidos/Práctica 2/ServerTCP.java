package es.uma.rysd2021.Bloque2.vacios;

import java.io.*;
import java.net.*;
import java.util.Scanner;


/**
*
* @author Isidro Javier García Fernández
*/
class ServerTCP {
    public static String invertir(String s){
        StringBuilder sbr = new StringBuilder(s);
        sbr.reverse();
        return sbr.toString();
    }

    public static void main(String[] args)
    {
        // DATOS DEL SERVIDOR
        int port = 12345; // puerto del servidor
        
        // int port = Integer.parseInt(args[0]); 

        // SOCKETS
        ServerSocket server = null; // Pasivo (recepciÃ³n de peticiones) // este socket sirve para escuchar
        Socket client = null;       // Activo (atenciÃ³n al cliente)  // este socket sirve para comunicar

        // FLUJOS PARA EL ENVÃ�O Y RECEPCIÃ“N
        BufferedReader in = null;
        PrintWriter out = null;

        //* COMPLETAR: Crear e inicalizar el socket del servidor (socket pasivo)
        try {
        	server = new ServerSocket(port);
        } catch (IOException e) {
        	System.err.println("Error: No se pudo escuchar al puerto " + port);
        	System.exit(1);
        }

        while (true) // Bucle de recepciÃ³n de conexiones entrantes
        {
            System.out.println("ESTADO: Esperando cliente");
            //* COMPLETAR: Esperar conexiones entrantes
        	try {
        		client = server.accept();
        	} catch (IOException e) {
        		System.err.println("Aceptación fallada: "+port);
        		System.exit(1);
        	}
            //* COMPLETAR: Una vez aceptada una conexion, inicializar flujos de entrada/salida del socket conectado
        	try {
        		out = new PrintWriter(client.getOutputStream(), true);
        		in = new BufferedReader(new InputStreamReader(client.getInputStream()));
        	} catch (IOException e) {
        		System.err.println("No se pudo conseguir entrada/salida con "+ client.getRemoteSocketAddress());
        		System.exit(1);
        	}
        	
        	System.out.println("ESTADO: Cliente conectado desde: " + client.getRemoteSocketAddress());
            out.println("Bienvenido");
        	boolean salir = false;
            while(!salir) // Inicio bucle del servicio de un cliente
            {
                //* COMPLETAR: Recibir texto en line enviado por el cliente a travÃ©s del flujo de entrada del socket conectado
                String line = null;
                try {
					line = in.readLine();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					System.err.println("Error en la lectura de la línea");
					System.exit(1);
				} //lectura

                System.out.println("ESTADO: Recibido desde el cliente " + line);
                //* COMPLETAR: Comprueba si es fin de conexion - SUSTITUIR POR LA CADENA DE FIN enunciado
                if (line.compareTo("END") != 0){
                    line = invertir(line);

                    //* COMPLETAR: Enviar texto al cliente a traves del flujo de salida del socket conectado
                    out.println(line);
                    
                    System.out.println("ESTADO: Enviando al cliente " + line);
                    
                } else { // El cliente quiere cerrar conexiÃ³n, ha enviado TERMINAR
                    salir = true;
                    out.println("VALE");
                }
            } // fin del servicio

            //* COMPLETAR: Cerrar flujos y socket
            System.out.println("ESTADO: Cerrando conexión con el cliente");
            try {
				in.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				System.err.println("Error al acabar conexión de entrada");
				System.exit(1);
			}
            out.close();
            try {
				client.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				System.err.println("Error al acabar conexión con el cliente");
				System.exit(1);
			}

        } // fin del bucle
    } // fin del metodo
}
