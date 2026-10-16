import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Frase de rodapé em fonte manuscrita com um link sublinhado, como
/// "Ainda não tem conta? Cadastre-se".
class RodapeManuscrito extends StatelessWidget {
  final String pergunta;
  final String acao;
  final VoidCallback onTap;

  const RodapeManuscrito({
    super.key,
    required this.pergunta,
    required this.acao,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            '$pergunta ',
            style: const TextStyle(
              fontFamily: AppFonts.manuscrita,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textoPrincipal,
            ),
          ),
          InkWell(
            onTap: onTap,
            child: Text(
              acao,
              style: const TextStyle(
                fontFamily: AppFonts.manuscrita,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.textoPrincipal,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
