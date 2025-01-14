import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DisasterContactsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DisasterContactsPage();
  }
}

class DisasterContactsPage extends StatelessWidget {
  final List<Contact> contacts = [
    Contact(
        name: "National Disaster Management Authority (NDMA)", number: "1078"),
    Contact(name: "National Emergency Number", number: "112"),
    Contact(
        name: "National Disaster Response Force (NDRF)",
        number: "011-24363260"),
    Contact(
        name: "Indian Meteorological Department (IMD)",
        number: "1800-180-1717"),
    Contact(
        name: "Andhra Pradesh Disaster Management Helpline", number: "1070"),
    Contact(name: "Tamil Nadu Disaster Management Helpline", number: "1070"),
    Contact(name: "Maharashtra Disaster Management Helpline", number: "1077"),
    Contact(name: "Kerala Disaster Management Helpline", number: "1077"),
    Contact(name: "West Bengal Disaster Management Helpline", number: "1070"),
    Contact(name: "Fire and Rescue Services", number: "101"),
    Contact(name: "Ambulance Services", number: "102"),
    Contact(name: "Police", number: "100"),
    Contact(name: "Child Helpline", number: "1098"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disaster Emergency Contacts'),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            title: Text(contact.name),
            subtitle: Text(contact.number),
            trailing: Icon(Icons.phone),
            onTap: () => _makePhoneCall(contact.number),
          );
        },
      ),
    );
  }

  Future<void> _makePhoneCall(String number) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: number,
    );
    await launch(launchUri.toString());
  }
}

class Contact {
  final String name;
  final String number;

  Contact({required this.name, required this.number});
}
