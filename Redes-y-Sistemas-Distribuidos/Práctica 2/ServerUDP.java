package es.uma.rysd2021.Bloque2.vacios;

import java.io.IOException;
import java.net.*;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;


/**
 *
 * @author Isidro Javier García Fernández
 */
public class ServerUDP {
    public static String invertir(String s){
        StringBuilder sbr = new StringBuilder(s);
        sbr.reverse();
        return sbr.toString();
    }

    public static void main(String[] args)
    {
        // DATOS DEL SERVIDOR
        int port = 12345; // puerto del servidor
        
    	//int port = Integer.parseInt(args[0]); puerto del servidor

        // SOCKET
        DatagramSocket server = null;

        //* COMPLETAR Crear e inicalizar el socket del servidor
        try {
        	server = new DatagramSocket(port);
        } catch (SocketException e) {
        	//System.err.println("Error: No se pudo escuchar al puerto" + port);
        	System.err.println(e.getMessage());
        	System.exit(1);
        }
        // Funcion PRINCIPAL del servidor
        while (true)
        {
        	System.out.println("ESTADO: Esperando recibir datos de cliente");
            //* COMPLETAR: Crear e inicializar un datagrama VACIO para recibir la respuesta de mÃ¡ximo 500 bytes
        	byte[] datosRecibidos = new byte[500];
        	DatagramPacket recepcion = new DatagramPacket(datosRecibidos, datosRecibidos.length);
            //* COMPLETAR: Recibir datagrama
        	try {
        		server.receive(recepcion);
        	} catch (IOException e) {
        		System.err.println("Servidor no puede recibir el datagrama");
        		System.exit(1);
        	}
            //* COMPLETAR: Obtener texto recibido
            String line = null;
            try {
            	line = new String(recepcion.getData(), recepcion.getOffset(), recepcion.getLength(), StandardCharsets.UTF_8);
            } catch (Exception e) {
            	System.err.println("No se pudo extraer mensaje del paquete recibido");
            	System.exit(1);
            }
            

            //* COMPLETAR: Mostrar por pantalla la direccion socket (IP y puerto) del cliente y su texto
            System.out.println("Direccion socket del cliente: (IP): " + recepcion.getAddress() + ", (Puerto): " + recepcion.getPort() + ", (Datos): " + line );
            // Invertimos la linea
            line = invertir(line);

            //* COMPLETAR: crear datagrama de respuesta
            DatagramPacket respuestaInfo = null;
            // no se si es necesario un try, catch aqui, porque lo implemente y me decia que nunca se iba a dar el catch, por eso lo quite
            	respuestaInfo = new DatagramPacket(line.getBytes(), line.getBytes().length, recepcion.getSocketAddress());

            //* COMPLETAR: Enviar datagrama de respuesta
            try {
            	server.send(respuestaInfo);
            } catch (IOException e) {
            	System.err.println("No puedo enviar el datagrama");
            	System.exit(1);
            }

        } // Fin del bucle del servicio
    }

}
