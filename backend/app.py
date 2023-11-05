from flask import Flask, request
from flask_mysqldb import MySQL
from uuid import uuid4

# DataBase Connection ---------------------------
app= Flask(__name__)

app.config['MYSQL_USER'] = "root"
app.config['MYSQL_PASSWORD'] = "sportingtfc2023"
app.config['MYSQL_HOST'] = "localhost"
app.config['MYSQL_DB'] = "academiasporting"
app.config['MYSQL_CURSORCLASS'] = "DictCursor"

mysql = MySQL(app)
# -----------------------------------------------


# Validate Login Function -----------------------
@app.route('/login', methods=["POST"])

def login():
    if request.method=="POST":
        data=request.get_json()

        # Variables
        username = str(data["username"])
        password = str(data["password"])
        token = uuid4()

        # DataBase Pointer
        cur = mysql.connection.cursor()

        # 1º Query - Get the user, with the specific username
        query = "SELECT * FROM user WHERE username=%s;"
        val = (username,)
        cur.execute(query, val)
        info = cur.fetchall()

        # Return false, because there isn't a user in the DataBase with that specific username
        if len(info)==0: return {"success":False,"error":"invalid_username"}

        # Return false, because the password submited doesn't match the user password
        if password != info[0]["password"]: return {"success":False,"error":"invalid_password"}

        # 2º Query - Update the token value inside the DataBase
        query = "UPDATE user SET token=%s WHERE username=%s"
        val = (token, username)
        cur.execute(query, val)
        mysql.connection.commit()

        # Return true, because the user is successfully logged in
        return {"success":True, "token":token}
# -----------------------------------------------


# Ceate User ------------------------------------
@app.route('/registerUser', methods=["POST"])

def registerUser():
    if request.method=="POST":
        data=request.get_json()

        # Variables
        name = str(data["name"])
        surname = str(data["surname"])
        password = str(data["password"])
        age = str(data["class"])
        username = name + "_" + surname
        role = "atleta"

        # DataBase Pointer
        cur = mysql.connection.cursor()

        # 1º Query - Get the user, with the specific username
        query = "SELECT * FROM user WHERE username=%s;"
        val = (username,)
        cur.execute(query, val)
        info = cur.fetchall()

        # Return false, because username already exists in DataBase
        if len(info)!=0: return {"success":False,"error":"username_already_exists"}

        # 2º Query - Insert a new user into the users table
        query = "INSERT INTO academiasporting.user (username, name, surname, password, role, class) VALUES (%s, %s, %s, %s, %s, %s);"
        val = (username, name, surname, password, role, age)
        cur.execute(query, val)
        mysql.connection.commit()
        
        # Return true, because the new user was created successfully
        return {"success":True}
# -----------------------------------------------











if __name__=="__main__" :
    app.run(debug=True)