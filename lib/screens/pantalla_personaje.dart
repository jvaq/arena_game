import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/arena_theme.dart';
import '../widgets/personaje/barras_stats.dart';
import '../widgets/personaje/escena_personaje.dart';
import '../widgets/personaje/rejilla_armas.dart';
import '../widgets/personaje/selector_clase.dart';

/// Pantalla 2 · Elección de personaje.
///
/// PIEZA I (grupo de estado y guardado): completa los TODO de esta clase.
/// Las piezas E, F, G y H se reciben ya hechas por los otros grupos.
class PantallaPersonaje extends StatefulWidget {
  const PantallaPersonaje({super.key});

  @override
  State<PantallaPersonaje> createState() => _PantallaPersonajeState();
}

class _PantallaPersonajeState extends State<PantallaPersonaje> {
  Catalogo? _catalogo;
  ClasePersonaje? _clase;
  final List<Arma> _elegidas = [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final catalogo = await Catalogo.cargar();
    setState(() {
      _catalogo = catalogo;
      _clase = catalogo.clases.first;
    });
  }

  /// TODO(grupo I): al cambiar de clase se guarda la nueva y se VACÍA la selección de armas.
  void _cambiarClase(ClasePersonaje nueva) {
    setState(() {
      _clase = nueva;
      _elegidas.clear();
    });
  }

  /// TODO(grupo I): si el arma ya está elegida, quitarla; si no y hay hueco
  /// (`_elegidas.length < _catalogo!.armasPorPersonaje`), añadirla.

  void _alternarArma(Arma arma) {
    setState(() {
      // Comprueba si el arma ya está seleccionada.
      final seleccionada = _elegidas.any(
            (elemento) => elemento.id == arma.id,
      );

      if (seleccionada) {
        // Si ya estaba seleccionada, la quitamos.
        _elegidas.removeWhere(
              (elemento) => elemento.id == arma.id,
        );
      } else {
        // Si hay espacio, añadimos el arma.
        if (_elegidas.length < _catalogo!.armasPorPersonaje) {
          _elegidas.add(arma);
        }
      }
    });
  }


  /// TODO(grupo I): true solo cuando hay exactamente `armasPorPersonaje` armas elegidas.
  bool get _puedeGuardar =>
      _catalogo != null && _elegidas.length == _catalogo!.armasPorPersonaje;

  /// TODO(grupo I): al pulsar «Guardar». Fase 1: SnackBar con «Personaje guardado».
  /// Fase 2 (opcional): PUT /jugadores/{id}/personaje con la API.
  void _guardar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Personaje guardado')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalogo = _catalogo;
    final clase = _clase;
    if (catalogo == null || clase == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: ArenaColors.dorado)));
    }

    final stats = clase.statsCon(_elegidas);

    return Scaffold(
      appBar: AppBar(title: const Text('Tu personaje')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ArenaMedidas.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            EscenaPersonaje(clase: clase, armas: _elegidas),
            const SizedBox(height: ArenaMedidas.s16),
            // Aquí le pasamos tu _cambiarClase al SelectorClase que acabas de hacer
            SelectorClase(clases: catalogo.clases, elegida: clase, onCambiar: _cambiarClase),
            const SizedBox(height: ArenaMedidas.s16),
            BarrasStats(stats: stats, maxPuntosBarra: catalogo.maxPuntosBarra, color: clase.color),
            const SizedBox(height: ArenaMedidas.s16),
            RejillaArmas(
              armas: clase.armas,
              elegidas: _elegidas,
              maxArmas: catalogo.armasPorPersonaje,
              colorClase: clase.color,
              onAlternar: _alternarArma,
            ),
            const SizedBox(height: ArenaMedidas.s24),
            FilledButton(
              onPressed: _puedeGuardar ? _guardar : null,
              child: const Text('Guardar personaje'),
            ),
          ],
        ),
      ),
    );
  }
}
