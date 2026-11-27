
import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../theme/arena_assets.dart';
import '../../theme/arena_theme.dart';
import '../../utils/clase_visual.dart';
import '../app/routes.dart';

// ======================================================
// CONTENIDO PRINCIPAL
// ======================================================

class ContenidoInicio extends StatelessWidget {
  const ContenidoInicio({
    super.key,
    required this.jugador,
    required this.alVolver,
  });

  final Jugador jugador;
  final VoidCallback alVolver;

  // TODO 6: NAVEGACIÓN
  Future<void> _ir(BuildContext context, String ruta) async {
    await Navigator.pushNamed(context, ruta);
    alVolver();
  }

  @override
  Widget build(BuildContext context) {
    final clase = claseVisual(jugador.clase);

    // TODO 1: ESTRUCTURA PRINCIPAL
    return ListView(
      padding: const EdgeInsets.all(ArenaMedidas.s16),
      children: [
        // TODO 2: TARJETA DEL JUGADOR
        _TarjetaJugador(jugador: jugador),

        const SizedBox(height: ArenaMedidas.s16),

        // TODO 3: ESCENA
        _Escena(
          clase: clase,
          configurado: jugador.configurado,
        ),

        const SizedBox(height: ArenaMedidas.s16),

        // TODO 4: AVISO CONDICIONAL
        if (!jugador.configurado)
          Text(
            'Aún no tienes personaje. Créalo para poder combatir.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),

        const SizedBox(height: ArenaMedidas.s16),

        // TODO 5: MENÚ
        _MenuInicio(
          configurado: jugador.configurado,
          ir: (ruta) => _ir(context, ruta),
        ),
      ],
    );
  }
}

// ======================================================
// TODO 2: TARJETA DEL JUGADOR
// ======================================================

class _TarjetaJugador extends StatelessWidget {
  const _TarjetaJugador({
    required this.jugador,
  });

  final Jugador jugador;

  @override
  Widget build(BuildContext context) {
    final clase = claseVisual(jugador.clase);

    final colorClase = jugador.configurado
        ? ArenaColors.deClase(clase)
        : Colors.grey;

    return Container(
      padding: const EdgeInsets.all(ArenaMedidas.s16),

      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,

        borderRadius: BorderRadius.circular(
          ArenaMedidas.radioTarjeta,
        ),

        border: Border.all(
          color: colorClase,
          width: 2,
        ),
      ),

      child: Row(
        children: [
          // AVATAR
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colorClase,
                width: 2,
              ),
            ),

            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.black,

              child: ClipOval(
                child: jugador.configurado
                    ? Image.asset(
                  ArenaAssets.avatar(clase),
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,

                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.person,
                      size: 35,
                      color: Colors.white,
                    );
                  },
                )
                    : const Icon(
                  Icons.person,
                  size: 35,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(width: ArenaMedidas.s16),

          // INFORMACIÓN DEL JUGADOR
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jugador.nick,
                  style: ArenaTextos.cuerpo,
                ),

                const SizedBox(height: 4),

                Text(
                  jugador.configurado
                      ? '${nombreClase(jugador.clase)} · '
                      '${jugador.victorias} V · '
                      '${jugador.derrotas} D'
                      : 'Sin personaje',

                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // PUNTOS
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${jugador.puntos}',
                style: ArenaTextos.puntos,
              ),

              Text(
                'puntos',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ======================================================
// TODO 3: ESCENA DEL PERSONAJE
// ======================================================

class _Escena extends StatelessWidget {
  const _Escena({
    required this.clase,
    required this.configurado,
  });

  final String clase;
  final bool configurado;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        ArenaMedidas.radioTarjeta,
      ),

      child: SizedBox(
        height: 220,
        width: double.infinity,

        child: Stack(
          children: [
            // FONDO
            Positioned.fill(
              child: Image.asset(
                ArenaAssets.fondo,
                fit: BoxFit.cover,

                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Theme.of(context).colorScheme.surface,
                  );
                },
              ),
            ),

            // PLATAFORMA
            Align(
              alignment: Alignment.bottomCenter,

              child: Image.asset(
                ArenaAssets.plataforma,
                width: 170,
                fit: BoxFit.contain,

                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox.shrink();
                },
              ),
            ),

            // PERSONAJE
            if (configurado)
              Align(
                alignment: Alignment.bottomCenter,

                child: Image.asset(
                  ArenaAssets.personaje(clase),
                  height: 170,
                  fit: BoxFit.contain,

                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.white,
                    );
                  },
                ),
              )
            else
              const Align(
                alignment: Alignment.center,

                child: Icon(
                  Icons.question_mark,
                  size: 80,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// TODO 5: MENÚ PRINCIPAL
// ======================================================

class _MenuInicio extends StatelessWidget {
  const _MenuInicio({
    required this.configurado,
    required this.ir,
  });

  final bool configurado;
  final Function(String) ir;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,

      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      mainAxisSpacing: 8,
      crossAxisSpacing: 8,

      childAspectRatio: 1.8,

      children: [
        // COMBATIR
        _Opcion(
          texto: 'Combatir',
          icono: ArenaAssets.combate,

          alPulsar: configurado
              ? () => ir(Routes.rival)
              : null,
        ),

        // PERSONAJE
        _Opcion(
          texto: 'Mi personaje',
          icono: ArenaAssets.iconoPersonaje,

          resaltado: !configurado,

          alPulsar: () => ir(Routes.personaje),
        ),

        // RANKING
        _Opcion(
          texto: 'Ranking',
          icono: ArenaAssets.ranking,

          alPulsar: () => ir(Routes.ranking),
        ),

        // HISTORIAL
        _Opcion(
          texto: 'Historial',
          icono: ArenaAssets.historial,

          alPulsar: () => ir(Routes.historial),
        ),
      ],
    );
  }
}

// ======================================================
// BOTÓN INDIVIDUAL
// ======================================================

class _Opcion extends StatelessWidget {
  const _Opcion({
    required this.texto,
    required this.icono,
    required this.alPulsar,
    this.resaltado = false,
  });

  final String texto;
  final String icono;
  final VoidCallback? alPulsar;
  final bool resaltado;

  @override
  Widget build(BuildContext context) {
    final activado = alPulsar != null;

    final colorTexto = !activado
        ? Colors.grey
        : resaltado
        ? Colors.amber
        : Theme.of(context).colorScheme.onSurface;

    return Opacity(
      opacity: activado ? 1.0 : 0.45,

      child: Material(
        color: Theme.of(context).colorScheme.surface,

        borderRadius: BorderRadius.circular(
          ArenaMedidas.radioTarjeta,
        ),

        child: InkWell(
          onTap: alPulsar,

          borderRadius: BorderRadius.circular(
            ArenaMedidas.radioTarjeta,
          ),

          child: Container(
            padding: const EdgeInsets.all(8),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                ArenaMedidas.radioTarjeta,
              ),

              border: Border.all(
                color: resaltado
                    ? Colors.amber
                    : Colors.grey,

                width: resaltado ? 2 : 1,
              ),
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                // ICONO
                Image.asset(
                  icono,
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,

                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.image_not_supported,
                      size: 32,
                      color: colorTexto,
                    );
                  },
                ),

                const SizedBox(height: 4),

                // TEXTO
                Text(
                  texto,
                  textAlign: TextAlign.center,

                  style: ArenaTextos.cuerpo.copyWith(
                    color: colorTexto,
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
