from flask import request, Blueprint
from database import mysql

supervisor_bp = Blueprint("supervisor", __name__)

@supervisor_bp.route('/getSupervisorList', methods=["GET"])
def getSupervisorList():
    if request.method=="GET":

        ptr = mysql.connection.cursor()

        query = "SELECT name, surname FROM user WHERE role='supervisor';"
        ptr.execute(query)
        list = ptr.fetchall()

        if len(list)==0: return {"success":False,"error":"no_supervisors_found"}

        return {"success":True, "list":list}