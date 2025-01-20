import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Uicomponents.dart';
import '../ads.dart';

class Buy extends StatelessWidget {
  Future<void> _deleteProduct(String id) async {
    await FirebaseFirestore.instance.collection('products').doc(id).delete();
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
                  .collection('products')
                  .doc(id)
                  .update({
                'stock': int.parse(_stockController.text),
              });
              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products', style: appbar_Tstyle),
        iconTheme: backButton(color: Colors.white),
        backgroundColor: appblue,
        // actions: [
        //   ElevatedButton(
        //       onPressed: () {
        //         Navigator.push(context,
        //             MaterialPageRoute(builder: (context) => placeScreen1()));
        //       },
        //       child: Text('Places'))
        // ],
      ),
      body: Column(children: [
        MyBannerAdWidget(),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('products').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              final products = snapshot.data!.docs;

              return SingleChildScrollView(
                padding: EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(products.length, (index) {
                    final product = products[index];
                    return SizedBox(
                      width: (MediaQuery.of(context).size.width - 24) /
                          2, // Adjust width for 2 columns with spacing
                      child: buyProduct(
                          context: context,
                          productId: product.id,
                          productName: product['name'],
                          imagelink: product['imageUrl'],
                          location: product['location'],
                          stockno: product['stock'],
                          productPrice: product['price']),
                    );
                  }),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
