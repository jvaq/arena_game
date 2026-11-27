import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../theme/arena_assets.dart';
import '../../theme/arena_theme.dart';
import '../../utils/clase_visual.dart';
import '../app/routes.dart';

/// EJERCICIO 3 · Contenido del Inicio: DISEÑO + NAVEGACIÓN.
///
/// Los datos ya llegan cargados en [jugador] (lo hace `pantalla_inicio.dart`).
/// Diseño de referencia: Diseno_completo_Arena.pdf, pantalla «Inicio».
class _TarjetaJugador extends StatelessWidget {
  final Jugador jugador;
  final String clase;

  const _TarjetaJugador({
    super.key,
    required this.jugador,
    required this.clase,
  });

  @override
  Widget build(BuildContext context) {
    final bool configurado = jugador.configurado;
    final Color colorBorde =
    configurado ? ArenaColors.deClase(clase) : ArenaColors.borde;

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
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colorBorde,
                width: ArenaMedidas.grosorBorde,
              ),
            ),
            child: CircleAvatar(
              radius: ArenaMedidas.radioBoton,
              backgroundColor: ArenaColors.fondo,
              backgroundImage:
              configurado ? AssetImage(ArenaAssets.avatar(clase)) : null,
              child: !configurado
                  ? const Icon(
                Icons.person,
                color: Colors.blueAccent,
                size: ArenaMedidas.s32,
              )
                  : null,
            ),
          ),
          const SizedBox(width: ArenaMedidas.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  configurado ? jugador.nick : "nuevo01",
                  style: ArenaTextos.subtitulo,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  configurado
                      ? '${nombreClase(jugador.clase)} · ${jugador.victorias} V · ${jugador.derrotas} D'
                      : 'Sin personaje',
                  style: ArenaTextos.cuerpoSuave,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                configurado ? '${jugador.puntos}': '0',
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
  final bool configurado;
  final String clase;

  const _Escena({
    super.key,
    required this.configurado,
    required this.clase,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
      child: SizedBox(
        height: 220,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                ArenaAssets.fondo,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  child: const Icon(Icons.image_not_supported, size: 48),
                ),
              ),
            ),
            // Centro plataforma
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                ArenaAssets.plataforma,
                width: 240,
                errorBuilder: (context, error, stackTrace) =>
                const SizedBox.shrink(),
              ),
            ),
            if (!configurado)
              const Center(
                child: Icon(
                  Icons.help_outline,
                  size: 80,
                ),
              )
            else ...[
              // Centro personaje
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Image.asset(
                    ArenaAssets.personaje(clase),
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.help_outline,
                      size: 80,
                    ),
                  ),
                ),
              ),
              // Arma izquierda
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Image.asset(
                    width: 80,
                    ArenaAssets.arma(clase, 'baston_fuego'),
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.help_outline,
                      size: 80,
                    ),
                  ),
                ),
              ),
              // Arma derecha
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Image.asset(
                    width: 80,
                    ArenaAssets.arma(clase, 'libro'),
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.help_outline,
                      size: 80,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Opcion extends StatelessWidget {
  final String icono;
  final String label;
  final VoidCallback action;
  final bool desactivado;
  final bool resaltado;

  const _Opcion({
    super.key,
    required this.icono,
    required this.label,
    required this.action,
    this.desactivado = false,
    this.resaltado = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor:
        desactivado ? ArenaColors.fondo : ArenaColors.superficie,
        side: BorderSide(
          color: resaltado ? ArenaColors.dorado : ArenaColors.borde,
        ),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: desactivado ? null : action,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(icono, width: 60, height: 60),
          Text(label, style: ArenaTextos.cuerpo),
        ],
      ),
    );
  }
}

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
    alVolver();
  }

  @override
  Widget build(BuildContext context) {
    final clase = claseVisual(jugador.clase);
    final configurado = jugador.configurado;

    // TODO 1: ListView con padding ArenaMedidas.s16 y, en orden:
    // tarjeta, escena, aviso y menú.
    return ListView(
      padding: const EdgeInsets.all(ArenaMedidas.s16),
      children: [
        _TarjetaJugador(
          jugador: jugador,
          clase: clase,
        ),
        const SizedBox(height: ArenaMedidas.s16),
        _Escena(
          configurado: configurado,
          clase: clase,
        ),
        const SizedBox(height: ArenaMedidas.s16),
        if (!configurado) ...[
          Text(
            'Aún no tienes personaje. Créalo para poder combatir.',
            style: ArenaTextos.cuerpo,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: ArenaMedidas.s16),
        ],
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          crossAxisCount: 2,
          childAspectRatio: 2,
          children: [
            _Opcion(
              icono: ArenaAssets.icono_rival,
              desactivado: !configurado,
              label: 'Combatir',
              action: () => _ir(context, Routes.rival),
            ),
            _Opcion(
              icono: ArenaAssets.icono_personaje,
              resaltado: !configurado,
              label: 'Personaje',
              action: () => _ir(context, Routes.personaje),
            ),
            _Opcion(
              icono: ArenaAssets.icono_ranking,
              label: 'Ranking',
              action: () => _ir(context, Routes.ranking),
            ),
            _Opcion(
              icono: ArenaAssets.icono_historial,
              label: 'Historial',
              action: () => _ir(context, Routes.historial),
            ),
          ],
        ),
      ],
    );
  }
}