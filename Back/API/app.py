from flask import Flask, Response
from flask_cors import CORS, cross_origin
from flask_migrate import Migrate

from routes.users import usersbp as users
from routes.auth import authsbp as auth
from routes.story import storiesbp as story
from routes.tag import tagsbp as tag

from config import *
from models.models import db


def create_db():
    db.create_all()
    db.session.commit()

def create_app():
    app = Flask(__name__)
    app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
    app.config['SQLALCHEMY_DATABASE_URI'] = SQLALCHEMY_DATABASE_URI
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.config['SECRET_KEY'] = SECRET_KEY
    app.app_context().push()
    db.init_app(app)
    create_db()
    migrate = Migrate(app, db)
    CORS(app)
    
    return app

app = create_app()

app.register_blueprint(users)
app.register_blueprint(auth)
app.register_blueprint(story)
app.register_blueprint(tag)

@app.route('/ping', methods=['GET'])
@cross_origin()
def ping():
    return Response("pong", mimetype='text/html')

if __name__ == "__main__":
    print("API start")
    try:
        app.run(host="0.0.0.0", port=8000, debug=True)
    except Exception as e:
        print(str(e))
        pass
