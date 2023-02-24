import jwt
from flask import request, jsonify, Blueprint, request
from flask_cors import cross_origin
from werkzeug.security import generate_password_hash
from models.models import UserModel, db
from routes.auth import token_required
from config import *

usersbp = Blueprint('users', __name__)

def get_current_user(request):
    token = request.headers['x-access-token']
    data = jwt.decode(token, SECRET_KEY)
    user = UserModel.query.filter_by(id = data['id']).first()
    return user

@usersbp.route('/users', methods=['get'])
@cross_origin()
def get_users():
    if request.method == 'GET': 
        users = db.session.query(UserModel).all()
        return jsonify({"ReqStatus": "OK", "Users": [user.serialize() for user in users]})

@usersbp.route('/user', methods=['get'])
@cross_origin()
@token_required
def get_user():
    if request.method == 'GET':
        user = get_current_user(request)
        if user:
            return jsonify({"ReqStatus": "OK", "User": user.serialize()})
        else:
            return jsonify({"ReqStatus": "Error", "response": "No user with this ID"})

@usersbp.route('/user', methods=['delete'])
@token_required
@cross_origin()
def del_user():
    if request.method == 'DELETE':
        user = get_current_user(request)
        if user:
            db.session.delete(user)
            db.session.commit()
            return jsonify({"ReqStatus": "OK", "Response": "User deleted"})
        else: 
            return jsonify({"ReqStatus": "Error", "Response": "No user found for this action"})

@usersbp.route('/user', methods=['put'])
@token_required
@cross_origin()
def update_user():
    if request.method == 'PUT':
        user_data = request.get_json()

        user_umail = user_data['email']
        user_username = user_data['username']
        user_pd = user_data['password']

        user = get_current_user(request)

        if user:
            
            user.userMail = user_umail
            user.username = user_username
            user.password = generate_password_hash(user_pd, method='sha256')

            db.session.commit()
            return jsonify({"ReqStatus": "OK", "Response": "User updated"})
        else:
            return jsonify({"ReqStatus": "Error", "Response": "User not found"})
