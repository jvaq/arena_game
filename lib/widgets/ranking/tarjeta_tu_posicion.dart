import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../theme/arena_assets.dart';
import '../../theme/arena_theme.dart';


/// PIEZA B · Tarjeta fija «Tu posición» (va abajo del todo en la pantalla).
///
/// Qué hay que dibujar (altura 64): hecho
///  - Pequeña etiqueta superior «TU POSICIÓN» (`ArenaTextos.etiqueta`).hecho
///  - Fondo `superficieAlta` y borde dorado de 2.5 (`grosorBordeSeleccion`). hecho
///  - Posición (`ArenaTextos.puntos` o `subtitulo`), hecho pendiente avatar 44 px con borde de clase, hecho
///    nick + etiqueta «TÚ» (fondo dorado, texto `textoSobreDorado`), «V · D» y puntos. hecho
///
/// NO cambies el constructor.
class TarjetaTuPosicion extends StatelessWidget {
  const TarjetaTuPosicion({super.key, required this.entrada});

  final EntradaRanking entrada;

  @override
  Widget build(BuildContext context) {
    final medalla = ArenaAssets.medalla(entrada.posicion); //recibe clase de medalla

    return
    //se creo un column para poder insertar el texto de "TU POSICIÓN"
      Column(
        //Controlar la distribucion  horizontal de la tarjeta ya que ahora el contenedor principal es el column no el container
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("TU POSICIÓN",style:ArenaTextos.etiqueta),
          Container( //container.. que tiene como hijo un row y sus hijos con sus caracteristicas
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: ArenaMedidas.s8),
          decoration: BoxDecoration(
            color: ArenaColors.superficieAlta,
            borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
            border: Border.all(
              color: ArenaColors.dorado,
              width: ArenaMedidas.grosorBordeSeleccion,
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
                  : Text('${entrada.posicion}', textAlign: TextAlign.center, style: ArenaTextos.subtitulo),//ya es subtitulo como raking lo dejo como esta
            ),
            const SizedBox(width: ArenaMedidas.s8),
            // AVATAR CIRCULAR
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,//forma circular
                border: Border.all(color: ArenaColors.deClase(entrada.clase), width: 2), //se cambia clase por entrada.clase
                //porque entrada ya usa la clase EntradaRanking y que esto llama sus datos de un fromJson.
              ),
              //recorta la imagen, boxshape solo le da la forma circular mas no hace el recorte de la imagen por eso es necesario clipOval widget
              child: ClipOval(

                child: Image.asset(ArenaAssets.avatar(entrada.clase), width: 44, height: 44, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: ArenaMedidas.s8),
            Expanded(
              //NOMBRE PERSONAJE Y VICTORIAS/DERROTA
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                Row(
                  children: [
                    Text(entrada.nick, style: ArenaTextos.cuerpo, overflow: TextOverflow.ellipsis),
                    //se agrega en un container para darle color de fondo y el texto de tú usa un color de ArenaColors como es un colors no un style de texto se necesito copia
                    //del TextStyle existente y modificar unicamente la propiedad del color.
                    Container(color: ArenaColors.dorado,child: Text(" TÚ ", style: ArenaTextos.etiqueta.copyWith(
                      color:ArenaColors.textoSobreDorado),
                    ))
                    ,
                  ],
                ),
                Text(entrada.victoriasDerrotas, style: ArenaTextos.etiqueta),
              ]),
            ),
            const SizedBox(width: ArenaMedidas.s8),
            // puntaje es un text ultimo hijo que recibe entrada que es una variable declarada previamente como final
            Text('${entrada.puntos}', style: ArenaTextos.puntos),
          ]),
              ),
        ],
      );
  }
}



