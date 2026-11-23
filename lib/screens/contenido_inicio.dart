import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../theme/arena_assets.dart';
import '../../theme/arena_theme.dart';
import '../../utils/clase_visual.dart';
import '../app/routes.dart';

/// EJERCICIO 3 · Contenido del Inicio: DISEÑO + NAVEGACIÓN.
///
/// Los datos ya llegan cargados en [jugador] (lo hace `pantalla_inicio.dart`).
/// Diseño de referencia: Diseno_completo_Arena.pdf, pantalla «Inicio».
///
/// Pistas útiles:
///   claseVisual(jugador.clase)  → 'caballero' | 'orco' | 'mago'
///   nombreClase(jugador.clase)  → 'Mago'
///   ArenaColors.deClase(clase)  → color del borde del avatar
///   ArenaAssets.avatar(clase), ArenaAssets.personaje(clase), ArenaAssets.fondo, ArenaAssets.plataforma
///   jugador.configurado == false → aún no tiene personaje (clase es null)
class ContenidoInicio extends StatelessWidget {
  const ContenidoInicio({
    super.key,
    required this.jugador,
    required this.alVolver,
  });

  final Jugador jugador;

  /// Llámala al volver de otra pantalla para recargar los datos.
  final VoidCallback alVolver;

  // TODO 6 (navegación): método que abre una ruta y, al volver, llama a alVolver():
  Future<void> _ir(BuildContext context, String ruta) async {
    await Navigator.pushNamed(context, ruta);
    alVolver();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final clase = claseVisual(jugador.clase);

    // TODO 1: sustituye este ListView por el diseño completo. Un ListView con padding
    //         ArenaMedidas.s16 y, en orden: tarjeta, escena, aviso y menú.
    return ListView(
      padding: const EdgeInsets.all(ArenaMedidas.s16),
      children: [
        // TODO 2: TARJETA DEL JUGADOR (crea un widget propio, p. ej. _TarjetaJugador)
        //   Container con color superficie, borde y esquinas redondeadas (ArenaMedidas.radioTarjeta).
        //   Row: avatar circular con borde del color de la clase · nick (subtitulo) y
        //   «Mago · 21V · 3D» · a la derecha los puntos (ArenaTextos.puntos) y «puntos».
        //   Sin personaje: icono de persona y el texto «Sin personaje».
        //Text('Tarjeta del jugador: ${jugador.nick}', style: ArenaTextos.cuerpo),
        Container(
          decoration: BoxDecoration(
            color: ArenaColors.superficie,
            borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
            border: Border.all(
              width: ArenaMedidas.grosorBorde,
              color: ArenaColors.borde,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(ArenaMedidas.s16),
            child: Row(
              children: [
                //Hago un contenedor exterior para hacer el borde del color de la clase
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: jugador.configurado
                          ? ArenaColors.deClase(clase)
                          : ArenaColors.borde,
                      width: 2
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundImage: jugador.configurado
                        ? AssetImage(ArenaAssets.avatar(clase))
                        : null,
                    radius: ArenaMedidas.radioBoton,
                    backgroundColor: ArenaColors.fondo,
                    child: !jugador.configurado
                        ? const Icon(
                      Icons.person,
                      color: Colors.blueAccent,
                      size: ArenaMedidas.s32,
                    )
                        : null,
                  ),
                ),
                const SizedBox(width: ArenaMedidas.s16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(jugador.nick, style: ArenaTextos.cuerpo),
                      const SizedBox(height: ArenaMedidas.s4),
                      Text(
                        jugador.configurado
                            ? '${nombreClase(jugador.clase)} · ${jugador.victorias} V · ${jugador.derrotas} D'
                            : 'Sin personaje',
                        style: ArenaTextos.cuerpoSuave,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${jugador.puntos}', style: ArenaTextos.puntos),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: ArenaMedidas.s8),

        // TODO 3: ESCENA (widget propio, p. ej. _Escena)
        //   ClipRRect + SizedBox(height: 220) + Stack: fondo (BoxFit.cover), plataforma y
        //   personaje colocados con Align. Sin personaje: un icono de interrogación.
        //   Usa errorBuilder en Image.asset por si falta alguna imagen.
        ClipRRect(
          borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
          child: SizedBox(
            height: 220,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                    child: Image.asset(
                      ArenaAssets.fondo,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: ArenaColors.superficie),
                    ),
                ),
                Align(
                  alignment: Alignment(0, 0.55),
                  child: Image.asset(
                    ArenaAssets.plataforma,
                    width: 170,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  )
                ),
                Align(
                  alignment: Alignment(0, -0.35),
                  child: jugador.configurado
                    ? Image.asset(
                      ArenaAssets.personaje(clase),
                      height: 120,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      )
                    : const Icon(
                    Icons.question_mark,
                    color: ArenaColors.textoSuave,
                    size: 80,
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: ArenaMedidas.s8),

        // TODO 4: si !jugador.configurado, un texto centrado:
        //   «Aún no tienes personaje. Créalo para poder combatir.»
        if (!jugador.configurado)
          Center(child: Text('Aún no tienes personaje. Créalo para poder combatir.', style: ArenaTextos.cuerpoSuave.copyWith(fontSize: 12))),

        const SizedBox(height: ArenaMedidas.s8),

        // TODO 5: MENÚ 2×2 (GridView.count con shrinkWrap y NeverScrollableScrollPhysics,
        //   o Row/Column). Cuatro botones iguales (icono + texto), widget propio _Opcion:
        //     Combatir      → Rutas.rival      (desactivado si !configurado)
        //     Mi personaje  → Rutas.personaje  (resaltado en dorado si !configurado)
        //     Ranking       → Rutas.ranking
        //     Historial     → Rutas.historial
        //   Cada botón navega con el método del TODO 6.
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: ArenaMedidas.s8,
          crossAxisSpacing: ArenaMedidas.s8,
          childAspectRatio: 1.9,
          children: [
            _Opcion(
              activado: jugador.configurado,
              estado: false,
              alPulsar: jugador.configurado ? () => _ir(context, Routes.rival) : null,
              texto: 'Combatir',
              icono: ArenaAssets.combate,
            ),
            _Opcion(
              activado: true,
              estado: !jugador.configurado,
              alPulsar: () => _ir(context, Routes.rival),
              texto: 'Mi personaje',
              icono: ArenaAssets.iconoPersonaje,
            ),
            _Opcion(
              activado: true,
              estado: false,
              alPulsar: () => _ir(context, Routes.ranking),
              texto: 'Ranking',
              icono: ArenaAssets.ranking,
            ),
            _Opcion(
              activado: true,
              estado: false,
              alPulsar: () => _ir(context, Routes.historial),
              texto: 'Historial',
              icono: ArenaAssets.historial,
            ),
          ],
        )
      ],
    );
  }
}

class _Opcion extends StatelessWidget {
  final String texto;
  final String icono;
  final bool estado;
  final bool activado;
  final VoidCallback? alPulsar;

  const _Opcion({
    required this.texto,
    required this.icono,
    required this.estado,
    required this.activado,
    required this.alPulsar,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: activado ? alPulsar : null,
      child: Opacity(
        opacity: activado ? 1.0 : 0.45,
        child: Container(
          padding: const EdgeInsets.all(ArenaMedidas.s4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
            border: Border.all(
              color: estado ? ArenaColors.dorado : ArenaColors.borde,
              width: estado
                  ? ArenaMedidas.grosorBordeSeleccion
                  : ArenaMedidas.grosorBorde,
            ),
            color: ArenaColors.superficie,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  icono,
                  width: ArenaMedidas.s32,
                  height: ArenaMedidas.s32,
                  fit: BoxFit.contain,
                  color: activado ? null : ArenaColors.textoSuave,
                ),
                const SizedBox(height: ArenaMedidas.s4),
                Text(
                  texto,
                  textAlign: TextAlign.center,
                  style: (activado ? ArenaTextos.cuerpo : ArenaTextos.cuerpoSuave).copyWith(
                    color: !activado
                        ? ArenaColors.textoSuave
                        : (estado ? ArenaColors.dorado : ArenaColors.texto),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}