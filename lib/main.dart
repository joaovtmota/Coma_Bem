import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/cadastro_screen.dart';
import 'screens/cadastro_usuario_screen.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  // BUG CORRIGIDO: o pacote sqflite (usado pelo DatabaseHelper) só
  // funciona nativamente em Android/iOS. Em Windows, Linux ou macOS
  // (desktop) ele falha silenciosamente e todo INSERT/SELECT dá erro,
  // inclusive "criar conta". O sqflite_common_ffi já estava no
  // pubspec.yaml mas nunca era inicializado -- por isso o cadastro
  // "não era possível" em quem testava no desktop.
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const ComaBemApp());
}

class ComaBemApp extends StatelessWidget {
  const ComaBemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Coma Bem',

      // Tema centralizado em lib/theme/app_theme.dart (paleta vinho + dourado)
      theme: AppTheme.tema,

      // Primeira tela que será aberta
      initialRoute: '/splash',

      // Rotas do aplicativo
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/cadastro-usuario': (context) => const CadastroUsuarioScreen(),
        '/cadastro': (context) => const CadastroScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
