import 'package:flutter/material.dart';
import 'dart:async';
import '../components/indicador_carregando.dart';
import '../components/logo_coma_bem.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // O logo se adapta à altura da tela (limitado entre 120 e 210).
    final altura = MediaQuery.sizeOf(context).height;
    final larguraLogo = (altura * 0.26).clamp(120.0, 210.0).toDouble();

    return Scaffold(
      backgroundColor: AppColors.fundo,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LogoComaBem(largura: larguraLogo),
              SizedBox(height: altura * 0.09),
              const IndicadorCarregando(tamanho: 72, espessura: 8),
            ],
          ),
        ),
      ),
    );
  }
}
