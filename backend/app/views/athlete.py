from flask import request, Blueprint, jsonify
from database import mysql
from datetime import date, time, datetime, timedelta
import pytz

athlete_bp = Blueprint("athlete", __name__)

@athlete_bp.route('/registAthlete', methods=["POST"])
def registAthlete():
    if request.method=="POST":

        ptr = mysql.connection.cursor()
        data = request.get_json()

        name = str(data["name"])
        surname = str(data["surname"])
        password = str(data["password"])
        category = str(data["category"])
        image = str(data["image"])
        room_number = data["room_number"]
        birth_date = str(data["birth_date"])
        username = name + "_" + surname
        role = "athlete"

        date = datetime.fromisoformat(birth_date).date()

        query = "SELECT * FROM user WHERE username=%s;"
        values = (username,)
        ptr.execute(query, values)
        info = ptr.fetchall()

        if len(info)!=0: return {"success":False,"error":"username_already_exists"}

        query = "INSERT INTO user (username, name, surname, password, role, category, image_path, room_number, birth_date) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s);"
        values = (username, name, surname, password, role, category, image, room_number, date)
        ptr.execute(query, values)
        mysql.connection.commit()
        
        return {"success":True}


@athlete_bp.route('/getAthleteList', methods=["GET"])
def getAthleteList():
    if request.method=="GET":

        ptr = mysql.connection.cursor()

        query = "SELECT * FROM user WHERE role='athlete';"
        ptr.execute(query)
        list = ptr.fetchall()

        if len(list)==0: return {"success":False,"error":"no_athletes_found"}

        formatted_list = []
        for row in list:
            
            formatted_row = {
                "user_id": row['user_id'],
                "name": row['name'],
                "surname": row['surname'],
                "password": row['password'],
                "category": row['category'],
                "room_number": row['room_number'],
                "birth_date": row['birth_date'].strftime("%Y-%m-%d"),
                "image": row['image_path'],
            }
            formatted_list.append(formatted_row)

        return {"success":True, "list":formatted_list}
    

@athlete_bp.route('/updateAthlete', methods=["POST"])
def updateAthlete():
    if request.method=="POST":

        ptr = mysql.connection.cursor()
        data = request.get_json()

        id = data["user_id"]
        name = data["name"]
        surname = data["surname"]
        password = data["password"]
        category = data["category"]
        room_number = data["room_number"]
        birth_date = data["birth_date"]

        query = "UPDATE user SET password=%s WHERE user_id=%s"
        values = (password, id)
        ptr.execute(query, values)
        mysql.connection.commit()

        query = "UPDATE user SET category=%s, room_number=%s, birth_date=%s WHERE user_id=%s"
        values = (category, room_number, birth_date, id)
        ptr.execute(query, values)
        mysql.connection.commit()

        username = name + "_" + surname

        query = "SELECT * FROM user WHERE username=%s;"
        values = (username,)
        ptr.execute(query, values)
        info = ptr.fetchall()

        if len(info)!=0: return {"success":False,"error":"username_already_exists"}

        query = "UPDATE user SET name=%s, surname=%s, username=%s WHERE user_id=%s"
        values = (name, surname, username, id)
        ptr.execute(query, values)
        mysql.connection.commit()

        return {"success":True}
    

@athlete_bp.route('/getAvailableAthletes', methods=["GET"])
def getAvailableAthletes():
    if request.method == "GET":
        
        ptr = mysql.connection.cursor()

        portugal_tz = pytz.timezone('Europe/Lisbon')
        current_date = datetime.now().date()
        current_time = datetime.now(portugal_tz).time()

        unavailable_ids = set()

        # GET ALL ACCEPTED WEEKEND REQUEST
        query = "SELECT * FROM weekendrequest WHERE state='authorized';"
        ptr.execute(query)
        weekend_list = ptr.fetchall()

        for row in weekend_list:
            if(row['user_id'] in unavailable_ids): continue

            leave_time = datetime.strptime(str(row['leave_time']), "%H:%M:%S").time()
            arrival_time = datetime.strptime(str(row['arrival_time']), "%H:%M:%S").time()

            if (row['leave_date'] <= current_date <= row['arrival_date']):
                if((row['leave_date'] == current_date) and (leave_time <= current_time)): unavailable_ids.add(row['user_id'])
                elif((row['arrival_date'] == current_date) and (current_time <= arrival_time)): unavailable_ids.add(row['user_id'])
                elif(row['leave_date'] < current_date < row['arrival_date']): unavailable_ids.add(row['user_id'])

        # GET ALL ACCEPTED TEMPORARY REQUEST
        query = "SELECT * FROM temporaryrequest WHERE state='authorized';"
        ptr.execute(query)
        temporary_list = ptr.fetchall()

        for row in temporary_list:
            if(row['user_id'] in unavailable_ids): continue

            leave_time = datetime.strptime(str(row['leave_time']), "%H:%M:%S").time()
            arrival_time = datetime.strptime(str(row['arrival_time']), "%H:%M:%S").time()

            if (row['leave_date'] <= current_date <= row['arrival_date']):

                if((row['leave_date'] == current_date) and (leave_time <= current_time)):
                    if((row['arrival_date'] == current_date) and (current_time <= arrival_time)): unavailable_ids.add(row['user_id'])
                    elif(current_date < row['arrival_date']): unavailable_ids.add(row['user_id'])

                elif((row['arrival_date'] == current_date) and (current_time <= arrival_time)):
                    if((row['leave_date'] == current_date) and (leave_time <= current_time)): unavailable_ids.add(row['user_id'])
                    elif(row['leave_date'] < current_date): unavailable_ids.add(row['user_id'])

                elif(row['leave_date'] < current_date < row['arrival_date']):
                    unavailable_ids.add(row['user_id'])

        available_athletes = []
        unavailable_athletes = []

        #GET ALL ATHLETES
        query = "SELECT * FROM user WHERE role='athlete';"
        ptr.execute(query)
        athletes = ptr.fetchall()

        if len(athletes) == 0: return {"success": False, "error": "no_athletes_found"}

        for row in athletes:
            if(row['user_id'] in unavailable_ids): unavailable_athletes.append(row)
            else: available_athletes.append(row)

        return {"success": True, "available_athletes": available_athletes, "unavailable_athletes":unavailable_athletes}