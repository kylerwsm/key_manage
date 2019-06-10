import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:key_manage/models/card_item_model.dart';
import 'package:key_manage/services/authentication.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class KeyTab extends StatefulWidget {
  KeyTab({Key key, this.auth, this.userId}) : super(key: key);

  final BaseAuth auth;
  final String userId;

  @override
  _KeyTabState createState() => new _KeyTabState();
}

class _KeyTabState extends State<KeyTab> {
  var iconColor = Color.fromRGBO(231, 129, 109, 1.0);
  var cardIndex = 0;
  var currentColor = Colors.white;
  var keyCard;
  var keyID;
  var userLoanedKeys = 0;
  String barcode = "";

  @override
  void initState() {
    super.initState();
    _makeQRCard();
  }

  // Scans a bar code and saves the result into barcode variable.
  void _scanQrCode() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The application requires camera permission.';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode = 'null.');
      print(
          'null (User returned using the "back"-button before scanning anything)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error.');
      print('Unknown error: $e');
    }
  }

  void _makeQRCard() {
    var date = new DateTime.utc(1989, 11, 9);
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(date);
    keyID = '123456789';
    keyCard = CardItemModel(keyID, Icons.vpn_key, formattedDate, null);
  }

  Widget _showActions() {
    return new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RaisedButton(
                  elevation: 5.0,
                  color: Colors.white,
                  padding: EdgeInsets.all(15.0),
                  onPressed: () {
                    _scanQrCode();
                  },
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.swap_horiz,
                          size: 40.0,
                        ),
                        Text(
                          'Transfer',
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400),
                        )
                      ]),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0))),
              RaisedButton(
                  elevation: 5.0,
                  color: Colors.white,
                  padding: EdgeInsets.all(15.0),
                  // TODO: SEARCH METHOD.
                  onPressed: () {},
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.search,
                          size: 40.0,
                        ),
                        Text(
                          'Search',
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400),
                        )
                      ]),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0))),
              RaisedButton(
                  elevation: 5.0,
                  color: Colors.white,
                  padding: EdgeInsets.all(15.0),
                  onPressed: () {
                    setState(() {});
                  },
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.refresh,
                          size: 40.0,
                        ),
                        Text(
                          'Refresh',
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400),
                        )
                      ]),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0))),
            ]));
  }

  // Shows the content on the page.
  Widget _showBody() {
    return new ListView(
      controller: ScrollController(),
      padding: EdgeInsets.all(16.0),
      shrinkWrap: true,
      children: <Widget>[
        _showActionsHeader(),
        _showActions(),
        _showKeyHeader(),
        _showKeyEntry(),
        _showKeyEntry(),
        _showKeyEntry(),
        _showKeyEntry(),
        _showKeyEntry(),
        _showKeyEntry(),
        _showKeyEntry(),
        _showKeyEntry(),
        _showKeyEntry(),
        _showKeyEntry(),
      ],
    );
  }

  Widget _showActionsHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 40.0, 12.0),
      child: Text(
        "Actions",
        style: TextStyle(
            fontSize: 18.0, color: Colors.black87, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _showKeyHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 12.0),
      child: Text(
        "Borrowed Keys",
        style: TextStyle(
            fontSize: 18.0, color: Colors.black87, fontWeight: FontWeight.w500),
      ),
    );
  }

  // Displays the QR card on the KeyTab.
  Widget _showKeyEntry() {
    return new Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
        child: GestureDetector(
            onTap: _showKeyInfo,
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
                            "Held since ${keyCard.description}",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Text(
                            "KeyID: ${keyCard.cardTitle}",
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

  void _showKeyInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Key Information"),
          content: new Container(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child:
                        Text('KeyID: ', style: TextStyle(color: Colors.grey))),
                    Text('123456789'),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Divider()),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text('Address Information:',
                            style: TextStyle(color: Colors.grey))),
                    Text('Block 123, Pasir Ris Street 13'),
                    Text('#01-101'),
                    Text('Singapore 123123'),
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
