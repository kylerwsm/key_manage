import 'package:flutter/material.dart';

// Titles for the respective tabs.
List<String> screenTitles = ['Home', 'Keys', 'Notifications', 'Your Account'];

class HomeScreen extends StatefulWidget {
  final title = screenTitles[0];

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[_showBody()],
    ));
  }

  /*
  Widget _showWelcomeMessage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 100.0, 30.0, 0.0),
      child: new TextField()
    );
  }
  */

  // Displays welcome text. Text style used here adopted from:
  // https://pusher.com/tutorials/styled-text-flutter
  Widget _showWelcomeMessage(BuildContext context) {
    return Text(
      'Good day',
      style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
    );
  }

  Widget _showBody() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: null, // Might require global key if snackbars are required.
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[_showWelcomeMessage(context)],
          ),
        ));
  }
}

class KeyScreen extends StatelessWidget {
  final title = screenTitles[1];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container();
  }
}

class NotiScreen extends StatelessWidget {
  final title = screenTitles[2];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container();
  }
}

class AccountScreen extends StatelessWidget {
  final title = screenTitles[3];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container();
  }
}
