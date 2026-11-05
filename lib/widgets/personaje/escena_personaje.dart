import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../theme/arena_assets.dart';
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

  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Fondo
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                ArenaAssets.fondo, // Volvemos a usar la variable de tu proyecto
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. Plataforma (centrada abajo)
          Positioned(
            bottom: 15,
            child: Image.asset(
              ArenaAssets.plataforma, // Volvemos a usar la plataforma correcta
              width: 220,
            ),
          ),

          // 3. Personaje grande
          Positioned(
            bottom: 40,
            child: Image.asset(
              clase.imagen,
              height: 220,
            ),
          ),

          // 4. Arma 1 (Izquierda)
          Positioned(
            left: 20,
            child: armas.isNotEmpty
                ? _ConstruirCirculoArma(imagen: armas[0].imagen)
                : const _HuecoArma(texto: 'Arma 1'),
          ),

          // 4. Arma 2 (Derecha)
          Positioned(
            right: 20,
            child: armas.length > 1
                ? _ConstruirCirculoArma(imagen: armas[1].imagen)
                : const _HuecoArma(texto: 'Arma 2'),
          ),
        ],
      ),
    );
  }
}

class _ConstruirCirculoArma extends StatelessWidget {
  final String imagen;

  const _ConstruirCirculoArma({required this.imagen});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 68,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C), // Color oscuro del fondo del círculo
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF3B82F6), // Azul claro idéntico a la imagen
          width: 3.5, // Borde más grueso
        ),
      ),
      child: Image.asset(imagen),
    );
  }
}

// NUEVO WIDGET: Dibuja el círculo semitransparente para los huecos vacíos
class _HuecoArma extends StatelessWidget {
  final String texto;

  const _HuecoArma({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 68,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white24, // Borde suave para simular el espacio vacío
          width: 2,
        ),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}