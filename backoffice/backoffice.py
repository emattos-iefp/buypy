"""
BuyPy

A command-line backoffice application. This is an interactive 
shell application

(c) Joao Galamba, 2024
"""

import os
import sys
from getpass import getpass
from time import sleep

import db
from misc import cls, do_crypt, drawbox, getkey, \
                 hashify, pause, undo_crypt
 
dicOperator = ""

def backup():
    dicChoices0B = {
        "Title" : "Menu 'Backup'",
        "1" : "Realizar Backup",
        "V" : "Voltar"
    }
    while True:
        cls()
        drawbox( dicChoices0B, dicOperator )
        print("\n>> ", end="")
        option = getkey().upper()
        if option == "1":
            db.backup()
            print( "\rBackup realizado." )
            pause()
        elif option == "V":
            break

def produto():
    dicChoices0P = {
        "Title" : "Menu 'Produto'",
        "1" : "Listar Livros",
        "2" : "Listar Consumíveis",
        "3" : "Listar por Quantidade",
        "4" : "Listar por Preço",
        "V" : "Voltar"
    }
    while True:
        cls()
        drawbox( dicChoices0P, dicOperator )
        print("\n>> ", end="")
        option = getkey().upper()
        if option == "1":
            lstBooks = db.list_books()
            if lstBooks is None:
                print( "\rNão há livros registados." )
            else:
                cls()
                print("Livros registados:\n")
                lstSize = []
                for row in lstBooks:
                    for i in range(len(row)):
                        cell = str(row[i])
                        if len(lstSize) < i + 1:
                            lstSize.append( len( cell ) )
                        else:
                            if lstSize[i] < len( cell ):
                                lstSize[i] = len( cell )
                for row in lstBooks:
                    for i in range(len(row)):
                        cell = str(row[i])
                        print( f" | {cell: <{lstSize[i]}}", end="" )
                    print( " |" )
            pause()
        if option == "2":
            lstElectronics = db.list_electronics()
            if lstElectronics is None:
                print( "\rNão há livros registados." )
            else:
                cls()
                print("Livros registados:\n")
                lstSize = []
                for row in lstElectronics:
                    for i in range(len(row)):
                        cell = str(row[i])
                        if len(lstSize) < i + 1:
                            lstSize.append( len( cell ) )
                        else:
                            if lstSize[i] < len( cell ):
                                lstSize[i] = len( cell )
                for row in lstElectronics:
                    for i in range(len(row)):
                        cell = str(row[i])
                        print( f" | {cell: <{lstSize[i]}}", end="" )
                    print( " |" )
            pause()
        if option == "3":
            print( "\rQuantidade mínima", end="" )
            try:
                intMin = int(input(": "))
                intMax = int(input("Quantidade máxima: "))
            except ValueError:
                print( "\nInsira somente dígitos sff!" )
                pause()
                continue
            lstProducts = db.list_quantity(intMin, intMax)
            if lstProducts is None:
                print( "\rNão há produtos registados." )
            else:
                cls()
                print("Produtos registados:\n")
                lstSize = []
                for row in lstProducts:
                    for i in range(len(row)):
                        cell = str(row[i])
                        if len(lstSize) < i + 1:
                            lstSize.append( len( cell ) )
                        else:
                            if lstSize[i] < len( cell ):
                                lstSize[i] = len( cell )
                for row in lstProducts:
                    for i in range(len(row)):
                        cell = str(row[i])
                        print( f" | {cell: <{lstSize[i]}}", end="" )
                    print( " |" )
            pause()
        elif option == "4":
            print( "\rPreço mínimo", end="" )
            try:
                intMin = int(input(": "))
                intMax = int(input("Preço máximo: "))
            except ValueError:
                print( "\nInsira somente dígitos sff!" )
                pause()
                continue
            lstProducts = db.list_price(intMin, intMax)
            if lstProducts is None:
                print( "\rNão há produtos registados." )
            else:
                cls()
                print("Produtos registados:\n")
                lstSize = []
                for row in lstProducts:
                    for i in range(len(row)):
                        cell = str(row[i])
                        if len(lstSize) < i + 1:
                            lstSize.append( len( cell ) )
                        else:
                            if lstSize[i] < len( cell ):
                                lstSize[i] = len( cell )
                for row in lstProducts:
                    for i in range(len(row)):
                        cell = str(row[i])
                        print( f" | {cell: <{lstSize[i]}}", end="" )
                    print( " |" )
            pause()
        elif option == "V":
            break

