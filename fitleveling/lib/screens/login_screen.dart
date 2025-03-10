import 'package:flutter/material.dart';
import '../main.dart';
import 'package:fitleveling/l10n/app_localizations.dart';

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

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void validateAndSubmit() {
    final AppLocalizations t = AppLocalizations.of(context)!;
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showErrorDialog(t.emptyFields);
      return;
    }

    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}").hasMatch(email)) {
      showErrorDialog(t.invalidEmail);
      return;
    }

    if (password.length < 8) {
      showErrorDialog(t.shortPassword);
      return;
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color.fromARGB(230, 255, 255, 255),
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
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF221426), 
                    Color(0xFF1D1340),
                  ],
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
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/logo.png', height: 100),
                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                TextField(
                                  focusNode: emailFocusNode,
                                  controller: emailController,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    hintText: t.email,
                                    prefixIcon: const Icon(
                                      Icons.email,
                                      color: Colors.white70,
                                    ),
                                    filled: true,
                                    fillColor: Colors.black26,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintStyle: const TextStyle(color: Colors.white70),
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                  onEditingComplete:
                                      () => FocusScope.of(context).requestFocus(passwordFocusNode),
                                ),
                                const SizedBox(height: 20),
                                TextField(
                                  focusNode: passwordFocusNode,
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: t.password,
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: Colors.white70,
                                    ),
                                    filled: true,
                                    fillColor: Colors.black26,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintStyle: const TextStyle(color: Colors.white70),
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 30),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF445EF2),
                                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    minimumSize: const Size(180, 50),
                                  ),
                                  onPressed: validateAndSubmit,
                                  child: Text(
                                    t.login,
                                    style: const TextStyle(fontSize: 18, color: Colors.white),
                                  ),
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
          ),
        ],
      ),
    );
  }
}
