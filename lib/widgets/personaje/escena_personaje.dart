import 'package:arena_game/theme/arena_assets.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';

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
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ArenaAssets.fondo),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start ,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: .max,
        children: [
          ArmaImagen(armaseleccionada: armas.first),
          ImagenPersonaje(personaje: clase),
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
      ArenaAssets.arma("mago", armaseleccionada.id),
      width: 80,
      height: 80,
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
      ArenaAssets.personaje(personaje.id),
      width: 200,
      height: 150,
      fit: BoxFit.contain,
    );
  }
}
