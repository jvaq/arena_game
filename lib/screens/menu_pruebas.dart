import 'package:arena_game/screens/pantalla_ranking.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/arena_theme.dart';
import '../widgets/personaje/barras_stats.dart';
import '../widgets/personaje/escena_personaje.dart';
import '../widgets/personaje/rejilla_armas.dart';
import '../widgets/personaje/selector_clase.dart';
import '../widgets/ranking/estados_ranking.dart';
import '../widgets/ranking/fila_ranking.dart';
import '../widgets/ranking/tarjeta_tu_posicion.dart';
import 'pantalla_personaje.dart';

/// Menú de pruebas: permite ver cada pieza SOLA con datos de ejemplo,
/// sin esperar a que las demás estén terminadas. No hay que editarlo.
class MenuPruebas extends StatelessWidget {
  const MenuPruebas({super.key});

  static const _ejemplo = EntradaRanking(
    posicion: 1, id: 1, nick: 'Aria', clase: 'mago', puntos: 340, victorias: 21, derrotas: 3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Arena · Pruebas')),
      body: ListView(
        padding: const EdgeInsets.all(ArenaMedidas.s16),
        children: [
          _titulo('Pantallas completas'),
          _boton(context, 'Pantalla Ranking', (_) => const PantallaRanking()),
          _boton(context, 'Pantalla Personaje', (_) => const PantallaPersonaje()),
          _titulo('Pieza A-C · Ranking'),
          _boton(context, 'A · FilaRanking', (_) => _solo(const FilaRanking(entrada: _ejemplo))),
          _boton(context, 'A · FilaRanking (resaltada)',
              (_) => _solo(const FilaRanking(entrada: _ejemplo, resaltada: true))),
          _boton(context, 'B · TarjetaTuPosicion', (_) => _solo(const TarjetaTuPosicion(entrada: _ejemplo))),
          _boton(context, 'C · Cargando', (_) => _solo(const RankingCargando())),
          _boton(context, 'C · Error',
              (_) => _solo(RankingError(mensaje: 'Sin conexión', onReintentar: () {}))),
          _boton(context, 'C · Vacío', (_) => _solo(const RankingVacio())),
          _titulo('Pieza E-H · Personaje'),
          _conCatalogo(context, 'E · EscenaPersonaje',
              (c) => EscenaPersonaje(clase: c.clases[2], armas: c.clases[2].armas.take(2).toList())),
          _conCatalogo(context, 'F · SelectorClase',
              (c) => SelectorClase(clases: c.clases, elegida: c.clases[0], onCambiar: (_) {})),
          _conCatalogo(context, 'G · BarrasStats',
              (c) => BarrasStats(
                  stats: c.clases[2].statsCon(c.clases[2].armas.take(2).toList()),
                  maxPuntosBarra: c.maxPuntosBarra,
                  color: c.clases[2].color)),
          _conCatalogo(context, 'H · RejillaArmas',
              (c) => RejillaArmas(
                  armas: c.clases[0].armas,
                  elegidas: [c.clases[0].armas[0]],
                  maxArmas: c.armasPorPersonaje,
                  colorClase: c.clases[0].color,
                  onAlternar: (_) {})),
        ],
      ),
    );
  }

  Widget _titulo(String t) => Padding(
        padding: const EdgeInsets.fromLTRB(0, ArenaMedidas.s16, 0, ArenaMedidas.s8),
        child: Text(t, style: ArenaTextos.puntos),
      );

  Widget _boton(BuildContext context, String texto, WidgetBuilder destino) => Padding(
        padding: const EdgeInsets.only(bottom: ArenaMedidas.s8),
        child: FilledButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: destino)),
          child: Text(texto),
        ),
      );

  Widget _conCatalogo(BuildContext context, String texto, Widget Function(Catalogo) crear) =>
      _boton(context, texto, (_) => FutureBuilder<Catalogo>(
            future: Catalogo.cargar(),
            builder: (_, snap) => snap.hasData
                ? _solo(crear(snap.data!))
                : const Scaffold(body: Center(child: CircularProgressIndicator())),
          ));

  Widget _solo(Widget pieza) => Scaffold(
        appBar: AppBar(),
        body: Padding(padding: const EdgeInsets.all(ArenaMedidas.s16), child: pieza),
      );
}
