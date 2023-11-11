from flask import request, Blueprint
from database import mysql

athlete_bp = Blueprint("athlete", __name__)

@athlete_bp.route('/registAthlete', methods=["POST"])
def registAthlete():
    if request.method=="POST":

        ptr = mysql.connection.cursor()
        data = request.get_json()

        name = str(data["name"])
        surname = str(data["surname"])
        password = str(data["password"])
        category = str(data["class"])
        username = name + "_" + surname
        role = "atleta"

        query = "SELECT * FROM user WHERE username=%s;"
        values = (username,)
        ptr.execute(query, values)
        info = ptr.fetchall()

        if len(info)!=0: return {"success":False,"error":"username_already_exists"}

        query = "INSERT INTO user (username, name, surname, password, role, class) VALUES (%s, %s, %s, %s, %s, %s);"
        values = (username, name, surname, password, role, category)
        ptr.execute(query, values)
        mysql.connection.commit()
        
        return {"success":True}


@athlete_bp.route('/getAthleteList', methods=["GET"])
def getAthleteList():
    if request.method=="GET":

        ptr = mysql.connection.cursor()

        query = "SELECT name, surname, class FROM user;"
        ptr.execute(query)
        list = ptr.fetchall()

        if len(list)==0: return {"success":False,"error":"no_athletes_found"}

        return {"success":True, "list":list}
    