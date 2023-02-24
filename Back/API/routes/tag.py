from crypt import methods
from flask import request, jsonify, Blueprint, request
from flask_cors import cross_origin

from models.models import TagModel, db
from routes.auth import token_required
from config import *

tagsbp = Blueprint('tags', __name__)

@tagsbp.route('/tags', methods=['get'])
@cross_origin()
@token_required
def get_tags():
    if request.method == 'GET':
        tags = db.session.query(TagModel).all()
        return jsonify({"ReqStatus": "OK", "Tags": [tag.serialize() for tag in tags]})
    else:
        return jsonify({"ReqStatus": "Error", "Tags": "No tags"})

@tagsbp.route('/tag/<name>', methods=['get'])
@cross_origin()
@token_required
def get_tag(name):
    if request.method == 'GET':
        tag = TagModel.query.filter_by(name=name).first()
        return jsonify({"ReqStatus": "OK", "Album": tag.serialize()})
    else:
        return jsonify({"ReqStatus": "Error", "Response": "No tag with this name"})


@tagsbp.route('/tags/', methods=['post'])
@cross_origin()
@token_required
def post_tag():
    if request.method == 'POST':
        tag_data = request.get_json()
        tag_name = tag_data["name"]

        tag = TagModel.query.filter_by(name=tag_name).first() 
        if tag:
            return jsonify({"ReqStatus": "Error", "Response": "Tag already existed"})
        
        new_tag = TagModel(name=tag_name)
        db.session.add(new_tag)
        db.session.commit()

        return jsonify({"ReqStatus": "ok", "Response": "Tag created"})

@tagsbp.route('/tags/<id>', methods=['delete'])
@cross_origin()
@token_required
def delete_tag(id):
    if request.method == 'DELETE':
        tag = TagModel.query.filter_by(id=id).first() 
        if tag: 
            db.session.delete(tag)
            db.session.commit()
            return jsonify({"ReqStatus": "OK", "Response": "Tag deleted"})
        else:
            return jsonify({"ReqStatus": "Error", "Response": "No tag found for this action"})

@tagsbp.route('/tags/<name>', methods=['put'])
@cross_origin()
@token_required
def update_tag(name):
    if request.method == 'PUT':
        tag_data = request.get_json()

        tag_name = tag_data['name']

        tag = TagModel.query.filter_by(name=name).first()
        if tag:
            tag.name = tag_name

            db.session.commit()
            return jsonify({"ReqStatus": "OK", "Response": "tag updated"})
        else:
            return jsonify({"ReqStatus": "Error", "Response": "Tag not found"})

