import 'package:flutter/material.dart';

/// Paleta de cores oficial do Coma Bem (extraída do design no Figma).
/// Tudo no app deve referenciar essas constantes em vez de usar
/// Colors.xxx / Color(0x...) espalhados pelas telas, para manter a
/// identidade visual consistente. Para mudar uma cor do app inteiro,
/// altere só o valor aqui.
class AppColors {
  AppColors._();

  // Fundo lilás claro de todas as telas
  static const Color fundo = Color(0xFFFAECFD);

  // Roxo principal (botões e ações) e variações
  static const Color roxo = Color(0xFF7D00C5);
  static const Color roxoEscuro = Color(0xFF4F378A);
  static const Color lavanda = Color(0xFFD0BCFF);

  // Cores do logo (destaques, etiquetas)
  static const Color lilas = Color(0xFFBC8ADE);
  static const Color rosa = Color(0xFFE97AE0);

  // Neutros
  static const Color branco = Colors.white;
  static const Color textoPrincipal = Color(0xFF1C1C1E);
  static const Color textoSecundario = Color(0xFF5C5C60);
  static const Color textoDica = Color(0xFFA1A1A6);
  static const Color icone = Color(0xFF8A8A8F);
  static const Color borda = Color(0xFFCAC4D0);
  static const Color bordaCard = Color(0xFFEFDFF3);

  // Feedback
  static const Color sucesso = Color(0xFF3E7A4B);
  static const Color erro = Color(0xFFB3261E);
}

/// Famílias de fonte (arquivos em assets/fonts, declarados no pubspec.yaml).
class AppFonts {
  AppFonts._();

  /// Fonte principal: títulos, campos, botões.
  static const String principal = 'Inter';

  /// Fonte manuscrita: frases de rodapé como "Ainda não tem conta?".
  static const String manuscrita = 'ComicNeue';
}

class AppTheme {
  AppTheme._();

  static ThemeData get tema {
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: AppFonts.principal,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.roxo,
        primary: AppColors.roxo,
        secondary: AppColors.rosa,
        surface: AppColors.fundo,
        error: AppColors.erro,
      ),
      scaffoldBackgroundColor: AppColors.fundo,
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.fundo,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.roxoEscuro,
        titleTextStyle: TextStyle(
          fontFamily: AppFonts.principal,
          color: AppColors.textoPrincipal,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textoPrincipal,
        displayColor: AppColors.textoPrincipal,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.roxo,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.roxo.withValues(alpha: 0.5),
          disabledForegroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontFamily: AppFonts.principal,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.roxo,
          textStyle: const TextStyle(
            fontFamily: AppFonts.principal,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        hintStyle: const TextStyle(color: AppColors.textoDica, fontSize: 14),
        labelStyle: const TextStyle(color: AppColors.textoSecundario),
        errorStyle: const TextStyle(color: AppColors.erro, fontSize: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borda, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borda, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.roxo, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.erro, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.erro, width: 1.6),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.roxo,
        foregroundColor: Colors.white,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
