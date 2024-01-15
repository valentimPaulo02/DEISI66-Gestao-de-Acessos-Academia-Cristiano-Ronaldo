from flask import request, Blueprint
from database import mysql
from datetime import date, time, datetime

request_bp = Blueprint("request", __name__)

@request_bp.route('/makeTemporaryRequest', methods=["POST"])
def makeTemporaryRequest():
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

        query = "INSERT INTO temporaryrequest (user_id, state, validated, date, leave_date, leave_time, supervisor, transport_out, destiny, arrival_date, arrival_time) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);"
        values = (user_id, state, validated, date, leave_date, leave_time, supervisor, transport, destiny, arrival_date, arrival_time)
        ptr.execute(query, values)
        mysql.connection.commit()
        
        return {"success":True}
    

@request_bp.route('/makeWeekendRequest', methods=["POST"])
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