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
  var qrCard;
  var qrCardIconColor = Color.fromRGBO(231, 129, 109, 1.0);
  var keyID;
  var userLoanedKeys = 0;
  String barcode = "";

  @override
  void initState() {
    super.initState();
    _makeQRCard();
  }

  // Scans a bar code and saves the result into barcode variable.
  void _scan() async {
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

  void _scanQrCode() {
    _scan();
  }

  void _makeQRCard() {
    var date = new DateTime.utc(1989, 11, 9);
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(date);
    keyID = '123456789';
    qrCard = CardItemModel(keyID, Icons.vpn_key, formattedDate, null);
  }

  Widget _buildTransferOption() {
    Icon icon = Icon(
      Icons.swap_horiz,
      size: 40.0,
    );
    Text text = Text(
      'Transfer',
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
          _scanQrCode();
        });
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

  Widget _showActions() {
    Widget transferOption = _buildTransferOption();
    Widget searchOption = _buildSearchOption();
    Widget refreshOption = _buildRefreshOption();

    return new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 0.0),
        child: Card(
          elevation: 5.0,
          child: Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[transferOption, searchOption, refreshOption],
          )),
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
        _showActionsHeader(),
        _showActions(),
        _showKeyHeader(),
        _showKeyEntry(),
      ],
    );
  }

  Widget _showActionsHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 0.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[_actionsHeader()],
        ),
      ),
    );
  }

  Widget _actionsHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 12.0),
      child: Text(
        "Actions",
        style: TextStyle(
            fontSize: 18.0, color: Colors.black87, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _showKeyHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[_keyHeader()],
        ),
      ),
    );
  }

  Widget _keyHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 12.0),
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
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
                        "Held since ${qrCard.description}",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Text(
                        "KeyID: ${qrCard.cardTitle}",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ],
                ),
              )),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ));
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
