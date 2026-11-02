import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../pieza_pendiente.dart';

/// PIEZA A · Fila del ranking.
///
/// Qué hay que dibujar (altura 52, ver README, sección «Pantalla 1»):
///  - Posición: medalla `ArenaAssets.medalla(posicion)` si es 1-3; si no, el número.
///  - Avatar circular (38 px) con borde del color de la clase (`ArenaColors.deClase`).
///  - Nick (`ArenaTextos.cuerpo`) y `entrada.victoriasDerrotas` (`ArenaTextos.etiqueta`).
///  - Puntos a la derecha (`ArenaTextos.puntos`).
///  - Si `entrada.posicion == 1`: borde dorado.
///  - Si `resaltada` es true: fondo `superficieAlta` (para tu fila dentro del top 10).
///
/// NO cambies el constructor: el resto de piezas dependen de él.
class FilaRanking extends StatelessWidget {
  const FilaRanking({super.key, required this.entrada, this.resaltada = false});

  final EntradaRanking entrada;
  final bool resaltada;

  @override
  Widget build(BuildContext context) {
    // TODO(grupo A): sustituye este placeholder por la fila real.
    return PiezaPendiente('FilaRanking · ${entrada.posicion} ${entrada.nick}', alto: 52);
  }
}
