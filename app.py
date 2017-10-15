from flask import Flask, request
import requests
import time
import os
import json
app = Flask(__name__)


def connection():
    headers = {
        'content-type': 'application/json',
    }

    data = json.dumps({"data": {
        "type": "tokens", "attributes": {
            "email": "atom.colour@gmail.com", "password": "imuzesxsw1"}}})

    r = requests.post(
        'https://production.imuze-api.com/v2/tokens',
        headers=headers,
        data=data)

    token = r.json()
    token = token["data"]["attributes"]["value"]

    return token


def post_music(token, genre, subgenre):

    headers = {
        "authorization": "Bearer {0}".format(token),
        'content-type': 'application/vnd.api+json'}

    data = json.dumps({"data": {
        "type": "musics", "attributes": {
            "genre": genre, "subgenre": subgenre,
            "voices-volume": 0,
            "duration-ms": 90000,
            "movements": [
                {"energy": "dynamic",
                 "start": 0,
                 "duration": 0.4190774042220485},
                {"start": 0.4190774042220485,
                 "energy": "medium", "duration": 0.25254104769351055},
                {"start": 0.671618451915559,
                 "energy": "medium", "duration": 0.1641907740422205},
                {"start": 0.8358092259577795,
                 "energy": "dynamic", "duration": 0.1641907740422205}],
                "crop": True}}})

    r = requests.post(
        'https://production.imuze-api.com/v2/musics',
        headers=headers,
        data=data)

    music_id_string = r.json()["data"]["links"]["self"]
    return music_id_string


def get_music(token, music_id_string):
    headers = {"authorization": "Bearer {0}".format(token)}

    r = requests.get('{0}'.format(music_id_string), headers=headers)
    download = r.json()["data"]["attributes"]["mp3-url"]

    return download


@app.route('/', methods=['GET'])
def index():
    token = connection()

    # get music
    music_id_string = post_music(token, "dub", "dubstep")
    time.sleep(10)
    music = get_music(token, music_id_string)

    return str(music)


@app.route('/music', methods=['GET'])
def music():

    genre = request.args.get("genre", "dub")
    subgenre = request.args.get("subgenre", "dubstep")

    # get music
    token = connection()
    music_id_string = post_music(token, genre, subgenre)
    time.sleep(10)
    music = get_music(token, music_id_string)

    return str(music)


if __name__ == '__main__':
    # db.create_all()
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=True)
