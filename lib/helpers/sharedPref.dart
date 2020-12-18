import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences _sharedPrefs;

  init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }

  String get username => _sharedPrefs.getString(keyUsername) ?? "";

  set username(String value) {
    _sharedPrefs.setString(keyUsername, value);
  }

  String get name => _sharedPrefs.getString(keyName) ?? "";

  set name(String value) {
    _sharedPrefs.setString(keyName, value);
  }

  String get idUser => _sharedPrefs.getString(keyIdUser) ?? "";

  set idUser(String value) {
    _sharedPrefs.setString(keyIdUser, value);
  }

  String get email => _sharedPrefs.getString(keyEmail) ?? "";

  set email(String value) {
    _sharedPrefs.setString(keyEmail, value);
  }

  String get photo => _sharedPrefs.getString(keyPhoto) ?? "";

  set photo(String value) {
    _sharedPrefs.setString(keyPhoto, value);
  }

  clear() {
    _sharedPrefs.clear();
  }
}

final sharedPrefs = SharedPrefs();
// constants/strings.dart
const String keyUsername = "username";
const String keyName = "name";
const String keyIdUser = "idUser";
const String keyEmail = "email";
const String keyPhoto = "urlPhoto";