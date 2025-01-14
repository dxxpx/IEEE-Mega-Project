import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackfest/views/admin_online/add_products.dart';
import 'places.dart';
import 'placeScreen.dart';
import '../Uicomponents.dart';
import 'add_provisions.dart';
import 'showProvisions.dart';

class ProductListPage extends StatelessWidget {
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

  Widget Product(
      {required BuildContext context,
      required String productName,
      required String productId,
      required String imagelink,
      required String productPrice,
      required String location,
      required int stockno}) {
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
              productName,
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
              'Rs.$productPrice',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () => _deleteProduct(productId),
                  icon: Icon(Icons.delete)),
              IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () =>
                      _editStock(context, productId, stockno as int))
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
          'Products',
          style: appbar_Tstyle,
        ),
        backgroundColor: appblue,
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => placeScreen1()));
              },
              child: Text('Places'))
        ],
        iconTheme: backButton(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
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
                  child: Product(
                      context: context,
                      productName: product['name'],
                      productId: product.id,
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProvisionListPage()));
              },
              child: Icon(
                Icons.local_grocery_store,
                color: Colors.red,
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProductFormPage()));
            },
            child: Icon(
              Icons.add,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
