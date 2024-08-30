from Crypto.Hash import SHA256, HMAC
import base64
import funciones_rsa
import json
import sys
from socket_class import SOCKET_SIMPLE_TCP
import funciones_aes
from datetime import datetime
keyTTP = funciones_rsa.crear_RSAKey()

funciones_rsa.guardar_RSAKey_Publica("PUB_TTP.pub", keyTTP)
# funciones_rsa.guardar_RSAKey_Privada("PRIV_TTP.pem", keyTTP, "ttp")

print("---------- PASO 1 ----------")
socketAlice = SOCKET_SIMPLE_TCP('127.0.0.1', 5551)
socketAlice.escuchar()
datos = socketAlice.recibir()
datos_decod = datos.decode("utf-8" ,"ignore")

mensajehex, firmahex = json.loads(datos_decod)

mensaje = bytearray.fromhex(mensajehex)
firma = bytearray.fromhex(firmahex)
# key_priv_TTP = funciones_rsa.cargar_RSAKey_Privada("PRIV_TTP.pem", "ttp")

mensaje_descif = funciones_rsa.descifrarRSA_OAEP(mensaje, keyTTP)
# mensaje_descif = funciones_rsa.descifrarRSA_OAEP(mensaje, key_priv_TTP)

print("Mensaje A -> T:", mensaje_descif)

msg_A, msgKAThex = json.loads(mensaje_descif)

msgKAT = bytearray.fromhex(msgKAThex)

key_pub_A = funciones_rsa.cargar_RSAKey_Publica("PUB_ALICE.pub")
if (funciones_rsa.comprobarRSA_PSS(msgKAT, firma, key_pub_A)):
    print("La firma de A es correcta")
else:
    print("La firma de A es incorrecta. Cerrando conexion con Alice...")
    socketAlice.cerrar()

# Parte 2)
print("---------- PASO 2 ----------")
socketBob = SOCKET_SIMPLE_TCP('127.0.0.1', 5552)
socketBob.escuchar()
datosB = socketBob.recibir()
datos_decodB = datosB.decode("utf-8" ,"ignore")

mensajehexB, firmahexB = json.loads(datos_decodB)

mensajeB = bytearray.fromhex(mensajehexB)
firmaB = bytearray.fromhex(firmahexB)

mensaje_descifB = funciones_rsa.descifrarRSA_OAEP(mensajeB, keyTTP)
# mensaje_descifB = funciones_rsa.descifrarRSA_OAEP(mensajeB, key_priv_TTP)

print("Mensaje B -> T:", mensaje_descifB)
msg_B, msgKBThex = json.loads(mensaje_descifB)

msgKBT = bytearray.fromhex(msgKBThex)
key_pub_B = funciones_rsa.cargar_RSAKey_Publica("PUB_BOB.pub")

if (funciones_rsa.comprobarRSA_PSS(msgKBT, firmaB, key_pub_B)):
    print("La firma de B es correcta")
else:
    print("La firma de B es incorrecta. Cerrando conexion con Alice...")
    socketBob.cerrar()

socketBob.cerrar()

# Paso 3
print("---------- PASO 3 ----------")
datosPaso3 = socketAlice.recibir()
datos_decodPaso3 = datosPaso3.decode("utf-8" ,"ignore")

mensaje_Paso3 = json.loads(datos_decodPaso3)

print("Mensaje A -> T:", mensaje_Paso3)


# Paso 4
# msgKAT == KAT
# msgKBT == KBT
# dt = datetime.now() Getting the current date and time
# ts = datetime.timestamp(dt) getting the timestamp 
# print("Dat and time is:" , dt)
# print("Timestamp is: " , ts)
print("---------- PASO 4 ----------")
dt = datetime.now()
ts = datetime.timestamp(dt)
KAB = funciones_aes.crear_AESKey()
mensaje4 = [ts, KAB.hex()]
json_4 = json.dumps(mensaje4)
aes_engine = funciones_aes.iniciarAES_GCM(msgKBT)
json_4_env = json_4.encode('utf-8')
# msg_4, mac_4, nonce_4 = funciones_aes.cifrarAES_GCM(aes_engine, json_4)
msg_4, mac_4, nonce_4 = funciones_aes.cifrarAES_GCM(aes_engine, json_4_env)

#EKBT[ts, KAB]
mensajePaso_4 = [ts, KAB.hex(), msg_4.hex(), mac_4.hex(), nonce_4.hex()]

jsonPaso_4 = json.dumps(mensajePaso_4)
aes_enginePaso_4 = funciones_aes.iniciarAES_GCM(msgKAT)
jsonPaso_4_env = jsonPaso_4.encode('utf-8')
msgPaso_4, macPaso_4, noncePaso_4 = funciones_aes.cifrarAES_GCM(aes_enginePaso_4, jsonPaso_4_env)

#EKBT[ts, KAB, EKBT[ts, KAB]]
mensajeF_4 = [msgPaso_4.hex(), macPaso_4.hex(), noncePaso_4.hex()]
jsonF_4 = json.dumps(mensajeF_4)
jStr_bytesT4 = jsonF_4.encode('utf-8')
print("Ts: ", ts)
socketAlice.enviar(jStr_bytesT4)
socketAlice.cerrar()


