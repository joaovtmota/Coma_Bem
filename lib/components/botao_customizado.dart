import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Botão reutilizável do app. Usa o ElevatedButtonTheme central
/// (definido em app_theme.dart) em vez de cores fixas, então basta
/// mudar a paleta em um único lugar para atualizar todos os botões.
class BotaoCustomizado extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;
  final bool carregando;
  final bool secundario;

  const BotaoCustomizado({
    super.key,
    required this.texto,
    required this.onPressed,
    this.carregando = false,
    this.secundario = false,
  });

  @override
  Widget build(BuildContext context) {
    final corIndicador = secundario ? AppColors.roxo : Colors.white;

    final child = carregando
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              valueColor: AlwaysStoppedAnimation<Color>(corIndicador),
            ),
          )
        : Text(texto);

    if (secundario) {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: OutlinedButton(
          onPressed: carregando ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.roxo,
            side: const BorderSide(color: AppColors.roxo, width: 1.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontFamily: AppFonts.principal,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          child: child,
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: carregando ? null : onPressed,
        child: child,
      ),
    );
  }
}
