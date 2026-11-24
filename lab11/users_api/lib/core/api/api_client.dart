import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../storage/secure_store.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient(
    this._client,
    this._store, {
    this.host = 'jsonplaceholder.typicode.com',
  });

  final http.Client _client;
  final SecureStore _store;
  final String host;

  Future<Map<String, String>> _headers() async {
    return {
      'Accept': 'application/json',
      if (await _store.readToken() case final t?) 'Authorization': 'Bearer $t',
    };
  }

  Uri uri(String path, [Map<String, String>? query]) {
    return Uri.https(host, path, query);
  }

  Future<http.Response> _send(Future<http.Response> Function() call) async {
    try {
      final response = await call().timeout(const Duration(seconds: 10));

      if (kDebugMode) {
        log(
          '${response.request?.method} '
          '${response.request?.url} '
          '${response.statusCode}',
        );
      }

      return response;
    } on SocketException {
      throw const NoConnectionException();
    } on TimeoutException {
      throw const NoConnectionException();
    } on http.ClientException {
      throw const NoConnectionException();
    }
  }

  void _check(http.Response response) {
    final status = response.statusCode;

    if (status == 401) {
      throw const UnauthorizedException();
    }

    if (status == 404) {
      throw const NotFoundException();
    }

    if (status >= 500) {
      throw ServerException(status);
    }

    if (status >= 400) {
      throw BadResponseException('HTTP $status');
    }
  }

  dynamic _decode(http.Response response) {
    try {
      return jsonDecode(response.body);
    } on FormatException {
      throw const BadResponseException('Invalid JSON');
    }
  }

  Future<dynamic> get(String path, {Map<String, String>? query}) async {
    final headers = await _headers();

    final response = await _send(
      () => _client.get(uri(path, query), headers: headers),
    );

    _check(response);

    return _decode(response);
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final headers = await _headers();

    final response = await _send(
      () => _client.post(
        uri(path),
        headers: {...headers, 'Content-Type': 'application/json'},
        body: jsonEncode(body),
      ),
    );

    _check(response);

    if (response.statusCode != 201) {
      throw const BadResponseException('Expected HTTP 201');
    }

    return _decode(response);
  }

  void close() {
    _client.close();
  }
}
