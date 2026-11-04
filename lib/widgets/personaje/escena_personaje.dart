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
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if(armas.isNotEmpty)
          ArmaImagen(armaseleccionada: armas.first),
          ImagenPersonaje(personaje: clase),
          if(armas.length>1)
          ArmaImagen(armaseleccionada: armas.last),
        ],
      ),
    );
  }
}

class ArmaImagen extends StatelessWidget {
  const ArmaImagen({super.key, required this.armaseleccionada});

  final Arma armaseleccionada;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ArenaAssets.arma(armaseleccionada.nombre, armaseleccionada.id),
      width: 65,
      height: 65,
      fit: BoxFit.contain,
    );
  }
}

class ImagenPersonaje extends StatelessWidget {
  const ImagenPersonaje({super.key, required this.personaje});

  final ClasePersonaje personaje;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ArenaAssets.personaje(personaje.nombre),
      width: 180,
      height: 220,
      fit: BoxFit.contain,
    );
  }
}
