#!flask/bin/python

from flask import Flask
from flask_sqlalchemy import SQLAlchemy

# The WSGI configuration on Elastic Beanstalk requires
# the callable be named 'application' by default.

application = Flask(__name__)
application.config.from_object('config')
application.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True
application.config['SQLALCHEMY_DATABASE_URI'] = 'mysql:localhost'
db = SQLAlchemy(application)

from app import views, models
