import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Nome "Coma Bem" com as mesmas cores do logo: "Coma" em lilás e
/// "Bem" em rosa. Usado no topo da tela inicial.
class TituloComaBem extends StatelessWidget {
  final double tamanho;

  const TituloComaBem({super.key, this.tamanho = 34});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontFamily: AppFonts.principal,
          fontSize: tamanho,
          fontWeight: FontWeight.w700,
          height: 1.1,
        ),
        children: const [
          TextSpan(text: 'Coma ', style: TextStyle(color: AppColors.lilas)),
          TextSpan(text: 'Bem', style: TextStyle(color: AppColors.rosa)),
        ],
      ),
    );
  }
}
