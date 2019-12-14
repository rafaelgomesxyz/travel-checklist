import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import './screens/HomeScreen.dart';

void main() {
  initializeDateFormatting('pt_BR', null).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(title: 'Travel Checklist'),
    );
  }
}