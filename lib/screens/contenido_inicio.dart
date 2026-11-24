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
class ContenidoInicio extends StatelessWidget {
  const ContenidoInicio({super.key, required this.jugador, required this.alVolver});

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
    final clase = claseVisual(jugador.clase);

    return ListView(
      padding: const EdgeInsets.all(ArenaMedidas.s16),
      children: [
        // TODO 2: TARJETA DEL JUGADOR
        _TarjetaJugador(jugador: jugador, clase: clase),

        const SizedBox(height: ArenaMedidas.s16),

        // TODO 3: ESCENA
        _Escena(jugador: jugador, clase: clase),

        // TODO 4: Aviso si !jugador.configurado
        if (!jugador.configurado) ...[
          const SizedBox(height: ArenaMedidas.s16),
          Text(
            'Aún no tienes personaje. Créalo para poder combatir.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],

        const SizedBox(height: ArenaMedidas.s24),

        // TODO 5: MENÚ 2×2 (GridView.count con shrinkWrap y NeverScrollableScrollPhysics)
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: ArenaMedidas.s16,
          mainAxisSpacing: ArenaMedidas.s16,
          childAspectRatio: 1.3,
          children: [
            _Opcion(
              titulo: 'Combatir',
              icono: Icons.sports_kabaddi,
              desactivado: !jugador.configurado,
              onTap: () => _ir(context, Routes.rival),
            ),
            _Opcion(
              titulo: 'Mi personaje',
              icono: Icons.shield,
              resaltado: !jugador.configurado,
              onTap: () => _ir(context, Routes.personaje),
            ),
            _Opcion(
              titulo: 'Ranking',
              icono: Icons.leaderboard,
              onTap: () => _ir(context, Routes.ranking),
            ),
            _Opcion(
              titulo: 'Historial',
              icono: Icons.history,
              onTap: () => _ir(context, Routes.historial),
            ),
          ],
        ),
      ],
    );
  }
}

/// Widget auxiliar para la Tarjeta del Jugador (TODO 2)
class _TarjetaJugador extends StatelessWidget {
  const _TarjetaJugador({required this.jugador, required this.clase});

  final Jugador jugador;
  final String? clase;

  @override
  Widget build(BuildContext context) {
    final colorBorde = clase != null ? ArenaColors.deClase(clase!) : Colors.grey;

    return Container(
      padding: const EdgeInsets.all(ArenaMedidas.s16),
      decoration: BoxDecoration(
        color: ArenaColors.superficie,
        borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
        border: Border.all(color: colorBorde, width: 2),
      ),
      child: Row(
        children: [
          // Avatar o Icono por defecto
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colorBorde, width: 2),
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.black26,
              backgroundImage: jugador.configurado
                  ? AssetImage(ArenaAssets.avatar(clase!))
                  : null,
              onBackgroundImageError: jugador.configurado
                  ? (exception, stackTrace) {}
                  : null,
              child: !jugador.configurado
                  ? const Icon(Icons.person, size: 30, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: ArenaMedidas.s16),

          // Información del jugador
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jugador.nick,
                  style: ArenaTextos.subtitulo.copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  jugador.configurado
                      ? '${nombreClase(jugador.clase)} · ${jugador.victorias}V · ${jugador.derrotas}D'
                      : 'Sin personaje',
                  style: ArenaTextos.cuerpo.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),

          // Puntos
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${jugador.puntos}',
                style: ArenaTextos.puntos ?? const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text('puntos', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Widget auxiliar para la Escena del personaje (TODO 3)
class _Escena extends StatelessWidget {
  const _Escena({required this.jugador, required this.clase});

  final Jugador jugador;
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
            // Fondo
            Image.asset(
              ArenaAssets.fondo,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: Colors.blueGrey),
            ),
            // Plataforma
            Image.asset(
              ArenaAssets.plataforma,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox(),
            ),
            // Personaje o Interrogación
            if (jugador.configurado && clase != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  ArenaAssets.personaje(clase!),
                  height: 160,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.person, size: 80, color: Colors.white),
                ),
              )
            else
              const Center(
                child: Icon(Icons.help_outline, size: 64, color: Colors.white70),
              ),
          ],
        ),
      ),
    );
  }
}

/// Widget auxiliar para cada opción del menú 2x2 (TODO 5)
class _Opcion extends StatelessWidget {
  const _Opcion({
    required this.titulo,
    required this.icono,
    required this.onTap,
    this.desactivado = false,
    this.resaltado = false,
  });

  final String titulo;
  final IconData icono;
  final VoidCallback onTap;
  final bool desactivado;
  final bool resaltado;

  @override
  Widget build(BuildContext context) {
    final colorFondo = resaltado ? Colors.amber.shade800 : ArenaColors.superficie;

    return InkWell(
      onTap: desactivado ? null : onTap,
      borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
      child: Opacity(
        opacity: desactivado ? 0.5 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: colorFondo,
            borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
            border: Border.all(
              color: resaltado ? Colors.amber : Colors.white24,
              width: resaltado ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icono, size: 36, color: resaltado ? Colors.white : Colors.amber),
              const SizedBox(height: 8),
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: resaltado ? Colors.white : Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}