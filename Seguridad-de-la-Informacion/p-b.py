from Crypto.Hash import SHA256, HMAC
import base64
import funciones_rsa
import json
import sys
from socket_class import SOCKET_SIMPLE_TCP
import funciones_aes


keyB = funciones_rsa.crear_RSAKey()

funciones_rsa.guardar_RSAKey_Publica("PUB_BOB.pub", keyB)
# funciones_rsa.guardar_RSAKey_Privada("PRIV_BOB.pem", keyB, "bob")
# key_priv_B = funciones_rsa.cargar_RSAKey_Privada("PRIV_BOB.pem", "bob")
# Crear Clave KbT
KBT = funciones_aes.crear_AESKey()

key_pub_TTP = funciones_rsa.cargar_RSAKey_Publica("PUB_TTP.pub")

print("---------- PASO 1 ----------")
socketBT = SOCKET_SIMPLE_TCP('127.0.0.1', 5552)
socketBT.conectar()

mensaje2 = ["Bob", KBT.hex()]
json_2 = json.dumps(mensaje2)
Bob_KBT_cif = funciones_rsa.cifrarRSA_OAEP(json_2, key_pub_TTP)
firmaB = funciones_rsa.firmarRSA_PSS(KBT, keyB)
# firmaB = funciones_rsa.firmarRSA_PSS(KBT, key_priv_B)
print("Bob envia primer paquete a TTP...")
print("Mensaje A -> T: ", json_2)

mensajeB = []
mensajeB.append(Bob_KBT_cif.hex())
mensajeB.append(firmaB.hex())

jStrB = json.dumps(mensajeB)
jStr_bytesB = jStrB.encode('utf-8')
socketBT.enviar(jStr_bytesB)
socketBT.cerrar()

#Paso 5
print("---------- PASO 5 ----------")
socketBA = SOCKET_SIMPLE_TCP('127.0.0.1', 5553)
socketBA.escuchar()


datos5 = socketBA.recibir()
datos5_decodA = datos5.decode('utf-8', "ignore")

msg5hexA_5, hex5mac, hex5nonce, msg51hexA_5, hex51mac, hex51nonce = json.loads(datos5_decodA)
msg5A_5 = bytearray.fromhex(msg5hexA_5)
mac_5 = bytearray.fromhex(hex5mac)
nonce_5 = bytearray.fromhex(hex5nonce)
msg51A_5 = bytearray.fromhex(msg51hexA_5)
mac_51 = bytearray.fromhex(hex51mac)
nonce_51 = bytearray.fromhex(hex51nonce)

mensaje_descif5 = funciones_aes.descifrarAES_GCM(KBT, nonce_5, msg5A_5, mac_5).decode('utf-8')

ts_5, KABhex_5 = json.loads(mensaje_descif5)
KAB_5 = bytearray.fromhex(KABhex_5)

mensaje_descif51 = funciones_aes.descifrarAES_GCM(KAB_5, nonce_51, msg51A_5, mac_51).decode('utf-8')
mensaje_5, ts_5_2 = json.loads(mensaje_descif51)
# if dt = dt2 => no ha habido problemas o hackeos xd
# mensaje_5 == "Alice"
print("Mensaje A -> B: ", mensaje_descif51)

if ts_5 == ts_5_2:
    print("La conexión es segura. Los ts coinciden.")
else:
    print("La conexión no es segura. El ts_1:", ts_5, " y el ts_2:", ts_5_2, " no coinciden.")
    socketBA.cerrar()

#Paso 6)
print("---------- PASO 6 ----------")
ts_6 = ts_5 + 1
msg_6 = [ts_6]
json_6 = json.dumps(msg_6)
aes_engine_6 = funciones_aes.iniciarAES_GCM(KAB_5)
msg_6, mac_6, nonce_6 = funciones_aes.cifrarAES_GCM(aes_engine_6, json_6.encode('utf-8'))

msgFin_6 = [msg_6.hex(), mac_6.hex(), nonce_6.hex()]
jsonFin_6 = json.dumps(msgFin_6)
jStr_bytesT6 = jsonFin_6.encode('utf-8')

print("Ts + 1: ", json_6)
socketBA.enviar(jStr_bytesT6)

# Paso 7)
print("---------- PASO 7 ----------")
datos7 = socketBA.recibir()
datos7_decodA = datos7.decode('utf-8')
mensajehexA_7, hex_mac_A7, hex_nonce_A7 = json.loads(datos7_decodA)

mensajeA_7 = bytearray.fromhex(mensajehexA_7)
mac_A7 = bytearray.fromhex(hex_mac_A7)
nonce_A7 = bytearray.fromhex(hex_nonce_A7)

mensaje_descif6 = funciones_aes.descifrarAES_GCM(KAB_5, nonce_A7, mensajeA_7, mac_A7).decode('utf-8')
dni = json.loads(mensaje_descif6)
print("Mensaje A -> B: ", dni)

#Paso 8)
print("---------- PASO 8 ----------")
msg_8 = ["Miranda"]
json_8 = json.dumps(msg_8)
aes_engine_8 = funciones_aes.iniciarAES_GCM(KAB_5)
msg_8, mac_8, nonce_8 = funciones_aes.cifrarAES_GCM(aes_engine_8, json_8.encode('utf-8'))
# msg_7, mac_7, nonce_7 = funciones_aes.cifrarAES_GCM(aes_engine_6, json_8) porque ya lo tenemos de antes

msgFin_8 = [msg_8.hex(), mac_8.hex(), nonce_8.hex()]
jsonFin_8 = json.dumps(msgFin_8)
jStr_bytesT8 = jsonFin_8.encode('utf-8')

print("Mensaje B -> A: ", json_8)
socketBA.enviar(jStr_bytesT8)
socketBA.cerrar()