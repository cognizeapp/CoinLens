import 'dart:convert';

import 'package:http/http.dart' as http;

import '../error/failure.dart';

/// Thin JSON/multipart client for the CoinLens backend (Cloud Functions / API
/// gateway). The backend holds every secret — AI provider keys, catalog and
/// pricing data sources — so the client only ever sends images and structured
/// data and receives structured results.
class ApiClient {
  ApiClient({required this.baseUrl, http.Client? client, this.authToken})
      : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  /// Firebase ID token, injected per request once auth is wired.
  String? authToken;

  Map<String, String> get _headers => {
        'content-type': 'application/json',
        if (authToken != null) 'authorization': 'Bearer $authToken',
      };

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Future<Map<String, dynamic>> postJson(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      final res = await _client
          .post(_uri(path), headers: _headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 25));
      return _decode(res);
    } on Failure {
      rethrow;
    } catch (e) {
      throw _translate(e);
    }
  }

  Future<Map<String, dynamic>> postImages(
    String path, {
    required List<int> front,
    List<int>? back,
    Map<String, String> fields = const {},
  }) async {
    try {
      final request = http.MultipartRequest('POST', _uri(path))
        ..headers.addAll({if (authToken != null) 'authorization': 'Bearer $authToken'})
        ..fields.addAll(fields)
        ..files.add(http.MultipartFile.fromBytes('front', front,
            filename: 'front.jpg'));
      if (back != null) {
        request.files.add(
            http.MultipartFile.fromBytes('back', back, filename: 'back.jpg'));
      }
      final streamed = await request.send().timeout(const Duration(seconds: 40));
      final res = await http.Response.fromStream(streamed);
      return _decode(res);
    } on Failure {
      rethrow;
    } catch (e) {
      throw _translate(e);
    }
  }

  Map<String, dynamic> _decode(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final decoded = jsonDecode(res.body);
      if (decoded is Map<String, dynamic>) return decoded;
      return {'data': decoded};
    }
    if (res.statusCode == 401 || res.statusCode == 403) {
      throw const AuthFailure('Your session expired. Please sign in again.');
    }
    if (res.statusCode == 404) {
      throw const NotFoundFailure('The server could not find a match.');
    }
    throw const ServerFailure();
  }

  Failure _translate(Object e) {
    final s = e.toString().toLowerCase();
    if (s.contains('socket') ||
        s.contains('failed host lookup') ||
        s.contains('timeout') ||
        s.contains('connection')) {
      return const NetworkFailure();
    }
    return UnknownFailure(cause: e);
  }

  void dispose() => _client.close();
}
