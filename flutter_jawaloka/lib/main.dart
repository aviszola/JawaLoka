import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'features/splash/presentation/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const JawaLokaApp());
}

/// Root widget for JawaLoka: Aplikasi Belajar Bahasa & Aksara Jawa.
class JawaLokaApp extends StatelessWidget {
  const JawaLokaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JawaLoka',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
