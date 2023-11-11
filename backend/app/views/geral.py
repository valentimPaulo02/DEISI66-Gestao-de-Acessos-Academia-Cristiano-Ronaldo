from flask import request, Blueprint
from uuid import uuid4
from database import mysql

geral_bp = Blueprint("geral", __name__)

@geral_bp.route('/login', methods=["POST"])
def login():
    if request.method=="POST":

        ptr = mysql.connection.cursor()
        data=request.get_json()

        username = str(data["username"])
        password = str(data["password"])
        token = uuid4()

        query = "SELECT * FROM user WHERE username=%s;"
        values = (username,)
        ptr.execute(query, values)
        info = ptr.fetchall()

        if len(info)==0: return {"success":False,"error":"invalid_username"}

        if password != info[0]["password"]: return {"success":False,"error":"invalid_password"}

        query = "UPDATE user SET token=%s WHERE username=%s"
        values = (token, username)
        ptr.execute(query, values)
        mysql.connection.commit()

        return {"success":True, "token":token}
    

@geral_bp.route('/logout', methods=["POST"])
def logout():
    if request.method=="POST":

        ptr = mysql.connection.cursor()
        data=request.get_json()

        token = str(data["token"])

        query = "SELECT * FROM user WHERE token=%s;"
        values = (token,)
        ptr.execute(query, values)
        info = ptr.fetchall()

        username = info[0]["username"]

        query = "UPDATE user SET token=NULL WHERE username=%s"
        values = (username, )
        ptr.execute(query, values)
        mysql.connection.commit()

        return {"success":True}