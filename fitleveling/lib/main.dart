import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'providers/pet_provider.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => PetProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0xFF2A2D3E),
        textTheme: Theme.of(
          context,
        ).textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white),
        useMaterial3: true,
      ),
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('vi', ''), // Vietnamese
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/home',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
      home: const AssetPreloader(child: HomeScreen()),
    );
  }
}

// Widget để tải trước tất cả tài nguyên
class AssetPreloader extends StatefulWidget {
  final Widget child;

  const AssetPreloader({super.key, required this.child});

  @override
  State<AssetPreloader> createState() => _AssetPreloaderState();
}

class _AssetPreloaderState extends State<AssetPreloader> {
  bool _assetsLoaded = false;

  @override
  void initState() {
    super.initState();
    _preloadAssets();
  }

  // Tải trước tất cả tài nguyên
  Future<void> _preloadAssets() async {
    try {
      // Hiển thị preloader trong 1 giây tối thiểu để người dùng có thể nhìn thấy
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _assetsLoaded = true;
      });
    } catch (e) {
      print('DEBUG - Lỗi khi tải trước tài nguyên: $e');
      setState(() {
        _assetsLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_assetsLoaded) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', width: 150, height: 150),
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              const Text('Đang tải dữ liệu...', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      );
    }

    return widget.child;
  }
}
