from flask import request, Blueprint
from database import mysql

supervisor_bp = Blueprint("supervisor", __name__)

@supervisor_bp.route('/registSupervisor', methods=["POST"]) #TODO - UPDATE
def registSupervisor():
    if request.method=="POST":

        ptr = mysql.connection.cursor()
        data = request.get_json()

        name = str(data["name"])
        surname = str(data["surname"])
        password = str(data["password"])
        image = str(data["image"])
        username = name + "_" + surname
        role = "supervisor"

        query = "SELECT * FROM user WHERE username=%s;"
        values = (username,)
        ptr.execute(query, values)
        info = ptr.fetchall()

        if len(info)!=0: return {"success":False,"error":"username_already_exists"}

        query = "INSERT INTO user (username, name, surname, password, role, image_path) VALUES (%s, %s, %s, %s, %s, %s);"
        values = (username, name, surname, password, role, image)
        ptr.execute(query, values)
        mysql.connection.commit()
        
        return {"success":True}


@supervisor_bp.route('/getSupervisorList', methods=["GET"])
def getSupervisorList():
    if request.method=="GET":

        ptr = mysql.connection.cursor()

        query = "SELECT * FROM user WHERE role='supervisor';"
        ptr.execute(query)
        list = ptr.fetchall()

        if len(list)==0: return {"success":False,"error":"no_supervisors_found"}

        return {"success":True, "list":list}
    

@supervisor_bp.route('/updateSupervisor', methods=["POST"])
def updateSupervisor():
    if request.method=="POST":

        ptr = mysql.connection.cursor()
        data = request.get_json()

        id = data["user_id"]
        name = data["name"]
        surname = data["surname"]
        password = data["password"]

        query = "SELECT * FROM user WHERE user_id=%s;"
        values = (id,)
        ptr.execute(query, values)
        info = ptr.fetchall()

        user_name = info[0]["name"]
        user_surname = info[0]["surname"]
        user_password = info[0]["password"]

        if name != user_name: user_name = name
        if surname != user_surname: user_surname = surname
        if password != user_password: user_password = password

        user_username = user_name + "_" + user_surname

        query = "SELECT * FROM user WHERE username=%s;"
        values = (user_username,)
        ptr.execute(query, values)
        info = ptr.fetchall()

        if len(info)!=0: return {"success":False,"error":"username_already_exists"}

        query = "UPDATE user SET name=%s, surname=%s, username=%s, password=%s WHERE user_id=%s"
        values = (user_name, user_surname, user_username, user_password, id)
        ptr.execute(query, values)
        mysql.connection.commit()

        return {"success":True}