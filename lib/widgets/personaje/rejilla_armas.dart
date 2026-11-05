import 'package:flutter/material.dart';
import '../../theme/arena_theme.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Armas', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('${elegidas.length}/$maxArmas elegidas', style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),


        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2,
          children: armas.map((arma) {
            final seleccionada = elegidas.any((e) => e.nombre == arma.nombre);

            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ArenaColors.superficieAlta,
                foregroundColor: Colors.white,
                elevation: seleccionada ? 5 : 1,
                side: BorderSide(
                  color: seleccionada ? ArenaColors.dorado : Colors.transparent,
                  width: 3,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => onAlternar(arma),
              child: Expanded(flex: 44,
                child:Row(children: [
                Image.asset(arma.imagen, width: 45, height: 45),
                SizedBox(width: 10),
                Expanded(flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Text(arma.nombre, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 6,
                    runSpacing: 2,
                    children: [
                      if (arma.bonus.ataque != 0)
                        Text('${arma.bonus.ataque} atq', style: TextStyle(color: ArenaColors.textoSuave),),

                      if (arma.bonus.velocidad != 0)
                        Text('${arma.bonus.velocidad} vel', style: TextStyle(color: ArenaColors.textoSuave)),

                      if (arma.bonus.vida != 0)
                        Text('${arma.bonus.vida} vida', style: TextStyle(color: ArenaColors.textoSuave)),
                    ],
                  )
                ],)
                )
              ],
              ),
            ));
          }).toList(),
        ),
      ],
    );
}}
