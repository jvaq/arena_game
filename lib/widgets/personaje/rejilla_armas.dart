import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../theme/arena_theme.dart';
import '../pieza_pendiente.dart';

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

  // Convierte los bonus en texto: "+2 atq · +1 vel"
  String obtenerBonus(Arma arma) {
    List<String> bonus = [];

    if (arma.bonus.vida != 0) {
      bonus.add('${arma.bonus.vida > 0 ? '+' : ''}${arma.bonus.vida} vida');
    }

    if (arma.bonus.ataque != 0) {
      bonus.add('${arma.bonus.ataque > 0 ? '+' : ''}${arma.bonus.ataque} atq');
    }

    if (arma.bonus.velocidad != 0) {
      bonus.add(
        '${arma.bonus.velocidad > 0 ? '+' : ''}${arma.bonus.velocidad} vel',
      );
    }

    return bonus.isEmpty ? 'Sin bonus' : bonus.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título y contador
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('ARMAS', style: ArenaTextos.subtitulo.copyWith(fontSize: 18)),
            Text(
              '${elegidas.length} / $maxArmas elegidas',
              style: ArenaTextos.etiqueta.copyWith(color: ArenaColors.dorado),
            ),
          ],
        ),

        const SizedBox(height: ArenaMedidas.s8),

        // Cuadrícula de dos columnas
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: armas.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: 85,
          ),
          itemBuilder: (context, index) {
            final arma = armas[index];

            // ¿Está elegida esta arma?
            final seleccionada = elegidas.any(
                  (elemento) => elemento.id == arma.id,
            );

            // ¿Ya hay 2 elegidas y esta no es una de ellas?
            final limiteAlcanzado = elegidas.length >= maxArmas && !seleccionada;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Tarjeta del arma
                Positioned.fill(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
                    onTap: () => onAlternar(arma),
                    child: Opacity(
                      opacity: limiteAlcanzado ? 0.65 : 1.0,
                      child: Container(
                        padding: const EdgeInsets.all(ArenaMedidas.s8),
                        decoration: BoxDecoration(
                          color: seleccionada
                              ? ArenaColors.superficieAlta
                              : ArenaColors.superficie,
                          borderRadius:
                          BorderRadius.circular(ArenaMedidas.radioTarjeta),
                          border: Border.all(
                            color: seleccionada
                                ? ArenaColors.dorado
                                : ArenaColors.borde,
                            width: seleccionada
                                ? ArenaMedidas.grosorBordeSeleccion
                                : ArenaMedidas.grosorBorde,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Imagen del arma
                            Image.asset(
                              arma.imagen,
                              width: 40,
                              height: 40,
                              fit: BoxFit.contain,
                            ),

                            const SizedBox(width: 6),

                            // Nombre y bonus
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    arma.nombre,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: ArenaTextos.cuerpo
                                        .copyWith(fontSize: 12),
                                  ),
                                  const SizedBox(height: ArenaMedidas.s4),
                                  Text(
                                    obtenerBonus(arma),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: ArenaTextos.etiqueta
                                        .copyWith(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Check dorado en la esquina superior derecha
                if (seleccionada)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IgnorePointer(
                      child: Transform.translate(
                        offset: const Offset(7, -7),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: ArenaColors.dorado,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: ArenaColors.textoSobreDorado,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}