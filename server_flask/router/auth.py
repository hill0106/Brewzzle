import datetime
import jwt
from functools import wraps
from flask import Blueprint, request, jsonify, abort, current_app, make_response
from werkzeug.security import generate_password_hash, check_password_hash
from config import get_db
from authlib.integrations.flask_client import OAuth
import os

bp = Blueprint("auth", __name__, url_prefix="/auth")

# In‐memory user store for demo; replace with a real DB in production
users = {}  # email -> password_hash

# Setup OAuth
oauth = OAuth()
google = oauth.register(
    name='google',
    client_id=os.getenv('GOOGLE_CLIENT_ID'),
    client_secret=os.getenv('GOOGLE_CLIENT_SECRET'),
    server_metadata_url='https://accounts.google.com/.well-known/openid-configuration',
    client_kwargs={
        'scope': 'openid email profile'
    }
)

def init_oauth(app):
    oauth.init_app(app)

def login_required(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        token = request.cookies.get("access_token")
        if not token:
            abort(401, "Missing auth token")
        try:
            payload = jwt.decode(token, current_app.config["SECRET_KEY"], algorithms=["HS256"])
        except jwt.ExpiredSignatureError:
            abort(401, "Token expired")
        except jwt.InvalidTokenError:
            abort(401, "Invalid token")
        request.user_email = payload["email"]
        return f(*args, **kwargs)
    return wrapper

@bp.route("/signup", methods=["POST"])
def signup():
    data = request.get_json() or {}
    name = data.get("name", "").strip()
    email = data.get("email", "").strip().lower()
    pwd = data.get("password", "")
    location = data.get("location", "").strip()

    if not name or not email or not pwd or not location:
        abort(400, "Name, email, password, and location are all required")

    db = get_db()
    users_col = db["user"]
    if users_col.find_one({"email": email}):
        abort(400, "User already exists")

    user_doc = {
        "name": name,
        "email": email,
        "password": generate_password_hash(pwd),
        "location": location,
        "default_title": "Cafe Lover",
        "favorite_cafe": [],
        "check_in": [],
        "reviews": [],
        "profile_image": "https://images.unsplash.com/photo-1587734195503-904fca47e0e9?q=80&w=1935&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    }
    users_col.insert_one(user_doc)
    return jsonify(message="User created"), 201

@bp.route("/login", methods=["POST"])
def login():
    data = request.get_json() or {}
    email = data.get("email", "").strip().lower()
    pwd   = data.get("password", "")
    db = get_db()
    users_col = db["user"]
    user = users_col.find_one({"email": email})
    if not user or not check_password_hash(user["password"], pwd):
        abort(401, "Invalid credentials")

    # Issue JWT valid for 1 hour
    token = jwt.encode({
        "email": email,
        "exp": datetime.datetime.utcnow() + datetime.timedelta(hours=1)
    }, current_app.config["SECRET_KEY"], algorithm="HS256")

    resp = make_response(jsonify(message="Logged in"))
    resp.set_cookie(
        "access_token",
        token,
        httponly=True,
        samesite="Lax",
        max_age=60*60
    )
    return resp

@bp.route("/logout", methods=["POST"])
@login_required
def logout():
    resp = make_response(jsonify(message="Logged out"))
    # Clear the cookie
    resp.set_cookie("access_token", "", expires=0)
    return resp

@bp.route('/google-login')
def google_login():
    redirect_uri = os.getenv('GOOGLE_REDIRECT_URI', 'http://localhost:5050/auth/google-callback')
    return google.authorize_redirect(redirect_uri)

@bp.route('/google-callback')
def google_callback():
    token = google.authorize_access_token()
    resp = google.get('https://openidconnect.googleapis.com/v1/userinfo')
    user_info = resp.json()
    email = user_info.get('email')
    name = user_info.get('name')
    location = ''  # Google does not provide location
    
    db = get_db()
    users_col = db['user']
    user = users_col.find_one({'email': email})
    if not user:
        user_doc = {
            'name': name,
            'email': email,
            'password': None,  # No password for Google users
            'location': location,
            'default_title': "Cafe Lover",
            'favorite_cafe': [],
            'check_in': [],
            'reviews': [],
            'profile_image': "https://images.unsplash.com/photo-1587734195503-904fca47e0e9?q=80&w=1935&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
        }
        users_col.insert_one(user_doc)
    else:
        # Optionally update name/profile_image if changed
        users_col.update_one({'email': email}, {'$set': {'name': name, 'profile_image': profile_image}})

    # Issue JWT valid for 1 hour
    jwt_token = jwt.encode({
        'email': email,
        'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=1)
    }, current_app.config['SECRET_KEY'], algorithm='HS256')

    resp = make_response(jsonify(message='Logged in with Google'))
    resp.set_cookie(
        'access_token',
        jwt_token,
        httponly=True,
        samesite='Lax',
        max_age=60*60
    )
    return resp

