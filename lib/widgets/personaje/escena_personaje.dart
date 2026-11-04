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

  @override
  Widget build(BuildContext context) {
    // TODO(grupo E)
    return SizedBox(
      height: 300, // Altura aproximada requerida
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Fondo (cubriendo todo el espacio del Stack)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16), // Opcional: bordes redondeados
              child: Image.asset(
                // Si te da error ArenaAssets, asegúrate de importar el archivo correcto
                // o usa directamente 'assets/images/ui/fondo_arena.png'
                ArenaAssets.fondo,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. Plataforma (centrada abajo)
          Positioned(
            bottom: 20,
            child: Image.asset(
              ArenaAssets.plataforma,
              width: 220, // Ajusta según el tamaño real de tu asset
            ),
          ),

          // 3. Personaje grande (encima de la plataforma)
          Positioned(
            bottom: 45, // Un poco más arriba que la plataforma para que "pise" sobre ella
            child: Image.asset(
              clase.imagen,
              height: 200,
            ),
          ),

          // 4. Arma 1 (Izquierda) - Solo se muestra si hay al menos 1 arma
          if (armas.isNotEmpty)
            Positioned(
              left: 20,
              top: 80,
              child: _ConstruirCirculoArma(imagen: armas[0].imagen),
            ),

          // 4. Arma 2 (Derecha) - Solo se muestra si hay 2 armas
          if (armas.length > 1)
            Positioned(
              right: 20,
              top: 80,
              child: _ConstruirCirculoArma(imagen: armas[1].imagen),
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
      width: 64,
      height: 64,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C), // Color oscuro de fondo
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF4A609D), // Borde azulado
          width: 2,
        ),
      ),
      child: Image.asset(imagen),
    );
  }
}
