import 'package:flutter/material.dart';

import '../pieza_pendiente.dart';

/// PIEZA C · Los tres estados alternativos de la pantalla Ranking.
/// Cada uno es un widget que ocupa toda la zona de la lista.

/// Cargando: `CircularProgressIndicator` dorado centrado + texto «Cargando ranking…».
class RankingCargando extends StatelessWidget {
  const RankingCargando({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(grupo C)
    return const PiezaPendiente('RankingCargando');
  }
}

/// Error: icono o imagen, mensaje (`mensaje`) y botón «Reintentar» que llama a `onReintentar`.
class RankingError extends StatelessWidget {
  const RankingError({super.key, required this.mensaje, required this.onReintentar});

  final String mensaje;
  final VoidCallback onReintentar;

  @override
  Widget build(BuildContext context) {
    // TODO(grupo C)
    return Text('RankingError · $mensaje');
  }
}

/// Vacío: mensaje amable («Aún no hay jugadores») con `ArenaAssets.trofeo` o `emblema`.
class RankingVacio extends StatelessWidget {
  const RankingVacio({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(grupo C)
    return const Text("Aun no hay datos");
  }
}
