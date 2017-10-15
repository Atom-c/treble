import requests, base64
from pprint import pprint


def connection():
    client_id = "q1z3zf6papfwyx50"
    client_secret = "vue1t81673e8w6da6wo6r7071nkxrfew"
    data = {"grant_type":"client_credentials","client_id":client_id,"client_secret":client_secret}
    r = requests.post("https://api.musimap.net/oauth/access_token", data=data)

    token = base64.b64encode(r.json()["access_token"])

    headers = {"Authorization":"Bearer {0}".format(token)}

    return headers


# START HERE

# Mood

# Key/Tonality
def get_by_tonality(headers, limit=20):

    categories = [
                    # "ethnos_group",
                    # "fact",
                    "instrument",
                    "instrument_family",
                    "keyword",
                    # "language",
                    # "location",
                    # "medium",
                    "mood",
                    "rhythm",
                    # "rhythmic_mood",
                    "role",
                    "situation",
                    "soundkey",
                    "substyle",
                    # "tessitura",
                    "visual",
                    # "voice_family"
                    ]
    # for cat in categories:
    content = requests.get("{0}/properties/search?category=mood&name=love&limit={1}".format(host,limit), headers=headers)
    pprint(content.json())
    return ""

# Genre
def get_by_genre(headers, limit=10):
    content = requests.get("{0}/genres/search?limit={1}".format(host, limit), headers=headers)

    return content.json()

def get_tracks_by_mood(headers, limit=5):
    content = requests.get("{0}/tracks/search?moods[0][uid]=6755A82E-689A-E825-EE02-5551736CDB4D&limit={1}".format(host, limit), headers=headers)

    return content.json()


headers = connection()
host = "https://api.musimap.net"

# pprint(get_by_tonality(headers, 5))
pprint(get_tracks_by_mood(headers, 5))
# pprint(get_by_genre(headers, 15))
