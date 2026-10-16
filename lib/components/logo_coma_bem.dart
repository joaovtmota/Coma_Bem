import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Logo do Coma Bem (assets/images/logo.png).
///
/// Para trocar o logo, basta substituir o arquivo assets/images/logo.png
/// por outro com o mesmo nome (de preferência PNG com fundo transparente
/// ou na cor de fundo do app, em alta resolução).
class LogoComaBem extends StatelessWidget {
  final double largura;

  const LogoComaBem({super.key, this.largura = 200});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      width: largura,
      fit: BoxFit.contain,
      semanticLabel: 'Logo Coma Bem',
      // Se o arquivo do logo não for encontrado, mostra o nome em texto
      // em vez de quebrar a tela.
      errorBuilder: (context, erro, pilha) => SizedBox(
        width: largura,
        child: Text(
          'Coma Bem',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: largura * 0.2,
            fontWeight: FontWeight.w700,
            color: AppColors.roxo,
          ),
        ),
      ),
    );
  }
}
