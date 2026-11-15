import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../models/post.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  static const Duration _timeout = Duration(seconds: 10);

  // Mengambil daftar pengguna dengan timeout yang dapat diatur
  Future<List<User>> getUsers({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/users'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception(
          'Gagal mengambil data pengguna: ${response.statusCode}',
        );
      }
    } on TimeoutException {
      throw Exception('Request timeout. Coba lagi.');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet.');
    } on FormatException {
      throw Exception('Format data tidak valid.');
    }
  }

  // Mengambil detail pengguna berdasarkan ID
  Future<User> getUserById(int id) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/users/$id'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception('Gagal mengambil detail pengguna.');
      }
    } on TimeoutException {
      throw Exception('Request timeout. Coba lagi.');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet.');
    } on FormatException {
      throw Exception('Format data tidak valid.');
    }
  }

  // Simulasi proses login
  Future<String> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.isNotEmpty && password.isNotEmpty) {
      final token = 'dummy_token_${DateTime.now().millisecondsSinceEpoch}';

      print('Login berhasil');
      return token;
    }

    throw Exception('Email dan password tidak boleh kosong.');
  }

  // Mengambil daftar postingan
  Future<List<Post>> getPosts() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/posts'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception(
          'Gagal mengambil data postingan: ${response.statusCode}',
        );
      }
    } on TimeoutException {
      throw Exception('Request timeout. Coba lagi.');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet.');
    } on FormatException {
      throw Exception('Format data tidak valid.');
    }
  }
}
