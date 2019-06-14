import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:key_manage/firestore_constants.dart';
import 'package:key_manage/services/authentication.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KeyTab extends StatefulWidget {
  KeyTab({Key key, this.auth, this.userId}) : super(key: key);

  final BaseAuth auth;
  final String userId;

  @override
  _KeyTabState createState() => new _KeyTabState();
}

class _KeyTabState extends State<KeyTab> {
  final _formKey = new GlobalKey<FormState>();
  var iconColor = Color.fromRGBO(231, 129, 109, 1.0);
  var currentColor = Colors.white;
  bool _isLoading = false;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  /// Transfer selected keys to receiver.
  void _transferKeys(String receiver) async {
    TextEditingController keyIdController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Transfer a Key to $receiver',
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: new TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    controller: keyIdController,
                    decoration: new InputDecoration(
                        hintText: 'Key to transfer',
                        icon: new Icon(
                          Icons.vpn_key,
                          color: Colors.grey,
                        )),
                    validator: (value) =>
                        value.isEmpty ? 'Key number can\'t be empty' : null,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  keyIdController.clear();
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                  child: new Text('Transfer'),
                  onPressed: () {
                    setState(() => this._isLoading = true);
                    if (_formKey.currentState.validate()) {
                      _transferKeyAndFeedbackUser(
                          receiver, keyIdController.text);
                      keyIdController.clear();
                      Navigator.of(context).pop();
                    }
                    setState(() => this._isLoading = false);
                  })
            ],
          );
        });
  }

  /// Transfer the key to the receiver if the key belongs to current user.
  void _transferKeyAndFeedbackUser(String receiver, String keyId) async {
    // Check if the key is transferred to oneself.
    if (receiver == widget.userId) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Transfer Information'),
            content: Text('You cannot transfer a key to yourself.'),
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
    } else {
      CollectionReference keyDb =
          Firestore.instance.collection(keyIdCollection);
      var snapShot = await keyDb.document(keyId).get();
      var transferIsSuccessful = false;

      if (snapShot.exists && snapShot[locationHeader] == widget.userId) {
        keyDb.document(keyId).updateData({
          locationHeader: receiver,
          dateHeader: DateFormat('dd MMMM yyyy, kk:mm').format(DateTime.now()),
        });
        transferIsSuccessful = true;
      }

      var feedbackToUser = transferIsSuccessful
          ? 'Transferred successfully.'
          : 'You need to own the key in order to transfer it.';

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Transfer Information'),
            content: Text(feedbackToUser),
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
  }

  /// Scans a bar code and saves the result into barcode variable.
  void _scanQrCode() async {
    try {
      String barcode = await BarcodeScanner.scan();
      _transferKeys(barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Error"),
              content: Text('The application requires camera permission.'),
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
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Error"),
              content: Text('Unknown error: $e'),
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
    } on FormatException {
      print('User returned using the "back"-button before scanning anything');
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Error"),
            content: Text('Unknown error: $e'),
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
      print('Unknown error: $e');
    }
  }

  /// Transfer the key to the receiver if the key belongs to current user.
  void _searchKeyAndFeedbackUser(String keyId) async {
    CollectionReference keyDb = Firestore.instance.collection(keyIdCollection);
    var snapShot = await keyDb.document(keyId).get();

    var feedbackToUser = snapShot.exists
        ? 'Key ${snapShot.documentID} is held by ${snapShot[locationHeader]} since ${snapShot[dateHeader]}.'
        : 'Key does not seem to exist.';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('Search Results'),
          content: Text(feedbackToUser),
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

  /// Search for a key and displays result to user via a dialog box.
  void _searchForAKey() {
    TextEditingController keyIdController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Search for a Key',
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: new TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    controller: keyIdController,
                    decoration: new InputDecoration(
                        hintText: 'Key number to search',
                        icon: new Icon(
                          Icons.vpn_key,
                          color: Colors.grey,
                        )),
                    validator: (value) =>
                        value.isEmpty ? 'Key number can\'t be empty' : null,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  keyIdController.clear();
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                  child: new Text('Search'),
                  onPressed: () {
                    setState(() => this._isLoading = true);
                    if (_formKey.currentState.validate()) {
                      _searchKeyAndFeedbackUser(keyIdController.text);
                      keyIdController.clear();
                      Navigator.of(context).pop();
                    }
                    setState(() => this._isLoading = false);
                  })
            ],
          );
        });
  }

  /// Shows all the action buttons.
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
                  onPressed: () => _searchForAKey(),
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

  /// Shows the content on the page.
  Widget _showBody() {
    return new ListView(
      controller: _controller,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(16.0),
      children: <Widget>[
        _showActionsHeader(),
        _showActions(),
        _showKeyHeader(),
        _buildKeys()
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

  /// This widget builds the keys.
  Widget _buildKeys() {
    return new Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection(keyIdCollection)
              .where(locationHeader, isEqualTo: widget.userId)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');
              default:
                return new Column(
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return new ListTile(
                      title: new Text('Key ${document.documentID}',
                          style: TextStyle(fontSize: 18.0)),
                      subtitle: new Text('Held since ${document[dateHeader]}'),
                      onTap: () {
                        _showKeyInfo(document);
                      },
                    );
                  }).toList(),
                );
            }
          },
        ));
  }

  void _showKeyInfo(DocumentSnapshot document) {
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
                    child: Text('Key: ', style: TextStyle(color: Colors.grey))),
                Text(document.documentID),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Divider()),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text('Address Information:',
                        style: TextStyle(color: Colors.grey))),
                Text(
                    '${document[addressLine1]}\n${document[addressLine2]}\nSingapore ${document[postalCode]}'),
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
