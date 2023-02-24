from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()
class UserModel(db.Model):
    __tablename__ = 'UserModel'

    id = db.Column(db.Integer, primary_key=True)
    userMail = db.Column(db.String())
    username = db.Column(db.String(), unique = True)
    password = db.Column(db.String())
    token = db.Column(db.String())
    Stories = db.relationship("StoryModel", backref="user")

    def __init__(self, userMail, username, password):
        self.userMail = userMail
        self.username = username
        self.password = password

    def serialize(self):
        return {"id": self.id,
                "email": self.userMail,
                "username": self.username,
                "password": self.password,
                "token": self.token,
                "Stories": [Story.serialize() for Story in self.Stories]
                }

class StoryModel(db.Model):
    __tablename__ = 'StoryModel'
    id = db.Column(db.Integer, primary_key = True)
    StoryName = db.Column(db.String(50))
    Story = db.Column(db.Text)
    user_id = db.Column(db.Integer, db.ForeignKey('UserModel.id'))
 
    def __init__(self, StoryName, Story, user_id):
        self.StoryName = StoryName
        self.Story = Story
        self.user_id = user_id

    def __repr__(self):
        return f"<User {self.StoryName}>"

    def serialize(self):
        return {"id": self.id,
            "Story Name": self.StoryName,
            "Story": self.Story,
            "Story Owner": self.user_id
            }

class TagModel(db.Model):
    __tablename__ = "TagModel"
    id = db.Column(db.Integer, primary_key = True)
    name = db.Column(db.String(50))

    def __init__(self, name):
        self.name = name

    def serialize(self):
        return {
            "id": self.id,
            "name": self.name
        }