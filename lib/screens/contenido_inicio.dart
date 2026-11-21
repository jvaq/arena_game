import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../../models/models.dart';
import '../../theme/arena_assets.dart';
import '../../theme/arena_theme.dart';
import '../../utils/clase_visual.dart';

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
    if (context.mounted) {
      alVolver();
    }
  }
  // Construye la tarjeta del jugador.
  Widget _tarjetaJugador() {
    final clase = claseVisual(jugador.clase);
    return Container(
      padding: const EdgeInsets.all(ArenaMedidas.s16),
      decoration: BoxDecoration(
        color: ArenaColors.superficie,
        border: Border.all(color: ArenaColors.borde),
        borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
      ),
      child: Row(
        children: [
          if (jugador.configurado)
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ArenaColors.deClase(clase)),
              ),
              child: ClipOval(
                child: Image.asset(
                  ArenaAssets.avatar(clase),
                  width: ArenaMedidas.s32,
                  height: ArenaMedidas.s32,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const Icon(Icons.person),
                ),
              ),
            )
          else
            const Icon(Icons.person),
          const SizedBox(width: ArenaMedidas.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre del jugador.
                Text(jugador.nick, style: ArenaTextos.subtitulo),

                // Estadísticas o aviso si aún no tiene personaje.
                Text(
                  jugador.configurado
                      ? '${nombreClase(jugador.clase)} · ${jugador.victorias}V · ${jugador.derrotas}D'
                      : 'Sin personaje',
                  style: ArenaTextos.cuerpoSuave,
                ),
              ],
            ),
          ),
          // Puntuación del jugador, alineada a la derecha.
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

  //Construye la escena del personaje.
  Widget _escena() {
    final clase = claseVisual(jugador.clase);
    return ClipRRect(
      borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
      child: SizedBox(
        height: 220,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Fondo de la escena.
            Image.asset(
              ArenaAssets.fondo,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) =>
                  const ColoredBox(color: ArenaColors.superficie),
            ),
            // Plataforma situada en la parte inferior de la escena.
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                ArenaAssets.plataforma,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
            // Muestra el personaje únicamente si está configurado.
            if (jugador.configurado)
              Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  ArenaAssets.personaje(clase),
                  height: 160,
                  fit: BoxFit.contain,
                  // similar a python se usa _ porque errrorBuilder devuelve 3 parametros que no se van a uar
                  errorBuilder: (_, _, _) => const Icon(Icons.person),
                ),
              ),
            // Si no tiene personaje, muestra una interrogación.
            if (!jugador.configurado)
              const Center(
                child: Icon(
                  Icons.question_mark,
                  size: ArenaMedidas.s32,
                  color: ArenaColors.textoSuave,
                ),
              ),
          ],
        ),
      ),
    );
  }
//menu
  // Crea un botón del menú con icono y texto.
  Widget _opcion({
    required IconData icono,
    required String texto,
    VoidCallback? alPulsar,
    bool destacado = false,
  }) {
    final color = destacado
        ? ArenaColors.dorado
        : ArenaColors.textoSuave;

    return OutlinedButton(
      onPressed: alPulsar,
      style: OutlinedButton.styleFrom(
        backgroundColor: ArenaColors.superficie,
        foregroundColor: color,
        side: BorderSide(
          color: destacado ? ArenaColors.dorado : ArenaColors.borde,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icono),
          const SizedBox(height: ArenaMedidas.s8),
          Text(texto, textAlign: TextAlign.center),
        ],
      ),
    );
  }
  Widget _menu(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [_opcion(
        icono: Icons.sports_martial_arts,
        texto: 'Combatir',
        alPulsar: jugador.configurado
            ? () => _ir(context, Routes.rival)
            : null,
      ),
        _opcion(
          icono: Icons.shield_outlined,
          texto: 'Mi personaje',
          destacado: !jugador.configurado,
          alPulsar: () => _ir(context, Routes.personaje),
        ),
        _opcion(
          icono: Icons.emoji_events,
          texto: 'Ranking',
          alPulsar: () => _ir(context, Routes.ranking),
        ),
        _opcion(
          icono: Icons.history,
          texto: 'Historial',
          alPulsar: () => _ir(context, Routes.historial),
        ),
      ],
    );
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
        _tarjetaJugador(),

        // TODO 3: ESCENA (widget propio, p. ej. _Escena)
        //   ClipRRect + SizedBox(height: 220) + Stack: fondo (BoxFit.cover), plataforma y
        //   personaje colocados con Align. Sin personaje: un icono de interrogación.
        //   Usa errorBuilder en Image.asset por si falta alguna imagen.
        const SizedBox(height: ArenaMedidas.s16),
        _escena(),

        // TODO 4: si !jugador.configurado, un texto centrado:
        //   Aviso si el jugador todavía no tiene personaje.
        if (!jugador.configurado)
          Padding(
            padding: const EdgeInsets.only(top: ArenaMedidas.s16),
            child: Text(
              'Aún no tienes personaje. Créalo para poder combatir.',
              textAlign: TextAlign.center,
              style: ArenaTextos.cuerpoSuave,
            ),
          ),

        // TODO 5: MENÚ 2×2 (GridView.count con shrinkWrap y NeverScrollableScrollPhysics,
        //   o Row/Column). Cuatro botones iguales (icono + texto), widget propio _Opcion:
        //     Combatir      → Rutas.rival      (desactivado si !configurado)
        //     Mi personaje  → Rutas.personaje  (resaltado en dorado si !configurado)
        //     Ranking       → Rutas.ranking
        //     Historial     → Rutas.historial
        //   Cada botón navega con el método del TODO 6.
        const SizedBox(height: ArenaMedidas.s16),
        _menu(context),
      ],
    );
  }
}
