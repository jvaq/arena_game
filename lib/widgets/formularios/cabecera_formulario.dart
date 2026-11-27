import 'package:flutter/material.dart';

import '../../theme/arena_assets.dart';
import '../../theme/arena_theme.dart';

class CabeceraFormulario extends StatelessWidget {
  const CabeceraFormulario({
    super.key,
    required this.titulo,
    required this.subtitulo,
  });

  final String titulo;
  final String subtitulo;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Image.asset(
        ArenaAssets.emblema,
        height: ArenaMedidas.emblemaFormulario,
        errorBuilder: (_, error, stackTrace) => const Icon(
          Icons.shield,
          size: ArenaMedidas.emblemaFormulario,
          color: ArenaColors.dorado,
        ),
      ),
      const SizedBox(height: ArenaMedidas.s16),
      Text(titulo, textAlign: TextAlign.center, style: ArenaTextos.subtitulo),
      const SizedBox(height: ArenaMedidas.s8),
      Text(
        subtitulo,
        textAlign: TextAlign.center,
        style: ArenaTextos.cuerpoSuave,
      ),
    ],
  );
}
