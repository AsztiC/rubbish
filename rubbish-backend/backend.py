from flask import Flask, request, jsonify

app = Flask(__name__)

# Data storage (temporary for simplicity, not suitable for production)
integers_data = [0] * 8  # Default 8 integers
booleans_data = [False] * 8  # Default 8 booleans

# Endpoint to get 8 integers
@app.route('/get-integers', methods=['GET'])
def get_integers():
    return jsonify({"integers": integers_data}), 200

# Endpoint to update 8 booleans
@app.route('/set-booleans', methods=['POST'])
def set_booleans():
    global booleans_data
    data = request.json
    if not data or "booleans" not in data or len(data["booleans"]) != 8:
        return jsonify({"error": "Invalid data. Expected 8 booleans."}), 400

    booleans_data = data["booleans"]
    return jsonify({"message": "Booleans updated successfully."}), 200

if __name__ == '__main__':
    app.run(debug=True)