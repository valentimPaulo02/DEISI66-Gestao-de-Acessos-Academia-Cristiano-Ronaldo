from flask import Flask, request
from flask_mysqldb import MySQL
from uuid import uuid4



app = Flask(__name__)

app.config['MYSQL_USER'] = "root"
app.config['MYSQL_PASSWORD'] = "sportingtfc2023"
app.config['MYSQL_HOST'] = "localhost"
app.config['MYSQL_DB'] = "academiasporting"
app.config['MYSQL_CURSORCLASS'] = "DictCursor"

mysql = MySQL(app)



@app.route('/login', methods=["POST"])
def login():
    if request.method=="POST":

        data=request.get_json()

        username = str(data["username"])
        password = str(data["password"])
        token = uuid4()

        ptr = mysql.connection.cursor()

        query = "SELECT * FROM user WHERE username=%s;"
        values = (username,)
        ptr.execute(query, values)
        list = ptr.fetchall()

        if len(list)==0: return {"success":False,"error":"invalid_username"}

        if password != list[0]["password"]: return {"success":False,"error":"invalid_password"}

        query = "UPDATE user SET token=%s WHERE username=%s"
        values = (token, username)
        ptr.execute(query, values)
        mysql.connection.commit()

        return {"success":True, "token":token}


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

        ptr = mysql.connection.cursor()

        query = "SELECT * FROM user WHERE username=%s;"
        values = (username,)
        ptr.execute(query, values)
        list = ptr.fetchall()

        if len(list)!=0: return {"success":False,"error":"username_already_exists"}

        query = "INSERT INTO user (username, name, surname, password, role, class) VALUES (%s, %s, %s, %s, %s, %s);"
        values = (username, name, surname, password, role, age)
        ptr.execute(query, values)
        mysql.connection.commit()
        
        return {"success":True}
    

@app.route('/getAthletList', methods=["GET"])
def getAthletList():
    if request.method=="GET":

        ptr = mysql.connection.cursor()

        query = "SELECT name, surname, class FROM user;"
        ptr.execute(query)
        list = ptr.fetchall()

        if len(list)==0: return {"success":False,"error":"no_athlets_found"}

        return {"success":True, "list":list}
    








if __name__=="__main__" :
    app.run(debug=True)