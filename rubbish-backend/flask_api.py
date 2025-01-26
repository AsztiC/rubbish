from flask import Flask, request, jsonify
from threading import Thread
from backend import Backend

app = Flask(__name__)

# Shared data storage
integers_data = [0] * 8  # Default 8 integers
booleans_data = [False, True, True, True, False, True, False, True] * 8  # Default 8 booleans

#["battery", "bottle", "can", "cardboard", "metal", "paper", "plastic bag", "wrapper"]

# Initialize the Backend object
backend = Backend(integers_data, booleans_data)

# Start the Backend in a separate thread
backend_thread = Thread(target=backend.run, daemon=True)
backend_thread.start()

# Endpoint to get 8 integers
@app.route('/get-integers', methods=['GET'])
def get_integers():
    return jsonify({"integers": backend.get_integers()}), 200  # Fetch safely from the backend

# Endpoint to update 8 booleans
@app.route('/set-booleans', methods=['POST'])
def set_booleans():
    data = request.json
    if not data or "booleans" not in data or len(data["booleans"]) != 8:
        return jsonify({"error": "Invalid data. Expected 8 booleans."}), 400

    # Update safely via backend
    backend.set_booleans(data["booleans"])
    print("Booleans updated:", data["booleans"])
    return jsonify({"message": "Booleans updated successfully."}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
