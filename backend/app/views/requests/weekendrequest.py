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
        arrival_date = str(data["arrival_date"])
        arrival_time = str(data["arrival_time"])
        state = "pending"
        validated = False
        date = datetime.today().date()

        query = "SELECT * FROM user WHERE token=%s;"
        values = (token,)
        ptr.execute(query, values)
        info = ptr.fetchall()

        user_id = info[0]["user_id"]
        leave_date = datetime.fromisoformat(leave_date).date()
        arrival_date = datetime.fromisoformat(arrival_date).date()
        leave_time = datetime.strptime(leave_time, "%H:%M").time()
        arrival_time = datetime.strptime(arrival_time, "%H:%M").time()

        query = "INSERT INTO weekendrequest (user_id, state, validated, date, leave_date, leave_time, supervisor, transport_out, destiny, arrival_date, arrival_time) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);"
        values = (user_id, state, validated, date, leave_date, leave_time, supervisor, transport, destiny, arrival_date, arrival_time)
        ptr.execute(query, values)
        mysql.connection.commit()
        
        return {"success":True}
    
    
@weekendrequest_bp.route('/getAllWeekendRequest', methods=["GET"])
def getAllWeekendRequest():
    if request.method=="GET":

        ptr = mysql.connection.cursor()

        query = "SELECT * FROM weekendrequest;"
        ptr.execute(query)
        list = ptr.fetchall()

        if len(list)==0: return {"success":False,"error":"no_requests_found"}

        formatted_list = []
        for row in list:

            query = "SELECT username FROM user WHERE user_id=%s;"
            values = (row['user_id'],)
            ptr.execute(query, values)
            info = ptr.fetchall()

            username = info[0]['username']

            formatted_row = {
                "request_id": row['request_id'],
                "user_id": row['user_id'],
                "username": username,
                "state": row['state'],
                "date": row['date'].strftime("%Y-%m-%d"),
                "leave_date": row['leave_date'].strftime("%Y-%m-%d"),
                "leave_time": str(row['leave_time']),
                "destiny": row['destiny'],
                "transport": row['transport_out'],
                "supervisor": row['supervisor'],
                "arrival_date": row['arrival_date'].strftime("%Y-%m-%d"),
                "arrival_time": str(row['arrival_time']),
                "note": str(row['note']),
                "updated_by": row['updated_by'],
                "updated_at": row['updated_at'].strftime("%Y-%m-%d")
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
        username = info[0]['username']

        query = "SELECT * FROM weekendrequest WHERE user_id=%s;"
        values = (id,)
        ptr.execute(query, values)
        list = ptr.fetchall()

        if len(list)==0: return {"success":False,"error":"no_requests_found"}

        formatted_list = []
        for row in list:
            
            formatted_row = {
                "request_id": row['request_id'],
                "user_id": id,
                "username": username,
                "state": row['state'],
                "date": row['date'].strftime("%Y-%m-%d"),
                "leave_date": row['leave_date'].strftime("%Y-%m-%d"),
                "leave_time": str(row['leave_time']),
                "destiny": row['destiny'],
                "transport": row['transport_out'],
                "supervisor": row['supervisor'],
                "arrival_date": row['arrival_date'].strftime("%Y-%m-%d"),
                "arrival_time": str(row['arrival_time']),
                "note": str(row['note']),
                "updated_by": row['updated_by'],
                "updated_at": row['updated_at'].strftime("%Y-%m-%d")
            }
            formatted_list.append(formatted_row)

        return {"success":True, "list":formatted_list}
    

@weekendrequest_bp.route('/updateWeekendRequest', methods=["POST"])
def updateWeekendRequest():
    if request.method=="POST":

        ptr = mysql.connection.cursor()
        data = request.get_json()

        request_id = data["request_id"]
        leave_date = str(data["leave_date"])
        leave_time = str(data["leave_time"])
        supervisor = str(data["supervisor"])
        transport = str(data["transport"])
        destiny = str(data["destiny"])
        arrival_date = str(data["arrival_date"])
        arrival_time = str(data["arrival_time"])

        leave_date = datetime.fromisoformat(leave_date).date()
        arrival_date = datetime.fromisoformat(arrival_date).date()
        leave_time = datetime.strptime(leave_time, "%H:%M").time()
        arrival_time = datetime.strptime(arrival_time, "%H:%M").time()

        query = "UPDATE weekendrequest SET leave_date=%s, leave_time=%s, supervisor=%s, transport_out=%s, destiny=%s, arrival_date=%s, arrival_time=%s WHERE request_id=%s;"
        values = (leave_date, leave_time, supervisor, transport, destiny, arrival_date, arrival_time, request_id)
        ptr.execute(query, values)
        mysql.connection.commit()
        
        return {"success":True}