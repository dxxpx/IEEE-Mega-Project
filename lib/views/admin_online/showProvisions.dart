import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackfest/views/admin_online/add_products.dart';
import 'package:hackfest/views/admin_online/add_provisions.dart';
import 'places.dart';
import 'placeScreen.dart';
import '../Uicomponents.dart';

class ProvisionListPage extends StatelessWidget {
  Future<void> _deleteProduct(String id) async {
    await FirebaseFirestore.instance.collection('provisions').doc(id).delete();
  }

  Future<void> _editStock(
      BuildContext context, String id, int currentStock) async {
    final TextEditingController _stockController =
        TextEditingController(text: currentStock.toString());

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Stock Availability'),
        content: TextField(
          controller: _stockController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Stock Availability'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('provisions')
                  .doc(id)
                  .update({
                'Stock': int.parse(_stockController.text),
              });
              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget ProvisionTile(
      {required BuildContext context,
      required String provId,
      required String provName,
      required String imagelink,
      required String provPrice,
      required String location,
      required int stockno,
      required String provisionUserId}) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Card(
      elevation: 10,
      color: Colors.blue.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.all(2),
              height: 120,
              width: double.infinity,
              child: Image.network(
                imagelink,
                fit: BoxFit.fill,
              )),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              provName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              location,
              softWrap: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Stock: $stockno'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Rs.$provPrice',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (currentUser?.uid == provisionUserId)
                IconButton(
                    onPressed: () => _deleteProduct(provId),
                    icon: Icon(Icons.delete)),
              if (currentUser?.uid == provisionUserId)
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () =>
                        _editStock(context, provId, stockno as int))
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Provisions',
          style: appbar_Tstyle,
        ),
        backgroundColor: appblue,
        iconTheme: backButton(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('provisions').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final Provisions = snapshot.data!.docs;

          return SingleChildScrollView(
            padding: EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(Provisions.length, (index) {
                final provision = Provisions[index];
                return SizedBox(
                  width: (MediaQuery.of(context).size.width - 24) /
                      2, // Adjust width for 2 columns with spacing
                  child: ProvisionTile(
                      context: context,
                      provName: provision['name'],
                      provId: provision.id,
                      imagelink: provision['imageUrl'],
                      location: provision['location'],
                      stockno: provision['Stock'],
                      provPrice: provision['price'],
                      provisionUserId: provision['uid']),
                );
              }),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProvisionFormPage()));
        },
        child: Icon(
          Icons.add,
          color: Colors.red,
        ),
      ),
    );
  }
}
