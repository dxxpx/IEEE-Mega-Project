class Place {
  String name;
  String type;
  String? location;
  String address;
  String? info;
  String? accomodation;

  Place(
      {required this.name,
      this.location,
      required this.type,
      required this.address,
      this.info,
      this.accomodation});
}

List<Place> placesList = [
  Place(
      name: 'Apollo pharmacy', address: '9th,Street Chennai', type: 'Medicals'),
  Place(name: 'Grocery1', address: '10th,Street Chennai', type: 'Groceries'),
  Place(
      name: 'Hall 1',
      address: '11th,Street Chennai',
      type: 'Shelter',
      accomodation: '100'),
  Place(
      name: 'Pharmacy 2',
      type: 'Medicals',
      address: '15th cross street',
      info: 'Open 24/7'),
  Place(
      name: 'Hospital 1',
      type: 'Hospital',
      address: '11th cross street, Chennai',
      info: 'Open 24hrs'),
  Place(
      name: 'Grocery 2',
      type: 'Groceries',
      address: '12th cross street',
      info: 'Closes by 4pm'),
  Place(
      name: 'Hall 2',
      type: 'Groceries',
      accomodation: '150',
      address: '12th cross street',
      info: 'Food and basic necesities provided'),
];

void addPlace(String name, String type, String? location, String address,
    String? info, String? accomodation) {
  placesList.insert(
    0,
    Place(
        name: name,
        type: type,
        address: address,
        location: location,
        accomodation: accomodation,
        info: info),
  );
}

List<Place> getPlace() {
  return placesList;
}
