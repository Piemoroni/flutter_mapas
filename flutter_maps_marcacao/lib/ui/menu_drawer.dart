import 'package:flutter/material.dart';
import '../main.dart';
import 'rota.dart';
import 'splash.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = MyApp.of(context);
    final isDark = appState?.isDarkMode ?? false;

    return Drawer(
      child: Container(
        color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFF8E1),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Cabeçalho com o ícone de assets/icone.png
            DrawerHeader(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF212121) : const Color(0xFF5D4037),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icone.png',
                    height: 50,
                    width: 50,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.map,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              title: const Text(
                'Traçar Rotas',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const RotaScreen()),
                );
              },
            ),

            const Divider(height: 1),

            // Item: Splash (Abre a tela inicial de Splash)
            ListTile(
              title: const Text(
                'Splash',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Splash()),
                );
              },
            ),

            const Divider(height: 1),

            SwitchListTile(
              title: const Text(
                'Tema Escuro',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              value: isDark,
              onChanged: (bool value) {
                appState?.toggleTheme(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}