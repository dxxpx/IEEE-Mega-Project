import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../views/user_online/maps_markers.dart';
import 'package:intl/intl.dart';

Color appblue = Color(0XFF4D88D7);

TextStyle heading_Tstlye({Color? color, double? size}) {
  return TextStyle(
    fontSize: size != null ? size : 24.0,
    color: color != null ? color : Colors.black87,
    fontWeight: FontWeight.bold,
  );
}

TextStyle content_Tstlye({
  Color? color,
}) {
  return TextStyle(
      fontSize: 18.0,
      color: color != null ? color : Colors.black45,
      fontWeight: FontWeight.w500);
}

IconThemeData backButton({required Color color}) {
  return IconThemeData(color: color);
}

// TextStyle content_Tstyle = TextStyle(fontSize: 16.0, color: Colors.grey);

TextStyle appbar_Tstyle =
    TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20);

// TextStyle buttonTstyle =
//     TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16);

TextStyle buttonTstyle({Color? color}) {
  return TextStyle(
      color: color != null ? color : Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16);
}

InputDecoration t_boxdecor(
    {IconData? icon,
    required String hintText,
    String? labelText,
    Color? color}) {
  return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      floatingLabelStyle: TextStyle(fontSize: 24, color: Colors.black54),
      labelText: labelText != null ? labelText : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      icon: icon != null
          ? Icon(
              icon,
            )
          : null,
      iconColor: icon != null && color != null ? color : Colors.white);
}

// ButtonStyle buttonStyle = ElevatedButton.styleFrom(
//     backgroundColor: appblue,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)));

ButtonStyle buttonStyle({Color? bgcolor}) {
  return ElevatedButton.styleFrom(
      backgroundColor: bgcolor != null ? bgcolor : appblue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)));
}

String GetDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  String formattedDate = DateFormat('MMM d').format(dateTime);
  return formattedDate;
}

String GetTime(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  String formattedDate = DateFormat('h:mm a').format(dateTime);
  return formattedDate;
}

//Product Tile
Widget buyProduct({
  required BuildContext context,
  required String productId,
  required String imagelink,
  required String productPrice,
  required String productName,
  required String location,
  required int stockno,
}) {
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
      ],
    ),
  );
}

Widget buyProvisionTile(
    {required BuildContext context,
    required String provId,
    required String provName,
    required String imagelink,
    required String provPrice,
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
      ],
    ),
  );
}

//For Admin_Welcome_page
Widget DistressCalls(String distresstype, String name, String nop,
    String datetime, String location, Function() onpressed) {
  return Container(
    decoration: BoxDecoration(
        color: distresstype.toLowerCase() == 'sos'
            ? Colors.red.withOpacity(0.7)
            : distresstype.toLowerCase() == 'food'
                ? Colors.green.withOpacity(0.2)
                : Colors.blue.withOpacity(0.2),
        border: Border.all(color: Colors.black, width: 0.2)),
    padding: EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              child: Icon(
                distresstype.toLowerCase() == 'sos'
                    ? Icons.sos_rounded
                    : distresstype.toLowerCase() == 'food'
                        ? Icons.food_bank_rounded
                        : Icons.medical_services_rounded,
                size: 39,
                color: distresstype.toLowerCase() == 'sos'
                    ? Colors.red.shade900
                    : distresstype.toLowerCase() == 'food'
                        ? Colors.green.shade500
                        : Colors.blue.shade500,
              ),
              decoration:
                  BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            ),
            SizedBox(width: 20),
            Text(
              GetDate(datetime),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 10),
            Text(
              GetTime(datetime),
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            )
          ],
        ),
        Container(
          width: 220,
          padding: EdgeInsets.all(5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: distresstype.toLowerCase() == 'sos'
                  ? Colors.red.shade50
                  : distresstype.toLowerCase() == 'food'
                      ? Colors.green.shade50
                      : Colors.blue.shade50,
              border: Border.all(color: Colors.black, width: 0.2),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                distresstype.toUpperCase(),
                style: TextStyle(
                    color: distresstype.toLowerCase() == 'sos'
                        ? Colors.red.shade900
                        : distresstype.toLowerCase() == 'food'
                            ? Colors.green.shade500
                            : Colors.blue.shade500,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
              Divider(
                thickness: 1,
                color: Colors.grey,
                indent: 2,
                endIndent: 2,
              ),
              Text(
                name,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              Text('People : $nop',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              Text('Location :',
                  softWrap: true,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              Text(location,
                  softWrap: true,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87))
            ],
          ),
        ),
        ElevatedButton(
          onPressed: onpressed,
          child: Icon(
            Icons.location_on,
            color: distresstype.toLowerCase() == 'sos'
                ? Colors.red.shade900
                : distresstype.toLowerCase() == 'food'
                    ? Colors.green.shade500
                    : Colors.blue.shade500,
          ),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 10,
              shape: CircleBorder()),
        )
      ],
    ),
  );
}

