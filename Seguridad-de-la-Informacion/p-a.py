from Crypto.Hash import SHA256, HMAC
import base64
import funciones_rsa
import json
import sys
from socket_class import SOCKET_SIMPLE_TCP
import funciones_aes

keyA = funciones_rsa.crear_RSAKey()

funciones_rsa.guardar_RSAKey_Publica("PUB_ALICE.pub", keyA)
# funciones_rsa.guardar_RSAKey_Privada("PRIV_ALICE.pem", keyA, "alice")
# key_priv_A = funciones_rsa.cargar_RSAKey_Privada("PRIV_ALICE.pem", "alice")

# Crear Clave KAT (clave de sesion)
KAT = funciones_aes.crear_AESKey()


key_pub_TTP = funciones_rsa.cargar_RSAKey_Publica("PUB_TTP.pub")

print("---------- PASO 1 ----------")
socketAT = SOCKET_SIMPLE_TCP('127.0.0.1', 5551)
socketAT.conectar()

mensaje1 = ["Alice", KAT.hex()]
json_1 = json.dumps(mensaje1)
Alice_KAT_cif = funciones_rsa.cifrarRSA_OAEP(json_1, key_pub_TTP)
firmaA = funciones_rsa.firmarRSA_PSS(KAT, keyA)
# firmaA = funciones_rsa.firmarRSA_PSS(KAT, key_priv_A)

print("Alice envia primer paquete a TTP...")
print("Mensaje A -> T: ", json_1)

mensajeA = []
mensajeA.append(Alice_KAT_cif.hex())

mensajeA.append(firmaA.hex())

jStrA = json.dumps(mensajeA)

jStr_bytesA = jStrA.encode('utf-8')
socketAT.enviar(jStr_bytesA)

# Paso 3) 
print("---------- PASO 3 ----------")
mensajePaso3 = ["Alice", "Bob"]
json_Paso3 = json.dumps(mensajePaso3)
print("Mensaje A -> T: ", json_Paso3)

jStr_bytesA_3 = json_Paso3.encode('utf-8')
socketAT.enviar(jStr_bytesA_3)

# Paso 4)
print("---------- PASO 4 ----------")
datos4 = socketAT.recibir()
socketAT.cerrar() #Ya no vamos a conectar mas con TTP
datos4_decodT = datos4.decode('utf-8', "ignore")

mensajehexT_4, hex_mac_T4, hex_nonce_T4 = json.loads(datos4_decodT)


mensajeT_4 = bytearray.fromhex(mensajehexT_4)
mac_T4 = bytearray.fromhex(hex_mac_T4)
nonce_T4 = bytearray.fromhex(hex_nonce_T4)

#mensajeT_4 = [dt, KAB, EKBT[...], mac, nonce]
mensaje_descif4 = funciones_aes.descifrarAES_GCM(KAT, nonce_T4, mensajeT_4, mac_T4).decode('utf-8')
dt_T, KABhex_T, mensajehexT_B, machexT_B, noncehexT_B = json.loads(mensaje_descif4)
print("Ts: ", dt_T)
KAB_T = bytearray.fromhex(KABhex_T)


# Paso 5
print("---------- PASO 5 ----------")
#mensajehexT_B = EKBT[Ts, KAB]
socketAB = SOCKET_SIMPLE_TCP('127.0.0.1', 5553)
socketAB.conectar()


msg_5 = ["Alice", dt_T]
jsonmsg_5 = json.dumps(msg_5)
aes_engine_5 = funciones_aes.iniciarAES_GCM(KAB_T)
msg_5, mac_5, nonce_5 = funciones_aes.cifrarAES_GCM(aes_engine_5, jsonmsg_5.encode('utf-8'))

msgFin_5 = [mensajehexT_B, machexT_B, noncehexT_B, msg_5.hex(), mac_5.hex(), nonce_5.hex()]
jsonFin_5 = json.dumps(msgFin_5)
jStr_bytesT5 = jsonFin_5.encode('utf-8')
print("Mensaje A -> B: ", jsonmsg_5)
socketAB.enviar(jStr_bytesT5)

# Paso 6
print("---------- PASO 6 ----------")
datos6 = socketAB.recibir()
datos6_decodB = datos6.decode('utf-8')
mensajehexB_6, hex_mac_B6, hex_nonce_B6 = json.loads(datos6_decodB)

mensajeB_6 = bytearray.fromhex(mensajehexB_6)
mac_B6 = bytearray.fromhex(hex_mac_B6)
nonce_B6 = bytearray.fromhex(hex_nonce_B6)

mensaje_descif6 = funciones_aes.descifrarAES_GCM(KAB_T, nonce_B6, mensajeB_6, mac_B6).decode('utf-8')
ts_6 = json.loads(mensaje_descif6)
# Si pusieramos ts_6 daría [Ts+1] != Ts+1
if(ts_6[0] == dt_T + 1):
    print("La conexion es segura. Los Ts + 1 coinciden.")
    print("Ts + 1: ", ts_6[0])
else:
    print("La conexion no es segura: TsB + 1:", ts_6[0], " TsA + 1:", dt_T+1)
    socketAB.cerrar()

#Paso 7)
print("---------- PASO 7 ----------")
msg_7 = ["49379417P"]
json_7 = json.dumps(msg_7)
aes_engine_7 = funciones_aes.iniciarAES_GCM(KAB_T)
msg_7, mac_7, nonce_7 = funciones_aes.cifrarAES_GCM(aes_engine_7, json_7.encode('utf-8'))
# msg_7, mac_7, nonce_7 = funciones_aes.cifrarAES_GCM(aes_engine_5, json_7) porque ya lo tenemos de antes

msgFin_7 = [msg_7.hex(), mac_7.hex(), nonce_7.hex()]
jsonFin_7 = json.dumps(msgFin_7)
jStr_bytesT7 = jsonFin_7.encode('utf-8')

print("Mensaje A -> B: ", json_7)
socketAB.enviar(jStr_bytesT7)

# Paso 8)
print("---------- PASO 8 ----------")
datos8 = socketAB.recibir()
datos8_decodB = datos8.decode('utf-8')
mensajehexB_8, hex_mac_B8, hex_nonce_B8 = json.loads(datos8_decodB)

mensajeB_8 = bytearray.fromhex(mensajehexB_8)
mac_B8 = bytearray.fromhex(hex_mac_B8)
nonce_B8 = bytearray.fromhex(hex_nonce_B8)

mensaje_descif8 = funciones_aes.descifrarAES_GCM(KAB_T, nonce_B8, mensajeB_8, mac_B8).decode('utf-8')
apellido = json.loads(mensaje_descif8)
print("Mensaje B -> A: ", apellido)
socketAB.cerrar()