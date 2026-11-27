import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../models/models.dart';
import '../theme/arena_assets.dart';
import '../theme/arena_theme.dart';
import '../utils/clase_visual.dart';

/// Ejercicio 3: tarjeta, escena y menú para los dos estados del jugador.
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
    if (context.mounted) alVolver();
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(ArenaMedidas.s16),
    children: [
      _TarjetaJugador(jugador: jugador),
      const SizedBox(height: ArenaMedidas.s8),
      _Escena(jugador: jugador),
      if (!jugador.configurado) ...[
        const SizedBox(height: ArenaMedidas.s8),
        Text(
          'Aún no tienes personaje. Créalo para poder combatir.',
          textAlign: TextAlign.center,
          style: ArenaTextos.cuerpoSuave,
        ),
      ],
      SizedBox(
        height: jugador.configurado ? ArenaMedidas.s16 : ArenaMedidas.s8,
      ),
      GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: ArenaMedidas.s8 + ArenaMedidas.s4,
        mainAxisSpacing: ArenaMedidas.s8 + ArenaMedidas.s4,
        childAspectRatio: ArenaMedidas.proporcionMenuInicio,
        children: [
          _Opcion(
            texto: 'Combatir',
            simbolo: '⚔',
            monocromo: true,
            alPulsar: jugador.configurado
                ? () => _ir(context, Routes.rival)
                : null,
          ),
          _Opcion(
            texto: 'Mi personaje',
            icono: Icons.shield_outlined,
            destacada: !jugador.configurado,
            alPulsar: () => _ir(context, Routes.personaje),
          ),
          _Opcion(
            texto: 'Ranking',
            imagen: ArenaAssets.trofeo,
            alPulsar: () => _ir(context, Routes.ranking),
          ),
          _Opcion(
            texto: 'Historial',
            simbolo: '📜',
            alPulsar: () => _ir(context, Routes.historial),
          ),
        ],
      ),
    ],
  );
}

class _TarjetaJugador extends StatelessWidget {
  const _TarjetaJugador({required this.jugador});
  final Jugador jugador;

  @override
  Widget build(BuildContext context) {
    final clase = claseVisual(jugador.clase);
    const avatar = ArenaMedidas.s32 + ArenaMedidas.s8;
    return Container(
      padding: const EdgeInsets.all(ArenaMedidas.s16),
      decoration: BoxDecoration(
        color: ArenaColors.superficie,
        borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
        border: Border.all(
          color: ArenaColors.borde,
          width: ArenaMedidas.grosorBorde,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(ArenaMedidas.s4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: jugador.configurado
                    ? ArenaColors.deClase(clase)
                    : ArenaColors.borde,
                width: ArenaMedidas.grosorBorde,
              ),
            ),
            child: ClipOval(
              child: jugador.configurado
                  ? Image.asset(
                      ArenaAssets.avatar(clase),
                      width: avatar,
                      height: avatar,
                      fit: BoxFit.cover,
                      errorBuilder: (_, error, stackTrace) => const Icon(
                        Icons.person,
                        size: avatar,
                        color: ArenaColors.caballero,
                      ),
                    )
                  : const Icon(
                      Icons.person,
                      size: avatar,
                      color: ArenaColors.caballero,
                    ),
            ),
          ),
          const SizedBox(width: ArenaMedidas.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jugador.nick,
                  style: ArenaTextos.subtitulo,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  jugador.configurado
                      ? '${nombreClase(jugador.clase)} · ${jugador.victorias} V · ${jugador.derrotas} D'
                      : 'Sin personaje',
                  style: ArenaTextos.cuerpoSuave,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: ArenaMedidas.s8),
          Column(
            children: [
              Text('${jugador.puntos}', style: ArenaTextos.puntos),
              Text('puntos', style: ArenaTextos.etiqueta),
            ],
          ),
        ],
      ),
    );
  }
}

class _Escena extends StatelessWidget {
  const _Escena({required this.jugador});
  final Jugador jugador;

