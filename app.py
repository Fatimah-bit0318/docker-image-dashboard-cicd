from flask import Flask, render_template, jsonify
import os
import socket
from datetime import datetime, timezone

app = Flask(__name__)

def get_metadata():
    return {
        "app_name": "Docker Image Information Dashboard",
        "app_version": os.getenv("APP_VERSION", "1.0.1",
        "build_number": os.getenv("BUILD_NUMBER", "1"),
        "image_tag": os.getenv("IMAGE_TAG", "local"),
        "git_commit": os.getenv("GIT_COMMIT", "development"),
        "deployment_time": os.getenv("DEPLOYMENT_TIME", "Not Deployed"),
        "environment": os.getenv("ENVIRONMENT", "Development"),
        "hostname": socket.gethostname(),
        "current_time": datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S UTC"),
        "status": "Healthy"
    }

@app.route("/")
def home():
    return render_template("index.html", data=get_metadata())

@app.route("/info")
def info():
    return jsonify(get_metadata())

@app.route("/health")
def health():
    return {"status": "UP"}, 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
