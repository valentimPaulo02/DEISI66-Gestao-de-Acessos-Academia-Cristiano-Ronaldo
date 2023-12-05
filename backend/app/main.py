from flask import Flask
from flask_cors import CORS
from database import mysql
from views.geral import geral_bp
from views.athlete import athlete_bp


app = Flask(__name__)
CORS(app)

app.config['MYSQL_USER'] = "root"
app.config['MYSQL_PASSWORD'] = "frizze2002"
app.config['MYSQL_HOST'] = "localhost"
app.config['MYSQL_DB'] = "academiasporting"
app.config['MYSQL_CURSORCLASS'] = "DictCursor"

mysql.init_app(app)

app.register_blueprint(geral_bp)
app.register_blueprint(athlete_bp)


if __name__=="__main__" :
    app.run(debug=True)