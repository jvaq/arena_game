import 'package:arena_game/theme/arena_assets.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';
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
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned.fill(
            child: Image.asset(
            ArenaAssets.fondo,
            fit:BoxFit.cover,
        ),
        ),
          Positioned(
            bottom: 0,
            child: Image.asset(ArenaAssets.plataforma,
              width: 240,
              height: 110,
              fit:BoxFit.contain,
            ),
          ),

          Positioned(
            bottom: 35,
            child: Image.asset(clase.imagen,
              width: 190,
              height: 245,
              fit:BoxFit.contain,
            ),
          ),
          if(armas.isNotEmpty)

            Positioned(
              left: 20,
              bottom: 0,

              child: Image.asset(armas[0].imagen,
                width: 65,
                height: 75,
                fit:BoxFit.contain,
              ),
            ),





          if(armas.length>1)

            Positioned(
              right: 20,
              bottom: 55,
              child: Image.asset(armas[1].imagen,
                width: 65,
                height: 75,
                fit:BoxFit.contain,
              ),
            ),
        ],
      )
    );
    return PiezaPendiente('EscenaPersonaje · ${clase.nombre} (${armas.length} armas)', alto: 300);
  }
}
