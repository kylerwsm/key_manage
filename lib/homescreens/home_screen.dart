import 'package:flutter/material.dart';
import 'package:key_manage/homescreens/home_tab.dart';
import 'package:key_manage/homescreens/key_tab.dart';
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
  bool _isEmailVerified = false;

  List<Widget> tabs = [HomeTab(), KeyTab(), NotiScreen(), AccountScreen()];
  List<String> tabNames = ['Home', 'Keys', 'Notifications', 'Account'];

  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
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
          backgroundColor: Color.fromRGBO(231, 129, 109, 1.0),
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
          elevation: 0.0,
        ),
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
