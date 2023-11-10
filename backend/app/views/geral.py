from flask import request, Blueprint
from uuid import uuid4
from database import mysql

geral_bp = Blueprint("geral", __name__)

@geral_bp.route('/login', methods=["POST"])
def login():
    if request.method=="POST":

        data=request.get_json()

        username = str(data["username"])
        password = str(data["password"])
        token = uuid4()

        ptr = mysql.connection.cursor()

        query = "SELECT * FROM user WHERE username=%s;"
        values = (username,)
        ptr.execute(query, values)
        list = ptr.fetchall()

        if len(list)==0: return {"success":False,"error":"invalid_username"}

        if password != list[0]["password"]: return {"success":False,"error":"invalid_password"}

        query = "UPDATE user SET token=%s WHERE username=%s"
        values = (token, username)
        ptr.execute(query, values)
        mysql.connection.commit()

        return {"success":True, "token":token}