//For user's welcome_page
Widget profilecard(String name, String adharCardNumber, String NOP,
    String location, Function() onpressed, String pphone, String sphone) {
  return Center(
    child: Card(
      margin: EdgeInsets.symmetric(vertical: 40),
      elevation: 10,
      color: appblue.withOpacity(0.9),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: Icon(
                CupertinoIcons.profile_circled,
                size: 180,
                color: Colors.blueGrey,
              ),
            ),
            SizedBox(height: 14),
            Text(
              'Welcome, $name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 290,
              child: Divider(
                thickness: 1,
              ),
            ),
            SizedBox(height: 10),
            Text(
              textAlign: TextAlign.center,
              'Aadhar Number',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              textAlign: TextAlign.center,
              adharCardNumber,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Number Of People : $NOP',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Location:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              location,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: onpressed,
              child: Text('Update Location'),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(),
                  textStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  elevation: 10),
            ),
            SizedBox(height: 10),
            Text(
              'Phone No.: $pphone',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Alt Phone No.: $sphone',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget Updatetile(String disasterType, String suggestion, String DateNTime,
    bool isSevere, String location, BuildContext context) {
  return Column(children: [
    Container(
      decoration: BoxDecoration(
          color: isSevere
              ? Colors.red.withOpacity(0.6)
              : Colors.yellow.withOpacity(0.5),
          border: Border.symmetric(
              horizontal: BorderSide(color: Colors.white, width: 1.9))),
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                InkWell(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      disasterType.trim() == "Flood"
                          ? Icons.flood
                          : disasterType.trim() == "Hurricane"
                              ? Icons.cloudy_snowing
                              : disasterType.trim() == "Earthquake"
                                  ? Icons.landslide
                                  : Icons.flood,
                      size: 39,
                      color: Colors.red.shade900,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                  ),
                  onTap: () {
                    List<String> latLng = location.split(', ');
                    double latitude = double.parse(latLng[0].split(': ')[1]);
                    double longitude = double.parse(latLng[1].split(': ')[1]);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GoogleMapScreen(
                              lat: latitude,
                              long: longitude,
                            )));
                  },
                ),
                SizedBox(height: 5),
                Text(
                  GetDate(DateNTime),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  GetTime(DateNTime),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(width: 20),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isSevere
                            ? Colors.red.shade50
                            : Colors.deepOrange.shade50,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        disasterType[0].toUpperCase() +
                            disasterType.substring(1),
                        style: TextStyle(
                            color: isSevere ? Colors.red : Colors.deepOrange,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isSevere
                            ? Colors.red.shade50
                            : Colors.deepOrange.shade50,
                      ),
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Suggestion :',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              softWrap: true,
                              suggestion,
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ]);
}

Widget Historytile(String distressType, String DistressTime) {
  return Column(children: [
    Container(
      decoration: BoxDecoration(
          color: distressType.toLowerCase() == 'sos'
              ? Colors.red.withOpacity(0.8)
              : distressType.toLowerCase() == 'food'
                  ? Colors.green.withOpacity(0.5)
                  : Colors.blue.withOpacity(0.5),
          border: Border.symmetric(
              horizontal: BorderSide(color: Colors.white, width: 2.0))),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    distressType.toLowerCase() == 'sos'
                        ? Icons.sos_rounded
                        : Icons.food_bank_rounded,
                    size: distressType.toLowerCase() == 'sos' ? 40 : 45,
                    color: distressType.toLowerCase() == 'sos'
                        ? Colors.red.shade900
                        : Colors.deepOrange.shade500,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                ),
                SizedBox(height: 5),
              ],
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: distressType.toLowerCase() == 'sos'
                          ? Colors.red.shade50
                          : Colors.deepOrange.shade50,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      distressType,
                      style: TextStyle(
                          color: distressType.toLowerCase() == 'sos'
                              ? Colors.red
                              : Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: distressType.toLowerCase() == 'sos'
                          ? Colors.red.shade50
                          : Colors.deepOrange.shade50,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Date : ' + GetDate(DistressTime),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Time : ' + GetTime(DistressTime),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  ]);
}

Widget distressTile(
    String innerText, IconData iconData, Function()? onpressed, Color color) {
  return Container(
    height: 160,
    width: 160,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.4),
          spreadRadius: 3,
          blurRadius: 10,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          Text(
            innerText,
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(10),
              backgroundColor: color,
              // overlayColor: Colors.red,
              elevation: 10,
            ),
            onPressed: onpressed,
            child: Icon(
              iconData,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    ),
  );
}
