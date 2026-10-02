import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../ui/linha.dart';
import '../ui/rota.dart';
import '../ui/splash.dart';
import '../style/colors.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  void _encerrarApp() {
    SystemNavigator.pop();
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.verdeEscuro,
            ),
            accountName: const Text(
              'Menu Principal',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: null,
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/icone.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.directions_car,
                    color: AppColors.verdeEscuro,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.splitscreen),
            title: const Text('Splash'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Splash()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.show_chart),
            title: const Text('Traçar Linhas'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LinhaScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.alt_route),
            title: const Text('Traçar Rotas'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const RotaScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.redAccent),
            title: const Text('Sair'),
            onTap: _encerrarApp,
          ),
        ],
      ),
    );
  }
}