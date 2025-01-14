import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hackfest/views/Uicomponents.dart';

class UdpSender extends StatefulWidget {
  @override
  _UdpSenderState createState() => _UdpSenderState();
}

class _UdpSenderState extends State<UdpSender> {
  String? _selectedOption = "Food";

  Future<void> sendUdpMessage(String message, String ip, int port) async {
    final RawDatagramSocket socket =
        await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    socket.broadcastEnabled = true;
    socket.send(utf8.encode(message), InternetAddress(ip), port);
    print("sent");
    socket.close();
  }

  void _sendMessage() async {
    final String ip = "192.168.71.22";
    final int port = int.tryParse("4210") ?? 0;
    if (_selectedOption != null && ip.isNotEmpty && port > 0) {
      await sendUdpMessage("[rqt]" + _selectedOption!, ip, port);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message sent: $_selectedOption')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Please select an option, and enter valid IP and port')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('What are you looking for?')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            DropdownButton<String>(
              hint: Text('Select an option'),
              value: _selectedOption!.length > 6 ? "Food" : _selectedOption,
              items:
                  <String>['Food', 'Water', 'Milk', 'Dolo'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedOption = newValue;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text('Send Request'),
            ),
            SizedBox(height: 20),
            distressTile("Save Me", Icons.sos_rounded, () async {
              Future<void> _getCurrentLocation() async {
                Position position = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high);
                _selectedOption =
                    '[dst]${position.latitude}, ${position.longitude}';
              }

              await _getCurrentLocation();
              _sendMessage();
            }, Colors.red)
          ],
        ),
      ),
    );
  }
}
