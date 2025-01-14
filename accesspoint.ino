#include <ESP8266WiFi.h>
#include <WiFiUdp.h>
const char *ssid = "DistressAP";

IPAddress local_IP(192,168,71,22);
IPAddress gateway(192,168,4,9);
IPAddress subnet(255,255,255,0);
IPAddress broadcast(192,168,71,255);

#define UDP_PORT 4210

WiFiUDP UDP;
char packet[255];
char header[4];



void setup()
{
  Serial.begin(115200);
  Serial.println();

  Serial.print("Setting soft-AP configuration ... ");
  Serial.println(WiFi.softAPConfig(local_IP, gateway, subnet) ? "Ready" : "Failed!");

  Serial.print("Setting soft-AP ... ");
  Serial.println(WiFi.softAP(ssid) ? "Ready" : "Failed!");
  //WiFi.softAP(ssid);
  //WiFi.softAP(ssid, password, channel, hidden, max_connection)
  
  Serial.print("Soft-AP IP address = ");
  Serial.println(WiFi.softAPIP());

  UDP.begin(UDP_PORT);
}

void loop() {

  char reply[50] = { 0 };
  char msg[250] = { 0 };

  int packetSize = UDP.parsePacket();
    
  if(packetSize){
      Serial.print("Received Packet! "); //code to perform after receiving packet
      Serial.println(packetSize);
      int len = UDP.read(packet, 255);
      if(len > 0){
        packet[len] = '\0';
      }

      Serial.println(packet);
    
    String Pack(packet);

    for(int i=1; i<4;i++){
      header[i-1] = packet[i];
    }
    header[4] = '\0';

    for(int i=5; i<len; i++){
      msg[i-5] = packet[i];
    }
    
    String recv_Head(header);
    String recv_msg(msg);
    
    String dst_Head = String("dst");
    String rqt_Head = String("rqt");

    if(recv_Head.equals(dst_Head)){
      strcpy(reply, "DISTRESS ");
      UDP.beginPacket(broadcast, UDP_PORT);
      //UDP.beginPacket(UDP.remoteIP(), UDP.remotePort());
      UDP.printf(reply);
      UDP.printf(msg);
      UDP.endPacket(); 
    }
    else if(recv_Head.equals(rqt_Head)){
      strcpy(reply, "REQUEST received: ");
      //UDP.beginPacket(UDP.remoteIP(), UDP.remotePort());
      UDP.beginPacket(broadcast, UDP_PORT);
      UDP.printf(reply);
      UDP.printf(msg);
      UDP.endPacket();  
    }

    }
}