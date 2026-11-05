import 'package:arena_game/theme/arena_assets.dart';
import 'package:arena_game/theme/arena_theme.dart';
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

    return Container(child: Row(children: [
      Padding(
        padding: EdgeInsets.all(ArenaMedidas.s8),
        child: RankingNumber(rankingNumber: 1),
      ),
      AvatarCirculo(clasePersonaje: "orco"),
      NombrePersonaje(nombre: "Aria"),
      PartidasJugadas(partidasGanadas: 21, partidasPerdidas: 3),
      PuntosPersonajes(puntos: 340)

    ]));
  }
}

class RankingNumber extends StatelessWidget {
  const RankingNumber({super.key, required this.rankingNumber});

  final int rankingNumber;

  @override
  Widget build(BuildContext context) {
    if (rankingNumber < 3) {
      return Image.asset(ArenaAssets.medalla(rankingNumber)!);
    } else {
      return Text(rankingNumber.toString(), style: ArenaTextos.subtitulo);
    }
  }
}

class AvatarCirculo extends StatelessWidget {
  AvatarCirculo({super.key, required this.clasePersonaje});

  String clasePersonaje;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ArenaAssets.avatar(clasePersonaje),
      height: ArenaMedidas.s32,
      width: ArenaMedidas.s32,
    );
  }
}

class NombrePersonaje extends StatelessWidget {
  const NombrePersonaje({super.key, required this.nombre});

  final String nombre;

  @override
  Widget build(BuildContext context) {
    return Text(ArenaAssets.personaje(nombre)
    );
  }
}

class PartidasJugadas extends StatelessWidget {
  const PartidasJugadas({super.key, required this.partidasGanadas, required this.partidasPerdidas});

  final int partidasGanadas;
  final int partidasPerdidas;

  @override
  Widget build(BuildContext context) {
    return Text("$partidasGanadas V · $partidasPerdidas D");
  }
}

class PuntosPersonajes extends StatelessWidget {
  const PuntosPersonajes({super.key, required this.puntos});

final int puntos;
  @override
  Widget build(BuildContext context) {
    return Text("$puntos");
  }
}

