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
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 0.0),
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

  Widget _buildNameOption() {
    Icon icon = Icon(
      Icons.person,
      size: 40.0,
    );
    Text text = Text(
      'Alias',
      style: TextStyle(
          fontSize: 12.0, color: Colors.black87, fontWeight: FontWeight.w400),
    );
    return new GestureDetector(
        child: new Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[icon, text],
          ),
        ),
        onTap: () {});
  }

  Widget _buildSearchOption() {
    Icon icon = Icon(
      Icons.search,
      size: 40.0,
    );
    Text text = Text(
      'Search',
      style: TextStyle(
          fontSize: 12.0, color: Colors.black87, fontWeight: FontWeight.w400),
    );
    return new GestureDetector(
        child: new Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[icon, text],
          ),
        ),
        onTap: () {});
  }

  Widget _buildRefreshOption() {
    Icon icon = Icon(
      Icons.refresh,
      size: 40.0,
    );
    Text text = Text(
      'Refresh',
      style: TextStyle(
          fontSize: 12.0, color: Colors.black87, fontWeight: FontWeight.w400),
    );
    return new GestureDetector(
        child: new Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[icon, text],
          ),
        ),
        onTap: () {
          setState(() {});
        });
  }

  Widget _showAccountSettings() {
    Widget nameOption = _buildNameOption();
    Widget searchOption = _buildSearchOption();
    Widget refreshOption = _buildRefreshOption();

    return new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 0.0),
        child: Card(
          elevation: 5.0,
          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[nameOption, searchOption, refreshOption],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[nameOption, searchOption, refreshOption],
            )
          ]),
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
      padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 0.0),
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
      padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 0.0),
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
