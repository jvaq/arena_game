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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Row(
        crossAxisAlignment: CrossAxisAlignment.center ,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (armas.isNotEmpty)ArmaImagen(armaseleccionada: armas.first),
          ImagenPersonaje(personaje: clase),
          if (armas.length > 1)ArmaImagen(armaseleccionada: armas.last),
        ],
      ),
        Image.asset(
          ArenaAssets.plataforma,
          width: 220,
          fit: BoxFit.contain,

        ),
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
    return Container(
      width: 75,
      height: 75,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withOpacity(0.3), // Fondo semitransparente opcional
        border: Border.all(
          color: Colors.blueAccent, // Color del borde circular
          width: 3.0, // Grosor del círculo
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Espacio entre el arma y el borde del círculo
        child: Image.asset(
          ArenaAssets.arma("mago", armaseleccionada.id),
          fit: BoxFit.contain,

        ),
      ),
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
      height: 200,

      fit: BoxFit.contain,
    );
  }
}


