import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../theme/arena_assets.dart';
import '../../theme/arena_theme.dart';
import '../pieza_pendiente.dart';

/// PIEZA E · Zona superior de la pantalla de personaje (altura aprox. 300).
///
/// Capas con `Stack` + `Positioned` (README, sección «Pantalla 2»):
///  1. Fondo: `ArenaAssets.fondo` (BoxFit.cover).
///  2. Plataforma: `ArenaAssets.plataforma`, centrada abajo.
///  3. Personaje grande: `clase.imagen` encima de la plataforma.
///  4. Las armas elegidas (0, 1 o 2) pequeñas a izquierda y derecha: `arma.imagen`.
///
/// NO cambies el constructor.
class EscenaPersonaje extends StatelessWidget {
  const EscenaPersonaje({super.key, required this.clase, required this.armas});

  final ClasePersonaje clase;
  final List<Arma> armas;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Image.asset(ArenaAssets.fondo, fit: BoxFit.cover),
            ),

            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, 0.3),
                    radius: 0.8,
                    colors: [
                      clase.color.withValues(alpha: 0.45),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 15,
              child: Image.asset(ArenaAssets.plataforma, width: 220),
            ),
            Positioned(
              bottom: 40,
              child: Image.asset(clase.imagen, height: 220),
            ),

            Positioned(
              left: 20,
              child: armas.isNotEmpty
                  ? _CirculoArma(imagen: armas[0].imagen, color: clase.color)
                  : const _HuecoArma(texto: 'Arma 1'),
            ),

            Positioned(
              right: 20,
              child: armas.length > 1
                  ? _CirculoArma(imagen: armas[1].imagen, color: clase.color)
                  : const _HuecoArma(texto: 'Arma 2'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Círculo con el arma elegida. El borde es del color de la clase.
class _CirculoArma extends StatelessWidget {
  const _CirculoArma({required this.imagen, required this.color});

  final String imagen;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 68,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ArenaColors.fondo,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 3),
      ),
      child: Image.asset(imagen),
    );
  }
}

class _HuecoArma extends StatelessWidget {
  const _HuecoArma({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68,
      height: 68,
      child: CustomPaint(
        painter: _PintorBordePunteado(
          color: ArenaColors.textoSuave.withValues(alpha: 0.5),
          grosor: 2,
          longitudTrazo: 6,
          espacioTrazo: 5,
        ),
        child: Center(
          child: Text(texto, style: ArenaTextos.etiqueta),
        ),
      ),
    );
  }
}

class _PintorBordePunteado extends CustomPainter {
  final Color color;
  final double grosor;
  final double longitudTrazo;
  final double espacioTrazo;

  _PintorBordePunteado({
    required this.color,
    required this.grosor,
    required this.longitudTrazo,
    required this.espacioTrazo,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = grosor
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final double anguloTrazo = longitudTrazo / radius;
    final double anguloEspacio = espacioTrazo / radius;

    double anguloActual = 0;

    while (anguloActual < 2 * math.pi) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        anguloActual,
        anguloTrazo,
        false,
        paint,
      );
      anguloActual += anguloTrazo + anguloEspacio;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
