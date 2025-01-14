import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Uicomponents.dart';

class ProvisionFormPage extends StatefulWidget {
  @override
  _ProvisionFormPageState createState() => _ProvisionFormPageState();
}

class _ProvisionFormPageState extends State<ProvisionFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile?.path ?? '');
    });
  }

  Future<void> _submit() async {
    if (_nameController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _stockController.text.isEmpty ||
        _image == null) {
      return;
    }

    // Upload image to Firebase Storage
    String fileName = _image!.path.split('/').last;
    UploadTask uploadTask = FirebaseStorage.instance
        .ref('provisions_image/$fileName')
        .putFile(_image!);
    TaskSnapshot taskSnapshot = await uploadTask;
    String imageUrl = await taskSnapshot.ref.getDownloadURL();

    // Add product to Firestore
    await FirebaseFirestore.instance.collection('provisions').add({
      'name': _nameController.text,
      'location': _locationController.text,
      'Stock': int.parse(_stockController.text),
      'price': _priceController.text.toString(),
      'imageUrl': imageUrl,
      'uid': FirebaseAuth.instance.currentUser!.uid,
    });

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Provisions added Successfully'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Provision',
          style: appbar_Tstyle,
        ),
        backgroundColor: appblue,
        iconTheme: backButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Provision Name :",
                style: heading_Tstlye(size: 20),
              ),
              SizedBox(height: 3),
              TextFormField(
                  controller: _nameController,
                  decoration:
                      t_boxdecor(hintText: "Enter your Provision Name")),
              SizedBox(height: 20),
              Text(
                "Stock Available :",
                style: heading_Tstlye(size: 20),
              ),
              SizedBox(height: 3),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _stockController,
                decoration:
                    t_boxdecor(hintText: "Enter available Stock Quantity"),
              ),
              SizedBox(height: 20),
              Text(
                "Provision Price :",
                style: heading_Tstlye(size: 20),
              ),
              SizedBox(height: 3),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _priceController,
                decoration: t_boxdecor(hintText: "Enter the price"),
              ),
              SizedBox(height: 20),
              Text(
                "Location :",
                style: heading_Tstlye(size: 20),
              ),
              SizedBox(height: 3),
              TextFormField(
                controller: _locationController,
                decoration: t_boxdecor(hintText: "Enter your Location"),
              ),
              SizedBox(height: 20),
              Text(
                "Upload Provision Image :",
                style: heading_Tstlye(size: 20),
              ),
              SizedBox(height: 3),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(
                        child: _image == null
                            ? Text(
                                "No Image Selected",
                                style: content_Tstlye(),
                              )
                            : Image.file(
                                _image!,
                                fit: BoxFit.fill,
                              ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    style: buttonStyle(),
                    onPressed: _pickImage,
                    child: Text(
                      "Pick Image",
                      style: buttonTstyle(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  style: buttonStyle(),
                  onPressed: _submit,
                  child: Text(
                    'Add Provision',
                    style: buttonTstyle(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
