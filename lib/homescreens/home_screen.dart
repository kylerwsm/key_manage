import 'package:flutter/material.dart';
import 'package:key_manage/services/authentication.dart';
import 'tab_screens.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Text style for the login page.
  TextStyle style = TextStyle(fontSize: 20.0);
  int currentTabIndex = 0;

  List<Widget> tabs = [
    HomeScreen(),
    KeyScreen(),
    NotiScreen(),
    AccountScreen()
  ];

  // When the icon in the tab navigation is tapped, this method saves the index
  // of the tab that was tapped on.
  void onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(screenTitles[currentTabIndex]),
            actions: <Widget>[
              new FlatButton(
                  child: new Text('Logout',
                      style:
                          new TextStyle(fontSize: 17.0, color: Colors.white)),
                  onPressed: _signOutSequence)
            ]),
        body: tabs[currentTabIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: onTapped,
          currentIndex: currentTabIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.vpn_key),
              title: Text('Keys'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              title: Text('Notifications'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              title: Text('Account'),
            )
          ],
        ));
  }

  // This method signs the user out of the app.
  _signOut() async {
    await widget.auth.signOut();
    widget.onSignedOut();
  }

  // This method prompts an alert dialog for logout confirmation.
  _signOutSequence() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Logout"),
            content: new Text("You will be returned to the login screen."),
            actions: <Widget>[
              // Buttons for the dialog box.
              new FlatButton(
                child: new Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text("Logout"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _signOut();
                },
              )
            ],
          );
        });
  }
}
