import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:key_manage/homescreens/card_item_model.dart';
import 'package:key_manage/services/authentication.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeTab extends StatefulWidget {
  HomeTab({Key key, this.auth, this.userId}) : super(key: key);

  final BaseAuth auth;
  final String userId;

  @override
  _HomeTabState createState() => new _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with TickerProviderStateMixin {
  var iconColor = Color.fromRGBO(231, 129, 109, 1.0);
  var cardIndex = 0;
  ScrollController scrollController;
  var currentColor = Colors.white;
  var qrCard;
  var qrCardIconColor = Color.fromRGBO(231, 129, 109, 1.0);

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
    qrCard = CardItemModel("Your QR Code", Icons.code, widget.userId, null);
    print('The QR userID is ${widget.userId}');
  }

  // Shows the content on the page.
  Widget _showBody() {
    return new ListView(
      padding: EdgeInsets.all(16.0),
      shrinkWrap: true,
      children: <Widget>[
        _showHeader(),
        _showQRCard(),
      ],
    );
  }

  // Shows the Icon on top of the screen.
  // Shows Icon according to time of day.
  // Morning: 0600 - 1159.
  // Afternoon: 1200 - 1659.
  // Evening: 1700 - 2159.
  // Night: 2200 - 0559.
  Widget _showIcon() {
    List<IconData> icons = [
      Icons.wb_sunny,
      Icons.wb_sunny,
      Icons.wb_sunny,
      Icons.brightness_3,
    ];
    IconData iconData;
    var hourOfDay = TimeOfDay.now().hour;

    if (hourOfDay < 6) {
      iconData = icons[3];  // Night
    } else if (hourOfDay < 12) {
      iconData = icons[0];  // Morning
    } else if (hourOfDay < 17) {
      iconData = icons[1];  // Afternoon
    } else if (hourOfDay < 22) {
      iconData = icons[2];  // Evening
    } else {
      iconData = icons[3];  // Night
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Icon(
        iconData,
        size: 45.0,
        color: iconColor,
      ),
    );
  }

  // Shows the hello message.
  Widget _showWelcome() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 12.0),
      child: Text(
        "Hello, $userName.",
        style: TextStyle(
            fontSize: 30.0, color: Colors.black87, fontWeight: FontWeight.w400),
      ),
    );
  }

  // Shows the description under the hello message.
  Widget _showDescription() {
    return Text(
      "You have $userLoanedKeys borrowed keys.",
      style: TextStyle(
        color: Colors.black,
      ),
    );
  }

  // Shows Icon, hello, description.
  Widget _showHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 32.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[_showIcon(), _showWelcome(), _showDescription()],
        ),
      ),
    );
  }

  // Displays the QR card on the hometab.
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
                    child: Container(
                        height: 200.0,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _getQrCode()))),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Text(
                          "Your code: ${qrCard.description}",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Text(
                          "${qrCard.cardTitle}",
                          style: TextStyle(fontSize: 28.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LinearProgressIndicator(
                          value: qrCard.percentDone,
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
  Widget _getQrCode() {
    return QrImage(
      data: widget.userId,
      // size: 0.5 * bodyHeight,
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
