from ultralytics import YOLO

model = YOLO("yolo11x.pt")

model.train(data = "dataset_custom.yaml", imgsz = 640, batch = -1, epochs = 200, workers = 0, device = "0")