import 'package:arena_game/theme/arena_assets.dart';
import 'package:arena_game/theme/arena_theme.dart';
import 'package:dotted_border/dotted_border.dart';
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

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: ArenaColors.superficieAlta,
        border: Border.all(color: ArenaColors.dorado, width: 2.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(ArenaMedidas.s4),
                child: RankingNumber(rankingNumber: 1),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(ArenaMedidas.s8),
            child: AvatarCirculo(clasePersonaje: "mago"),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NombrePersonaje(nombre: "Aria"),
                PartidasJugadas(partidasGanadas: 21, partidasPerdidas: 3),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(ArenaMedidas.s16),
                    child: PuntosPersonajes(puntos: 340),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
    return DottedBorder(
      options: CircularDottedBorderOptions(
        dashPattern: [10, 0],
        strokeWidth: 2,
        color: ArenaColors.mago,
        padding: EdgeInsets.all(6),
      ),
      child: Image.asset(ArenaAssets.avatar(clasePersonaje)),
    );
  }
}

class NombrePersonaje extends StatelessWidget {
  const NombrePersonaje({super.key, required this.nombre});

  final String nombre;

  @override
  Widget build(BuildContext context) {
    return Text(
      (nombre),
      style: TextStyle(color: ArenaColors.texto, fontWeight: FontWeight.bold),
    );
  }
}

class PartidasJugadas extends StatelessWidget {
  const PartidasJugadas({
    super.key,
    required this.partidasGanadas,
    required this.partidasPerdidas,
  });

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
    return Center(
      child: Text(
        ("$puntos"),
        style: TextStyle(
          color: ArenaColors.dorado,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

