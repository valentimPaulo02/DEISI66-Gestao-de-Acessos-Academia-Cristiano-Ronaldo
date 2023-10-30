from flask import Flask, request
from flask_mysqldb import MySQL

app= Flask(__name__)

app.config['MYSQL_USER'] = "root"
app.config['MYSQL_PASSWORD'] = "sportingtfc2023"
app.config['MYSQL_HOST'] = "localhost"
app.config['MYSQL_DB'] = "academiasporting"
app.config['MYSQL_CURSORCLASS'] = "DictCursor"

mysql = MySQL(app)


#VALIDATE LOGIN FUNCTION
@app.route('/login', methods=["POST"])
def login():
    if request.method=="POST":
        data=request.get_json()
        username = str(data["username"])
        password = str(data["password"])

        cur = mysql.connection.cursor()

        query = "SELECT * FROM user WHERE username=%s;"
        val = (username,)

        cur.execute(query, val)
        info = cur.fetchall()

        if len(info)==0: return {"success":False,"error":"invalid_username"}

        if password != info[0]["password"]: return {"success":False,"error":"invalid_password"}
        
        return {"success":True}



#CREATE USER
@app.route('/registerUser', methods=["POST"])
def registerUser():
    if request.method=="POST":
        data=request.get_json()
        name = str(data["name"])
        surname = str(data["surname"])
        password = str(data["password"])
        age = str(data["class"])
        
        username = name + "_" + surname
        role = "atleta"

        cur = mysql.connection.cursor()

        query = "SELECT * FROM user WHERE username=%s;"
        val = (username,)
        
        cur.execute(query, val)
        info = cur.fetchall()

        if len(info)!=0: return {"success":False,"error":"username_already_exists"}

        query = "INSERT INTO academiasporting.user (username, name, surname, password, role, class) VALUES (%s, %s, %s, %s, %s, %s);"
        val = (username, name, surname, password, role, age)

        cur.execute(query, val)
        mysql.connection.commit()
        
        return {"success":True}












if __name__=="__main__" :
    app.run(debug=True)