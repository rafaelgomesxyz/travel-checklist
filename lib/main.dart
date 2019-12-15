import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:travel_checklist/screens/HomeScreen.dart';
import 'package:travel_checklist/services/PreferencesManager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesManager.instance.init();
  await initializeDateFormatting('pt_BR', null);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travel Checklist',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(title: 'Travel Checklist'),
    );
  }
}