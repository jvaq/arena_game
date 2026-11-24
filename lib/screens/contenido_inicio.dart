import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../models/models.dart';
import '../theme/arena_assets.dart';
import '../theme/arena_theme.dart';
import '../utils/clase_visual.dart';

/// EJERCICIO 3 · Contenido del Inicio: DISEÑO + NAVEGACIÓN.
class ContenidoInicio extends StatelessWidget {
  const ContenidoInicio({super.key, required this.jugador, required this.alVolver});

  final Jugador jugador;

  /// Llámala al volver de otra pantalla para recargar los datos.
  final VoidCallback alVolver;

  // TODO 6 (navegación): abre una ruta y, al volver, recarga los datos
  Future<void> _ir(BuildContext context, String ruta) async {
    await Navigator.pushNamed(context, ruta);
    alVolver();
  }

  @override
  Widget build(BuildContext context) {
    final clase = claseVisual(jugador.clase);

    // TODO 1: ListView con padding s16 y, en orden: tarjeta, escena, aviso y menú
    return ListView(
      padding: const EdgeInsets.all(ArenaMedidas.s16),
      children: [
        _TarjetaJugador(jugador: jugador, clase: clase),
        const SizedBox(height: ArenaMedidas.s16),
        _Escena(configurado: jugador.configurado, clase: clase),
        const SizedBox(height: ArenaMedidas.s16),

        // TODO 4: aviso solo si no hay personaje
        if (!jugador.configurado)
          Padding(
            padding: const EdgeInsets.only(bottom: ArenaMedidas.s16),
            child: Text(
              'Aún no tienes personaje. Créalo para poder combatir.',
              style: ArenaTextos.cuerpoSuave,
              textAlign: TextAlign.center,
            ),
          ),

        // TODO 5: menú 2×2
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: ArenaMedidas.s16,
          crossAxisSpacing: ArenaMedidas.s16,
          childAspectRatio: 1.4,
          children: [
            _Opcion(
              icono: Icons.sports_kabaddi,
              texto: 'Combatir',
              onTap: jugador.configurado
                  ? () => _ir(context, Routes.rival)
                  : null,
            ),
            _Opcion(
              icono: Icons.shield_outlined,
              texto: 'Mi personaje',
              resaltado: !jugador.configurado,
              onTap: () => _ir(context, Routes.personaje),
            ),
            _Opcion(
              icono: Icons.emoji_events_outlined,
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

/// TODO 2: tarjeta del jugador
class _TarjetaJugador extends StatelessWidget {
  const _TarjetaJugador({required this.jugador, required this.clase});

  final Jugador jugador;
  final String clase;

  @override
  Widget build(BuildContext context) {
    final subtitulo = jugador.configurado
        ? '${nombreClase(jugador.clase)} · ${jugador.victorias}V · ${jugador.derrotas}D'
        : 'Sin personaje';

    return Container(
      padding: const EdgeInsets.all(ArenaMedidas.s16),
      decoration: BoxDecoration(
        color: ArenaColors.superficie,
        border: Border.all(color: ArenaColors.borde),
        borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: jugador.configurado
                    ? ArenaColors.deClase(clase)
                    : ArenaColors.borde,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: jugador.configurado
                  ? Image.asset(
                ArenaAssets.avatar(clase),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(Icons.person),
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
                Text(subtitulo, style: ArenaTextos.cuerpoSuave),
              ],
            ),
          ),
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

/// TODO 3: escena con fondo, plataforma y personaje
class _Escena extends StatelessWidget {
  const _Escena({required this.configurado, required this.clase});

  final bool configurado;
  final String clase;

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
              errorBuilder: (_, _, _) => const ColoredBox(color: Colors.black),
            ),
            Align(
              alignment: const Alignment(0, 0.7),
              child: Image.asset(
                ArenaAssets.plataforma,
                width: 200,
                errorBuilder: (_, _, _) => const SizedBox(),
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.2),
              child: configurado
                  ? Image.asset(
                ArenaAssets.personaje(clase),
                height: 150,
                errorBuilder: (_, _, _) => const Icon(Icons.person, size: 100),
              )
                  : const Icon(Icons.question_mark, size: 64, color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }
}

/// TODO 5: botón del menú (icono + texto)
class _Opcion extends StatelessWidget {
  const _Opcion({
    required this.icono,
    required this.texto,
    required this.onTap,
    this.resaltado = false,
  });

  final IconData icono;
  final String texto;
  final VoidCallback? onTap;
  final bool resaltado;

  @override
  Widget build(BuildContext context) {
    final desactivado = onTap == null;
    final color = resaltado
        ? ArenaColors.dorado
        : (desactivado ? Colors.white38 : Colors.white);

    return Material(
      color: ArenaColors.superficie,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
        side: BorderSide(color: resaltado ? ArenaColors.dorado : ArenaColors.borde),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, color: color, size: 28),
            const SizedBox(height: ArenaMedidas.s8),
            Text(texto, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}