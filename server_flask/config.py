# config.py
import os
import googlemaps
from pymongo import MongoClient
from pymongo.server_api import ServerApi

GOOGLE_MAPS_API_KEY = os.getenv("GOOGLE_MAPS_API_KEY")
if not GOOGLE_MAPS_API_KEY:
    raise RuntimeError("Please set the GOOGLE_MAPS_API_KEY environment variable")

# Initialize a single shared client
gmaps_client = googlemaps.Client(key=GOOGLE_MAPS_API_KEY)

def get_db():
    mongo_url = os.getenv("MONGO_URL")
    client = MongoClient(mongo_url, server_api=ServerApi('1'))
    db = client["brewzzle_db"]
    return db
