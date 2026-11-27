import 'package:flutter/material.dart';

import '../../theme/arena_assets.dart';
import '../../theme/arena_theme.dart';

/// PIEZA C · Los tres estados alternativos de la pantalla Ranking.
/// Cada uno es un widget que ocupa toda la zona de la lista.

/// Cargando: `CircularProgressIndicator` dorado centrado + texto «Cargando ranking…».
class RankingCargando extends StatelessWidget {
  const RankingCargando({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: ArenaColors.dorado),
          const SizedBox(height: ArenaMedidas.s16),
          Text('Cargando ranking…', style: ArenaTextos.cuerpoSuave),
        ],
      ),
    );
  }
}

/// Error: icono o imagen, mensaje (`mensaje`) y botón «Reintentar» que llama a `onReintentar`.
class RankingError extends StatelessWidget {
  const RankingError({
    super.key,
    required this.mensaje,
    required this.onReintentar,
  });

  final String mensaje;
  final VoidCallback onReintentar;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ArenaMedidas.s24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: ArenaColors.dorado,
            ),
            const SizedBox(height: ArenaMedidas.s16),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: ArenaTextos.cuerpo,
            ),
            const SizedBox(height: ArenaMedidas.s16),
            ElevatedButton(
              onPressed: onReintentar,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Vacío: mensaje amable («Aún no hay jugadores») con `ArenaAssets.trofeo` o `emblema`.
class RankingVacio extends StatelessWidget {
  const RankingVacio({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ArenaMedidas.s24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              ArenaAssets.trofeo,
              height: 72,
              errorBuilder: (_, __, _) => const Icon(
                Icons.emoji_events_outlined,
                size: 56,
                color: ArenaColors.dorado,
              ),
            ),
            const SizedBox(height: ArenaMedidas.s16),
            Text(
              'Aún no hay jugadores',
              textAlign: TextAlign.center,
              style: ArenaTextos.cuerpoSuave,
            ),
          ],
        ),
      ),
    );
  }
}