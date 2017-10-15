import requests, base64, time
from pprint import pprint
# from urllib.request import urlretrieve

# tokenize
def connection():
    headers = {
        'content-type': 'application/json',
    }

    data = '{\n    "data":{\n    \t"type": "tokens",\n    \t"attributes": {\n        \t"email": "atom.colour@gmail.com",\n        \t"password": "imuzesxsw1"\n    \t}\n    }\n}'

    r = requests.post('https://production.imuze-api.com/v2/tokens', headers=headers, data=data)

    token = r.json()
    token = token["data"]["attributes"]["value"]

    # print token
    # print ""
    return token

token = connection()
# post music

def post_music():

    headers = {"authorization":"Bearer {0}".format(token), 'content-type': 'application/vnd.api+json'}

    data = '{\n\t"data": {\n\t\t"type": "musics",\n\t\t"attributes": {\n        \t"genre": "dub",\n        \t"subgenre": "dubstep",\n        \t"voices-volume": 0,\n        \t"duration-ms": 90000,\n        \t"movements": [{\n\t            "energy": "dynamic",\n    \t        "start": 0,\n        \t    "duration": 0.4190774042220485\n        \t}, {\n            \t"start": 0.4190774042220485,\n\t            "energy": "medium",\n    \t        "duration": 0.25254104769351055\n        \t}, {\n\t            "start": 0.671618451915559,\n    \t        "energy": "medium",\n        \t    "duration": 0.1641907740422205\n    \t\t}, {\n            \t"start": 0.8358092259577795,\n    \t\t    "energy": "dynamic",\n\t            "duration": 0.1641907740422205\n\t        }],\n    \t    "crop": true\n\t\t}\n    }\n}'

    r = requests.post('https://production.imuze-api.com/v2/musics', headers=headers, data=data)

    music_id_string = r.json()["data"]["links"]["self"]

    # print music_id_string
    # print ""
    return music_id_string


# get music
music_id_string = post_music()

# raw_input("Press Enter to continue...")
time.sleep(10)

def get_music():
    headers = {"authorization":"Bearer {0}".format(token)}

    r = requests.get('{0}'.format(music_id_string), headers=headers)

    download = r.json()["data"]["attributes"]["mp3-url"]

    # pprint(r.json())
    print("")
    print(download)
    print("")


music = get_music()

music

# urlretrieve(music)
