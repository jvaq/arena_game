import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../models/models.dart';
import '../../theme/arena_assets.dart';
import '../../theme/arena_theme.dart';
import '../../utils/clase_visual.dart';

class ContenidoInicio extends StatelessWidget {
  const ContenidoInicio({
    super.key,
    required this.jugador,
    required this.alVolver,
  });

  final Jugador jugador;
  final VoidCallback alVolver;

  Future<void> _ir(BuildContext context, String ruta) async {
    await Navigator.pushNamed(context, ruta);
    alVolver();
  }

  @override
  Widget build(BuildContext context) {
    final clase = claseVisual(jugador.clase);
    final configurado = jugador.configurado;

    return ListView(
      padding: const EdgeInsets.all(ArenaMedidas.s16),
      children: [
        _TarjetaJugador(jugador: jugador, clase: clase, configurado: configurado),
        const SizedBox(height: ArenaMedidas.s16),
        _Escena(clase: clase, configurado: configurado),
        if (!configurado) ...[
          const SizedBox(height: ArenaMedidas.s16),
          const Text(
            'Aún no tienes personaje. Créalo para poder combatir.',
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: ArenaMedidas.s16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: ArenaMedidas.s16,
          crossAxisSpacing: ArenaMedidas.s16,
          childAspectRatio: 1.4,
          children: [
            _Opcion(
              icono: Icons.sports_esports,
              texto: 'Combatir',
              habilitado: configurado,
              destacado: false,
              onTap: () => _ir(context, Routes.rival),
            ),
            _Opcion(
              icono: Icons.shield,
              texto: 'Mi personaje',
              habilitado: true,
              destacado: !configurado,
              onTap: () => _ir(context, Routes.personaje),
            ),
            _Opcion(
              icono: Icons.emoji_events,
              texto: 'Ranking',
              habilitado: true,
              destacado: false,
              onTap: () => _ir(context, Routes.ranking),
            ),
            _Opcion(
              icono: Icons.history,
              texto: 'Historial',
              habilitado: true,
              destacado: false,
              onTap: () => _ir(context, Routes.historial),
            ),
          ],
        ),
      ],
    );
  }
}

class _TarjetaJugador extends StatelessWidget {
  const _TarjetaJugador({
    required this.jugador,
    required this.clase,
    required this.configurado,
  });

  final Jugador jugador;
  final String clase;
  final bool configurado;

  @override
  Widget build(BuildContext context) {
    final colorClase = ArenaColors.deClase(clase);

    return Container(
      padding: const EdgeInsets.all(ArenaMedidas.s16),
      decoration: BoxDecoration(
        color: ArenaColors.superficie,
        borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
        border: Border.all(color: ArenaColors.borde),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colorClase, width: 2),
            ),
            child: ClipOval(
              child: configurado
                  ? Image.asset(
                ArenaAssets.avatar(clase),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.person),
              )
                  : const Icon(Icons.person),
            ),
          ),
          const SizedBox(width: ArenaMedidas.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(jugador.nick, style: ArenaTextos.subtitulo),
                const SizedBox(height: 4),
                Text(
                  configurado
                      ? '${nombreClase(jugador.clase)} · ${jugador.victorias}V · ${jugador.derrotas}D'
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
              const Text('puntos'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Escena extends StatelessWidget {
  const _Escena({required this.clase, required this.configurado});

  final String clase;
  final bool configurado;

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
              const ColoredBox(color: Color(0xFF140F26)),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Image.asset(
                  ArenaAssets.plataforma,
                  width: 180,
                  errorBuilder: (_, __, ___) => const SizedBox(height: 24),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: configurado
                    ? Image.asset(
                  ArenaAssets.personaje(clase),
                  height: 140,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.person, size: 80),
                )
                    : const Icon(
                  Icons.help_outline,
                  size: 72,
                  color: Colors.white70,
                ),
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
    required this.habilitado,
    required this.destacado,
    required this.onTap,
  });

  final IconData icono;
  final String texto;
  final bool habilitado;
  final bool destacado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorBorde = destacado
        ? ArenaColors.dorado
        : ArenaColors.borde;
    final colorContenido = !habilitado
        ? Colors.white38
        : (destacado ? ArenaColors.dorado : Colors.white);

    return Opacity(
      opacity: habilitado ? 1.0 : 0.5,
      child: InkWell(
        onTap: habilitado ? onTap : null,
        borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
        child: Container(
          decoration: BoxDecoration(
            color: ArenaColors.superficie,
            borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
            border: Border.all(color: colorBorde),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icono, color: colorContenido, size: 28),
              const SizedBox(height: 8),
              Text(
                texto,
                style: TextStyle(color: colorContenido),
              ),
            ],
          ),
        ),
      ),
    );
  }
}