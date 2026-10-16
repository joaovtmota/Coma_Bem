import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Indicador de carregamento circular do splash: trilho lavanda com um
/// arco roxo escuro girando por cima (como no design).
class IndicadorCarregando extends StatefulWidget {
  final double tamanho;
  final double espessura;

  const IndicadorCarregando({
    super.key,
    this.tamanho = 72,
    this.espessura = 8,
  });

  @override
  State<IndicadorCarregando> createState() => _IndicadorCarregandoState();
}

class _IndicadorCarregandoState extends State<IndicadorCarregando>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controlador = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.tamanho,
      height: widget.tamanho,
      child: RotationTransition(
        turns: _controlador,
        child: CustomPaint(painter: _PintorArco(widget.espessura)),
      ),
    );
  }
}

class _PintorArco extends CustomPainter {
  final double espessura;

  _PintorArco(this.espessura);

  @override
  void paint(Canvas canvas, Size size) {
    final centro = Offset(size.width / 2, size.height / 2);
    final raio = (size.shortestSide - espessura) / 2;

    final trilho = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = espessura
      ..strokeCap = StrokeCap.round
      ..color = AppColors.lavanda;
    canvas.drawCircle(centro, raio, trilho);

    final arco = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = espessura
      ..strokeCap = StrokeCap.round
      ..color = AppColors.roxoEscuro;
    canvas.drawArc(
      Rect.fromCircle(center: centro, radius: raio),
      0.15,
      math.pi * 0.42,
      false,
      arco,
    );
  }

  @override
  bool shouldRepaint(covariant _PintorArco antigo) =>
      antigo.espessura != espessura;
}
