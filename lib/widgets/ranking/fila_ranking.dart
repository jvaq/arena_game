import 'package:arena_game/theme/arena_assets.dart';
import 'package:arena_game/theme/arena_theme.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';

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

    return ListTile(
      minTileHeight: 52,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: entrada.posicion == 1 || resaltada ? ArenaColors.dorado : ArenaColors.borde,
          width:  resaltada ? ArenaMedidas.grosorBordeSeleccion : ArenaMedidas.grosorBorde
        ),
        borderRadius: BorderRadius.circular(8),
      ),

      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 38,
            child: Center(
              child: entrada.posicion <= 3
                  ? Image.asset(ArenaAssets.medalla(entrada.posicion)!)
                  : Text("${entrada.posicion}", style: const TextStyle(fontSize: 18)),
            ),
          ),
          SizedBox(width: 8,),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: ArenaColors.deClase(entrada.clase),
                width: 2,
              ),
            ),
            child:
               Image.asset(
                ArenaAssets.avatar(entrada.clase.toLowerCase()),
                fit: BoxFit.cover,

            ),
          ),
        ],
      ),

      // nombre
      title: Row(
        children: [
          Text("${entrada.nick}", style: ArenaTextos.cuerpo),
          if(resaltada) Container(
            margin: EdgeInsets.only(left: 5),
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Color(0xFFE5B84C), // Fondo amarillo[cite: 1]
              borderRadius: BorderRadius.circular(8), // Bordes redondeados[cite: 1]
            ),
            child: Text(
              'TÚ',
              style: TextStyle(
                color: Color(0xFF2C2444), // Texto oscuro para contraste
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      // racha
      subtitle: Text(
        "${entrada.victorias} V · ${entrada.derrotas} D",
        style: ArenaTextos.etiqueta,
      ),
      // puntaje
      trailing: Text("${entrada.puntos}", style: ArenaTextos.puntos),
    );
  }
}
