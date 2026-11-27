import 'package:arena_game/app/routes.dart';
import 'package:flutter/material.dart';

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
  const ContenidoInicio({super.key, required this.jugador, required this.alVolver});

  final Jugador jugador;

  /// Llámala al volver de otra pantalla para recargar los datos.
  final VoidCallback alVolver;

  Future<void> _ir(BuildContext context, String ruta) async {
    await Navigator.pushNamed(context, ruta);
    alVolver();
  }

  // TODO 6 (navegación): método que abre una ruta y, al volver, llama a alVolver():


  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final clase = claseVisual(jugador.clase);
    final configurado = jugador.configurado;

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
        _TarjetaJugador(jugador: jugador, clase: clase),
        const SizedBox(height: 16),

        // TODO 3: ESCENA (widget propio, p. ej. _Escena)
        //   ClipRRect + SizedBox(height: 220) + Stack: fondo (BoxFit.cover), plataforma y
        //   personaje colocados con Align. Sin personaje: un icono de interrogación.
        //   Usa errorBuilder en Image.asset por si falta alguna imagen.
        _Escena(clase: clase),
        const SizedBox(height: 12),

        // TODO 4: si !jugador.configurado, un texto centrado:
        //   «Aún no tienes personaje. Créalo para poder combatir.»
        if (!jugador.configurado) ...[
          Text(
            'Aún no tienes personaje. Créalo para poder combatir.',
            textAlign: TextAlign.center,
            style: ArenaTextos.cuerpoSuave,
          ),
          const SizedBox(height: 12),
        ],

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
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.6,
          children: [
            _Opcion(
              icono: "⚔",
              texto: 'Combatir',
              onTap: jugador.configurado
                  ? () => _ir(context, Routes.rival)
                  : null,
            ),
            _Opcion(
              icono: "🛡",
              texto: 'Mi personaje',
              resaltado: !jugador.configurado,
              onTap: () => _ir(context, Routes.personaje),
            ),
            _Opcion(
              icono: '🏆',
              texto: 'Ranking',
              onTap: () => _ir(context, Routes.ranking),
            ),
            _Opcion(
              icono: '📜',
              texto: 'Historial',
              onTap: () => _ir(context, Routes.historial),
            ),
          ],
        ),
      ],
    );
  }
}

class _TarjetaJugador extends StatelessWidget {
  const _TarjetaJugador({required this.jugador, required this.clase});

  final Jugador jugador;
  final String? clase;

  @override
  Widget build(BuildContext context) {
    final configurado = jugador.configurado && clase != null;
    final colorBorde =
    configurado ? ArenaColors.deClase(clase!) : ArenaColors.borde;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ArenaColors.superficie,
        border: Border.all(color: ArenaColors.borde),
        borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
      ),
      child: Row(
        children: [
          // Avatar redondo con borde del color de la clase
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colorBorde, width: 2),
            ),
            child: ClipOval(
              child: configurado
                  ? Image.asset(
                ArenaAssets.avatar(clase!),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.person),
              )
                  : const Icon(Icons.person),
            ),
          ),
          const SizedBox(width: 12),

          // Nick + clase y resultados
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jugador.nick,
                  style: ArenaTextos.subtitulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  configurado
                      ? '${nombreClase(jugador.clase)} · ${jugador.victorias}V · ${jugador.derrotas}D'
                      : 'Sin personaje',
                  style: ArenaTextos.cuerpoSuave,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Puntos
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
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

/// Escena: fondo + plataforma + personaje (o «?» si no hay personaje).
class _Escena extends StatelessWidget {
  const _Escena({required this.clase});

  final String? clase;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
      child: SizedBox(
        height: 220,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              ArenaAssets.fondo,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
              const ColoredBox(color: ArenaColors.superficie),
            ),
            Align(
              alignment: const Alignment(0, 0.75),
              child: Image.asset(
                ArenaAssets.plataforma,
                width: 200,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
            if (clase != null)
              Align(
                alignment: const Alignment(0, 0.35),
                child: Image.asset(
                  ArenaAssets.personaje(clase!),
                  height: 150,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              )
            else
              const Align(
                alignment: Alignment(0, -0.2),
                child: Text(
                  '?',
                  style: TextStyle(fontSize: 64, color: Colors.white54),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Botón del menú: icono + texto. `onTap == null` → desactivado.
class _Opcion extends StatelessWidget {
  const _Opcion({
    required this.icono,
    required this.texto,
    required this.onTap,
    this.resaltado = false,
  });

  final String icono;
  final String texto;
  final VoidCallback? onTap;
  final bool resaltado;

  @override
  Widget build(BuildContext context) {
    final dorado = Theme.of(context).colorScheme.primary;
    final activo = onTap != null;

    return Opacity(
      opacity: activo ? 1 : 0.4,
      child: Material(
        color: ArenaColors.superficie,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
          side: BorderSide(
            color: resaltado ? dorado : ArenaColors.borde,
            width: resaltado ? 1.5 : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icono, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 6),
              Text(
                texto,
                style: ArenaTextos.cuerpo.copyWith(
                  color: resaltado ? dorado : null,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
