from flask import request, Blueprint, jsonify
from uuid import uuid4
from database import mysql

geral_bp = Blueprint("geral", __name__)

@geral_bp.route('/login', methods=["POST"])
def login():
    if request.method=="POST":

        ptr = mysql.connection.cursor()
        data = request.get_json()

        username = str(data["username"])
        password = str(data["password"])
        token = uuid4()

        while True:
            query = "SELECT * FROM user WHERE token=%s;"
            values = (token,)
            ptr.execute(query, values)
            info = ptr.fetchall()

            if len(info)==0: break
            else: token=uuid4()

        query = "SELECT * FROM user WHERE username=%s;"
        values = (username,)
        ptr.execute(query, values)
        info = ptr.fetchall()

        if len(info)==0: return {"success":False,"error":"invalid_username"}

        dbpassword = info[0]["password"]

        if password!=dbpassword: return {"success":False,"error":"invalid_password"}

        query = "UPDATE user SET token=%s WHERE username=%s"
        values = (token, username)
        ptr.execute(query, values)
        mysql.connection.commit()

        return {"success":True, "token":token}
    

@geral_bp.route('/logout', methods=["POST"])
def logout():
    if request.method=="POST":

        ptr = mysql.connection.cursor()
        data = request.get_json()

        token = str(data["token"])

        query = "SELECT * FROM user WHERE token=%s;"
        values = (token,)
        ptr.execute(query, values)
        info = ptr.fetchall()

        dbusername = info[0]["username"]

        query = "UPDATE user SET token=NULL WHERE username=%s"
        values = (dbusername, )
        ptr.execute(query, values)
        mysql.connection.commit()

        return {"success":True}
    

@geral_bp.route('/getRole', methods=["GET"])
def getRole():
    if request.method=="GET":

        ptr = mysql.connection.cursor()

        token = request.headers.get("token")

        query = "SELECT * FROM user WHERE token=%s;"
        values = (token,)
        ptr.execute(query, values)
        info = ptr.fetchall()

        role = info[0]["role"]

        return {"success":True, "role":role}
    

@geral_bp.route('/deleteUser', methods=["POST"])
def deleteUser():
    if request.method=="POST":

        ptr = mysql.connection.cursor()
        data = request.get_json()

        id = data["user_id"]

        query = "DELETE FROM user WHERE user_id=%s;"
        values = (id,)
        ptr.execute(query, values)
        mysql.connection.commit()

        return {"success":True}
        

@geral_bp.route('/getUserData', methods=["GET"])
def getUserData():
    if request.method=="GET":

        ptr = mysql.connection.cursor()

        token = request.headers.get("token")

        query = "SELECT * FROM user WHERE token=%s;"
        values = (token,)
        ptr.execute(query, values)
        info = ptr.fetchall()

        name = info[0]["name"]
        surname = info[0]["surname"]
        password = info[0]["password"]
        image = info[0]["image_path"] 
        room = info[0]["room_number"] if info[0]['room_number'] is not None else ""

        return {"success":True, "name":name, "surname":surname, "password":password, "image":image, "room":room}
    

@geral_bp.route('/updatePassword', methods=["POST"])
def updatePassword():
    if request.method=="POST":

        ptr = mysql.connection.cursor()
        data = request.get_json()

        token = data["token"]
        password = data["password"]

        query = "SELECT * FROM user WHERE token=%s;"
        values = (token,)
        ptr.execute(query, values)
        info = ptr.fetchall()

        dbpassword = info[0]["password"]

        if(dbpassword == password): return {"success":False}

        query = "UPDATE user SET password=%s WHERE token=%s"
        values = (password, token)
        ptr.execute(query, values)
        mysql.connection.commit()

        return {"success":True}