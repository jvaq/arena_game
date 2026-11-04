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

  String _formatearAtaque(Arma arma) {
    String bonusFormateado = "";
    if (arma.bonus.vida > 0) {
      bonusFormateado = "+${arma.bonus.vida} vida";
    } else if (arma.bonus.vida < 0) {
      bonusFormateado = "${arma.bonus.vida} vida";
    }

    if (arma.bonus.ataque > 0) {
      if (bonusFormateado.isNotEmpty) {
        bonusFormateado += " · +${arma.bonus.ataque} atq";
      }
      else {
        bonusFormateado = "+${arma.bonus.ataque} atq";
      }
    } else if (arma.bonus.ataque < 0) {
      if (bonusFormateado.isNotEmpty) {
        bonusFormateado += " · ${arma.bonus.ataque} atq";
      }
      else {
        bonusFormateado = "${arma.bonus.ataque} atq";
      }
    }

    if (arma.bonus.velocidad > 0) {
      if (bonusFormateado.isNotEmpty) {
        bonusFormateado += " · +${arma.bonus.velocidad} vel";
      }
      else {
        bonusFormateado = "+${arma.bonus.velocidad} vel";
      }
    } else if (arma.bonus.velocidad < 0) {
      if (bonusFormateado.isNotEmpty) {
        bonusFormateado += " · ${arma.bonus.velocidad} vel";
      }
      else {
        bonusFormateado = "${arma.bonus.velocidad} vel";
      }
    }
    return bonusFormateado;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: ArenaMedidas.s8,
      crossAxisSpacing: ArenaMedidas.s8,
      childAspectRatio: 2,   //Hace que sea rectangular
      children: [
        for (var arma in armas)
          OutlinedButton.icon(
            onPressed: () => onAlternar(arma),
            style: OutlinedButton.styleFrom(
              backgroundColor: elegidas.contains(arma)
                  ? ArenaColors.superficieAlta
                  : ArenaColors.superficie,
              side: BorderSide(
                color: elegidas.contains(arma)
                    ? ArenaColors.dorado
                    : ArenaColors.borde,
                width: elegidas.contains(arma)
                    ? ArenaMedidas.grosorBordeSeleccion
                    : ArenaMedidas.grosorBorde,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
              ),
            ),
            icon: SizedBox(
              width: 50,
              height: 50,
              child: Image.asset(arma.imagen)
            ),
            label: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start, // texto a la izq
              children: [
                Text(
                  arma.nombre,
                  style: ArenaTextos.cuerpo,
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                ),
                Text(
                  _formatearAtaque(arma),
                  style: ArenaTextos.cuerpoSuave,
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
      ],
    );
  }
}