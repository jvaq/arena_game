import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../models/models.dart';
import '../theme/arena_assets.dart';
import '../theme/arena_theme.dart';
import '../utils/clase_visual.dart';

/// EJERCICIO 3 · Contenido del Inicio: DISEÑO + NAVEGACIÓN.
///
/// Los datos ya llegan cargados en [jugador] (lo hace `pantalla_inicio.dart`).
/// La pantalla tiene 4 partes, de arriba a abajo:
///   1. Tarjeta del jugador   (_TarjetaJugador)
///   2. Escena con el personaje (_Escena)
///   3. Aviso «sin personaje» (solo si !configurado)
///   4. Menú 2x2 con 4 botones (_Opcion)
class ContenidoInicio extends StatelessWidget {
  const ContenidoInicio({
    super.key,
    required this.jugador,
    required this.alVolver,
  });

  final Jugador jugador;

  /// Se llama al volver de otra pantalla para recargar los datos.
  final VoidCallback alVolver;

  // TODO 6 (navegación): abre una ruta con nombre y, cuando el usuario
  // vuelve con «atrás», recarga los datos del Inicio.
  Future<void> _ir(BuildContext context, String ruta) async {
    await Navigator.pushNamed(context, ruta);
    alVolver();
  }

  @override
  Widget build(BuildContext context) {
    // TODO 1: ListView con padding s16 y las 4 partes en orden.
    return ListView(
      padding: const EdgeInsets.all(ArenaMedidas.s16),
      children: [
        // TODO 2: tarjeta del jugador
        _TarjetaJugador(jugador: jugador),
        const SizedBox(height: ArenaMedidas.s16),

        // TODO 3: escena
        _Escena(jugador: jugador),
        const SizedBox(height: ArenaMedidas.s8),

        // TODO 4: aviso, solo si todavía no tiene personaje
        if (!jugador.configurado)
          Padding(
            padding: const EdgeInsets.only(bottom: ArenaMedidas.s8),
            child: Text(
              'Aún no tienes personaje. Créalo para poder combatir.',
              textAlign: TextAlign.center,
              style: ArenaTextos.etiqueta,
            ),
          ),

        // TODO 5: menú 2x2
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: ArenaMedidas.s8,
          crossAxisSpacing: ArenaMedidas.s8,
          childAspectRatio: 1.5,
          children: [
            _Opcion(
              emoji: '⚔',
              texto: 'Combatir',
              activo: jugador.configurado,
              alPulsar: () {
                _ir(context, Routes.rival);
              },
            ),
            _Opcion(
              emoji: '🛡',
              texto: 'Mi personaje',
              resaltado: !jugador.configurado,
              alPulsar: () {
                _ir(context, Routes.personaje);
              },
            ),
            _Opcion(
              emoji: '🏆',
              texto: 'Ranking',
              alPulsar: () {
                _ir(context, Routes.ranking);
              },
            ),
            _Opcion(
              emoji: '📜',
              texto: 'Historial',
              alPulsar: () {
                _ir(context, Routes.historial);
              },
            ),
          ],
        ),
      ],
    );
  }
}

/// Tarjeta de arriba: avatar + nick + «Mago · 21V · 3D» + puntos.
class _TarjetaJugador extends StatelessWidget {
  const _TarjetaJugador({required this.jugador});

  final Jugador jugador;

  /// Avatar redondo. Con personaje: su imagen con borde del color de la clase.
  /// Sin personaje: un icono de persona.
  Widget _construirAvatar() {
    if (!jugador.configurado) {
      return Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: ArenaColors.superficieAlta,
        ),
        child: const Icon(Icons.person, color: ArenaColors.textoSuave),
      );
    }

    final clase = claseVisual(jugador.clase);
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: ArenaColors.deClase(clase),
          width: ArenaMedidas.grosorBordeSeleccion,
        ),
      ),
      child: ClipOval(
        child: Image.asset(
          ArenaAssets.avatar(clase),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.person, color: ArenaColors.textoSuave);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Texto pequeño bajo el nick
    String detalle = 'Sin personaje';
    if (jugador.configurado) {
      detalle =
      '${nombreClase(jugador.clase)} · ${jugador.victorias}V · ${jugador.derrotas}D';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ArenaMedidas.s16,
        vertical: ArenaMedidas.s8,
      ),
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
          _construirAvatar(),
          const SizedBox(width: ArenaMedidas.s16),
          // Expanded: el nick ocupa el hueco que sobra y, si es largo, se corta con "..."
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jugador.nick,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ArenaTextos.subtitulo,
                ),
                Text(detalle, style: ArenaTextos.cuerpoSuave),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
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

/// Escena: fondo + plataforma + personaje (o un «?» si no tiene personaje).
class _Escena extends StatelessWidget {
  const _Escena({required this.jugador});

  final Jugador jugador;

  @override
  Widget build(BuildContext context) {
    final clase = claseVisual(jugador.clase);

    return ClipRRect(
      borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
      child: SizedBox(
        height: 220,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Fondo a todo el ancho de la escena
            Image.asset(
              ArenaAssets.fondo,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const ColoredBox(color: ArenaColors.superficie);
              },
            ),

            // 2. Plataforma abajo y centrada
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: ArenaMedidas.s8),
                child: Image.asset(
                  ArenaAssets.plataforma,
                  width: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(width: 200);
                  },
                ),
              ),
            ),

            // 3. Personaje encima de la plataforma, o «?» si aún no tiene
            if (jugador.configurado)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: ArenaMedidas.s32),
                  child: Image.asset(
                    ArenaAssets.personaje(clase),
                    height: 170,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(height: 170);
                    },
                  ),
                ),
              )
            else
              Align(
                alignment: Alignment.center,
                child: Text(
                  '?',
                  style: ArenaTextos.titulo.copyWith(
                    fontSize: 64,
                    color: ArenaColors.textoSuave,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Botón del menú: emoji grande + texto. Los 4 son iguales, solo cambian los datos.
///   activo    → si es false, el botón no se puede pulsar y se ve apagado
///   resaltado → si es true, borde y texto dorados
class _Opcion extends StatelessWidget {
  const _Opcion({
    required this.emoji,
    required this.texto,
    required this.alPulsar,
    this.activo = true,
    this.resaltado = false,
  });

  final String emoji;
  final String texto;
  final VoidCallback alPulsar;
  final bool activo;
  final bool resaltado;

  @override
  Widget build(BuildContext context) {
    Color colorBorde = ArenaColors.borde;
    Color colorTexto = ArenaColors.texto;

    if (resaltado) {
      colorBorde = ArenaColors.dorado;
      colorTexto = ArenaColors.dorado;
    }
    if (!activo) {
      colorTexto = ArenaColors.textoSuave;
    }

    final forma = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
      side: BorderSide(color: colorBorde, width: ArenaMedidas.grosorBorde),
    );

    return Opacity(
      opacity: activo ? 1 : 0.5,
      child: Material(
        color: ArenaColors.superficie,
        shape: forma,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          // onTap null = botón desactivado
          onTap: activo ? alPulsar : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: ArenaMedidas.s8),
              Text(
                texto,
                style: ArenaTextos.cuerpo.copyWith(
                  fontSize: 14,
                  color: colorTexto,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}