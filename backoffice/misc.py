import os
import sys
import termios
import tty
from cryptography.fernet import Fernet
from hashlib import sha256 as default_hashalgo
from subprocess import run

def cls():
    if sys.platform in ('linux', 'darwin', 'freebsd'):
        run(['clear'])
    elif sys.platform == 'win32':
        run(['cls'], shell=True)

key = b'JTrch_owdTqsihVjM_J4KP6r4xBB3fEZ1CQH-Tv4wDY='

def do_crypt(plain: str):
    cipher_suite = Fernet(key)
    return cipher_suite.encrypt( plain.encode() ).decode()

def undo_crypt(code: str):
    cipher_suite = Fernet(key)
    return cipher_suite.decrypt( code.encode() ).decode()

def hashify(plain: str):
    hash_obj = default_hashalgo()
    hash_obj.update(plain.encode())
    hashed = hash_obj.hexdigest()
    return hashed

def pause():
    input("\nPressione qualquer tecla para continuar...")

def getkey():
    old_settings = termios.tcgetattr(sys.stdin)
    tty.setcbreak(sys.stdin.fileno())
    try:
        while True:
            b = os.read(sys.stdin.fileno(), 3).decode()
            if len(b) == 3:
                k = ord(b[2])
            else:
                k = ord(b)
            key_mapping = {
                127: 'backspace',
                10: 'return',
                32: 'space',
                9: 'tab',
                27: 'esc',
                65: 'up',
                66: 'down',
                67: 'right',
                68: 'left'
            }
            return key_mapping.get(k, chr(k))
    finally:
        termios.tcsetattr(sys.stdin, termios.TCSADRAIN, old_settings)

def drawbox( menu : dict, dicOperator : dict ):
    intSize = 0
    strUser = f"{dicOperator['id']}-{dicOperator['firstname']}"
    for key, value in menu.items():
        if key == 'Title':
            intCache = len(value)
        else:
            intCache = len(key) + len(value) + 3
        if intCache > intSize:
            intSize = intCache
    print(f"╔═{'':═^{intSize}}═╗")
    print(f"║ {'': ^{intSize}} ║")
    for key, value in menu.items():
        if key == 'Title':
            print(f"║ {value: ^{intSize}} ║")
            print(f"║ {'': ^{intSize}} ║")
        else:
            print(f"║ {key + ' - ' + value: <{intSize}} ║")
    print(f"║ {strUser: >{intSize}} ║")
    print(f"╚═{'':═^{intSize}}═╝")
