import 'dart:convert';
import 'dart:io';
import 'package:comepaga/model/jsorn_serializer.dart';
import 'package:comepaga/utils/cookie_config.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

import 'package:http/io_client.dart';

class CallService<T extends JsonSerializer> {
  late String baseUrl;
  final String uri;
  late String url;
  final T Function(Map<String, dynamic>) fromJson;

  CallService({required this.uri, required this.fromJson}) {
    this.baseUrl = "https://172.16.131.66:8080/come-paga/";
    this.url = baseUrl + uri;
  }

  Future<String> getCertificate() async {
    ByteData data =
        await rootBundle.load('assets/certificates/cert-come-paga.p12');
    Uint8List certBytes = data.buffer.asUint8List();

    return base64Encode(certBytes);
  }

  Future<T?> get(Map<String, dynamic>? filter, String? url) async {
    String finalUrl = this.url + (url ?? '');

    List<Cookie> cookies =
        await CookieConfig.getCookies(Uri.parse(this.baseUrl));

    final httpClient = IOClient(
      HttpClient()
        ..badCertificateCallback = (
          X509Certificate cert,
          String host,
          int port,
        ) =>
            true,
    );

    final response = await httpClient.get(Uri.parse(finalUrl), headers: {
      'Content-Type': 'application/json',
      'Cookie':
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; '),
      'X-Client-Certificate': await getCertificate(),
    });

    httpClient.close();

    String responseBody = response.body;

    if (responseBody.isEmpty) return null;
    return fromJson(jsonDecode(responseBody));
  }

  Future<T?> put<E extends JsonSerializer>(String? url, E body,
      [T? body_]) async {
    var finalBody = body_ ?? body;
    String finalUrl = this.url + (url ?? '');
    List<Cookie> cookies =
        await CookieConfig.getCookies(Uri.parse(this.baseUrl));

    final httpClient = IOClient(
      HttpClient()
        ..badCertificateCallback = (
          X509Certificate cert,
          String host,
          int port,
        ) =>
            true,
    );

    final response = await httpClient.put(Uri.parse(finalUrl),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': cookies
              .map((cookie) => '${cookie.name}=${cookie.value}')
              .join('; '),
          'X-Client-Certificate': await getCertificate(),
        },
        body: jsonEncode(finalBody.toJson()));

    httpClient.close();

    String responseBody = response.body;

