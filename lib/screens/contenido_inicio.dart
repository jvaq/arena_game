import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../theme/arena_assets.dart';
import '../../theme/arena_theme.dart';
import '../../utils/clase_visual.dart';
import '../../app/routes.dart';

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
  const ContenidoInicio({super.key, required this.jugador, required this.alVolver});

  final Jugador jugador;

  /// Llámala al volver de otra pantalla para recargar los datos.
  final VoidCallback alVolver;

  // TODO 6 (navegación): método que abre una ruta y, al volver, llama a alVolver():
  //   Future<void> _ir(BuildContext context, String ruta) async {
  //     await Navigator.pushNamed(context, ruta);
  //     alVolver();
  //   }
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
        _TarjetaJugador(jugador: jugador),

        // TODO 3: ESCENA (widget propio, p. ej. _Escena)
        //   ClipRRect + SizedBox(height: 220) + Stack: fondo (BoxFit.cover), plataforma y
        //   personaje colocados con Align. Sin personaje: un icono de interrogación.
        //   Usa errorBuilder en Image.asset por si falta alguna imagen.
        const SizedBox(height: ArenaMedidas.s16),
        _Escena(jugador: jugador, clase: clase),

        // TODO 4: si !jugador.configurado, un texto centrado:
        //   «Aún no tienes personaje. Créalo para poder combatir.»
        if (!jugador.configurado) ...[
          const SizedBox(height: ArenaMedidas.s16),
          Text(
            'Aún no tienes personaje. Créalo para poder combatir.',
            textAlign: TextAlign.center,
            style: ArenaTextos.cuerpoSuave,
          ),
        ],

        // TODO 5: MENÚ 2×2 (GridView.count con shrinkWrap y NeverScrollableScrollPhysics,
        //   o Row/Column). Cuatro botones iguales (icono + texto), widget propio _Opcion:
        //     Combatir      → Rutas.rival      (desactivado si !configurado)
        //     Mi personaje  → Rutas.personaje  (resaltado en dorado si !configurado)
        //     Ranking       → Rutas.ranking
        //     Historial     → Rutas.historial
        //   Cada botón navega con el método del TODO 6.
        const SizedBox(height: ArenaMedidas.s16),

        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: ArenaMedidas.s16,
          mainAxisSpacing: ArenaMedidas.s16,
          childAspectRatio: 1.5,
          children: [
            _Opcion(
              icono: Icons.sports_martial_arts,
              texto: 'Combatir',
              desactivado: !jugador.configurado,
              onTap: () => _ir(context, Routes.rival),
            ),
            _Opcion(
              icono: Icons.person,
              texto: 'Mi personaje',
              resaltado: !jugador.configurado,
              onTap: () => _ir(context, Routes.personaje),
            ),
            _Opcion(
              icono: Icons.emoji_events,
              texto: 'Ranking',
              onTap: () => _ir(context, Routes.ranking),
            ),
            _Opcion(
              icono: Icons.history,
              texto: 'Historial',
              onTap: () => _ir(context, Routes.historial),
            ),
          ],
        ),
      ],
    );
  }
}

class _Escena extends StatelessWidget {
  const _Escena({
    required this.jugador,
    required this.clase,
  });

  final Jugador jugador;
  final String clase;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
      child: SizedBox(
        height: 220,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                ArenaAssets.fondo,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: ArenaColors.superficie);
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                ArenaAssets.plataforma,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox();
                },
              ),
            ),
            if (jugador.configurado)
              Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  ArenaAssets.personaje(clase),
                  height: 180,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.person,
                      size: 100,
                      color: ArenaColors.dorado,
                    );
                  },
                ),
              )
            else
              const Center(
                child: Icon(
                  Icons.help_outline,
                  size: 80,
                  color: ArenaColors.dorado,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Opcion extends StatelessWidget {
  const _Opcion({
    required this.icono,
    required this.texto,
    required this.onTap,
    this.desactivado = false,
    this.resaltado = false,
  });

  final IconData icono;
  final String texto;
  final VoidCallback onTap;
  final bool desactivado;
  final bool resaltado;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: resaltado
          ? ArenaColors.superficieAlta
          : ArenaColors.superficie,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
        side: BorderSide(
          color: resaltado ? ArenaColors.dorado : ArenaColors.borde,
        ),
      ),
      child: InkWell(
        onTap: desactivado ? null : onTap,
        borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icono,
              size: 32,
              color: desactivado
                  ? ArenaColors.textoSuave
                  : resaltado
                  ? ArenaColors.dorado
                  : ArenaColors.texto,
            ),
            const SizedBox(height: ArenaMedidas.s8),
            Text(texto, style: ArenaTextos.boton),
          ],
        ),
      ),
    );
  }
}

class _TarjetaJugador extends StatelessWidget {
  const _TarjetaJugador({required this.jugador});

  final Jugador jugador;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ArenaMedidas.s16),
      decoration: BoxDecoration(
        color: ArenaColors.superficie,
        borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
        border: Border.all(color: ArenaColors.borde),
      ),
      child: Row(
        children: [
          const Icon(Icons.person, size: 48, color: ArenaColors.dorado),
          const SizedBox(width: ArenaMedidas.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(jugador.nick, style: ArenaTextos.subtitulo),
                Text(
                  jugador.configurado
                      ? '${nombreClase(jugador.clase)} · ${jugador.victorias}V · ${jugador.derrotas}D'
                      : 'Sin personaje',
                  style: ArenaTextos.cuerpoSuave,
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text('${jugador.puntos}', style: ArenaTextos.puntos),
              Text('puntos', style: ArenaTextos.cuerpoSuave),
            ],
          ),
        ],
      ),
    );
  }
}
