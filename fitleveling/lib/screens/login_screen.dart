import 'package:flutter/material.dart';
import '../main.dart';
import 'package:fitleveling/l10n/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("FitLeveling"),
        backgroundColor: Colors.black,
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: [Colors.blue, Colors.green, Colors.yellow, Colors.red],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: const Text(
                "FitLeveling",
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              minimumSize: const Size(180, 50),
            ),
            onPressed: () {},
            child: Text(
              t.login,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              minimumSize: const Size(180, 50),
            ),
            onPressed: () {},
            child: Text(
              t.signUp,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
