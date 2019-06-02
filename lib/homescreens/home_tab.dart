import 'package:flutter/material.dart';
import 'package:key_manage/homescreens/card_item_model.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => new _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with TickerProviderStateMixin {
  var appColors = [
    Color.fromRGBO(231, 129, 109, 1.0),
    Color.fromRGBO(99, 138, 223, 1.0),
    Color.fromRGBO(111, 194, 173, 1.0)
  ];
  var cardIndex = 0;
  ScrollController scrollController;
  var currentColor = Colors.white;
  var qrCard = CardItemModel("Your QR Code", Icons.code, 9, 0.83);

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
    scrollController = new ScrollController();
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
  Widget _showIcon() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Icon(
        Icons.wb_sunny,
        size: 45.0,
        color: Color.fromRGBO(231, 129, 109, 1.0),
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
                        color: appColors[0],
                      ),
                      Icon(
                        Icons.more_vert,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Text(
                          "${qrCard.tasksRemaining} Tasks",
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
                          value: qrCard.taskCompletion,
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
