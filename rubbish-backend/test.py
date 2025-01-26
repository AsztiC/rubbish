import cv2

def main():
    # Open webcam (default is 0 for the built-in camera)
    cam = cv2.VideoCapture(4)
    cam.set(cv2.CAP_PROP_FRAME_WIDTH, 1280)  # Adjust resolution
    cam.set(cv2.CAP_PROP_FRAME_HEIGHT, 720)
    cam.set(cv2.CAP_PROP_FPS, 30)  # Adjust FPS

    if not cam.isOpened():
        print("Error: Could not open the webcam.")
        return

    print("Press 'q' to exit the webcam viewer.")
    
    while True:
        # Capture frame-by-frame
        ret, frame = cam.read()

        if not ret:
            print("Error: Failed to capture frame.")
            break

        # Display the frame
        cv2.imshow("Webcam Feed", frame)

        # Press 'q' to exit
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    # Release the webcam and close windows
    cam.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    main()
