import 'package:flutter/material.dart';
import 'package:travel_checklist/services/PreferencesManager.dart';
import 'package:travel_checklist/enums.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();

  static final stringSaved = 'Salvo com sucesso!';

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    Map<String, Map<String, dynamic>> settings = PreferencesManager.instance.settings;
    for (String id in settings.keys) {
      Map<String, dynamic> setting = settings[id];
      switch (setting['type']) {
        case Setting.Switch:
          widgets.add(SwitchListTile(
            onChanged: (bool value) async {
              await setting['save'](value);
              SnackBar snackBar = SnackBar(content: Text(stringSaved));
              _scaffold.currentState.showSnackBar(snackBar);
              setState(() {});
            },
            title: Text(setting['name']),
            value: setting['value'],
          ));
          break;
      }
    }
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: Container(
        child: ListView(
          children: widgets,
        ),
      ),
    );
  }
}