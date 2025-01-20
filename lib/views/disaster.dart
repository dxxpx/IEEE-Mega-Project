import 'package:flutter/material.dart';
import './ads.dart';
import 'package:url_launcher/url_launcher.dart';
import './Uicomponents.dart';

class DisasterInfo {
  final String title;
  final String description;
  final List<RecoveryLink> preparationLinks;
  final List<RecoveryLink> precautionLinks;
  final List<RecoveryLink> firstAidLinks;
  final List<RecoveryLink> recoveryLinks;

  DisasterInfo({
    required this.title,
    required this.description,
    List<RecoveryLink>? preparationLinks,
    List<RecoveryLink>? precautionLinks,
    List<RecoveryLink>? firstAidLinks,
    List<RecoveryLink>? recoveryLinks,
  })  : preparationLinks = preparationLinks ?? [],
        precautionLinks = precautionLinks ?? [],
        firstAidLinks = firstAidLinks ?? [],
        recoveryLinks = recoveryLinks ?? [];
}

class RecoveryLink {
  final String title;
  final String url;

  RecoveryLink({required this.title, required this.url});
}

List<DisasterInfo> disasters = [
  DisasterInfo(
    title: "Flood",
    description: "Information about how to stay safe during floods.",
    preparationLinks: [
      RecoveryLink(
          title: "Flood Preparation Guide",
          url: "https://www.ready.gov/floods"),
    ],
    precautionLinks: [
      RecoveryLink(
          title: "Flood Safety Tips",
          url: "https://www.cdc.gov/disasters/floods/index.html"),
    ],
    firstAidLinks: [
      RecoveryLink(
          title: "Flood First Aid Tips",
          url:
              "https://www.redcross.org/get-help/how-to-prepare-for-emergencies/types-of-emergencies/flood.html"),
    ],
    recoveryLinks: [
      RecoveryLink(
          title: "Flood Recovery Guide",
          url:
              "https://www.redcross.org/get-help/how-to-prepare-for-emergencies/types-of-emergencies/flood.html"),
    ],
  ),
  DisasterInfo(
    title: "Earthquake",
    description: "Information about how to stay safe during earthquakes.",
    preparationLinks: [
      RecoveryLink(
          title: "Earthquake Preparation Guide",
          url: "https://www.ready.gov/earthquakes"),
    ],
    precautionLinks: [
      RecoveryLink(
          title: "Earthquake Safety Tips",
          url: "https://www.cdc.gov/disasters/earthquakes/index.html"),
    ],
    firstAidLinks: [
      RecoveryLink(
          title: "Earthquake First Aid Tips",
          url:
              "https://www.redcross.org/get-help/how-to-prepare-for-emergencies/types-of-emergencies/earthquake.html"),
    ],
    recoveryLinks: [
      RecoveryLink(
          title: "Earthquake Recovery Guide",
          url:
              "https://www.redcross.org/get-help/how-to-prepare-for-emergencies/types-of-emergencies/earthquake.html"),
    ],
  ),
  DisasterInfo(
    title: "Tornado",
    description: "Information about how to stay safe during tornadoes.",
    preparationLinks: [
      RecoveryLink(
          title: "Tornado Preparation Guide",
          url: "https://www.ready.gov/tornadoes"),
    ],
    precautionLinks: [
      RecoveryLink(
          title: "Tornado Safety Tips",
          url: "https://www.cdc.gov/nceh/features/tornadosafety/index.html"),
    ],
    firstAidLinks: [
      RecoveryLink(
          title: "Tornado First Aid Tips",
          url:
              "https://www.redcross.org/get-help/how-to-prepare-for-emergencies/types-of-emergencies/tornado.html"),
    ],
    recoveryLinks: [
      RecoveryLink(
          title: "Tornado Recovery Guide",
          url:
              "https://www.redcross.org/get-help/how-to-prepare-for-emergencies/types-of-emergencies/tornado.html"),
    ],
  ),
  DisasterInfo(
    title: "Wildfire",
    description: "Information about how to stay safe during wildfires.",
    preparationLinks: [
      RecoveryLink(
          title: "Wildfire Preparation Guide",
          url: "https://www.ready.gov/wildfires"),
    ],
    precautionLinks: [
      RecoveryLink(
          title: "Wildfire Safety Tips",
          url: "https://www.cdc.gov/disasters/wildfires/index.html"),
    ],
    firstAidLinks: [
      RecoveryLink(
          title: "Wildfire First Aid Tips",
          url:
              "https://www.redcross.org/get-help/how-to-prepare-for-emergencies/types-of-emergencies/wildfire.html"),
    ],
    recoveryLinks: [
      RecoveryLink(
          title: "Wildfire Recovery Guide",
          url:
              "https://www.redcross.org/get-help/how-to-prepare-for-emergencies/types-of-emergencies/wildfire.html"),
    ],
  ),
  DisasterInfo(
    title: "Hurricane",
    description: "Information about how to stay safe during hurricanes.",
    preparationLinks: [
      RecoveryLink(
          title: "Hurricane Preparation Guide",
          url: "https://www.ready.gov/hurricanes"),
    ],
    precautionLinks: [
      RecoveryLink(
          title: "Hurricane Safety Tips",
          url: "https://www.cdc.gov/disasters/hurricanes/index.html"),
    ],
    firstAidLinks: [
      RecoveryLink(
          title: "Hurricane First Aid Tips",
          url:
              "https://www.redcross.org/get-help/how-to-prepare-for-emergencies/types-of-emergencies/hurricane.html"),
    ],
    recoveryLinks: [
      RecoveryLink(
          title: "Hurricane Recovery Guide",
          url:
              "https://www.redcross.org/get-help/how-to-prepare-for-emergencies/types-of-emergencies/hurricane.html"),
    ],
  ),
];

class DisasterInfoPage extends StatelessWidget {
  final List<DisasterInfo> disasters;

  DisasterInfoPage({required this.disasters});

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildLinkSection(String title, List<RecoveryLink> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ...links.map((link) {
          return GestureDetector(
            onTap: () {
              Future<void> _launchUrl() async {
                if (!await launchUrl(Uri.parse(link.url))) {
                  throw Exception('Could not launch');
                }
              }

              _launchUrl();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Text(
                link.title,
                style: TextStyle(
                    color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
          );
        }).toList(),
        SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: backButton(color: Colors.white),
        title: Text('Disaster Information and Recovery Links',
            style: appbar_Tstyle),
        backgroundColor: appblue,
      ),
      body: Column(
        children: [
          MyBannerAdWidget(),
          Expanded(
            child: ListView.builder(
              itemCount: disasters.length,
              itemBuilder: (context, index) {
                final disaster = disasters[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          disaster.title,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(disaster.description),
                        SizedBox(height: 10),
                        _buildLinkSection(
                            "Preparation", disaster.preparationLinks),
                        _buildLinkSection(
                            "Precaution", disaster.precautionLinks),
                        _buildLinkSection("First Aid", disaster.firstAidLinks),
                        _buildLinkSection("Recovery", disaster.recoveryLinks),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
