from flask import request, Blueprint
from database import mysql

request_bp = Blueprint("request", __name__)

@request_bp.route('/makeTemporaryRequest', methods=["POST"])
def makeTemporaryRequest():
    if request.method=="POST":

        
        
        return {"success":True}