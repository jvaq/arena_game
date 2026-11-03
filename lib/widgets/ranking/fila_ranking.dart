import 'package:arena_game/theme/arena_assets.dart';
import 'package:arena_game/theme/arena_theme.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../pieza_pendiente.dart';
import '../../theme/arena_theme.dart';

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
    //return Text('FilaRanking · ${entrada.posicion} ${entrada.nick}', alto: 52);



    return ListTile(
      // aqui va el icono del ranking
        leading: entrada.posicion <= 3 ?
      Image.asset(ArenaAssets.medalla(entrada.posicion)!,height: ArenaMedidas.s32,width: ArenaMedidas.s32)
      : Text("${entrada.posicion}"),
        title: Row(
          children: [
            Image.asset(ArenaAssets.avatar(entrada.clase.toLowerCase()),width: 38, height: 38,),
            Column(children: [
              Text("${entrada.nick}"),
              Text("${entrada.victorias} V · ${entrada.derrotas} D")

            ],)
          ],
        ),
      trailing: Text("${entrada.puntos}",style: ArenaTextos.etiqueta,),
    );
  }
}
