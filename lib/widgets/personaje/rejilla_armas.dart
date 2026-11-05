
import 'package:flutter/material.dart';
import '../../models/models.dart';

/// GRUPO H - Rejilla de armas.
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

  static const Color colorSeleccion = Color(0xFFF5B941);

  // Convierte las bonificaciones en texto.
  String obtenerBonus(Arma arma) {
    List<String> bonus = [];

    if (arma.bonus.vida != 0) {
      bonus.add(
        '${arma.bonus.vida > 0 ? '+' : ''}${arma.bonus.vida} vida',
      );
    }

    if (arma.bonus.ataque != 0) {
      bonus.add(
        '${arma.bonus.ataque > 0 ? '+' : ''}${arma.bonus.ataque} atq',
      );
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
        // Título y contador.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ARMAS',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              '${elegidas.length}/$maxArmas elegidas',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: colorSeleccion,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Cuadrícula de dos columnas.
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: armas.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: 85,
          ),
          itemBuilder: (context, index) {
            final arma = armas[index];

            // Comprueba si el arma está seleccionada.
            final seleccionada = elegidas.any(
                  (elemento) => elemento.id == arma.id,
            );

            // Comprueba si se ha alcanzado el límite.
            final limiteAlcanzado =
                elegidas.length >= maxArmas && !seleccionada;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Tarjeta del arma.
                Positioned.fill(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => onAlternar(arma),
                    child: Opacity(
                      opacity: limiteAlcanzado ? 0.65 : 1.0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: seleccionada
                              ? const Color(0xFF2A2343)
                              : const Color(0xFF211B35),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: seleccionada
                                ? colorSeleccion
                                : const Color(0xFF40345E),
                            width: seleccionada ? 2.5 : 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Imagen del arma.
                            Image.asset(
                              arma.imagen,
                              width: 40,
                              height: 40,
                              fit: BoxFit.contain,
                            ),

                            const SizedBox(width: 6),

                            // Nombre y bonificaciones.
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    arma.nombre,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    obtenerBonus(arma),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFFB8ADC9),
                                    ),
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

                // Check en la esquina superior derecha.
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
                            color: colorSeleccion,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Color(0xFF211B35),
                            size: 20,
                            weight: 900,
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
