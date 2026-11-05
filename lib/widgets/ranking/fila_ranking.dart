import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../theme/arena_assets.dart';
import '../../theme/arena_theme.dart';


/// PIEZA A · Fila del ranking.
///
/// Qué hay que dibujar (altura 52, ver README, sección «Pantalla 1»):
///  - Posición: medalla `ArenaAssets.medalla(posicion)` si es 1-3; si no, el número. hecho
///  - Avatar circular (38 px) con borde del color de la clase (`ArenaColors.deClase`). hecho
///  - Nick (`ArenaTextos.cuerpo`) y `entrada.victoriasDerrotas` (`ArenaTextos.etiqueta`).hecho
///  - Puntos a la derecha (`ArenaTextos.puntos`). hecho
///  - Si `entrada.posicion == 1`: borde dorado.hecho
///  - Si `resaltada` es true: fondo `superficieAlta` (para tu fila dentro del top 10). //se hace con un if/else hecho en funcion privada se llama en boxdecoration color
///
/// NO cambies el constructor: el resto de piezas dependen de él.
class FilaRanking extends StatelessWidget {
  const FilaRanking({super.key, required this.entrada, this.resaltada = false});

  final EntradaRanking entrada;
  final bool resaltada;

  @override
  Widget build(BuildContext context) {
    final medalla = ArenaAssets.medalla(entrada.posicion); //recibe clase de medalla

    return Container( //container.. que tiene como hijo un row y sus hijos con sus caracteristicas
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: ArenaMedidas.s8),
      decoration: BoxDecoration(
        color:_obtenerColorFondo(resaltada),
        borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
        border: Border.all(
          color: entrada.posicion == 1 ? ArenaColors.dorado : ArenaColors.borde,
          width: ArenaMedidas.grosorBorde,
        ),
      ),
      child: Row(children: [ //los hijos del chil que tiene:
        //POSICION
        SizedBox(
          width: 36,
          //hijo medalla previamente medalla es un objeto que acepta null String?medalla
          child: medalla != null
              //usa el switch de medalla si no cumple no asigna meddalla solo texto
              ? Image.asset(medalla)
              : Text('${entrada.posicion}', textAlign: TextAlign.center, style: ArenaTextos.subtitulo),
        ),
        const SizedBox(width: ArenaMedidas.s8),
        // AVATAR
        // Avatar circular con borde del color de la clase
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,//forma circular
            border: Border.all(color: ArenaColors.deClase(entrada.clase), width: 2), //se cambia clase por entrada.clase
            //porque entrada ya usa la clase EntradaRanking y que esto llama sus datos de un fromJson.
          ),
          //recorta la imagen, boxshape solo le da la forma circular mas no hace el recorte de la imagen por eso es necesario clipOval widget
          child: ClipOval(
            //
            child: Image.asset(ArenaAssets.avatar(entrada.clase), width: 38, height: 38, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: ArenaMedidas.s8),
        Expanded(
          //penultimo hijo tiene una columna con dos texto
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(entrada.nick, style: ArenaTextos.cuerpo, overflow: TextOverflow.ellipsis),
            Text(entrada.victoriasDerrotas, style: ArenaTextos.etiqueta),
          ]),
        ),
        const SizedBox(width: ArenaMedidas.s8),
        // puntaje es un text ultimo hijo que recibe entrada que es una variable declarada previamente como final
        Text('${entrada.puntos}', style: ArenaTextos.puntos),
      ]),
    );
  }
}
// Uso una función en vez de un ternario para facilitar la ampliación a más colores.
// Si hubiera más de dos estados, cambiaría el bool por un enum y usaría if/else if o switch.
Color _obtenerColorFondo(bool resaltada){
  if(resaltada){
    return ArenaColors.superficieAlta;
  }else{
    return ArenaColors.superficie;
  }
}





