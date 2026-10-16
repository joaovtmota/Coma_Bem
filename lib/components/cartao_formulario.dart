import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Card branco arredondado que agrupa os campos de um formulário,
/// com um título em destaque no topo (ex.: "Acesse sua conta").
class CartaoFormulario extends StatelessWidget {
  final String titulo;
  final List<Widget> children;

  const CartaoFormulario({
    super.key,
    required this.titulo,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
      decoration: BoxDecoration(
        color: AppColors.branco,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textoPrincipal,
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }
}
