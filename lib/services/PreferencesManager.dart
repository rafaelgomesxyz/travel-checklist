import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_checklist/enums.dart';

class PreferencesManager {
  static final settingRemovePastTrips = 'remove_past_trips';

  PreferencesManager._privateConstructor(); // Singleton
  static final PreferencesManager instance = PreferencesManager._privateConstructor();
  static SharedPreferences _prefs;
  static Map<String, Map<String, dynamic>> _settings;

  Future<SharedPreferences> get prefs async {
    if (_prefs != null) {
      return _prefs;
    }
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  Map<String, Map<String, dynamic>> get settings => _settings;

  Future init() async {
    SharedPreferences pf = await instance.prefs;
    _settings = {
      settingRemovePastTrips: {
        'type': Setting.Switch,
        'name': 'Automaticamente deletar viagens passadas.',
        'value': pf.getBool(settingRemovePastTrips) ?? false,
        'save': (bool value) async {
          await pf.setBool(settingRemovePastTrips, value);
          _settings[settingRemovePastTrips]['value'] = value;
        },
      },
    };
  }
}