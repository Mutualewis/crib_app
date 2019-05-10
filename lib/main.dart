import 'package:flutter/material.dart';
import 'package:consumable_app/auth.dart';
import 'package:consumable_app/routes.dart';

void main() => runApp(NKGApp());

class NKGApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NKGEA',
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.deepOrange[200],
      ),
      routes: routes,
    );
  }
}
