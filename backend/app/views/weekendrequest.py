from flask import request, Blueprint
from database import mysql
from datetime import date, time, datetime, timedelta

weekendrequest_bp = Blueprint("weekendrequest", __name__)

@weekendrequest_bp.route('/makeWeekendRequest', methods=["POST"])
def makeWeekendRequest():
    if request.method=="POST":

        ptr = mysql.connection.cursor()
        data = request.get_json()

        token = str(data["token"])
        leave_date = str(data["leave_date"])
        leave_time = str(data["leave_time"])
        supervisor = str(data["supervisor"])
        transport = str(data["transport"])
        destiny = str(data["destiny"])
        state = "pending"
        validated = False
        date = datetime.today().date()

        query = "SELECT * FROM user WHERE token=%s;"
        values = (token,)
        ptr.execute(query, values)
        info = ptr.fetchall()

        user_id = info[0]["user_id"]
        leave_date = datetime.fromisoformat(leave_date).date()
        leave_time = datetime.strptime(leave_time, "%H:%M").time()

        query = "INSERT INTO weekendrequest (user_id, state, validated, date, leave_date, leave_time, supervisor, transport_out, destiny) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s);"
        values = (user_id, state, validated, date, leave_date, leave_time, supervisor, transport, destiny)
        ptr.execute(query, values)
        mysql.connection.commit()
        
        return {"success":True}
    
    
@weekendrequest_bp.route('/getAllWeekendRequest', methods=["GET"])
def getAllWeekendRequest():
    if request.method=="GET":

        ptr = mysql.connection.cursor()

        query = "SELECT * FROM weekendrequest;"
        ptr.execute(query)
        result = ptr.fetchall()

        if len(result)==0: return {"success":False,"error":"no_requests_found"}

        formatted_list = []
        for row in result:
            formatted_row = {
                "request_id": row['request_id'],
                "user_id": row['user_id'],
                "state": row['state'],
                "validated": bool(row['validated']),
                "supervisor": row['supervisor'],
                "transport_out": row['transport_out'],
                "destiny": row['destiny'],
                "leave_time": str(row['leave_time']),
                "leave_date": row['leave_date'].strftime("%Y-%m-%d")
            }
            formatted_list.append(formatted_row)

        return {"success":True, "list":formatted_list}
    

@weekendrequest_bp.route('/getUserWeekendRequest', methods=["GET"])
def getUserWeekendRequest():
    if request.method=="GET":

        ptr = mysql.connection.cursor()

        token = request.headers.get("token")

        query = "SELECT * FROM user WHERE token=%s;"
        values = (token,)
        ptr.execute(query, values)
        info = ptr.fetchall()

        id = info[0]['user_id']

        query = "SELECT * FROM weekendrequest WHERE user_id=%s;"
        values = (id,)
        ptr.execute(query, values)
        result = ptr.fetchall()

        if len(result)==0: return {"success":False,"error":"no_requests_found"}

        formatted_list = []
        for row in result:
            formatted_row = {
                "request_id": row['request_id'],
                "user_id": row['user_id'],
                "state": row['state'],
                "validated": bool(row['validated']),
                "supervisor": row['supervisor'],
                "transport_out": row['transport_out'],
                "destiny": row['destiny'],
                "leave_time": str(row['leave_time']),
                "leave_date": row['leave_date'].strftime("%Y-%m-%d")
            }
            formatted_list.append(formatted_row)

        return {"success":True, "list":formatted_list}