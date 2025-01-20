import 'dart:io';
import '../Uicomponents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class SubmitProblemPage extends StatefulWidget {
  @override
  _SubmitProblemPageState createState() => _SubmitProblemPageState();
}

class _SubmitProblemPageState extends State<SubmitProblemPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  Position? _currentPosition;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentPosition = position;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  Future<String?> _uploadImage() async {
    if (_image == null) return null;
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().toString()}');
      final uploadTask = storageRef.putFile(File(_image!.path));
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _submitProblem() async {
    final user = _auth.currentUser;
    final imageUrl = await _uploadImage();
    final timestamp = DateTime.now().toUtc();

    await FirebaseFirestore.instance.collection('problems').add({
      'description': _descriptionController.text,
      'location': _currentPosition != null
          ? 'Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}'
          : 'Location not available',
      'imageUrl': imageUrl,
      'timestamp': timestamp.toIso8601String(),
      'rectified': false,
      'userid': user?.uid,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Problem submitted successfully!')),
    );
    Navigator.of(context).pop();
    // Clear inputs
    _descriptionController.clear();
    setState(() {
      _image = null;
      _currentPosition = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Problem', style: buttonTstyle()),
        backgroundColor: appblue,
        iconTheme: backButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Description',
                  style: heading_Tstlye(), textAlign: TextAlign.start),
              SizedBox(height: 3),
              TextField(
                controller: _descriptionController,
                decoration: t_boxdecor(hintText: "Describe your problem here"),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    style: buttonStyle(),
                    onPressed: _pickImage,
                    child: Text('Pick Image', style: buttonTstyle()),
                  ),
                  SizedBox(width: 5),
                  if (_image != null) ...[
                    Image.file(File(_image!.path), height: 500),
                    SizedBox(height: 20),
                  ],
                ],
              ),
              // ElevatedButton(
              //   style: buttonStyle(),
              //   onPressed: _pickImage,
              //   child: Text('Pick Image', style: buttonTstyle()),
              // ),
              // if (_image != null) ...[
              //   Image.file(File(_image!.path), height: 500),
              //   SizedBox(height: 20),
              // ],
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Your Location: "),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      _currentPosition != null
                          ? 'Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}'
                          : 'Location not available',
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: buttonStyle(),
                onPressed: _getCurrentLocation,
                child: Text('Get Current Location', style: buttonTstyle()),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: buttonStyle(),
                onPressed: _submitProblem,
                child: Text('Submit Problem', style: buttonTstyle()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
