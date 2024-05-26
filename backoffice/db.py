"""
This module defines functions and classes related to DB access.

(c) Joao Galamba, 2024
"""

from mysql.connector import connect, Error as MySQLError
from subprocess import run


DB_CONN_PARAMS = {
    'host': 'localhost',
    'user': 'BUYDB_OPERATOR',
    'password': 'Lmxy20#a',
    'database': 'buypy',
}

def backup():
    run( 'mysqldump buypy -uBUYDB_ADMIN -p"Lmxy20#a" 2>/dev/null |  xz -c > dbbuypy.$(date +%Y%m%d%H%M%S%Z).sql.xz', shell=True )

def queryDB( strQuery : str, lstParameters : list ):
    with connect(**DB_CONN_PARAMS) as connection:
        with connection.cursor() as cursor:
            cursor.callproc( strQuery, lstParameters )
            return cursor

def login(username: str, passwd: str) -> dict | None:
    cursor = queryDB( 'AuthenticateOperator', [username, passwd] )
    user_info = next(cursor.stored_results())
    if user_info.rowcount != 1:
        return None
    user_row = user_info.fetchall()[0]
    return dict(zip(user_info.column_names, user_row))

def block_user(id: int):
    queryDB( 'BlockUser', [id] )

def unblock_user(id: int):
    queryDB( 'UnblockUser', [id] )

def list_books() -> list | None:
    cursor = queryDB( 'ListBooks', [] )
    user_info = next(cursor.stored_results())
    if user_info.rowcount < 1:
        return None
    table = []
    table.append( user_info.column_names )
    for row in user_info.fetchall():
        table.append( row )
    return table

def list_electronics() -> list | None:
    cursor = queryDB( 'ListElectronics', [] )
    user_info = next(cursor.stored_results())
    if user_info.rowcount < 1:
        return None
    table = []
    table.append( user_info.column_names )
    for row in user_info.fetchall():
        table.append( row )
    return table

def list_price(intMin: int, intMax: int) -> list | None:
    cursor = queryDB( 'ListPrice', [intMin, intMax] )
    user_info = next(cursor.stored_results())
    if user_info.rowcount < 1:
        return None
    table = []
    table.append( user_info.column_names )
    for row in user_info.fetchall():
        table.append( row )
    return table

def list_quantity(intMin: int, intMax: int) -> list | None:
    cursor = queryDB( 'ListQuantity', [intMin, intMax] )
    user_info = next(cursor.stored_results())
    if user_info.rowcount < 1:
        return None
    table = []
    table.append( user_info.column_names )
    for row in user_info.fetchall():
        table.append( row )
    return table

def search_user_blocked() -> list | None:
    cursor = queryDB( 'SearchUserBlocked', [] )
    user_info = next(cursor.stored_results())
    if user_info.rowcount < 1:
        return None
    table = []
    table.append( user_info.column_names )
    for row in user_info.fetchall():
        table.append( row )
    return table

def search_user_id(id: int) -> dict | None:
    cursor = queryDB( 'SearchUserByID', [id] )
    user_info = next(cursor.stored_results())
    if user_info.rowcount != 1:
        return None
    user_row = user_info.fetchall()[0]
    return dict(zip(user_info.column_names, user_row))

def search_user_name(firstname: str, apelido: str) -> list | None:
    cursor = queryDB( 'SearchUserByName', [firstname, apelido] )
    user_info = next(cursor.stored_results())
    if user_info.rowcount < 1:
        return None
    table = []
    table.append( user_info.column_names )
    for row in user_info.fetchall():
        table.append( row )
    return table
