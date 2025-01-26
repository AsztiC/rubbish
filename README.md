# rubbish
## Inspiration
We have communal recycling at our apartment complex and we typically see items that should not be recycled mixed in like plastic bags (and on the opposite side lots of recycling in the trash). Contaminated recycling is a major challenge that limits the effectiveness of recycling. We wanted to take an established environmental effort and use AI to solve one of its biggest challenges. 

## What it does
Rubbish is a device that attaches to a recycling bin. You place an item on the lid and it can either drop down into the bin or be ejected. It is integrated with our app that allows for advanced control for what can and cannot be recycled. Additionally, the app shows a visual of which items have been seen, and even contains a page that unlocks new characters and facts by collecting a certain amount of items to encourage recycling.

## How we built it
Flutter app --> Flask API --> Backend --> Computer Vision --> Python servo interface --> Serial communication --> Arduino Uno --> I2C to PWM board --> Servo --> Zip ties

The Flutter app communicates with a Flask API to get statistics about the items collected and to control which items can be recycled. We trained a Yolov11 computer vision model by labeling hundreds of images of various items. The backend run the computer vision, and communicates with the servo interface. The servo interface uses pyserial to communicate with an Arduino Uno to control a servo to move the lid.

## Challenges we ran into
We ran into issues training the computer vision model because we labeled the data incorrectly at first. Eventually it began working and it is now on its third major iteration and we are very satisfied with its performance. We also had issues opening the webcam in OpenCV but we solved it by using a virtual camera in OBS. This also allowed us to mask off parts of the background that are not needed.

## Accomplishments that we're proud of
Training the AI detection model ourselves. Everything can run locally without relying on any outside API or service. This means our project could be run on a single board computer without an internet connection.

The accuracy of the finished model. 

Software and hardware team collaboration.

## What we learned
Learning how to make a basic Flutter app and using Yolov11 model. 
Communication between API and app
Python inter-thread communication
Using Flask

## What's next for Rubbish
Just like those water bottle refill stations, we think it would be cool to make a display to show how much waste has been disposed in a particular bin. The app could be extended to be able to scan a QR code or something similar to add the trash/recycle bin to the app and keep track of all the places where you dispose rubbish. There could also be more content to unlock, and the model could be further trained to be able to identify a wider range of waste. 
