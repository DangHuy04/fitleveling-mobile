import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static const String baseUrl = "http://localhost:5000";

  // Đăng nhập
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return responseData; // Trả về token nếu đăng nhập thành công
      } else {
        return {
          "message": responseData["message"] ?? "Đăng nhập thất bại"
        }; // Chỉ lấy `message`
      }
    } catch (e) {
      return {"message": "Không thể kết nối đến máy chủ"};
    }
  }

  // Đăng ký
  Future<Map<String, dynamic>> register(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return responseData;
      } else {
        return {
          "message": responseData["message"] ?? "Đăng ký thất bại"
        };
      }
    } catch (e) {
      return {"message": "Không thể kết nối đến máy chủ"};
    }
  }
}
