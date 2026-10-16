import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Campo de formulário do app: rótulo em cima, caixa arredondada embaixo
/// (com ícone à esquerda e, opcionalmente, um widget à direita, como o
/// "olho" de mostrar/ocultar senha).
class CampoFormularioCustomizado extends StatelessWidget {
  final String titulo;
  final TextEditingController controlador;
  final TextInputType tipoTeclado;
  final bool ocultarTexto;
  final bool obrigatorio;
  final IconData? icone;

  /// Texto de exemplo mostrado dentro do campo enquanto está vazio.
  final String? dica;

  /// Widget mostrado no final do campo (ex.: botão de ver a senha).
  final Widget? sufixo;

  /// Validação personalizada. Se não for informada e [obrigatorio] for
  /// verdadeiro, o campo só exige preenchimento.
  final String? Function(String?)? validador;

  /// Espaço abaixo do campo (use 0 no último campo de um card).
  final double espacoInferior;

  const CampoFormularioCustomizado({
    super.key,
    required this.titulo,
    required this.controlador,
    this.tipoTeclado = TextInputType.text,
    this.ocultarTexto = false,
    this.obrigatorio = false,
    this.icone,
    this.dica,
    this.sufixo,
    this.validador,
    this.espacoInferior = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: espacoInferior),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textoSecundario,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controlador,
            keyboardType: tipoTeclado,
            obscureText: ocultarTexto,
            style: const TextStyle(
              fontSize: 14.5,
              color: AppColors.textoPrincipal,
            ),
            decoration: InputDecoration(
              hintText: dica,
              prefixIcon: icone != null
                  ? Icon(icone, color: AppColors.icone, size: 22)
                  : null,
              suffixIcon: sufixo,
            ),
            validator: validador ??
                (obrigatorio
                    ? (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      }
                    : null),
          ),
        ],
      ),
    );
  }
}
