import 'package:arena_game/theme/arena_assets.dart';
import 'package:arena_game/theme/arena_theme.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';

//Assets.plataforma`, centrada abajo.
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
    final Color colorClase = ArenaColors.deClase(clase.id);

    return Container(
      decoration: const BoxDecoration(
        // fondo
        gradient: RadialGradient(
          center: Alignment(0, 0.1),
          radius: 0.9,
          colors: [
            ArenaColors.superficieAlta,
            ArenaColors.fondo,
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. TÍTULO
          Align(
            alignment: const Alignment(0, -0.82),
            child: Text(
              'TU PERSONAJE',
              style: ArenaTextos.subtitulo.copyWith(
                fontSize: 30,
                letterSpacing: 2.5,
              ),
            ),
          ),

          // 2. PLATAFORMA
          Align(
            alignment: const Alignment(0, 0.06),
            child: Image.asset(
              ArenaAssets.plataforma,
              width: 600,
              fit: BoxFit.contain,
            ),
          ),

          // 3. PERSONAJE GRANDE
          Align(
            alignment: const Alignment(0, -0.50),
            child: Image.asset(
              clase.imagen,
              height: 350,
              fit: BoxFit.contain,
            ),
          ),

          // 4. ARMAS ELEGIDAS
          if (armas.isNotEmpty)
            Align(
              alignment: const Alignment(-0.90, -0.45),
              child: _CirculoArma(
                imagen: armas[0].imagen,
                colorBorde: colorClase,
              ),
            ),

          if (armas.length > 1)
            Align(
              alignment: const Alignment(0.90, -0.45),
              child: _CirculoArma(
                imagen: armas[1].imagen,
                colorBorde: colorClase,
              ),
            ),
        ],
      ),
    );
  }
}

class _CirculoArma extends StatelessWidget {
  const _CirculoArma({
    required this.imagen,
    required this.colorBorde,
  });

  final String imagen;
  final Color colorBorde;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      padding: const EdgeInsets.all(ArenaMedidas.s8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ArenaColors.fondo,
        border: Border.all(
          color: colorBorde,
          width: ArenaMedidas.grosorBordeSeleccion,
        ),
      ),
      child: Image.asset(
        imagen,
        fit: BoxFit.contain,
      ),
    );
  }
}