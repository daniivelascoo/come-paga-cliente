import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';

class CookieConfig {

  static final jar = CookieJar();

  static Future<List<Cookie>> getCookies(Uri request) async {
    var cookies =
        await jar.loadForRequest(request);

    return cookies;
  }
}
