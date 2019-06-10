import 'package:flutter/material.dart';
import 'package:key_manage/services/authentication.dart';
import 'package:key_manage/loginscreens/root_page.dart';
import 'package:flutter/services.dart';

final applicationName = 'KeyManage';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);
    return new MaterialApp(
        title: applicationName,
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new RootPage(auth: new Auth()));
  }
}
