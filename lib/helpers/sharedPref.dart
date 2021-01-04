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

  int get highlightHour => _sharedPrefs.getInt(keyHighlightHour) ?? 6;

  set highlightHour(int value) {
    _sharedPrefs.setInt(keyHighlightHour, value);
  }

  int get highlightMinute => _sharedPrefs.getInt(keyHighlightMinute) ?? 0;

  set highlightMinute(int value) {
    _sharedPrefs.setInt(keyHighlightMinute, value);
  }

  String get highlightTime => _sharedPrefs.getString(keyHighlightTime) ?? "";

  set highlightTime(String value) {
    _sharedPrefs.setString(keyHighlightTime, value);
  }

  bool get notificationStatus =>
      _sharedPrefs.getBool(keyNotificationStatus) ?? true;

  set notificationStatus(bool value) {
    _sharedPrefs.setBool(keyNotificationStatus, value);
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

  String get about => _sharedPrefs.getString(keyAbout) ?? "";

  set about(String value) {
    _sharedPrefs.setString(keyAbout, value);
  }

  String get dateNow => _sharedPrefs.getString(keyDateNow) ?? "";

  set dateNow(String value) {
    _sharedPrefs.setString(keyDateNow, value);
  }

  String get surprisingImage =>
      _sharedPrefs.getString(keySurprisingImage) ?? "1.jpg";

  set surprisingImage(String value) {
    _sharedPrefs.setString(keySurprisingImage, value);
  }

  bool get doneHighlight => _sharedPrefs.getBool(keyDoneHighlight) ?? false;

  set doneHighlight(bool value) {
    _sharedPrefs.setBool(keyDoneHighlight, value);
  }

  bool get doneOthers => _sharedPrefs.getBool(keyDoneOthers) ?? false;

  set doneOthers(bool value) {
    _sharedPrefs.setBool(keyDoneOthers, value);
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
const String keyAbout = "about";
const String keyDateNow = "dateNow";
const String keySurprisingImage = "surprisingImage";
const String keyDoneHighlight = "doneHighlight";
const String keyDoneOthers = "doneOthers";
const String keyNotificationStatus = "enable";
const String keyHighlightTime = null;
const String keyHighlightHour = "hour";
const String keyHighlightMinute = "minute";
