
import 'package:flutter/material.dart';
import '../../models/models.dart';

/// GRUPO H - Rejilla de armas del personaje.
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

  // Convierte los bonus del arma en texto.
  String obtenerBonus(Arma arma) {
    List<String> bonus = [];

    if (arma.bonus.vida != 0) {
      bonus.add('${arma.bonus.vida > 0 ? '+' : ''}${arma.bonus.vida} vida');
    }

    if (arma.bonus.ataque != 0) {
      bonus.add('${arma.bonus.ataque > 0 ? '+' : ''}${arma.bonus.ataque} ataque');
    }

    if (arma.bonus.velocidad != 0) {
      bonus.add('${arma.bonus.velocidad > 0 ? '+' : ''}${arma.bonus.velocidad} vel.');
    }

    return bonus.isEmpty ? 'Sin bonus' : bonus.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título y contador de armas elegidas.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ARMAS',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${elegidas.length}/$maxArmas elegidas',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: colorClase,
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

            // Comprueba si ya se alcanzó el máximo.
            final limiteAlcanzado =
                elegidas.length >= maxArmas && !seleccionada;

            return InkWell(
              borderRadius: BorderRadius.circular(12),

              // Notifica a la pantalla qué arma se ha pulsado.
              onTap: () => onAlternar(arma),

              child: Opacity(
                opacity: limiteAlcanzado ? 0.5 : 1.0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: seleccionada
                        ? colorClase.withValues(alpha: 0.15)
                        : const Color(0xFF211B35),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: seleccionada
                          ? colorClase
                          : const Color(0xFF40345E),
                      width: seleccionada ? 2 : 1,
                    ),
                  ),

                  child: Stack(
                    children: [
                      Row(
                        children: [
                          // Imagen del arma.
                          Image.asset(
                            arma.imagen,
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                          ),

                          const SizedBox(width: 6),

                          // Nombre y estadísticas.
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
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  obtenerBonus(arma),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Marca de arma seleccionada.
                      if (seleccionada)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Icon(
                            Icons.check_circle,
                            color: colorClase,
                            size: 18,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
