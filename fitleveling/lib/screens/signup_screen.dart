import 'package:fitleveling/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'package:fitleveling/l10n/app_localizations.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final FocusNode fullNameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _acceptTerms = false;

  @override
  void dispose() {
    fullNameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void validateAndSubmit() async {
    final AppLocalizations t = AppLocalizations.of(context)!;
    String fullName = fullNameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    // Kiểm tra các trường không được để trống
    if (fullName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showErrorDialog(t.emptyFields);
      return;
    }

    // Kiểm tra email hợp lệ
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email)) {
      showErrorDialog(t.invalidEmail);
      return;
    }

    // Kiểm tra độ dài mật khẩu
    if (password.length < 8) {
      showErrorDialog(t.shortPassword);
      return;
    }

    // Kiểm tra mật khẩu khớp nhau
    if (password != confirmPassword) {
      showErrorDialog(t.passwordMismatch); 
      return;
    }

    // Kiểm tra đã đồng ý điều khoản
    if (!_acceptTerms) {
      showErrorDialog(t.termsRequired);
      return;
    }

    // Thêm trạng thái loading và xử lý đăng ký
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = AuthService();
      final response = await authService.register(fullName, email, password, MyApp.of(context)?.locale.languageCode ?? 'en');

      if(!mounted) return;
      
      if (response['success'] == true) {
        // Hiển thị thông báo thành công trước khi pop
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        
        // Đảm bảo Navigator.pop() chạy sau khi hiển thị SnackBar
        Future.delayed(Duration.zero, () {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(t.registerSuccess), 
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          
          Navigator.pop(context);
        });
      } 
      else {
        showErrorDialog(response['message'] ?? "Register failed");
      }
    } 
    catch (e) {
      if (mounted) showErrorDialog("Dăng ký thất bại: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color.fromARGB(230, 255, 255, 255),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF281B30),
              Color(0xFF1D1340),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // AppBar với nút đổi ngôn ngữ và nút quay lại
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                PopupMenuButton<Locale>(
                  icon: const Icon(Icons.language, color: Colors.white),
                  onSelected: (Locale newLocale) {
                    MyApp.of(context)?.setLocale(newLocale);
                  },
                  itemBuilder: (BuildContext context) => [
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

            // Nội dung chính
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Image.asset('assets/logo.png', height: 100),

                    const SizedBox(height: 10),
                    Text(
                      t.createNewAccount, 
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 6,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          // Trường nhập họ tên
                          TextField(
                            controller: fullNameController,
                            focusNode: fullNameFocusNode,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.name,
                            onSubmitted: (_) => FocusScope.of(context).requestFocus(emailFocusNode),
                            decoration: InputDecoration(
                              hintText: t.fullName, 
                              prefixIcon: const Icon(Icons.person, color: Colors.white70),
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
                          const SizedBox(height: 15),

                          // Trường nhập email
                          TextField(
                            controller: emailController,
                            focusNode: emailFocusNode,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            onSubmitted: (_) => FocusScope.of(context).requestFocus(passwordFocusNode),
                            decoration: InputDecoration(
                              hintText: t.email,
                              prefixIcon: const Icon(Icons.email, color: Colors.white70),
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
                          const SizedBox(height: 15),

                          // Trường nhập mật khẩu
                          TextField(
                            controller: passwordController,
                            focusNode: passwordFocusNode,
                            textInputAction: TextInputAction.next,
                            obscureText: _obscurePassword,
                            onSubmitted: (_) => FocusScope.of(context).requestFocus(confirmPasswordFocusNode),
                            decoration: InputDecoration(
                              hintText: t.password,
                              prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.white70,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
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
                          const SizedBox(height: 15),

                          // Trường nhập xác nhận mật khẩu
                          TextField(
                            controller: confirmPasswordController,
                            focusNode: confirmPasswordFocusNode,
                            obscureText: _obscureConfirmPassword,
                            decoration: InputDecoration(
                              hintText: t.confirmPassword, 
                              prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.white70,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
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
                          const SizedBox(height: 15),

                          // Checkbox đồng ý điều khoản
                          Row(
                            children: [
                              Checkbox(
                                value: _acceptTerms,
                                onChanged: (value) {
                                  setState(() {
                                    _acceptTerms = value ?? false;
                                  });
                                },
                                fillColor: WidgetStateProperty.resolveWith(
                                  (states) => states.contains(WidgetState.selected)
                                    ? const Color(0xFFFF9F43)
                                    : Colors.white30,
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _acceptTerms = !_acceptTerms;
                                    });
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      text: t.termsAgree, 
                                      style: const TextStyle(color: Colors.white70),
                                      children: [
                                        TextSpan(
                                          text: t.termsOfService,
                                          style: const TextStyle(
                                            color: Color(0xFFFF9F43),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 25),

                          // Nút đăng ký
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
                              minimumSize: const Size(double.infinity, 50),
                              shadowColor: Colors.orangeAccent,
                              elevation: 8,
                            ),
                            onPressed: _isLoading ? null : validateAndSubmit,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    t.register, 
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),

                          const SizedBox(height: 20),

                          // Nút chuyển sang Đăng nhập
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Đã có tài khoản? ", // Thay t.alreadyHaveAccount
                                style: TextStyle(color: Colors.white70),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Quay lại màn hình đăng nhập
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  t.loginNow, 
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
                    const SizedBox(height: 20),
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