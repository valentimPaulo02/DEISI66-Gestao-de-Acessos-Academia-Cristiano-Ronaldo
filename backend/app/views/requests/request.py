from flask import request, Blueprint
from database import mysql
from datetime import date, time, datetime

request_bp = Blueprint("request", __name__)

@request_bp.route('/checkRequest', methods=["POST"])
def checkRequest():
    if request.method=="POST":

        ptr = mysql.connection.cursor()
        data = request.get_json()

        request_id = data["request_id"]
        accepted = data["accepted"]
        type = data["type"]
        checked_by = data["updated_by"]
        check_date = datetime.today().date()

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