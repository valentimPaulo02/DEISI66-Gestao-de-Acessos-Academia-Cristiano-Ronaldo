from flask import Flask
from flask_cors import CORS
from database import mysql
from views.geral import geral_bp
from views.athlete import athlete_bp
from views.request import request_bp
from views.supervisor import supervisor_bp


app = Flask(__name__)
CORS(app)

app.config['MYSQL_USER'] = "root"
app.config['MYSQL_PASSWORD'] = "sporting_database_connection_GUGf983YDR34535Dtdt"
app.config['MYSQL_HOST'] = "127.0.0.1"
app.config['MYSQL_DB'] = "academiasporting"
app.config['MYSQL_CURSORCLASS'] = "DictCursor"

mysql.init_app(app)

app.register_blueprint(geral_bp)
app.register_blueprint(athlete_bp)
app.register_blueprint(request_bp)
app.register_blueprint(supervisor_bp)


if __name__=="__main__" :
    app.run(debug=True, host="0.0.0.0")