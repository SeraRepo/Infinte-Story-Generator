import jwt
from flask import request, jsonify, Blueprint
from sqlalchemy import null
from werkzeug.security import generate_password_hash, check_password_hash
from flask_cors import cross_origin
from functools import wraps
from datetime import datetime, timedelta
from models.models import UserModel, db
from config import *

authsbp = Blueprint('auth', __name__)

def get_current_user(request):
    token = request.headers['x-access-token']
    data = jwt.decode(token, SECRET_KEY)
    user = UserModel.query.filter_by(id = data['id']).first()
    return user

def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None

        if 'x-access-token' in request.headers:
            token = request.headers['x-access-token']
        if not token:
            return jsonify({'message' : 'Token is missing !!'}), 401

        try:
            data = jwt.decode(token, SECRET_KEY)
        except Exception as e:
            return jsonify({"ReqStatus": "Error", "Response": "Error token"}), 401

        current_user = UserModel.query.filter_by(id = data['id']).first()
        ctoken = current_user.token

        if token != ctoken:
            return jsonify({"ReqStatus": "Error", "Response": "Error token"}), 401
        if token == "":
            return jsonify({"ReqStatus": "Error", "Response": "Error token"}), 401

        return  f(*args, **kwargs)
    return decorated

@authsbp.route('/signup', methods = ['post'])
@cross_origin()
def sign_up():
    if request.method == 'POST':
        print('User')
        user_data = request.get_json()
        
        user_email = user_data['email']
        user_uname = user_data['username']
        user_pass = user_data['password']

        user = UserModel.query.filter_by(username=user_uname).first()
        if user:
            return jsonify({"ReqStatus": "Error", "Response": "Username already used"})

        new_user = UserModel(userMail=user_email, username=user_uname, password=generate_password_hash(user_pass, method='sha256'))

        db.session.add(new_user)
        db.session.commit()

        return jsonify({"ReqStatus": "ok", "Response": "User added"})

@authsbp.route('/signin', methods = ['post'])
@cross_origin()
def login():
    if request.method == 'POST':
        login_data = request.get_json()

        userName = login_data['username']
        userpd = login_data['password']
        user = UserModel.query.filter_by(username=userName).first()

        if not user :
            print('check user')
            return jsonify({"ReqStatus": "Error", "Response": "User or password wrong"})

        if check_password_hash(user.password, userpd):
            token = jwt.encode({
            'id': user.id,
            'exp' : datetime.utcnow() + timedelta(minutes = 30)
            }, SECRET_KEY)

            user.token = token.decode('UTF-8') 
            db.session.commit()
            return jsonify({"ReqStatus": "ok", "Response": "User logged in", "token" : token.decode('UTF-8')})
        else:
            return jsonify({"ReqStatus": "Error", "Response": "User or password wrong"})
        
@authsbp.route('/logout', methods=['post'])
@cross_origin()
@token_required
def logout():
    if request.method == "POST":
        current_user = get_current_user(request)
        current_user.token = ""
        db.session.commit()
        return jsonify({"ReqStatus": "ok", "Response": "User logged out"})