  // Son las armas decorativas del ejemplo del PDF; no guardan una selección.
  List<String> _armasDeLaMaqueta(String clase) {
    switch (clase) {
      case 'mago':
        return [
          ArenaAssets.arma(clase, 'baston_fuego'),
          ArenaAssets.arma(clase, 'libro'),
        ];
      case 'orco':
        return [
          ArenaAssets.arma(clase, 'hacha_doble'),
          ArenaAssets.arma(clase, 'martillo'),
        ];
      default:
        return [
          ArenaAssets.arma(clase, 'espada'),
          ArenaAssets.arma(clase, 'hacha'),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final clase = claseVisual(jugador.clase);
    final armas = _armasDeLaMaqueta(clase);
    return ClipRRect(
      borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
      child: SizedBox(
        height: ArenaMedidas.escenaInicio,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              ArenaAssets.fondo,
              fit: BoxFit.cover,
              errorBuilder: (_, error, stackTrace) =>
                  const ColoredBox(color: ArenaColors.superficie),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                ArenaAssets.plataforma,
                width: ArenaMedidas.escenaInicio,
                errorBuilder: (_, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),
            Align(
              alignment: jugador.configurado
                  ? Alignment.center
                  : const Alignment(0, -0.2),
              child: jugador.configurado
                  ? Image.asset(
                      ArenaAssets.personaje(clase),
                      height: ArenaMedidas.personajeInicio,
                      errorBuilder: (_, error, stackTrace) => const Icon(
                        Icons.person,
                        size: ArenaMedidas.s32 * 2,
                        color: ArenaColors.textoSuave,
                      ),
                    )
                  : const Icon(
                      Icons.question_mark,
                      size: ArenaMedidas.s32 * 2,
                      color: ArenaColors.textoSuave,
                    ),
            ),
            if (jugador.configurado) ...[
              Positioned(
                left: ArenaMedidas.s32,
                bottom: ArenaMedidas.s32,
                child: _ArmaDecorativa(ruta: armas[0]),
              ),
              Positioned(
                right: ArenaMedidas.s32,
                bottom: ArenaMedidas.s32,
                child: _ArmaDecorativa(ruta: armas[1]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ArmaDecorativa extends StatelessWidget {
  const _ArmaDecorativa({required this.ruta});
  final String ruta;

  @override
  Widget build(BuildContext context) => Image.asset(
    ruta,
    width: ArenaMedidas.s32 * 2,
    height: ArenaMedidas.s32 * 2,
    fit: BoxFit.contain,
    excludeFromSemantics: true,
    errorBuilder: (_, error, stackTrace) => const SizedBox.shrink(),
  );
}

class _Opcion extends StatelessWidget {
  const _Opcion({
    required this.texto,
    this.icono,
    this.simbolo,
    this.monocromo = false,
    this.imagen,
    this.alPulsar,
    this.destacada = false,
  });

  final String texto;
  final IconData? icono;
  final String? simbolo;
  final bool monocromo;
  final String? imagen;
  final VoidCallback? alPulsar;
  final bool destacada;

  @override
  Widget build(BuildContext context) {
    final color = alPulsar == null
        ? ArenaColors.textoSuave
        : destacada
        ? ArenaColors.dorado
        : ArenaColors.texto;
    Widget dibujo;
    if (imagen != null) {
      dibujo = Image.asset(
        imagen!,
        width: ArenaMedidas.s32,
        height: ArenaMedidas.s32,
        errorBuilder: (_, error, stackTrace) =>
            Icon(Icons.emoji_events_outlined, color: color),
      );
    } else if (simbolo != null) {
      dibujo = Text(
        simbolo!,
        style: ArenaTextos.cuerpo.copyWith(
          fontSize: ArenaMedidas.s24,
          color: color,
        ),
      );
      if (monocromo) {
        dibujo = ColorFiltered(
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          child: dibujo,
        );
      }
    } else {
      dibujo = Icon(icono, size: ArenaMedidas.s24, color: color);
    }
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: alPulsar == null
            ? ArenaColors.fondo
            : ArenaColors.superficie,
        foregroundColor: color,
        disabledForegroundColor: ArenaColors.textoSuave,
        side: BorderSide(
          color: destacada ? ArenaColors.dorado : ArenaColors.borde,
          width: ArenaMedidas.grosorBorde,
        ),
        padding: const EdgeInsets.all(ArenaMedidas.s8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
        ),
      ),
      onPressed: alPulsar,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: ArenaMedidas.s32,
            child: Center(child: ExcludeSemantics(child: dibujo)),
          ),
          const SizedBox(height: ArenaMedidas.s4),
          Text(
            texto,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: ArenaTextos.cuerpoSuave.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
