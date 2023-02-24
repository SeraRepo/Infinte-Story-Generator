import jwt
from flask import request, jsonify, Blueprint, request
from flask_cors import cross_origin
from config import SECRET_KEY
from routes.auth import token_required
from models.models import StoryModel, TagModel, UserModel, db
from main.generate_story import generate_story

storiesbp = Blueprint('story', __name__)

def get_current_user(request):
    token = request.headers['x-access-token']
    data = jwt.decode(token, SECRET_KEY)
    user = UserModel.query.filter_by(id = data['id']).first()
    return user

@storiesbp.route('/stories', methods=['get'])
@cross_origin()
def get_stories():
    if request.method == 'GET':
        stories = db.session.query(StoryModel).all()
        if stories:
            return jsonify({"ReqStatus": "OK", "stories": [story.serialize() for story in stories]})
        else:
             return jsonify({"ReqStatus": "Error", "Response": "No stories"})

@storiesbp.route('/story/<id>', methods=['get'])
@cross_origin()
def get_story(id):
    if request.method == 'GET':
        story = StoryModel.query.filter_by(id=id).first()
        if story:
            return jsonify({"ReqStatus": "OK", "story": story.serialize()})
        else:
            return jsonify({"ReqStatus": "Error", "Response": "No story with this ID"})

@storiesbp.route('/story', methods=['post'])
@cross_origin()
@token_required
def create_story():
    if request.method == 'POST':
        story_data = request.get_json()
        story_name = story_data['story_name']
        params = story_data['params']

        user = get_current_user(request)
        if not user:
                return jsonify({"ReqStatus": "KO", "Response": "User not found"}) 
        if params == []:
            return({"message": "Invalid parameters", "ReqStatus": "ko"})

        story = generate_story(params)
        
        new_story = StoryModel(StoryName=story_name, Story=story, user_id=user.id)
        
        db.session.add(new_story)
        user.Stories.append(new_story)
        db.session.add
        db.session.commit()

        return jsonify({"ReqStatus": "ok", "Response": "story created", "Story": story})

@storiesbp.route("/story/<id>", methods=['put'])
@cross_origin()
@token_required
def update_story(id):
    if request.method == 'PUT':
        story_data = request.get_json()

        story_name = story_data['story_name']
        story_tag = story_data['story_tag']

        story = StoryModel.query.filter_by(id=id).first()
        if story:
            story.storyName = story_name
            story.storyTag = story_tag

            db.session.commit()
            return jsonify({"ReqStatus": "OK", "Response": "story updated"})
        else:
            return jsonify({"ReqStatus": "Error", "Response": "story not found"})
            
@storiesbp.route('/story/<id>', methods=['delete'])
@cross_origin()
@token_required
def delete_story(id):
    if request.method == 'DELETE':
        story = StoryModel.query.filter_by(id=id).first()
        if story:
            db.session.delete(story)
            db.session.commit()
            return jsonify({"ReqStatus": "OK", "Response": "story deleted"})
        else:
            return jsonify({"ReqStatus": "Error", "Response": "No story found for this action"})