    if (response.statusCode == 403) return null;
    if (responseBody.isEmpty) return null;
    return fromJson(jsonDecode(responseBody));
  }

  Future<T?> post(Map<String, dynamic>? filter, T body, String? url) async {
    List<Cookie> cookies =
        await CookieConfig.getCookies(Uri.parse(this.baseUrl));

    final httpClient = IOClient(
      HttpClient()
        ..badCertificateCallback = (
          X509Certificate cert,
          String host,
          int port,
        ) =>
            true,
    );

    String finalUrl = this.url + (url ?? '');

    final response = await httpClient.post(Uri.parse(finalUrl),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': cookies
              .map((cookie) => '${cookie.name}=${cookie.value}')
              .join('; '),
          'X-Client-Certificate': await getCertificate(),
        },
        body: jsonEncode(body.toJson()));

    httpClient.close();

    String responseBody = response.body;

    if (response.statusCode == 403) return null;
    if (responseBody.isEmpty) return null;
    return fromJson(jsonDecode(responseBody));
  }

  Future<List<T>> getAll(Map<String, String?>? filter, String? url) async {
    String finalUrl = this.url + (url ?? '');

    final httpClient = IOClient(
      HttpClient()
        ..badCertificateCallback = (
          X509Certificate cert,
          String host,
          int port,
        ) =>
            true,
    );

    List<Cookie> cookies =
        await CookieConfig.getCookies(Uri.parse(this.baseUrl));

    if (filter != null) {
      finalUrl =
          Uri.parse(finalUrl).replace(queryParameters: filter).toString();
    }

    final response = await httpClient.get(Uri.parse(finalUrl), headers: {
      'Content-Type': 'application/json',
      'X-Client-Certificate': await getCertificate(),
      'Cookie':
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; '),
    });

    httpClient.close();

    String responseBody = response.body;

    if (response.statusCode >= 400) return [];
    if (responseBody.isEmpty) return [];

    List<dynamic> list = json.decode(responseBody);
    List<T> finalResponse = list.map<T>((e) => fromJson(e)).toList();
    return finalResponse;
  }

  Future<T?> login(String? url, Map<String, dynamic> parts) async {
    String finalUrl = this.url + (url ?? '');

    final httpClient = IOClient(
      HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true,
    );

    final request = http.MultipartRequest('POST', Uri.parse(finalUrl));

    List<Cookie> cookiesToSend =
        await CookieConfig.getCookies(Uri.parse(this.baseUrl));

    request.headers['Cookie'] = cookiesToSend
        .map((cookie) => '${cookie.name}=${cookie.value}')
        .join('; ');
    request.headers['X-Client-Certificate'] = await getCertificate();

    parts.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    final response =
        await httpClient.send(request).timeout(const Duration(seconds: 60));

    List<Cookie> cookies =
        await CookieConfig.getCookies(Uri.parse(this.baseUrl));

    if (cookies.isEmpty) {
      var cookieHeaders = response.headers['set-cookie'];

      if (cookieHeaders == null) return null;
      var cookie = Cookie.fromSetCookieValue(cookieHeaders);
      var cookiesList = <Cookie>[];
      cookiesList.add(cookie);
      CookieConfig.jar.saveFromResponse(Uri.parse(this.baseUrl), cookiesList);
    }

    String responseBody = await response.stream.transform(utf8.decoder).join();

    if (response.statusCode >= 400) return null;
    if (responseBody.isEmpty) return null;

    Map<String, dynamic> bodyMap = json.decode(responseBody);

    return fromJson(bodyMap);
  }

  Future<T?> createWithCookie(String? url, T body) async {
    String finalUrl = this.url + (url ?? '');

    final httpClient = IOClient(
      HttpClient()
        ..badCertificateCallback = (
          X509Certificate cert,
          String host,
          int port,
        ) =>
            true,
    );

    List<Cookie> cookiesToSend =
        await CookieConfig.getCookies(Uri.parse(this.baseUrl));

    final response = await httpClient.post(Uri.parse(finalUrl),
        headers: {
          'Content-Type': 'application/json',
          'X-Client-Certificate': await getCertificate(),
          'Cookie': cookiesToSend
              .map((cookie) => '${cookie.name}=${cookie.value}')
              .join('; '),
        },
        body: jsonEncode(body.toJson()));

    httpClient.close();

    String responseBody = response.body;

    if (response.statusCode >= 400) return null;
    if (responseBody.isEmpty) return null;

    return fromJson(jsonDecode(responseBody));
  }

  Future<T?> postMultiPart(String? url, Map<String, dynamic> parts,
      [MultipartFile? file]) async {
    String finalUrl = this.url + (url ?? '');

    final httpClient = IOClient(
      HttpClient()
        ..badCertificateCallback = (
          X509Certificate cert,
          String host,
          int port,
        ) =>
            true,
    );

    List<Cookie> cookiesToSend =
        await CookieConfig.getCookies(Uri.parse(this.baseUrl));

    final request = http.MultipartRequest('POST', Uri.parse(finalUrl));
    request.headers['X-Client-Certificate'] = await getCertificate();
    request.headers['Cookie'] = cookiesToSend
        .map((cookie) => '${cookie.name}=${cookie.value}')
        .join('; ');

    parts.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    if (file != null) {
      request.files.add(await http.MultipartFile.fromBytes(
          'file', await file.finalize().toBytes(),
          filename: file.filename));
    }

    final response = await httpClient.send(request);

    if (response.statusCode >= 400) return null;

    String responseBody = await response.stream.transform(utf8.decoder).join();

    if (responseBody.isEmpty) return null;

    return fromJson(jsonDecode(responseBody));
  }

  Future<List<int>?> getFile(String? url,
      [Map<String, dynamic>? values]) async {
    String finalUrl = this.url + (url ?? '');

    final httpClient = IOClient(
      HttpClient()
        ..badCertificateCallback = (
          X509Certificate cert,
          String host,
          int port,
        ) =>
            true,
    );

    final response = await httpClient.get(Uri.parse(finalUrl), headers: {
      'X-Client-Certificate': await getCertificate(),
    });

    httpClient.close();

    if (response.statusCode >= 400) return null;

    List<int> bodyBytes = response.bodyBytes;

    return bodyBytes;
  }

  Future<void> delete(String? url) async {
    String finalUrl = this.url + (url ?? '');

    final httpClient = IOClient(
      HttpClient()
        ..badCertificateCallback = (
          X509Certificate cert,
          String host,
          int port,
        ) =>
            true,
    );

    final response = await httpClient.delete(Uri.parse(finalUrl), headers: {
      'X-Client-Certificate': await getCertificate(),
    });

    httpClient.close();
  }
}
