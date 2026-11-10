import 'package:arena_game/theme/arena_assets.dart';
import 'package:arena_game/theme/arena_theme.dart';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        //TEXTO 'TU POSICIÓN' ENCIMA DEL CONTENEDOR
        Text(
          'TU POSICIÓN',
          style: ArenaTextos.etiqueta,
        ),
        const SizedBox(height: 4), //SEPARACIÓN ENTRE EL COLUMN Y EL CONTAINER

        //CONTENEDOR PRINCIPAL
        Container(
          height: 64,
          decoration: BoxDecoration(
            color: ArenaColors.superficieAlta,
            border: Border.all(
              color: ArenaColors.dorado,
              width: 2.5,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),//AÑADE PADDING A LOS DOS LADOS
            child: Row(
              children: [

                //INSERTA TU POSICION ACTUAL
                Text(
                  entrada.posicion.toString(),
                  style: ArenaTextos.puntos,
                ),
                const SizedBox(width:18),

                //TU AVATAR
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ArenaColors.deClase( entrada.clase),
                    ),
                  ),
                  child: Image.asset(ArenaAssets.avatar(entrada.clase)),
                ),
                const SizedBox(width: 12),

                //NCOLUMNO NOMBRE + CONTEO DE V-D
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [
                        //NICK
                        Text(
                          entrada.nick.toString(),
                          style: ArenaTextos.cuerpo,

                        ),
                        const SizedBox(width: 8), // Separación entre el nick y la etiqueta

                        // Etiqueta "TÚ"
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),

                          decoration: BoxDecoration(
                            color: ArenaColors.dorado,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'TÚ',
                            style: TextStyle(
                              color: ArenaColors.textoSobreDorado,
                              fontWeight: FontWeight.bold,
                            )
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 2), // Pequeño espacio vertical
                    //V-D
                    Text(
                      "${entrada.victorias}V - ${entrada.derrotas}D",
                      style: ArenaTextos.cuerpoSuave,
                    ),

                  ],
                ),
                const Spacer(),

                Text(
                  '${entrada.puntos}',
                  style: ArenaTextos.puntos,
                ),

              ],
            ),
          ),

        ),
      ],
    );
  }


}



