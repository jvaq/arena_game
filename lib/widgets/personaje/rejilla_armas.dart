import 'package:flutter/material.dart';
import 'package:arena_game/theme/arena_theme.dart';

import '../../models/models.dart';

/// PIEZA H · Rejilla 2×2 con las armas de la clase.
///
/// Cada tarjeta: imagen (`arma.imagen`), nombre y bonus (por ejemplo «+3 ataque · −1 vel.»).
///  - Las armas de `elegidas` se muestran seleccionadas (borde del color de la clase).
///  - Al pulsar una: `onAlternar(arma)`. NO decides tú el máximo (lo hace la pantalla),
///    pero puedes atenuar visualmente las no elegidas cuando `elegidas.length >= maxArmas`.
///
/// NO cambies el constructor.
class RejillaArmas extends StatelessWidget {
  const RejillaArmas({
    super.key,
    required this.armas,
    required this.elegidas,
    required this.maxArmas,
    required this.colorClase,
    required this.onAlternar,
  });

  final List<Arma> armas;
  final List<Arma> elegidas;
  final int maxArmas;
  final Color colorClase;
  final ValueChanged<Arma> onAlternar;

  @override
  Widget build(BuildContext context) {
    // TODO(grupo H)
    //return PiezaPendiente('RejillaArmas · ${armas.length} armas, ${elegidas.length}/$maxArmas', alto: 220);
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: ArenaMedidas.s8,
      crossAxisSpacing: ArenaMedidas.s16,
      children: [
        for (var arma in armas)
          Container(
            decoration: BoxDecoration(
              color: elegidas.contains(arma)
                  ? ArenaColors.superficieAlta
                  : ArenaColors.superficie,
              borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
              border: Border.all(
                color: elegidas.contains(arma)
                    ? ArenaColors.dorado
                    : ArenaColors.borde,
                width: elegidas.contains(arma)
                    ? ArenaMedidas.grosorBordeSeleccion
                    : ArenaMedidas.grosorBorde,
              ),
            ),
            child: Row(
              children: [
                Image.asset(arma.imagen),
                Expanded(
                  child: Column(
                    children: [
                      Text(arma.nombre),
                      Text(arma.bonus.toString())],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
