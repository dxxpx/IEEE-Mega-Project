import 'package:flutter/material.dart';
import './Uicomponents.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NewsPage(),
    );
  }
}

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final String rssUrl =
      'https://news.google.com/rss/search?q=disaster&hl=en-IN&gl=IN&ceid=IN:en';

  @override
  void initState() {
    super.initState();
  }

  Future<List> fetchNews() async {
    var response = await http.get(Uri.parse(rssUrl));
    if (response.statusCode == 200) {
      var xmlResponse = XmlDocument.parse(response.body);
      return xmlResponse.findAllElements('item').map((element) {
        print(
          element.findElements('pubDate').single.text,
        );
        return {
          'title': element.findElements('title').single.text,
          'link': element.findElements('link').single.text,
          'pubDate': element.findElements('pubDate').single.text,
        };
      }).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  void _launchURL(String url) async {
    try {
      await launch(url);
    } catch (e) {
      throw 'Could not launch $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Disaster News',
          style: appbar_Tstyle,
        ),
        backgroundColor: appblue,
      ),
      body: FutureBuilder<List>(
        future: fetchNews(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                var article = snapshot.data![index];
                return Card(
                  color: Colors.blue.shade50,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(
                      article['title'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(article['pubDate']),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      _launchURL(article['link']);
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load news'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
