import 'package:flutter/material.dart';
import 'package:key_manage/homescreens/home_tab.dart';
import 'package:key_manage/homescreens/key_tab.dart';
import 'package:key_manage/homescreens/noti_tab.dart';
import 'package:key_manage/homescreens/account_tab.dart';
import 'package:key_manage/services/authentication.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({this.key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final Key key;
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
  bool _isEmailVerified = false;

  // The one to use in the end.
  List<Widget> tabs1 = [HomeTab(), KeyTab(), NotiTab(), AccountTab()];

  // The stub I am using now.
  List<Widget> tabs;

  List<String> tabNames = ['Home', 'Keys', 'Notifications', 'Account'];
  List<Color> tabColors = [
    // Make all tab colors the same.
    Color.fromRGBO(231, 129, 109, 1.0),
    Color.fromRGBO(231, 129, 109, 1.0),
    Color.fromRGBO(231, 129, 109, 1.0),
    Color.fromRGBO(231, 129, 109, 1.0),
    // Other tab colors archived.
    Color.fromRGBO(99, 138, 223, 1.0),
    Color.fromRGBO(111, 194, 173, 1.0),
    Color.fromRGBO(231, 129, 109, 1.0)
  ];

  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
    _initVariables();
  }

  void _initVariables() {
    tabs = [
      HomeTab(key: widget.key, auth: widget.auth, userId: widget.userId),
      KeyTab(key: widget.key, auth: widget.auth, userId: widget.userId),
      NotiTab(key: widget.key, auth: widget.auth, userId: widget.userId),
      AccountTab(key: widget.key, auth: widget.auth, userId: widget.userId)
    ];
  }

  // This method prompts the user to verify email.
  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text(
              "Please verify your account using the link sent to your registered email."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Resend link"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
              },
            ),
            new FlatButton(
              child: new Text("Logout"),
              onPressed: () {
                Navigator.of(context).pop();
                _signOut();
              },
            ),
          ],
        );
      },
    );
  }

  // This method resends a verification email to the user.
  void _resentVerifyEmail() {
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  // This method prompts user that verification email is resent.
  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been resent to your email."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Logout"),
              onPressed: () {
                Navigator.of(context).pop();
                _signOut();
              },
            ),
          ],
        );
      },
    );
  }

  // This method checks if user is email verified.
  void _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }

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
        appBar: new AppBar(
          title: new Text(
            tabNames[currentTabIndex],
            style: TextStyle(fontSize: 20.0),
          ),
          backgroundColor: tabColors[currentTabIndex],
          centerTitle: true,
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: GestureDetector(
                  child: Icon(Icons.exit_to_app),
                  onTap: () {
                    _signOutSequence();
                  },
                )),
          ],
          // elevation: 0.0,
        ),
        body: tabs[currentTabIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: onTapped,
          currentIndex: currentTabIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text(tabNames[0]),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.vpn_key),
              title: Text(tabNames[1]),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              title: Text(tabNames[2]),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              title: Text(tabNames[3]),
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
