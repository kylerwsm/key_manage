import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:key_manage/firestore_constants.dart';
import 'package:key_manage/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountTab extends StatefulWidget {
  AccountTab({Key key, this.auth, this.userId}) : super(key: key);

  final BaseAuth auth;
  final String userId;

  @override
  _AccountTabState createState() => new _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  final _reportInstructions = 'contacting HDB Helpdesk';
  var _textEditingController = TextEditingController();
  var _tecKeyId = TextEditingController();
  var _tecAddressLine1 = TextEditingController();
  var _tecAddressLine2 = TextEditingController();
  var _tecPostalCode = TextEditingController();

  var userDisplayName = '';
  var userEmail;
  var userAccessRights = '';
  var userIsAdmin = false;
  bool _isLoading = false;

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
    userIsAdmin = true;
    userAccessRights = userIsAdmin ? 'Admin' : 'User';
    setState(() {});
  }

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
                  _textEditingController.clear();
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

  /// Dialog to allow user to modify display name.
  void _showAddKeyInstructions() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add a Key'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _tecKeyId,
                  decoration: InputDecoration(hintText: "Key number"),
                ),
                TextField(
                  controller: _tecAddressLine1,
                  decoration: InputDecoration(hintText: "Block and Street Name"),
                ),
                TextField(
                  controller: _tecAddressLine2,
                  decoration: InputDecoration(hintText: "Unit Number"),
                ),
                TextField(
                  controller: _tecPostalCode,
                  decoration: InputDecoration(hintText: "Postal Code"),
                )
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  _tecKeyId.clear();
                  _tecAddressLine1.clear();
                  _tecAddressLine2.clear();
                  _tecPostalCode.clear();
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                  child: new Text('Add'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _addNewKey();
                  })
            ],
          );
        });
  }

  /// Adds a new key to the database.
  void _addNewKey() {
    CollectionReference keyDb = Firestore.instance.collection(keyIdCollection);
    String keyId = _tecKeyId.text;
    String address1 = _tecAddressLine1.text;
    String address2 = _tecAddressLine2.text;
    String postal = _tecPostalCode.text;

    if (_keyIdIsValid(keyId)) {
      _tecKeyId.clear();
      _tecAddressLine1.clear();
      _tecAddressLine2.clear();
      _tecPostalCode.clear();
      String dateNow = DateFormat('dd MMMM yyyy, kk:mm').format(DateTime.now());

      keyDb.document(keyId).setData({
        locationHeader: widget.userId,
        dateHeader: dateNow,
        addressLine1: address1,
        addressLine2: address2,
        postalCode: postal
      }, merge: true);
    }
  }

  /// Checks if the keyId is valid.
  static bool _keyIdIsValid(String keyId) {
    return true;
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

  /// Displays authentication option.
  Widget _showBiometricOption() {
    return RaisedButton(
        color: Colors.white,
        elevation: 5.0,
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)));
  }

  /// Displays change password option.
  Widget _showChangePassword() {
    return RaisedButton(
        color: Colors.white,
        elevation: 5.0,
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)));
  }

  /// Displays change notifications option.
  Widget _showNotificationsEdit() {
    return RaisedButton(
        color: Colors.white,
        elevation: 5.0,
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)));
  }

  /// Displays report problem option.
  Widget _showReportProblem() {
    return RaisedButton(
        color: Colors.white,
        elevation: 5.0,
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)));
  }

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

  /// Displays user management option.
  Widget _showManageUsersOption() {
    return RaisedButton(
        color: Colors.white,
        elevation: 5.0,
        child: new Padding(
          padding: const EdgeInsets.all(15.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                child: Icon(Icons.people),
              ),
              Container(
                child: Text(
                  'Manage Users',
                  style: TextStyle(fontSize: 16.0),
                ),
              )
            ],
          ),
        ),
        onPressed: () {},
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)));
  }

  /// Displays key management option.
  Widget _showAddKeyOption() {
    return RaisedButton(
        color: Colors.white,
        elevation: 5.0,
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
                  'Add Keys',
                  style: TextStyle(fontSize: 16.0),
                ),
              )
            ],
          ),
        ),
        onPressed: () {
          _showAddKeyInstructions();
        },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)));
  }

  /// Displays view log option.
  Widget _showViewLogOption() {
    return RaisedButton(
        color: Colors.white,
        elevation: 5.0,
        child: new Padding(
          padding: const EdgeInsets.all(15.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                child: Icon(Icons.history),
              ),
              Container(
                child: Text(
                  'View Usage Logs',
                  style: TextStyle(fontSize: 16.0),
                ),
              )
            ],
          ),
        ),
        onPressed: () {},
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)));
  }

  /// Displays apartment mapping option.
  Widget _showApartmentMappingOption() {
    return RaisedButton(
        color: Colors.white,
        elevation: 5.0,
        child: new Padding(
          padding: const EdgeInsets.all(15.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                child: Icon(Icons.home),
              ),
              Container(
                child: Text(
                  'Update Apartment Mapping',
                  style: TextStyle(fontSize: 16.0),
                ),
              )
            ],
          ),
        ),
        onPressed: () {},
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)));
  }

  /// Separator splitting individual buttons aesthetically.
  Widget _applySeparator() {
    return Padding(padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0));
  }

  /// Shows all admin user option.
  Widget _showAdminControls() {
    return new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: Column(
          children: <Widget>[
            //_showManageUsersOption(),
            //_applySeparator(),
            _showAddKeyOption(),
            //_applySeparator(),
            //_showApartmentMappingOption(),
            //_applySeparator(),
            //_showViewLogOption(),
          ],
        ));
  }

  /// Shows all account settings option.
  Widget _showAccountSettings() {
    return new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: Column(
          children: <Widget>[
            _showBiometricOption(),
            _applySeparator(),
            _showChangePassword(),
            _applySeparator(),
            _showNotificationsEdit(),
            _applySeparator(),
            _showReportProblem()
          ],
        ));
  }

  /// Shows all the page content.
  Widget _showBody() {
    return new ListView(
      padding: EdgeInsets.all(16.0),
      physics: const AlwaysScrollableScrollPhysics(),
      children: <Widget>[
        _showAccountHeader(),
        _showUserInfo(),
        _showSettingsHeader(),
        _showAccountSettings(),
        if (userIsAdmin) _showAdminHeader(),
        if (userIsAdmin) _showAdminControls()
      ],
    );
  }

  /// Displays the 'Admin User' header.
  Widget _showAdminHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 12.0),
              child: Text(
                "Admin User",
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

  /// Shows the circular progress.
  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Stack(
          children: <Widget>[
            _showBody(),
            _showCircularProgress(),
          ],
        ));
  }
}
