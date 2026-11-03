import 'package:flutter/material.dart';

import '../theme/arena_theme.dart';

/// Marcador visual de una pieza que aún no está hecha.
/// Cuando termines tu pieza, BORRA el uso de PiezaPendiente en tu archivo.
class PiezaPendiente extends StatelessWidget {
  const PiezaPendiente(this.nombre, {super.key, this.alto = 64});

  final String nombre;
  final double alto;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: alto,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ArenaColors.superficie,
        borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
        border: Border.all(color: ArenaColors.dorado, width: 1),
      ),
      child: Text('PENDIENTE · $nombre', style: ArenaTextos.etiqueta),
    );
  }
}
