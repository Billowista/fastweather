from flask import Flask
from flask import make_response

import json
import re
import requests
import urllib.parse

app = Flask(__name__)

api_url = "http://api.openweathermap.org/data/2.5"
api_key = "581756eb775ec74d4cc838b144b270f3"

@app.route('/getWeather/<zipcode>')
def get_weather(zipcode):
    if validate_zipcode(zipcode):
        body = call_weather_provider(zipcode)
        resp = make_response(body)
        resp.headers['content-type'] = "application/json"
        return resp
    else:
        return "Provided zipcode is not valid"

def validate_zipcode(zipcode):
    """ Return true if valid zipcode, false if invalid """

    match = re.search(r'^\d{5}(?:[-\s]\d{4})?$', zipcode)
    return bool(match)

def call_weather_provider(zipcode):
    """ Call OpenWeatherMap with zipcode Query. Return raw json response """

    query_values = { 
        'zip': zipcode,
        'appid': api_key
        }

    params = urllib.parse.urlencode(query_values)
    url = api_url + "/weather?%s" % params
    
    r = requests.get(url)

    return r.text