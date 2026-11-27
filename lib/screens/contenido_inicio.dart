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

    // TODO 1: sustituye este ListView por el diseño completo. Un ListView con padding
    //         ArenaMedidas.s16 y, en orden: tarjeta, escena, aviso y menú.
    return ListView(
      padding: const EdgeInsets.all(ArenaMedidas.s16),
      children: [
        // TODO 2: TARJETA DEL JUGADOR
        _TarjetaJugador(jugador: jugador, clase: clase),
        const SizedBox(height: ArenaMedidas.s16),

        // TODO 3: ESCENA
        _Escena(configurado: jugador.configurado, clase: clase),
        const SizedBox(height: ArenaMedidas.s16),

        // TODO 4: si !jugador.configurado, un texto centrado
        if (!jugador.configurado) ...[
          Text(
            'Aún no tienes personaje. Créalo para poder combatir.',
            style: ArenaTextos.cuerpoSuave,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: ArenaMedidas.s16),
        ],

        // TODO 5: MENÚ 2×2
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: ArenaMedidas.s16,
          crossAxisSpacing: ArenaMedidas.s16,
          childAspectRatio: 1.5,
          children: [
            _Opcion(
              rutaImagen: 'assets/images/ui/rival.png',
              texto: 'Combatir',
              desactivado: !jugador.configurado,
              alPulsar: () {
                _ir(context, Routes.rival);
              },
            ),
            _Opcion(
              rutaImagen: 'assets/images/ui/personaje.png',
              texto: 'Mi personaje',
              resaltado: !jugador.configurado,
              alPulsar: () {
                _ir(context, Routes.personaje);
              },
            ),
            _Opcion(
              rutaImagen: 'assets/images/ui/ranking.png',
              texto: 'Ranking',
              alPulsar: () {
                _ir(context, Routes.ranking);
              },
            ),
            _Opcion(
              rutaImagen: 'assets/images/ui/historial.png',
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

class _TarjetaJugador extends StatelessWidget {
  const _TarjetaJugador({required this.jugador, required this.clase});

  final Jugador jugador;
  final String clase;

  @override
  Widget build(BuildContext context) {
    final colorClase = jugador.configurado
        ? ArenaColors.deClase(clase)
        : ArenaColors.borde;

    final subtituloEstado = jugador.configurado
        ? '${nombreClase(jugador.clase)} · ${jugador.victorias}V · ${jugador.derrotas}D'
        : 'Sin personaje';

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
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ArenaColors.fondo,
              border: Border.all(
                color: colorClase,
                width: ArenaMedidas.grosorBordeSeleccion,
              ),
            ),
            child: ClipOval(
              child: jugador.configurado
                  ? Image.asset(
                ArenaAssets.avatar(clase),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person, color: ArenaColors.dorado);
                },
              )
                  : const Icon(
                Icons.person,
                size: 32,
                color: ArenaColors.textoSuave,
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
                const SizedBox(height: ArenaMedidas.s4),
                Text(
                  subtituloEstado,
                  style: ArenaTextos.cuerpoSuave,
                ),
              ],
            ),
          ),
          const SizedBox(width: ArenaMedidas.s8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${jugador.puntos}',
                style: ArenaTextos.puntos,
              ),
              Text(
                'puntos',
                style: ArenaTextos.cuerpoSuave,
              ),
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
              errorBuilder: (context, error, stackTrace) {
                return const ColoredBox(color: ArenaColors.superficie);
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                ArenaAssets.plataforma,
                height: 70,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox.shrink();
                },
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.25),
              child: configurado
                  ? Image.asset(
                ArenaAssets.personaje(clase),
                height: 155,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.shield,
                    size: 96,
                    color: ArenaColors.dorado,
                  );
                },
              )
                  : Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ArenaColors.superficie.withValues(alpha: 0.85),
                  border: Border.all(
                    color: ArenaColors.dorado,
                    width: ArenaMedidas.grosorBordeSeleccion,
                  ),
                ),
                child: const Icon(
                  Icons.question_mark,
                  size: 44,
                  color: ArenaColors.dorado,
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
    required this.rutaImagen,
    required this.texto,
    required this.alPulsar,
    this.desactivado = false,
    this.resaltado = false,
  });

  final String rutaImagen;
  final String texto;
  final VoidCallback alPulsar;
  final bool desactivado;
  final bool resaltado;

  @override
  Widget build(BuildContext context) {
    final colorBorde = resaltado ? ArenaColors.dorado : ArenaColors.borde;
    final colorTexto = desactivado
        ? ArenaColors.textoSuave.withValues(alpha: 0.4)
        : (resaltado ? ArenaColors.dorado : ArenaColors.texto);

    return Material(
      color: ArenaColors.superficie,
      borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
      child: InkWell(
        onTap: desactivado ? null : alPulsar,
        borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
            border: Border.all(
              color: colorBorde,
              width: resaltado
                  ? ArenaMedidas.grosorBordeSeleccion
                  : ArenaMedidas.grosorBorde,
            ),
          ),
          padding: const EdgeInsets.all(ArenaMedidas.s16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                opacity: desactivado ? 0.4 : 1.0,
                child: Image.asset(
                  rutaImagen,
                  height: 36,
                  width: 36,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.image_not_supported_outlined,
                      size: 30,
                      color: colorTexto,
                    );
                  },
                ),
              ),
              const SizedBox(height: ArenaMedidas.s8),
              Text(
                texto,
                style: ArenaTextos.cuerpo.copyWith(
                  color: colorTexto,
                  fontWeight: resaltado ? FontWeight.bold : FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}