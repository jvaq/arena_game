import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../pieza_pendiente.dart';

/// PIEZA B · Tarjeta fija «Tu posición» (va abajo del todo en la pantalla).
///
/// Qué hay que dibujar (altura 64):
///  - Pequeña etiqueta superior «TU POSICIÓN» (`ArenaTextos.etiqueta`).
///  - Fondo `superficieAlta` y borde dorado de 2.5 (`grosorBordeSeleccion`).
///  - Posición (`ArenaTextos.puntos` o `subtitulo`), avatar 44 px con borde de clase,
///    nick + etiqueta «TÚ» (fondo dorado, texto `textoSobreDorado`), «V · D» y puntos.
///
/// NO cambies el constructor.
class TarjetaTuPosicion extends StatelessWidget {
  const TarjetaTuPosicion({super.key, required this.entrada});

  final EntradaRanking entrada;

  @override
  Widget build(BuildContext context) {
    // TODO(grupo B): sustituye este placeholder por la tarjeta real.
    return PiezaPendiente('TarjetaTuPosicion · ${entrada.nick}', alto: 64);
  }
}
