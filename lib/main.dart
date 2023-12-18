import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class CharacterData {
  final String name;
  final String server;
  final String guild;
  final String spec;
  final int worldRank;
  final int regionRank;
  final int realmRank;
  final int dpsWorldRank;
  final int dpsRegionRank;
  final int dpsRealmRank;
  final int healWorldRank;
  final int healRegionRank;
  final int healRealmRank;
  final double mythicPlusScore;

  CharacterData({
    required this.name,
    required this.server,
    required this.guild,
    required this.spec,
    required this.worldRank,
    required this.regionRank,
    required this.realmRank,
    required this.dpsWorldRank,
    required this.dpsRegionRank,
    required this.dpsRealmRank,
    required this.healWorldRank,
    required this.healRegionRank,
    required this.healRealmRank,
    required this.mythicPlusScore,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: YourFlutterWidget(),
    );
  }
}

class YourFlutterWidget extends StatefulWidget {
  @override
  _YourFlutterWidgetState createState() => _YourFlutterWidgetState();
}

class _YourFlutterWidgetState extends State<YourFlutterWidget> {

  // Initialize characterData with default values
  late CharacterData characterData = CharacterData(
    name: '',
    server: '',
    guild: '',
    spec: '',
    worldRank: 0,
    regionRank: 0,
    realmRank: 0,
    dpsWorldRank: 0,
    dpsRegionRank: 0,
    dpsRealmRank: 0,
    healWorldRank: 0,
    healRegionRank: 0,
    healRealmRank: 0,
    mythicPlusScore: 0.0,
  );
  final characterTextField = TextEditingController();
  final serverTextField = TextEditingController();

  void fetchData(String characterName, String serverName) async {
    final response = await http.get(Uri.parse(
        'https://raider.io/api/v1/characters/profile?region=us&realm=$serverName&name=$characterName&fields=mythic_plus_scores_by_season%3Acurrent%2Cguild%2Cmythic_plus_ranks'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      setState(() {
        characterData = CharacterData(
          name: jsonData['name'],
          server: jsonData['realm'],
          guild: jsonData.containsKey('guild')
              ? jsonData['guild']['name']
              : 'No Guild Listed',
          spec: jsonData['active_spec_name'],
          worldRank: jsonData['mythic_plus_ranks']['overall']['world'],
          regionRank: jsonData['mythic_plus_ranks']['overall']['region'],
          realmRank: jsonData['mythic_plus_ranks']['overall']['realm'],
          dpsWorldRank: jsonData['mythic_plus_ranks']['class_dps']['world'],
          dpsRegionRank: jsonData['mythic_plus_ranks']['class_dps']['region'],
          dpsRealmRank: jsonData['mythic_plus_ranks']['class_dps']['realm'],
          healWorldRank: jsonData['mythic_plus_ranks']['class_healer']['world'],
          healRegionRank: jsonData['mythic_plus_ranks']['class_healer']['region'],
          healRealmRank: jsonData['mythic_plus_ranks']['class_healer']['realm'],
          mythicPlusScore: jsonData['mythic_plus_scores_by_season'][0]['scores']['all'].toDouble(),
        );
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RaiderIO'),
      ),
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          color: Color(0xFF070707),
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),
              Row(
                children: [
                  Image.asset(
                    'assets/rio_image.png',
                    width: 105,
                    height: 104,
                  ),
                  SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RaiderIO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Mobile Client',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Text(
                'Enter Character Name:',
                style: TextStyle(
                  color: Color(0xFFE49F24),
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: characterTextField,
                      decoration: InputDecoration(
                        hintText: 'Character',
                        hintStyle: TextStyle(color: Color(0xFF9F9D9D)),
                      ),
                      style: TextStyle(color: Color(0xFF9F9D9D)),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      controller: serverTextField,
                      decoration: InputDecoration(
                        hintText: 'Server',
                        hintStyle: TextStyle(color: Color(0xFF9F9D9D)),
                      ),
                      style: TextStyle(color: Color(0xFF9F9D9D)),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      String characterName = characterTextField.text;
                      String serverName = serverTextField.text;
                      fetchData(characterName, serverName);
                    },
                    child: Text('Search'),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        characterData = CharacterData(
                          name: '',
                          server: '',
                          guild: '',
                          spec: '',
                          worldRank: 0,
                          regionRank: 0,
                          realmRank: 0,
                          dpsWorldRank: 0,
                          dpsRegionRank: 0,
                          dpsRealmRank: 0,
                          healWorldRank: 0,
                          healRegionRank: 0,
                          healRealmRank: 0,
                          mythicPlusScore: 0.0,
                        );
                      });
                      characterTextField.clear();
                      serverTextField.clear();
                    },
                    child: Text('Clear'),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              // Display fetched data
              if (characterData != null) ...[
                Text(
                  'Name: ${characterData.name}',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Server: ${characterData.server}',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Guild: ${characterData.guild}',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Spec: ${characterData.spec}',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Mythic Plus Score: ${characterData.mythicPlusScore}',
                  style: TextStyle(color: Colors.pink),
                ),
                Text(
                  'World Rank: ${characterData.worldRank}',
                  style: TextStyle(color: Colors.orange),
                ),
                Text(
                  'Region Rank: ${characterData.regionRank}',
                  style: TextStyle(color: Colors.orange),
                ),
                Text(
                  'Realm Rank: ${characterData.realmRank}',
                  style: TextStyle(color: Colors.orange),
                ),
                Text(
                  'DPS World Rank: ${characterData.dpsWorldRank}',
                  style: TextStyle(color: Colors.lightBlue),
                ),
                Text(
                  'DPS Region Rank: ${characterData.dpsRegionRank}',
                  style: TextStyle(color: Colors.lightBlue),
                ),
                Text(
                  'DPS Realm Rank: ${characterData.dpsRealmRank}',
                  style: TextStyle(color: Colors.lightBlue),
                ),
                Text(
                  'Heal World Rank: ${characterData.healWorldRank}',
                  style: TextStyle(color: Colors.green),
                ),
                Text(
                  'Heal Region Rank: ${characterData.healRegionRank}',
                  style: TextStyle(color: Colors.green),
                ),
                Text(
                  'Heal Realm Rank: ${characterData.healRealmRank}',
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}