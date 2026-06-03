import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static String get baseUrl {
    if (kIsWeb) {
      return 'https://localhost:7065/api';
    }

    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5117/api';
    }

    return 'https://localhost:7065/api';
  }

  static Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Users/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "email": email.trim(),
          "password": password.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is Map<String, dynamic>) {
          return data;
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Users'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "fullName": fullName.trim(),
        "email": email.trim(),
        "password": password.trim(),
        "phoneNumber": "",
        "address": "",
        "gender": "",
        "dateOfBirth": "",
        "profileImage": "assets/images/profile.jpg"
      }),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  static Future<bool> updateUser({
    required int userId,
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required String address,
    required String gender,
    required String dateOfBirth,
    required String profileImage,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/Users/$userId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "userId": userId,
        "fullName": fullName.trim(),
        "email": email.trim(),
        "password": password.trim(),
        "phoneNumber": phoneNumber.trim(),
        "address": address.trim(),
        "gender": gender.trim(),
        "dateOfBirth": dateOfBirth.trim(),
        "profileImage": profileImage.trim(),
      }),
    );

    print('UPDATE USER STATUS: ${response.statusCode}');
    print('UPDATE USER BODY: ${response.body}');

    return response.statusCode == 200 || response.statusCode == 204;
  }

  static Future<List<dynamic>> getDoctors() async {
    final response = await http.get(
      Uri.parse('$baseUrl/Doctors'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to load doctors');
  }

  static Future<dynamic> getDoctorById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/Doctors/$id'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to load doctor');
  }

  static Future<void> bookAppointment({
    required int patientId,
    required int doctorId,
    required DateTime appointmentDate,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Appointments'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "patientId": patientId,
        "doctorId": doctorId,
        "appointmentDate": appointmentDate.toIso8601String(),
        "status": "Pending"
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to book appointment');
    }
  }

  static Future<List<dynamic>> getAppointments() async {
    final response = await http.get(
      Uri.parse('$baseUrl/Appointments'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to load appointments');
  }

  static Future<int> getAppointmentCountByUser(int patientId) async {
    final appointments = await getAppointments();

    return appointments.where((appointment) {
      return appointment['patientId'].toString() == patientId.toString();
    }).length;
  }

  static Future<void> deleteAppointment(int appointmentId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/Appointments/$appointmentId'),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete appointment');
    }
  }
}