import 'package:flutter/material.dart';
import 'style/theme.dart';
import 'ui/splash.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'flutter_maps_tracar_trajeto',
          theme: AppTheme.claro,
          darkTheme: AppTheme.escuro,
          themeMode: currentMode,
          home: const Splash(),
        );
      },
    );
  }
}