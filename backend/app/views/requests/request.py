from flask import request, Blueprint, jsonify
from database import mysql
from datetime import date, time, datetime

from flask import jsonify

request_bp = Blueprint("request", __name__, url_prefix="/DEISI66")

@request_bp.route('/checkRequest', methods=["POST"])
def checkRequest():
    if request.method=="POST":

        ptr = mysql.connection.cursor()
        data = request.get_json()

        request_id = data["request_id"]
        accepted = data["accepted"]
        type = data["type"]
        token = data["updated_by"]
        check_date = datetime.today().date()

        query = "SELECT * FROM user WHERE token=%s;"
        values = (token,)
        ptr.execute(query, values)
        info = ptr.fetchall()

        checked_by = info[0]["username"]

        if accepted == 1 : state = "authorized"
        elif accepted == 0 : state = "refused"
        else : return {"success":False, "error":"invalid_value_of_accepted"}

        if type == "Temporary" : query = "UPDATE temporaryrequest SET state=%s, updated_by=%s, updated_at=%s WHERE request_id=%s"
        elif type == "Weekend" : query = "UPDATE weekendrequest SET state=%s, updated_by=%s, updated_at=%s WHERE request_id=%s"
        else : return {"success":False, "error":"invalid_value_of_type"}
        
        values = (state, checked_by, check_date, request_id)
        ptr.execute(query, values)
        mysql.connection.commit()
        
        return {"success":True}
    

@request_bp.route('/editRequest', methods=["POST"])
def editRequest():
    if request.method=="POST":

        ptr = mysql.connection.cursor()
        data = request.get_json()

        request_id = data["request_id"]
        accepted = data["accepted"]
        type = data["type"]
        note = data["note"]

        if accepted == 1 : state = "authorized"
        elif accepted == 0 : state = "refused"
        else : return {"success":False, "error":"invalid_value_of_accepted"}

        if type == "Temporary" : 
            if note == "": 
                query = "UPDATE temporaryrequest SET state=%s WHERE request_id=%s"
                values = (state, request_id)
                ptr.execute(query, values)
                mysql.connection.commit()
            else:
                query = "UPDATE temporaryrequest SET state=%s, note=%s WHERE request_id=%s"
                values = (state, note, request_id)
                ptr.execute(query, values)
                mysql.connection.commit()

        elif type == "Weekend" :
            if note == "": 
                query = "UPDATE weekendrequest SET state=%s WHERE request_id=%s"
                values = (state, request_id)
                ptr.execute(query, values)
                mysql.connection.commit()
            else:
                query = "UPDATE weekendrequest SET state=%s, note=%s WHERE request_id=%s"
                values = (state, note, request_id)
                ptr.execute(query, values)
                mysql.connection.commit()
                
        else : return {"success":False, "error":"invalid_value_of_type"}
        
        
        
        return {"success":True}