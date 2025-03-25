import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'package:fitleveling/l10n/app_localizations.dart';
import 'signup_screen.dart';
import '../services/auth_service.dart';
import '../providers/user_provider.dart';
import '../providers/pet_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Đảm bảo widget được rebuild khi ngôn ngữ thay đổi
    final AppLocalizations? t = AppLocalizations.of(context);
    if (t == null) return;
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void validateAndSubmit() async {
    if (!mounted) return; // Kiểm tra widget có còn mounted không

    final AppLocalizations? t = AppLocalizations.of(context);
    if (t == null) return;

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      if (mounted) showErrorDialog(t.emptyFields);
      return;
    }

    if (!RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}",
    ).hasMatch(email)) {
      if (mounted) showErrorDialog(t.invalidEmail);
      return;
    }

    if (password.length < 8) {
      if (mounted) showErrorDialog(t.shortPassword);
      return;
    }

    if (_isLoading) return; 
    setState(() => _isLoading = true);
    
    try {
      final authService = AuthService();
      final response = await authService.login(
        email,
        password,
        MyApp.of(context)?.locale.languageCode ?? 'en',
      );

      if (!mounted) return;

      if (response['success'] == true) {
        // Kiểm tra xem có ID không
        if (!response.containsKey('id')) {
          showErrorDialog('Lỗi: Không thể lấy thông tin user. Vui lòng thử lại sau.');
          return;
        }

        final userId = response['id'];

        // Lưu thông tin user
        try {
          context.read<UserProvider>().setUserData(
            id: userId,
            fullName: response['fullName'] ?? '',
            email: response['email'] ?? '',
            avatar: response['avatar'] ?? '',
          );

          // Load pets của user
          await context.read<PetProvider>().loadPets(userId);

          if (!mounted) return;
          Navigator.of(context).pushReplacementNamed('/home');
        } catch (e) {
          showErrorDialog('Lỗi: Không thể xử lý thông tin user. Vui lòng thử lại sau.');
        }
      } else {
        showErrorDialog(response['message'] ?? t.loginFailed);
      }
    } catch (e) {
      if (mounted) showErrorDialog('Lỗi: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final AppLocalizations? t = AppLocalizations.of(context);
        return AlertDialog(
          title: Text(
            t?.error ?? 'Error !',
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          content: Text(message, style: const TextStyle(color: Colors.black87)),
          backgroundColor: Colors.white,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(t?.ok ?? 'OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _socialLoginButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return IconButton(
      icon: Icon(icon, color: color, size: 30),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? t = AppLocalizations.of(context);
    if (t == null) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF281B30), Color(0xFF1D1340)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                PopupMenuButton<Locale>(
                  icon: const Icon(Icons.language, color: Colors.white),
                  onSelected: (Locale newLocale) {
                    MyApp.of(context)?.setLocale(newLocale);
                  },
                  itemBuilder:
                      (context) => [
                        const PopupMenuItem(
                          value: Locale('en', ''),
                          child: Text('🇺🇸 English'),
                        ),
                        const PopupMenuItem(
                          value: Locale('vi', ''),
                          child: Text('🇻🇳 Tiếng Việt'),
                        ),
                      ],
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Image.asset('assets/logo.png', height: 150),
                    const SizedBox(height: 15),
              
                    Text(
                      t.welcomeToFitleveling,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 60),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: t.email,
                              prefixIcon: const Icon(
                                Icons.email,
                                color: Colors.white70,
                              ),
                              filled: true, // Thêm thuộc tính filled
                              fillColor: Colors.white10, // Thêm màu nền
                              border: OutlineInputBorder(
                                // Thêm viền có bo góc
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              hintStyle: const TextStyle(color: Colors.white70),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              hintText: t.password,
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.white70,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white70,
                                ),
                                onPressed:
                                    () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    ),
                              ),
                              filled: true,
                              fillColor: Colors.white10,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              hintStyle: const TextStyle(color: Colors.white70),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                          
                          // Thêm nút "Quên mật khẩu?"
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
        
                              },
                              child: Text(
                                t.forgotPassword, // Dùng chuỗi cứng thay vì t.forgotPassword
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF9F43),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              minimumSize: const Size(180, 50),
                            ),
                            onPressed: _isLoading ? null : validateAndSubmit,
                            child:
                                _isLoading
                                    ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : Text(
                                      t.login,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                          ),
                          
                          const SizedBox(height: 25),

                          // Thêm dòng phân cách với text
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  color: Colors.white30,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                        t.orLoginWith,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                ),
                              ),
                              const Expanded(
                                child: Divider(
                                  color: Colors.white30,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _socialLoginButton(
                                icon: Icons.g_mobiledata,
                                color: Colors.red,
                                onPressed: () {},
                              ),
                              _socialLoginButton(
                                icon: Icons.facebook,
                                color: Colors.blue,
                                onPressed: () {},
                              ),
                              _socialLoginButton(
                                icon: Icons.apple,
                                color: Colors.white,
                                onPressed: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                t.alreadyHaveAccount,
                                style: const TextStyle(color: Colors.white70),
                              ),
                              GestureDetector(
                                onTap:
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const SignupScreen(),
                                      ),
                                    ),
                                child: Text(
                                  t.signUpNow, 
                                  style: const TextStyle(
                                    color: Color(0xFFFF9F43),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}