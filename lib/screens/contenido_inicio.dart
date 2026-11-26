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
    final configurado = jugador.configurado;


    return ListView(
      padding: const EdgeInsets.all(ArenaMedidas.s16),
      children: [
        // TODO 2: TARJETA DEL JUGADOR
        _TarjetaJugador(jugador: jugador, clase: clase, configurado: configurado),


        const SizedBox(height: ArenaMedidas.s16),


        // TODO 3: ESCENA
        _Escena(jugador: jugador, clase: clase, configurado: configurado),


        // TODO 4: Aviso si no está configurado
        if (!configurado) ...[
          const SizedBox(height: ArenaMedidas.s16),
          Center(
            child: Text(
              'Aún no tienes personaje. Créalo para poder combatir.',
              style: ArenaTextos.cuerpoSuave,
              textAlign: TextAlign.center,
            ),
          ),
        ],


        const SizedBox(height: ArenaMedidas.s16),


        // TODO 5: MENÚ 2×2
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: ArenaMedidas.s16,
          mainAxisSpacing: ArenaMedidas.s16,
          childAspectRatio: 1.3,
          children: [
            _Opcion(
              icono: Icons.close,
              texto: 'Combatir',
              ruta: Routes.rival,
              desactivado: !configurado,
              resaltado: false,
              onTap: (ruta) => _ir(context, ruta),
            ),
            _Opcion(
              icono: Icons.shield_outlined,
              texto: 'Mi personaje',
              ruta: Routes.personaje,
              desactivado: false,
              resaltado: !configurado,
              onTap: (ruta) => _ir(context, ruta),
            ),
            _Opcion(
              icono: Icons.emoji_events,
              texto: 'Ranking',
              ruta: Routes.ranking,
              desactivado: false,
              resaltado: false,
              onTap: (ruta) => _ir(context, ruta),
            ),
            _Opcion(
              icono: Icons.menu_book,
              texto: 'Historial',
              ruta: Routes.historial,
              desactivado: false,
              resaltado: false,
              onTap: (ruta) => _ir(context, ruta),
            ),
          ],
        ),
      ],
    );
  }
}


/// Widget privado para la tarjeta del jugador
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
    final colorBorde = configurado ? ArenaColors.deClase(clase) : ArenaColors.superficie;


    return Container(
      padding: const EdgeInsets.all(ArenaMedidas.s16),
      decoration: BoxDecoration(
        color: ArenaColors.superficie,
        borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
        border: Border.all(color: ArenaColors.borde),
      ),
      child: Row(
        children: [
          // Avatar circular
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colorBorde, width: 2),
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: ArenaColors.fondo,
              child: configurado
                  ? Image.asset(
                ArenaAssets.avatar(clase),
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, color: Colors.white),
              )
                  : const Icon(Icons.person, color: Colors.white, size: 30),
            ),
          ),
          const SizedBox(width: ArenaMedidas.s16),
          // Textos de nick e info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jugador.nick,
                  style: ArenaTextos.subtitulo,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  configurado
                      ? '${nombreClase(jugador.clase)} · ${jugador.victorias} V · ${jugador.derrotas} D'
                      : 'Sin personaje',
                  style: ArenaTextos.cuerpoSuave,
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
                style: ArenaTextos.puntos,
              ),
              const Text(
                'puntos',
                style: TextStyle(color: ArenaColors.textoSuave, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


/// Widget privado para la escena del personaje
class _Escena extends StatelessWidget {
  const _Escena({
    required this.jugador,
    required this.clase,
    required this.configurado,
  });


  final Jugador jugador;
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
            // Fondo
            Image.asset(
              ArenaAssets.fondo,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const ColoredBox(color: Colors.black),
            ),
            // Plataforma centrada abajo
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                ArenaAssets.plataforma,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),
            // Personaje o Interrogación
            if (configurado)
              Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  ArenaAssets.personaje(clase),
                  height: 180,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.shield, size: 80, color: Colors.amber),
                ),
              )
            else
              const Center(
                child: Icon(
                  Icons.question_mark,
                  size: 80,
                  color: ArenaColors.textoSuave,
                ),
              ),
          ],
        ),
      ),
    );
  }
}


/// Widget privado para cada opción del menú 2x2
class _Opcion extends StatelessWidget {
  const _Opcion({
    required this.icono,
    required this.texto,
    required this.ruta,
    required this.desactivado,
    required this.resaltado,
    required this.onTap,
  });


  final IconData icono;
  final String texto;
  final String ruta;
  final bool desactivado;
  final bool resaltado;
  final Function(String) onTap;


  @override
  Widget build(BuildContext context) {
    final colorBorde = resaltado ? ArenaColors.dorado : ArenaColors.borde;
    final colorTexto = resaltado ? ArenaColors.dorado : ArenaColors.texto;


    return Opacity(
      opacity: desactivado ? 0.5 : 1.0,
      child: InkWell(
        onTap: desactivado ? null : () => onTap(ruta),
        borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
        child: Container(
          decoration: BoxDecoration(
            color: ArenaColors.superficie,
            borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
            border: Border.all(color: colorBorde, width: resaltado ? 1.5 : 1.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icono, color: colorTexto, size: 28),
              const SizedBox(height: 8),
              Text(
                texto,
                style: ArenaTextos.cuerpo.copyWith(color: colorTexto),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
