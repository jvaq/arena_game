import 'package:flutter/material.dart';

import '../theme/arena_assets.dart';
import '../theme/arena_theme.dart';

class CabeceraFormulario extends StatelessWidget {
  final String titulo;
  final String subtitulo;

  const CabeceraFormulario({
    super.key,
    required this.titulo,
    required this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          ArenaAssets.emblema,
          height: 100,
          errorBuilder: (_, __, ___) => const Icon(Icons.shield, size: 100),
        ),
        const SizedBox(height: ArenaMedidas.s16),
        Text(titulo, style: ArenaTextos.subtitulo, textAlign: TextAlign.center),
        const SizedBox(height: ArenaMedidas.s16),
        Text(subtitulo, style: ArenaTextos.cuerpoSuave, textAlign: TextAlign.center),
      ],
    );
  }
}