import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../theme/arena_assets.dart';
import '../pieza_pendiente.dart';

/// PIEZA E · Zona superior de la pantalla de personaje (altura aprox. 300).
///
/// Capas con `Stack` + `Positioned`:
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
      child: Stack(
        fit: StackFit.expand,
        children: [

          Image.asset(
            ArenaAssets.fondo,
            fit: BoxFit.cover,
          ),


          Positioned(
            top: 15,
            left: 0,
            right: 0,
            child: const Center(
              child: Text(
                'ELEGÍ TU PERSONAJE ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 15,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                ArenaAssets.plataforma,
                height: 50,
              ),
            ),
          ),


          Positioned(
            bottom: 25,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                clase.imagen,
                height: 150,
              ),
            ),
          ),


          if (armas.isNotEmpty)
            Positioned(
              left: 32,
              top: 30,
              bottom: 0,
              child: Center(
                child: _crearCirculoArma(armas[0].imagen),
              ),
            ),


          if (armas.length > 1)
            Positioned(
              right: 32,
              top: 30,
              bottom: 0,
              child: Center(
                child: _crearCirculoArma(armas[1].imagen),
              ),
            ),
        ],
      ),
    );
  }

  // Método auxiliar sencillo para los círculos de las armas
  Widget _crearCirculoArma(String rutaImagen) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blueAccent, width: 2),
        color: const Color(0xFF1E2235).withOpacity(0.7),
      ),
      padding: const EdgeInsets.all(10),
      child: Image.asset(rutaImagen),
    );
  }
}