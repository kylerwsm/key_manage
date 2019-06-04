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
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: FlatButton(
                onPressed: () {},
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                "UserID: $userEmail",
                                style: TextStyle(fontSize: 16.0),
                              ),
                            )),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                "User Type: $userAccessRights",
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.grey),
                              ),
                            )),
                      ]),
                ))));
  }

  Widget _showUserParticularsEdit() {
    return FlatButton(
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
      onPressed: () {},
    );
  }

  Widget _showChangePassword() {
    return FlatButton(
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
      onPressed: () {},
    );
  }

  Widget _showNotificationsEdit() {
    return FlatButton(
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
      onPressed: () {},
    );
  }

  Widget _showReportProblem() {
    return FlatButton(
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
      onPressed: _showReportProblemInstructions,
    );
  }

  void _showReportProblemInstructions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Report a Problem"),
          content: new Container(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Text('Thank you for your initiative.'),
                Padding(padding: const EdgeInsets.symmetric(vertical: 5.0)),
                Text('Kindly make the issue known to HDB Helpdesk.')
              ])),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
      padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
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
