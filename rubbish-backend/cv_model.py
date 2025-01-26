from ultralytics import YOLO
import cv2
import math

class ObjectDetection:
    def __init__(self, model_path="best.pt", camera_index=4, width=640, height=480, class_names=None):
        """Initializes the ObjectDetection class with the model, camera, and class names."""
        if class_names is None:
            class_names = ["battery", "bottle", "can", "cardboard", "metal", "paper", "plastic bag", "wrapper"]
        
        self.class_names = class_names
        self.model = self.load_model(model_path)
        self.cap = self.initialize_webcam(camera_index, width, height)

    def initialize_webcam(self, camera_index=4, width=640, height=480):
        """Initializes the webcam with specified resolution."""
        cap = cv2.VideoCapture(camera_index)
        cap.set(3, width)
        cap.set(4, height)
        return cap

    def load_model(self, model_path="best.pt"):
        """Loads the YOLO model."""
        return YOLO(model_path)

    def process_frame(self, img):
        """Processes a single frame: runs the model and draws bounding boxes."""
        results = self.model(img, stream=True)
        object_list = []

        for r in results:
            boxes = r.boxes
            for box in boxes:
                x1, y1, x2, y2 = map(int, box.xyxy[0])  # bounding box coordinates
                confidence = math.ceil((box.conf[0] * 100)) / 100  # confidence level
                cls = int(box.cls[0])  # class index

                #print("Confidence --->", confidence)
                #print("Class name -->", self.class_names[cls])

                if confidence > 0.25:
                    # Draw bounding box and label
                    cv2.rectangle(img, (x1, y1), (x2, y2), (255, 0, 255), 3)
                    cv2.putText(
                        img,
                        f"{self.class_names[cls]}, {confidence}",
                        (x1, y1),cv2.FONT_HERSHEY_SIMPLEX,1,(255, 0, 0),2)
                    
                    # Add object to found list
                    object_list.append(self.class_names[cls])
        
        return object_list

    def get_objects(self):
        success, img = self.cap.read()
        if not success:
            print("Failed to capture image from webcam.")
            return
        # Process frame and display results
        object_list = self.process_frame(img)

        cv2.imshow('Webcam', img)
        if cv2.waitKey(1) == ord('q'):  # Exit loop on 'q' key press
            return
        
        return object_list,img
    
    def kill(self):
        self.cap.release()
        cv2.destroyAllWindows()

if __name__ == "__main__":
    object_detector = ObjectDetection()
    while True:
        object_list,img = object_detector.get_objects()
        print(object_list)

