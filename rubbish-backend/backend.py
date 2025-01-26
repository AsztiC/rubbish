from servo_controller import ServoController
from cv_model import ObjectDetection
import cv2
import time
from threading import Lock

class Backend:
    def __init__(self, integers, booleans):
        self.class_names = ["battery", "bottle", "can", "cardboard", "metal", "paper", "plastic bag", "wrapper"]
        
        # Initialize data with shared lists
        self._integers = integers
        self._booleans = booleans
        self._lock = Lock()  # Thread-safe lock
        # Servo controller
        self.servo_controller = ServoController(port_name="COM8")
        self.down_count = 0
        self.up_count = 0

    def get_integers(self):
        """Return the current integers safely."""
        with self._lock:
            return self._integers.copy()  # Return a copy to avoid modification during access

    def set_booleans(self, new_booleans):
        """Update the booleans safely."""
        with self._lock:
            self._booleans[:] = new_booleans  # Update the list in-place to maintain the reference

    def update_integers(self):
        """Simulate updating integers in the backend."""
        with self._lock:
            for i in range(len(self._integers)):
                self._integers[i] += 1
    
    # logic to determine recycle based on list. 0 = do nothing 1 = open up -1 = open down
    def check_recycle(self, list):
        
        if len(list) < 1:
            return 0
        
        # Check if all items in list can be recycled
        for item in list:
            index = self.class_names.index(item)
            print(f"{item}, {index}")

            with self._lock:
                # if any trash then cannot open to recycle
                if not self._booleans[index]:
                    return 1
        return -1
    
    def add_list(self, list):
        for item in list:
            index = self.class_names.index(item)
            with self._lock:
                # update list
                self._integers[index] += 1

    def run(self):
        """Run the backend logic."""
        # Start detector
        # Get frame and result
        object_detector = ObjectDetection()
        while object_detector is None:
            pass
        while True:
            min_frame_count = 4
            object_list,img = object_detector.get_objects()
            print(object_list)
            can_recycle = self.check_recycle(object_list)
            print(f"Recycle: {can_recycle}")
            if (can_recycle == -1):
                self.up_count = 0
                self.down_count += 1
                if self.down_count >= min_frame_count:
                    print("down")
                    self.add_list(object_list)
                    self.servo_controller.down(1)
                    self.servo_controller.neutral(1)
                object_detector.get_objects()
            elif (can_recycle == 1):
                self.down_count = 0
                self.up_count += 1
                if self.up_count >= min_frame_count:
                    print("up")
                    self.add_list(object_list)
                    self.servo_controller.up(1)
                    self.servo_controller.neutral(1)
                    object_detector.get_objects()
            else:
                self.down_count = 0
                self.up_count = 0
            
            
if __name__ == "__main__":
    back = Backend([],[])
    back.run()