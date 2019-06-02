import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:key_manage/homescreens/card_item_model.dart';
import 'package:key_manage/services/authentication.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';

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
  ScrollController scrollController;
  var currentColor = Colors.white;
  var qrCard;
  var qrCardIconColor = Color.fromRGBO(231, 129, 109, 1.0);
  var keyID = null;

  AnimationController animationController;
  ColorTween colorTween;
  CurvedAnimation curvedAnimation;

  var userName = "Stranger";
  var userLoanedKeys = 0;

  @override
  void initState() {
    // TODO: Update userName from Auth.
    // TODO: Update keys on loan.
    super.initState();
    _makeQRCard();
  }

  void _makeQRCard() {
    var date = new DateTime.utc(1989, 11, 9);
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(date);
    keyID = '123456789012';
    qrCard = CardItemModel(keyID, Icons.vpn_key, formattedDate, null);
    print('KeyID: $keyID');
  }

  // Shows the content on the page.
  Widget _showBody() {
    return new ListView(
      padding: EdgeInsets.all(16.0),
      shrinkWrap: true,
      children: <Widget>[
        _showQRCard(),
      ],
    );
  }

  // Displays the QR card on the KeyTab.
  Widget _showQRCard() {
    return new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
        child: Card(
          elevation: 5.0,
          child: Container(
            width: 250.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        qrCard.icon,
                        color: qrCardIconColor,
                      ),
                      Icon(
                        Icons.more_vert,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
                Center(
                    // TODO: Add key content here.
                    child: null),
                Padding(
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
                ),
              ],
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        ));
  }

  // Generates QR based on userID.
  Widget _getQrCode(String keyID) {
    return QrImage(
      data: keyID,
      onError: (ex) {
        print("[QR] ERROR - $ex");
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
