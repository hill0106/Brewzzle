# app.py
import os
from dotenv import load_dotenv
load_dotenv()

from flask import Flask, jsonify
from router.search import bp as search_bp
from router.auth import bp as auth_bp, init_oauth




def create_app():
    app = Flask(__name__)
    app.config["SECRET_KEY"] = os.getenv("SECRET_KEY", "fallback_secret")
    app.register_blueprint(search_bp)
    app.register_blueprint(auth_bp)
    init_oauth(app)

    @app.errorhandler(400)
    def bad_request(err):
        return jsonify(error=str(err)), 400

    @app.errorhandler(500)
    def server_error(err):
        return jsonify(error="Internal Server Error"), 500

    return app

if __name__ == "__main__":
    app = create_app()
    app.run(debug=True, port=5050)
