import 'package:flutter/material.dart';
import 'package:pa8/models/Analyse.dart';
import 'package:pa8/models/User.dart';
import 'package:pa8/models/references/MoleType.dart';

class LastAnalysesWidget extends StatelessWidget {
  final UserData user;

  LastAnalysesWidget(this.user);

  final List<Analyse> _listAnalyses = [
    new Analyse(
      moleType: MoleType.BENIGN,
      risk: 45,
      date: DateTime.now(),
      imageUrl:
          "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fcdn.futura-sciences.com%2Fbuildsv6%2Fimages%2Fwide1920%2F3%2F0%2F3%2F3030e3c89f_134019_canonique-naevus.jpg&f=1&nofb=1",
    ),
  ];

  @override
  Widget build(BuildContext _context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(_context).size.height / 1.7,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _listAnalyses.length,
        itemBuilder: (_context, index) {
          Analyse analyse = _listAnalyses[0];
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Card(
              elevation: 5,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  leading: user == null ? Image.network(analyse.imageUrl) : Image.network(analyse.imageUrl),
                  title: Text('${analyse.date}'),
                  subtitle: Text("${analyse.moleType.toString().split('.')[1]} | ${analyse.risk} %"),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
