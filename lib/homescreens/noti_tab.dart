import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:key_manage/models/card_item_model.dart';
import 'package:key_manage/services/authentication.dart';
import 'package:intl/intl.dart';

class NotiTab extends StatefulWidget {
  NotiTab({Key key, this.auth, this.userId}) : super(key: key);

  final BaseAuth auth;
  final String userId;

  @override
  _NotiTabState createState() => new _NotiTabState();
}

class _NotiTabState extends State<NotiTab> {
  var iconColor = Color.fromRGBO(231, 129, 109, 1.0);
  var cardIndex = 0;
  var currentColor = Colors.white;
  var notificationDetails;
  var notificationContent;
  var userLoanedKeys = 0;
  String barcode = "";

  @override
  void initState() {
    super.initState();
    _makeNotification();
  }

  // Shows the content on the page.
  Widget _showBody() {
    return new ListView(
      controller: ScrollController(),
      padding: EdgeInsets.all(16.0),
      shrinkWrap: true,
      children: <Widget>[
        _showNotificationsHeader(),
        _showNotification()
      ],
    );
  }

  Widget _showNotificationsHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 40.0, 12.0),
      child: Text(
        "All Notifications",
        style: TextStyle(
            fontSize: 18.0, color: Colors.black87, fontWeight: FontWeight.w500),
      ),
    );
  }

  void _makeNotification() {
    var date = new DateTime.utc(1989, 11, 9);
    var formatter = new DateFormat('dd MMMM yyyy');
    String formattedDate = formatter.format(date);
    notificationContent = 'Welcome to KeyManage!';
    notificationDetails = CardItemModel(notificationContent, Icons.vpn_key, formattedDate, null);
  }

  // Displays the QR card on the NotiTab.
  Widget _showNotification() {
    return new Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
        child: GestureDetector(
            onTap: (){},
            child: Card(
              elevation: 5.0,
              child: Container(
                  width: 250.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Text(
                            "${notificationDetails.description}",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Text(
                            "${notificationDetails.cardTitle}",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ],
                    ),
                  )),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: currentColor,
        body: Stack(
          children: <Widget>[
            _showBody(),
          ],
        ));
  }
}
