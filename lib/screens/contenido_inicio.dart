import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../models/models.dart';
import '../../theme/arena_assets.dart';
import '../../theme/arena_theme.dart';
import '../../utils/clase_visual.dart';

class ContenidoInicio extends StatelessWidget {
  const ContenidoInicio({super.key, required this.jugador, required this.alVolver});

  final Jugador jugador;

  final VoidCallback alVolver;

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
        _TarjetaJugador(jugador: jugador, clase: clase),
        const SizedBox(height: ArenaMedidas.s16),
        _Escena(configurado: jugador.configurado, clase: clase),

        if (!jugador.configurado) ...[
          const SizedBox(height: ArenaMedidas.s16),
          Text(
            'Aún no tienes personaje. Créalo para poder combatir.',
            textAlign: TextAlign.center,
            style: ArenaTextos.cuerpoSuave,
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
              icono: Icons.flash_on,
              texto: 'Combatir',
              onTap: jugador.configurado
                  ? () => _ir(context, Routes.rival)
                  : null,
            ),
            _Opcion(
              icono: Icons.shield_outlined,
              texto: 'Mi personaje',
              resaltada: !jugador.configurado,
              onTap: () => _ir(context, Routes.personaje),
            ),
            _Opcion(
              icono: Icons.emoji_events,
              texto: 'Ranking',
              onTap: () => _ir(context, Routes.ranking),
            ),
            _Opcion(
              icono: Icons.history_edu,
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
  final String clase;

  @override
  Widget build(BuildContext context) {
    final configurado = jugador.configurado;
    final colorBorde = configurado ? ArenaColors.deClase(clase) : ArenaColors.textoSuave;

    return Container(
      padding: const EdgeInsets.all(ArenaMedidas.s16),
      decoration: BoxDecoration(
        color: ArenaColors.superficie,
        border: Border.all(color: ArenaColors.borde, width: ArenaMedidas.grosorBorde),
        borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colorBorde, width: ArenaMedidas.grosorBordeSeleccion),
            ),
            child: ClipOval(
              child: configurado
                  ? Image.asset(
                ArenaAssets.avatar(clase),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.person, color: ArenaColors.textoSuave),
              )
                  : const Icon(Icons.person, color: ArenaColors.textoSuave),
            ),
          ),
          const SizedBox(width: ArenaMedidas.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(jugador.nick, style: ArenaTextos.subtitulo),
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
            mainAxisSize: MainAxisSize.min,
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
              errorBuilder: (_, __, ___) => const ColoredBox(color: Colors.black),
            ),
            Align(
              alignment: const Alignment(0, 0.7),
              child: Image.asset(
                ArenaAssets.plataforma,
                width: 200,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.35),
              child: configurado
                  ? Image.asset(
                ArenaAssets.personaje(clase),
                height: 150,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              )
                  : const Icon(
                Icons.question_mark,
                size: 64,
                color: ArenaColors.textoSuave,
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
    this.resaltada = false,
  });

  final IconData icono;
  final String texto;
  final VoidCallback? onTap;
  final bool resaltada;

  @override
  Widget build(BuildContext context) {
    final activa = onTap != null;
    final estilo = resaltada
        ? ArenaTextos.cuerpo.copyWith(color: ArenaColors.dorado)
        : ArenaTextos.cuerpo;
    final forma = BorderRadius.circular(ArenaMedidas.radioTarjeta);

    return Opacity(
      opacity: activa ? 1 : 0.4,
      child: Material(
        color: ArenaColors.superficie,
        shape: RoundedRectangleBorder(
          borderRadius: forma,
          side: BorderSide(
            color: resaltada ? ArenaColors.dorado : ArenaColors.borde,
            width: resaltada
                ? ArenaMedidas.grosorBordeSeleccion
                : ArenaMedidas.grosorBorde,
          ),
        ),
        child: InkWell(
          borderRadius: forma,
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icono, color: estilo.color),
              const SizedBox(height: ArenaMedidas.s16),
              Text(texto, style: estilo),
            ],
          ),
        ),
      ),
    );
  }
}