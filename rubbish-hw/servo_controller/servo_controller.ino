#include <Wire.h>
#include <Adafruit_PWMServoDriver.h>

Adafruit_PWMServoDriver pwm = Adafruit_PWMServoDriver();

#define SERVOMIN 150 // Minimum pulse length count
#define SERVOMAX 600 // Maximum pulse length count
#define SERVO_FREQ 50 // Analog servos run at ~50 Hz updates

void setup() {
  Serial.begin(9600);
  pwm.begin();
  pwm.setOscillatorFrequency(27000000);
  pwm.setPWMFreq(SERVO_FREQ);
  delay(10);
  Serial.println("Ready to receive commands. Format: <channel> <position>");
}

// Read serial commands from pc to control a servo
void loop() {
  if (Serial.available()) {
    String command = Serial.readStringUntil('\n');
    command.trim(); // Remove trailing spaces or newline characters

    int spaceIndex = command.indexOf(' ');
    if (spaceIndex > 0) {
      int channel = command.substring(0, spaceIndex).toInt();
      int position = command.substring(spaceIndex + 1).toInt();

      if (channel >= 0 && channel <= 15 && position >= SERVOMIN && position <= SERVOMAX) {
        pwm.setPWM(channel, 0, position);
        Serial.print("Channel ");
        Serial.print(channel);
        Serial.print(" set to position ");
        Serial.println(position);
      } else {
        Serial.println("Invalid channel or position.");
      }
    } else {
      Serial.println("Invalid command format. Use: <channel> <position>");
    }
  }
}
