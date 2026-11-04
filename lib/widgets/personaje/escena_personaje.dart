import 'dart:math' as math;
import 'package:arena_game/theme/arena_assets.dart';
import 'package:arena_game/theme/arena_theme.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';

class EscenaPersonaje extends StatelessWidget {
  const EscenaPersonaje({super.key, required this.clase, required this.armas});

  final ClasePersonaje clase;
  final List<Arma> armas;

  @override
  Widget build(BuildContext context) {
    final Color colorClase = ArenaColors.deClase(clase.id);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: ArenaMedidas.s16,
        vertical: ArenaMedidas.s16,
      ),
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, 0.2),
          radius: 0.9,
          colors: [
            ArenaColors.superficieAlta,
            ArenaColors.fondo,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [



          // 2. FILA CENTRAL: Arma 1 | Personaje + Plataforma | Arma 2
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Arma Izquierda (Arma 1)
              _CirculoArma(
                imagen: armas.isNotEmpty ? armas[0].imagen : null,
                etiqueta: 'Arma 1',
                colorBorde: colorClase,
              ),

              // Centro: Plataforma DETRÁS y Personaje DELANTE
              Expanded(
                child: SizedBox(
                  height: 230,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    clipBehavior: Clip.none,
                    children: [
                      // 1º Plataforma (al ir primero, queda DETRÁS de los pies)
                      Positioned(
                        bottom: -10,
                        left: -20,
                        right: -20,
                        child: Image.asset(
                          ArenaAssets.plataforma,
                          height: 95,
                          fit: BoxFit.contain,
                        ),
                      ),

                      // 2º Personaje (al ir después, sus pies pisan ENCIMA de la plataforma)
                      Positioned(
                        bottom: 18,
                        child: Image.asset(
                          clase.imagen,
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Arma Derecha (Arma 2)
              _CirculoArma(
                imagen: armas.length > 1 ? armas[1].imagen : null,
                etiqueta: 'Arma 2',
                colorBorde: colorClase,
              ),
            ],
          ),
          const SizedBox(height: ArenaMedidas.s8),
        ],
      ),
    );
  }
}

class _CirculoArma extends StatelessWidget {
  const _CirculoArma({
    required this.imagen,
    required this.etiqueta,
    required this.colorBorde,
  });

  final String? imagen;
  final String etiqueta;
  final Color colorBorde;

  @override
  Widget build(BuildContext context) {
    final bool tieneArma = imagen != null;

    return CustomPaint(
      foregroundPainter: tieneArma
          ? null
          : _BordeDiscontinuoPainter(
        color: Colors.white24,
        grosor: 2,
      ),
      child: Container(
        width: 82,
        height: 82,
        padding: const EdgeInsets.all(ArenaMedidas.s8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ArenaColors.fondo,
          border: tieneArma
              ? Border.all(
            color: colorBorde,
            width: ArenaMedidas.grosorBordeSeleccion,
          )
              : null,
        ),
        child: tieneArma
            ? Image.asset(
          imagen!,
          fit: BoxFit.contain,
        )
            : Text(
          etiqueta,
          style: ArenaTextos.cuerpo.copyWith(
            color: Colors.white54,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _BordeDiscontinuoPainter extends CustomPainter {
  const _BordeDiscontinuoPainter({
    required this.color,
    required this.grosor,
  });

  final Color color;
  final double grosor;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = grosor
      ..style = PaintingStyle.stroke;

    final double radio = (size.width / 2) - (grosor / 2);
    final Offset centro = Offset(size.width / 2, size.height / 2);
    const int cantidadGuiones = 28;
    const double paso = (2 * math.pi) / cantidadGuiones;

    for (int i = 0; i < cantidadGuiones; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: centro, radius: radio),
        i * paso,
        paso * 0.55,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}