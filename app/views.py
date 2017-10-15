# from flask import request, render_template
from app import application


@application.route("/")
@application.route("/index/")
def index1():

    return "MUSIC URL"