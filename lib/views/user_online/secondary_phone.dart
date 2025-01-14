import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hackfest/views/user_online/additional_details.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:telephony/telephony.dart';

import '../../viewmodels/changes.dart';
import '../Uicomponents.dart';

class SecondaryPhone extends StatefulWidget {
  @override
  _SecondaryPhoneState createState() => _SecondaryPhoneState();
}

class _SecondaryPhoneState extends State<SecondaryPhone> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final Telephony telephony = Telephony.instance;
  String? _generatedOtp;
  Timer? _timer;
  int _start = 60;
  bool _isOtpSent = false;

  String _generateOtp() {
    var rng = Random();
    return (rng.nextInt(900000) + 100000).toString(); // 6 digit OTP
  }

  Future<void> _sendOtp(String phoneNumber) async {
    _generatedOtp = _generateOtp();
    bool? permissionsGranted = await telephony.requestSmsPermissions;
    if (permissionsGranted != null && permissionsGranted) {
      telephony.sendSms(
        to: phoneNumber,
        message: "Your OTP code is $_generatedOtp",
      );
      setState(() {
        _isOtpSent = true;
      });
      _startTimer();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('SMS permissions not granted')));
    }
  }

  void _startTimer() {
    _start = 60;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_start == 0) {
          timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  Future<void> _verifyOtp() async {
    String enteredOtp = _otpController.text.trim();
    if (enteredOtp == _generatedOtp) {
      await context
          .read<MyModel>()
          .regSecondaryPhone(_phoneController.text.trim());
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => AdditionalDetails()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Invalid OTP')));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Secondary Phone Number', style: appbar_Tstyle),
        iconTheme: backButton(color: Colors.white),
        backgroundColor: appblue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (!_isOtpSent) ...[
                Container(
                  height: 200,
                  child: Image.asset(
                      'assets/images/phoneNoImg.png'), // Replace with your image asset path
                ),
                SizedBox(height: 70),
                Text('Enter Secondary Phone Number', style: heading_Tstlye()),
                SizedBox(height: 10),
                Text('We will send you a Verification Code',
                    style: content_Tstlye()),
                SizedBox(height: 20),
                TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: t_boxdecor(
                        hintText: "Enter your 10-digit Phone Number",
                        labelText: "Back-up Phone Number")),
                SizedBox(height: 20),
                ElevatedButton(
                  style: buttonStyle(),
                  onPressed: () {
                    String phone = _phoneController.text.trim();
                    if (phone.length != 10 ||
                        !RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Please enter a valid 10 digit phone number')));
                      return;
                    }
                    _sendOtp(phone);
                  },
                  child: Text('Send OTP', style: buttonTstyle()),
                ),
              ] else ...[
                Container(
                  height: 200,
                  child: Image.asset('assets/images/otpimg.png'),
                ),
                SizedBox(height: 70),
                Text('Enter Your Confirmation Code', style: heading_Tstlye()),
                SizedBox(height: 10),
                Text(
                  'We have sent a confirmation code to your backup phone number',
                  style: content_Tstlye(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                PinCodeTextField(
                  length: 6,
                  appContext: context,
                  controller: _otpController,
                  onChanged: (value) {},
                ),
                SizedBox(height: 20),
                if (_start > 0)
                  Text(
                    'Resend OTP in $_start seconds',
                    style: TextStyle(fontSize: 17),
                  )
                else
                  ElevatedButton(
                    style: buttonStyle(),
                    onPressed: () {
                      String phone = _phoneController.text.trim();
                      _sendOtp(phone);
                    },
                    child: Text(
                      'Resend OTP',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: buttonStyle(),
                  onPressed: _verifyOtp,
                  child: Text(
                    'Verify OTP',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
//[
//               PinCodeTextField(
//                 length: 6,
//                 appContext: context,
//                 controller: _otpController,
//                 onChanged: (value) {},
//               ),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _verifyOtp,
//                 child: Text('Verify OTP'),
//               ),
//               SizedBox(height: 16),
//               if (_start > 0)
//                 Text('Resend OTP in $_start seconds')
//               else
//                 ElevatedButton(
//                   onPressed: () {
//                     String phone = _phoneController.text.trim();
//                     _sendOtp(phone);
//                   },
//                   child: Text('Resend OTP'),
//                 ),
//             ],

// [
//                 Container(
//                   height: 200,
//                   child: Image.asset('assets/images/otpimg.png'),
//                 ),
//                 SizedBox(height: 70),
//                 Text('Enter Your Confirmation Code', style: heading_Tstlye()),
//                 SizedBox(height: 10),
//                 Text(
//                   'We have sent a confirmation code to your phone number',
//                   style: content_Tstlye(),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 20),
//                 PinCodeTextField(
//                   length: 6,
//                   appContext: context,
//                   controller: _otpController,
//                   onChanged: (value) {},
//                 ),
//                 SizedBox(height: 20),
//                 if (_start > 0)
//                   Text(
//                     'Resend OTP in $_start seconds',
//                     style: TextStyle(fontSize: 17),
//                   )
//                 else
//                   ElevatedButton(
//                     style: buttonStyle(),
//                     onPressed: () {
//                       String phone = _phoneController.text.trim();
//                       _sendOtp(phone);
//                     },
//                     child: Text(
//                       'Resend OTP',
//                       style: TextStyle(fontSize: 20, color: Colors.white),
//                     ),
//                   ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   style: buttonStyle(),
//                   onPressed: _verifyOtp,
//                   child: Text(
//                     'Verify OTP',
//                     style: TextStyle(fontSize: 20, color: Colors.white),
//                   ),
//                 ),
//               ],
//             ],
