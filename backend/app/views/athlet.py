from flask import request, Blueprint
from database import mysql

athlet_bp = Blueprint("athlet", __name__)

@athlet_bp.route('/registAthlet', methods=["POST"])
def registAthlet():
    if request.method=="POST":

        data=request.get_json()

        name = str(data["name"])
        surname = str(data["surname"])
        password = str(data["password"])
        age = str(data["class"])
        username = name + "_" + surname
        role = "atleta"

        ptr = mysql.connection.cursor()

        query = "SELECT * FROM user WHERE username=%s;"
        values = (username,)
        ptr.execute(query, values)
        list = ptr.fetchall()

        if len(list)!=0: return {"success":False,"error":"username_already_exists"}

        query = "INSERT INTO user (username, name, surname, password, role, class) VALUES (%s, %s, %s, %s, %s, %s);"
        values = (username, name, surname, password, role, age)
        ptr.execute(query, values)
        mysql.connection.commit()
        
        return {"success":True}
    
@athlet_bp.route('/getAthletList', methods=["GET"])
def getAthletList():
    if request.method=="GET":

        ptr = mysql.connection.cursor()

        query = "SELECT name, surname, class FROM user;"
        ptr.execute(query)
        list = ptr.fetchall()

        if len(list)==0: return {"success":False,"error":"no_athlets_found"}

        return {"success":True, "list":list}
    