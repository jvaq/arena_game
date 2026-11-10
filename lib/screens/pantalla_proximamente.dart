import 'package:flutter/material.dart';

import '../../theme/arena_assets.dart';
import '../../theme/arena_theme.dart';

/// Marcador de una pantalla que todavía no se ha hecho. No hay que editarlo.
class PantallaProximamente extends StatelessWidget {
  const PantallaProximamente({super.key, required this.titulo});

  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(ArenaAssets.emblema, height: 96),
            const SizedBox(height: ArenaMedidas.s16),
            Text('Próximamente', style: ArenaTextos.subtitulo),
            const SizedBox(height: ArenaMedidas.s8),
            Text('Esta pantalla aún no está hecha.', style: ArenaTextos.cuerpoSuave),
          ],
        ),
      ),
    );
  }
}
