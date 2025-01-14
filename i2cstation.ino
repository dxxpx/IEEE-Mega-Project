#include <WiFi.h>
#include <WiFiUdp.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>

#define UDP_PORT 4210

WiFiUDP UDP;
LiquidCrystal_I2C lcd(0x27, 16, 2); 

void setup() {
  Serial.begin(115200);
  Serial.println();

  WiFi.begin("DistressAP");

  Serial.print("Connecting to ");
  Serial.print("DistressAP");

  while (WiFi.status() != WL_CONNECTED) {
    delay(100);
    Serial.print(".");
  }
  Serial.println();
  Serial.print("Connected! IP: ");
  Serial.println(WiFi.localIP());

  UDP.begin(UDP_PORT);
  Serial.print("Listening on UDP Port ");
  Serial.println(UDP_PORT);


  lcd.init();
  lcd.backlight();
  lcd.setCursor(0, 0);
  lcd.print("Waiting for data");
}

void loop() {
  char packet[255] = {0};
  char reply[50] = {0};

  int packetSize = UDP.parsePacket();
  if (packetSize) {
    int len = UDP.read(packet, 255);
    if (len > 0) {
      packet[len] = '\0';
    }
    Serial.println(packet);

   
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Received:");
    lcd.setCursor(0, 1);
    lcd.print(packet);

    UDP.beginPacket(UDP.remoteIP(), UDP.remotePort());
    UDP.printf(reply);
    UDP.endPacket();
  }
}