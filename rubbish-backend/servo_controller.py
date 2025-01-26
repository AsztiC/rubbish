import serial
import time
from time import sleep

class ServoController:
    DOWN_OFFSET = 170
    UP_OFFSET   = 80
    CENTER      = (150+600)/2 - 50
    
    def __init__(self, port_name, baud_rate=9600):
        """Initializes the servo controller with the specified serial port and baud rate."""
        self.port_name = port_name
        self.baud_rate = baud_rate
        self.port = None

        self.open_connection()
        self.neutral(2)

    def open_connection(self):
        """Opens the serial connection to the Arduino."""
        if self.port is None or not self.port.is_open:
            try:
                self.port = serial.Serial(self.port_name, self.baud_rate, timeout=1)
                time.sleep(2)  # Wait for Arduino to initialize
                print(f"Connected to Arduino on {self.port_name}.")
            except serial.SerialException as e:
                print(f"Failed to connect to the serial port: {e}")

    def close_connection(self):
        """Closes the serial connection to the Arduino."""
        if self.port and self.port.is_open:
            self.port.close()
            print(f"Connection to {self.port_name} closed.")

    def send_command(self, channel, position):
        """Sends a command to move a specific servo to the desired position."""
        if not (0 <= channel <= 15):
            raise ValueError("Channel must be between 0 and 15.")
        if not (150 <= position <= 600):
            raise ValueError("Position must be between 150 and 600.")

        command = f"{channel} {position}\n"
        if self.port and self.port.is_open:
            self.port.write(command.encode('utf-8'))
            print(f"Sent command: {command.strip()}")
        else:
            raise ConnectionError("Serial port is not open.")

    def down(self, time):
        # Move lid to down position
        open_position1 = self.CENTER + self.DOWN_OFFSET
        self.send_command(0, open_position1)
        sleep(time)
        self.neutral(0)

    def up(self, time):
        #down_small = self.CENTER + 40
        #self.send_command(0, down_small)
        #sleep(.15)
        # Move lid to up position
        open_position1 = self.CENTER - self.UP_OFFSET 
        self.send_command(0, open_position1)
        sleep(time)
        self.neutral(0)

    def neutral(self, time):
        # Move lid to neutral position
        open_position1 = self.CENTER
        open_position2 = self.CENTER 
        self.send_command(0, open_position1)
        self.send_command(1, open_position2)
        sleep(time)

# Example usage
if __name__ == "__main__":
    controller = ServoController(port_name="COM8")  # Replace with your serial port
    try:
        #controller.neutral(2)
        # Example: Open and close servo on channel 0
       # controller.down(2)
       # controller.neutral(2)
        controller.up(2)
        controller.neutral(0)

    finally:
        controller.close_connection()
