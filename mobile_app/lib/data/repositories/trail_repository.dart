import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/trail_model.dart';

class TrailRepository {
  String get baseUrl {
    if (kIsWeb) return 'http://localhost:3000/api';
    if (Platform.isAndroid) return 'http://10.0.2.2:3000/api';
    return 'http://localhost:3000/api';
  }

  Future<List<TrailModel>> fetchTrails({String filter = 'all', String search = ''}) async {
    final uri = Uri.parse('$baseUrl/trails?filter=$filter&search=$search');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => TrailModel.fromJson(json)).toList();
    } else {
      throw Exception('Ошибка сервера: ${response.statusCode}');
    }
  }

  Future<void> addTrail(String name, int altitude, String difficulty, String notes) async {
    final response = await http.post(
      Uri.parse('$baseUrl/trails'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'altitude': altitude,
        'difficulty': difficulty,
        'notes': notes,
      }),
    );
    if (response.statusCode != 201) throw Exception('Не удалось добавить маршрут');
  }

  Future<void> toggleTrailStatus(String id) async {
    final response = await http.patch(Uri.parse('$baseUrl/trails/$id/toggle'));
    if (response.statusCode != 200) throw Exception('Ошибка обновления статуса');
  }

  Future<void> deleteTrail(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/trails/$id'));
    if (response.statusCode != 204) throw Exception('Ошибка удаления');
  }
}