import 'package:flutter/material.dart';

import '../../models/models.dart';

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
    final limiteAlcanzado = elegidas.length >= maxArmas;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ARMAS',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              '${elegidas.length} / $maxArmas elegidas',
              style: TextStyle(
                color: colorClase,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: armas.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.3,
          ),
          itemBuilder: (context, index) {
            final arma = armas[index];
            final seleccionada = elegidas.contains(arma);
            final deshabilitada =
                limiteAlcanzado && !seleccionada;

            return Opacity(
              opacity: deshabilitada ? 0.45 : 1,
              child: Card(
                color: const Color(0xFF211B3A),
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    // MODIFICADO: Ahora es amarillo (Colors.amber) cuando está seleccionada
                    color: seleccionada
                        ? Colors.amber
                        : const Color(0xFF4B3C88),
                    width: seleccionada ? 2.5 : 1.5,
                  ),
                ),
                child: ListTile(
                  enabled: !deshabilitada,
                  onTap: deshabilitada
                      ? null
                      : () => onAlternar(arma),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8),
                  leading: Image.asset(
                    arma.imagen,
                    width: 42,
                    height: 48,
                    fit: BoxFit.contain,
                  ),
                  title: Text(
                    arma.nombre,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  subtitle: Text(
                    arma.bonus.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                  trailing: seleccionada
                      ? CircleAvatar(
                    radius: 12,
                    // MODIFICADO: Fondo amarillo para que coincida con el borde
                    backgroundColor: Colors.amber,
                    child: const Icon(
                      Icons.check,
                      size: 15,
                      color: Colors.black,
                    ),
                  )
                      : null,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}