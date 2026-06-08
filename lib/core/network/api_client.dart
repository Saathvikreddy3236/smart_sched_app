import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  static const baseUrl = 'https://smart-scheduler-backend-wvvw.onrender.com';

  final http.Client _client;
  String? _accessToken;
  Map<String, dynamic>? _currentUser;

  String? get accessToken => _accessToken;
  Map<String, dynamic>? get currentUser => _currentUser;

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String role,
  }) async {
    final data = await post(
      '/api/auth/login/',
      body: {'email': email, 'password': password, 'role': role.toUpperCase()},
    );
    _accessToken = data['access'] as String?;
    _currentUser = _readUser(data);
    return data;
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String role,
    required String name,
    required int departmentId,
    String? rollNo,
    int? sectionId,
  }) {
    final normalizedRole = role.toUpperCase();
    final body = <String, dynamic>{
      'email': email,
      'password': password,
      'role': normalizedRole,
      'department_id': departmentId,
    };

    if (normalizedRole == 'STUDENT') {
      body.addAll({
        'student_name': name,
        'roll_no': rollNo,
        'section_id': sectionId,
      });
    } else {
      body['faculty_name'] = name;
    }

    return post('/api/auth/register/', body: body);
  }

  Future<Map<String, dynamic>> getMe() => get('/api/auth/me/');

  Future<List<Map<String, dynamic>>> getDepartments() async {
    final data = await get('/api/academics/departments/');
    return _readList(data);
  }

  Future<List<Map<String, dynamic>>> getSections({
    required int departmentId,
  }) async {
    final data = await get(
      '/api/academics/sections/?department_id=$departmentId',
    );
    return _readList(data);
  }

  Future<Map<String, dynamic>> get(String path) async {
    final response = await _client.get(_uri(path), headers: _headers());
    return _decode(response);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    required Map<String, dynamic> body,
  }) async {
    final response = await _client.post(
      _uri(path),
      headers: _headers(),
      body: jsonEncode(body),
    );
    return _decode(response);
  }

  void logout() {
    _accessToken = null;
    _currentUser = null;
  }

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Map<String, String> _headers() => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
  };

  Map<String, dynamic> _decode(http.Response response) {
    final decoded = response.body.isEmpty ? null : jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (decoded is Map<String, dynamic>) return decoded;
      return {'data': decoded};
    }

    throw ApiException(
      statusCode: response.statusCode,
      message: _messageFrom(decoded),
    );
  }

  Map<String, dynamic>? _readUser(Map<String, dynamic> data) {
    final user = data['user'];
    return user is Map<String, dynamic> ? user : null;
  }

  List<Map<String, dynamic>> _readList(Map<String, dynamic> data) {
    final value = data['data'];
    if (value is List) {
      return value
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    return const [];
  }

  String _messageFrom(Object? decoded) {
    if (decoded is Map) {
      for (final key in ['detail', 'message', 'error', 'non_field_errors']) {
        final value = decoded[key];
        if (value == null) continue;
        if (value is List) return value.join(', ');
        return value.toString();
      }
      return decoded.entries
          .map((entry) => '${entry.key}: ${entry.value}')
          .join('\n');
    }
    return decoded?.toString() ?? 'Request failed. Please try again.';
  }
}

class ApiException implements Exception {
  const ApiException({required this.statusCode, required this.message});

  final int statusCode;
  final String message;

  @override
  String toString() => message;
}
