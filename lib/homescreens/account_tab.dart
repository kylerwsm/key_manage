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
  var userDisplayName = '';
  var userEmail;
  var userAccessRights = '';

  @override
  void initState() {
    super.initState();
    _initialiseUserInformation();
  }

  /// Initialise userID of user.
  void _initialiseUserInformation() async {
    userDisplayName = await widget.auth.getDisplayName();
    userEmail = await widget.auth.getEmail();
    // TODO: Check if user is admin.
    var userIsAdmin = false;
    userAccessRights = userIsAdmin ? 'Admin' : 'User';
    setState(() {});
  }

  /// Displays user email and user type.
  Widget _showUserInfo() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: FlatButton(
                onPressed: _showModifyUserInfoInstructions,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                          child: Icon(Icons.account_circle, size: 50.0),
                        ),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Text(
                                  "$userDisplayName",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 22.0),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Text(
                                  '$userEmail',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Text(
                                  "$userAccessRights Access",
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.grey),
                                ),
                              ),
                            ]))
                      ]),
                ))));
  }

  /// TextFieldController to get user input name.
  var _textEditingController = TextEditingController();

  /// Changes the user displayed name.
  /// Updates the screen.
  void _setUserDisplayedName() async {
    userDisplayName = _textEditingController.text;
    await widget.auth.updateDisplayName(_textEditingController.text);
    _textEditingController.clear();
    setState(() {});
  }

  /// Dialog to allow user to modify display name.
  void _showModifyUserInfoInstructions() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Change Display Name'),
            content: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(hintText: "$userDisplayName"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                  child: new Text('Apply'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _setUserDisplayedName();
                  })
            ],
          );
        });
  }

  /// Displays authentication option.
  Widget _showBiometricOption() {
    return FlatButton(
      child: new Padding(
        padding: const EdgeInsets.all(15.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
              child: Icon(Icons.fingerprint),
            ),
            Container(
              child: Text(
                'Enable Biometrics',
                style: TextStyle(fontSize: 16.0),
              ),
            )
          ],
        ),
      ),
      onPressed: () {},
    );
  }

  /// Displays change password option.
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

  /// Displays change notifications option.
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

  /// Displays report problem option.
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

  /// Personalised instructions for report instructions.
  final _reportInstructions = 'contacting HDB Helpdesk';

  /// Dialog when report problem option is pressed.
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
                Text('Kindly make the issue known by $_reportInstructions.')
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

  /// Shows all account settings option.
  Widget _showAccountSettings() {
    return new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: Card(
          elevation: 5.0,
          child: Column(
            children: <Widget>[
              _showBiometricOption(),
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

  /// Shows all the page content.
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

  /// Displays the 'Account Settings' header.
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

  /// Displays the 'Your Account' header.
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