def utilizador():
    dicChoices0U = {
        "Title" : "Menu 'Utilizador'",
        "1" : "Pesquisar por ID",
        "2" : "Pesquisar por Nome",
        "3" : "Bloquear utilizador",
        "4" : "Desbloquear utilizador",
        "5" : "Listar Utilizadores Bloqueados",
        "V" : "Voltar"
    }
    while True:
        cls()
        drawbox( dicChoices0U, dicOperator )
        print("\n>> ", end="")
        option = getkey().upper()
        if option == "1":
            print( "\rDigite o ID a procurar.", end="" )
            try:
                id = int(input(">> "))
            except ValueError:
                print( "\nInsira somente dígitos sff!" )
                pause()
                continue
            dicUser = db.search_user_id(id)
            if dicUser is None:
                print( "Utilizador não encontrado." )
            else:
                cls()
                print("Resultado da busca:\n")
                for key,value in dicUser.items():
                    value = str(value)
                    intSize = len(key)
                    if intSize < len(value):
                        intSize = len(value)
                    print( f" | {key: <{intSize}}", end="" )
                print( " |" )
                for key,value in dicUser.items():
                    value = str(value)
                    intSize = len(key)
                    if intSize < len(value):
                        intSize = len(value)
                    print( f" | {value: <{intSize}}", end="" )
                print( " |" )
            pause()
        elif option == "2":
            print( "\rDigite o nome (opcional)", end="" )
            name = input(": ").strip().upper()
            print( "Digite o apelido (opcional)", end="" )
            apelido = input(": ").strip().upper()
            lstUsers = db.search_user_name(name, apelido)
            if lstUsers is None:
                print( "\nUtilizador não encontrado." )
            else:
                cls()
                print("Resultado da busca:\n")
                lstSize = []
                for row in lstUsers:
                    for i in range(len(row)):
                        cell = str(row[i])
                        if len(lstSize) < i + 1:
                            lstSize.append( len( cell ) )
                        else:
                            if lstSize[i] < len( cell ):
                                lstSize[i] = len( cell )
                for row in lstUsers:
                    for i in range(len(row)):
                        cell = str(row[i])
                        print( f" | {cell: <{lstSize[i]}}", end="" )
                    print( " |" )
            pause()
        elif option == "3":
            print( "\rDigite o ID a bloquear", end="" )
            try:
                id = int(input(": "))
            except ValueError:
                print( "\nInsira somente dígitos sff!" )
                pause()
                continue
            db.block_user(id)
        elif option == "4":
            print( "\rDigite o ID a bloquear", end="" )
            try:
                id = int(input(": "))
            except ValueError:
                print( "\nInsira somente dígitos sff!" )
                pause()
                continue
            db.unblock_user(id)
        elif option == "5":
            lstUsers = db.search_user_blocked()
            if lstUsers is None:
                print( "\rNão há utilizadores bloqueados." )
            else:
                cls()
                print("Utilizadores bloqueados:\n")
                lstSize = []
                for row in lstUsers:
                    for i in range(len(row)):
                        cell = str(row[i])
                        if len(lstSize) < i + 1:
                            lstSize.append( len( cell ) )
                        else:
                            if lstSize[i] < len( cell ):
                                lstSize[i] = len( cell )
                for row in lstUsers:
                    for i in range(len(row)):
                        cell = str(row[i])
                        print( f" | {cell: <{lstSize[i]}}", end="" )
                    print( " |" )
            pause()
        elif option == "V":
            break
     
def exec_login():
    """
    Asks for user login info and then tries to authenticate the user in 
    the DB.
    Stores user data the data in the local config file 'config.ini'.
    """
    if os.path.isfile( "config.ini" ):
        with open( "config.ini", "r") as file:
            for line in file.readlines():
                line = undo_crypt( line )
                if line.split()[0] == "username":
                    username = line.split()[1]
                elif line.split()[0] == "password":
                    passwd = line.split()[1]
        try:
            user_info = db.login(username, passwd)
            if user_info:
                return user_info
        except:
            pass
    intCount = 0
    while True:
        username = input( "Username: " )
        passwd = hashify( getpass( "Password: " ) )
        user_info = db.login(username, passwd)
        if user_info:
            with open( "config.ini", "w") as file:
                line = do_crypt( f'username {username}' ) + "\n"
                file.write( line )
                line = do_crypt( f'password {passwd}' ) + "\n"
                file.write( line )
            break
        intCount += 1
        if intCount < 3:
            print("\nAutenticação inválida.\n")
        else:
            break
    return user_info

def main():
    global dicOperator
    dicOperator = exec_login()
    if dicOperator is None:
        print( "\nNo pass, no game!\n" )
        sys.exit(1)
    dicChoices0 = {
        "Title" : f"Bem vindo {dicOperator['firstname']}",
        "U" : "Menu 'Utilizador'",
        "P" : "Menu 'Produto'",
        "B" : "Menu 'Backup'",
        "S" : "Sair do BackOffice",
        "L" : "Logout do BackOffice"
    }
    while True:
        cls()
        drawbox( dicChoices0, dicOperator )
        print("\n>> ", end="")
        option = getkey().upper()
        if option == 'U':
            utilizador()
        elif option == 'P':
            produto()
        elif option == 'B':
            backup()
        elif option == 'S':
            print( "\rDeseja deslogar [s/N]: ", end="" )
            while True:
                option = getkey().upper()
                if option == "S":
                    os.remove( "config.ini" )
                    print("S")
                    break
                elif option in ("N", "RETURN"):
                    print("N")
                    break
            print("\nO BackOffice terminou. Bem haja!\n")
            sys.exit(0)
        elif option == 'L':
            os.remove( "config.ini" )
            print("\n\nO BackOffice terminou. Bem haja!\n")
            sys.exit(0)

if __name__ == '__main__':
    main()
