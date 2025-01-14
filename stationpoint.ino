#include<WiFi.h>
#include<WiFiUdp.h>

#define UDP_PORT 4210

WiFiUDP UDP;


void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  Serial.println();

  WiFi.begin("DistressAP");

  Serial.print("Connecting to ");
  Serial.print("DistressAP");

  while (WiFi.status() != WL_CONNECTED){
    delay(100);
    Serial.print(".");
  }
  Serial.println();
  Serial.print("Connected! IP: ");
  Serial.println(WiFi.localIP());

  UDP.begin(UDP_PORT);
  Serial.print("Listening on UDP Port ");
  Serial.println(UDP_PORT);
}

void loop() {
  char packet[255] = {0};
  char reply[50] = {0};

  int packetSize = UDP.parsePacket();
  if(packetSize){
    int len = UDP.read(packet, 255);
    if(len > 0){
      packet[len] = '\0';
    }
    Serial.println(packet);

    UDP.beginPacket(UDP.remoteIP(), UDP.remotePort());
    UDP.printf(reply);
    UDP.endPacket();
  }

}
