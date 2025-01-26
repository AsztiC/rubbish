# Rubbish

**How to run backend:**
1. Create a virtual python environment with python 3.11
2. Activate the virtual environment
3. Install required libraries:
    * pip install ultralytics
    * pip install flask
    * pip install pyserial

4. Run the backend server:
    python flask_api.py

This will run the Flask API and spawn the controller in another thread with the computer vision model and servo logic.
