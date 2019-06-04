import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:key_manage/services/authentication.dart';

class AccountTab extends StatefulWidget {
  AccountTab({Key key, this.auth, this.userId}) : super(key: key);

  final BaseAuth auth;
  final String userId;

  @override
  _AccountTabState createState() => new _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  var screenBackgroundColor = Colors.white;
  var userEmail;
  var userAccessRights = '';

  @override
  void initState() {
    super.initState();
    _initialiseUserInformation();
  }

  void _initialiseUserInformation() async {
    userEmail = await widget.auth.getEmail();
    // TODO: Check if user is admin.
    var userIsAdmin = false;
    userAccessRights = userIsAdmin ? 'Admin' : 'User';
    setState(() {});
  }

  Widget _showUserInfo() {
    return new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: Card(
          elevation: 5.0,
          child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Text(
                        "UserID: $userEmail",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Text(
                        "User Type: $userAccessRights",
                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                      ),
                    ),
                  ])),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ));
  }

  Widget _showUserParticularsEdit() {
    return GestureDetector(
      child: new Padding(
        padding: const EdgeInsets.all(15.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
              child: Icon(Icons.account_circle),
            ),
            Container(
              child: Text(
                'Change Displayed Name',
                style: TextStyle(fontSize: 16.0),
              ),
            )
          ],
        ),
      ),
      onTap: () {},
    );
  }

  Widget _showChangePassword() {
    return GestureDetector(
      child: new Padding(
        padding: const EdgeInsets.all(15.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
              child: Icon(Icons.vpn_key),
            ),
            Container(
              child: Text(
                'Change Password',
                style: TextStyle(fontSize: 16.0),
              ),
            )
          ],
        ),
      ),
      onTap: () {},
    );
  }

  Widget _showNotificationsEdit() {
    return GestureDetector(
      child: new Padding(
        padding: const EdgeInsets.all(15.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
              child: Icon(Icons.notifications),
            ),
            Container(
              child: Text(
                'Change Notifications',
                style: TextStyle(fontSize: 16.0),
              ),
            )
          ],
        ),
      ),
      onTap: () {},
    );
  }

  Widget _showReportProblem() {
    return GestureDetector(
      child: new Padding(
        padding: const EdgeInsets.all(15.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
              child: Icon(Icons.error),
            ),
            Container(
              child: Text(
                'Report a Problem',
                style: TextStyle(fontSize: 16.0),
              ),
            )
          ],
        ),
      ),
      onTap: () {},
    );
  }

  Widget _showAccountSettings() {
    return new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: Card(
          elevation: 5.0,
          child: Column(
            children: <Widget>[
              _showUserParticularsEdit(),
              Divider(),
              _showChangePassword(),
              Divider(),
              _showNotificationsEdit(),
              Divider(),
              _showReportProblem()
            ],
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ));
  }

  // Shows the content on the page.
  Widget _showBody() {
    return new ListView(
      padding: EdgeInsets.all(16.0),
      shrinkWrap: true,
      children: <Widget>[
        _showAccountHeader(),
        _showUserInfo(),
        _showSettingsHeader(),
        _showAccountSettings(),
      ],
    );
  }

  Widget _showSettingsHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 12.0),
              child: Text(
                "Account Settings",
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _showAccountHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 12.0),
              child: Text(
                "Your Account",
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: screenBackgroundColor,
        body: Stack(
          children: <Widget>[
            _showBody(),
          ],
        ));
  }
}
