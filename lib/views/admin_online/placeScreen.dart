import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Uicomponents.dart';
import 'addplaces.dart';
import 'places.dart';

class placeScreen1 extends StatefulWidget {
  const placeScreen1({super.key});

  @override
  State<placeScreen1> createState() => _placeScreen1State();
}

class _placeScreen1State extends State<placeScreen1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Places', style: appbar_Tstyle),
        iconTheme: backButton(color: Colors.white),
        backgroundColor: appblue,
      ),
      body: PlacesListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Addplaces()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class PlacesListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: getPlace().length,
      itemBuilder: (context, index) {
        Place place = getPlace()[index];
        return PlaceTile(
          name: place.name,
          type: place.type,
          location: place.location,
          address: place.address,
          info: place.info,
          accomodation: place.accomodation,
        );
      },
    );
  }
}

Widget PlaceTile(
    {required String name,
    required String type,
    String? location,
    required String address,
    String? info,
    String? accomodation}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Expanded(
        child: Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 30,
              child: Icon(
                type == 'Hospital'
                    ? Icons.local_hospital
                    : type == 'Groceries'
                        ? Icons.fastfood
                        : type == 'Shelter'
                            ? Icons.home
                            : type == 'Medicals'
                                ? Icons.medication_sharp
                                : CupertinoIcons.cart_fill,
                size: 40,
              ),
            ),
            Container(
              width: 220,
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: heading_Tstlye(),
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
                    indent: 2,
                    endIndent: 2,
                  ),
                  Text(
                    'Address : $address',
                    style: content_Tstlye(),
                  ),
                  SizedBox(height: 10),
                  if (info != null) ...[
                    Text('Additional Information :', style: content_Tstlye()),
                    Text(
                      info,
                      softWrap: true,
                      style: content_Tstlye(),
                    ),
                  ],
                  if (accomodation != '0' && accomodation != null) ...[
                    Row(
                      children: [
                        Text('Accomodation : ',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87)),
                        Text(
                          accomodation,
                          style: heading_Tstlye(),
                        )
                      ],
                    )
                  ],
                ],
              ),
            ),
            ElevatedButton(onPressed: () {}, child: Icon(Icons.location_on))
          ],
        ),
      ),
    )),
  );
}
