// Example Flutter code for connecting to your PHP API
// This is a sample Dart file showing how to integrate with your backend

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost/Alerto360/api.php'; // Adjust for your server

  // Login method
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Save token for future requests
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      return data;
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  // Register method
  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }

  // Get incidents
  static Future<List<dynamic>> getIncidents() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/incidents'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['incidents'];
    } else {
      throw Exception('Failed to load incidents: ${response.body}');
    }
  }

  // Report incident
  static Future<Map<String, dynamic>> reportIncident({
    required String type,
    required String description,
    double? latitude,
    double? longitude,
    String? imagePath,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$baseUrl/incidents'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'type': type,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'image_path': imagePath,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to report incident: ${response.body}');
    }
  }

  // Update incident status (for responders)
  static Future<Map<String, dynamic>> updateIncidentStatus(int incidentId, String status) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.put(
      Uri.parse('$baseUrl/incidents/$incidentId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'status': status,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update incident: ${response.body}');
    }
  }

  // Get responders (admin only)
  static Future<List<dynamic>> getResponders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/responders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['responders'];
    } else {
      throw Exception('Failed to load responders: ${response.body}');
    }
  }
}

// Example usage in a Flutter widget:
/*
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    try {
      final result = await ApiService.login(
        _emailController.text,
        _passwordController.text,
      );
      // Handle successful login
      print('Logged in: ${result['user']['name']}');
      // Navigate to home screen
    } catch (e) {
      // Handle login error
      print('Login failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
*/

// Dependencies to add to pubspec.yaml:
/*
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  shared_preferences: ^2.2.2
  provider: ^6.0.5  # For state management
*/