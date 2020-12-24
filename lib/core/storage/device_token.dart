class DeviceToken {
  static String token = '';

  static void setup(String dtoken) {
    token = dtoken;
  }

  get deviceToken => token;
}
