import 'package:arena_game/theme/arena_assets.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../theme/arena_theme.dart';
import '../pieza_pendiente.dart';

/// PIEZA F · Selector de clase: 3 tarjetas en fila (avatar + nombre).
///
///  - La clase `elegida` lleva borde de `ArenaMedidas.grosorBordeSeleccion` del color de la clase.
///  - Las demás, borde `ArenaColors.borde`.
///  - Al pulsar una tarjeta: `onCambiar(clase)`.
///
/// NO cambies el constructor.
class SelectorClase extends StatelessWidget {
  const SelectorClase({
    super.key,
    required this.clases,
    required this.elegida,
    required this.onCambiar,
  });

  final List<ClasePersonaje> clases;
  final ClasePersonaje elegida;
  final ValueChanged<ClasePersonaje> onCambiar;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: clases.map((clase) {
        final bool esElegida = clase == elegida;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: ArenaMedidas.s4),
            child: InkWell(
              onTap: () => onCambiar(clase),
              borderRadius: BorderRadius.circular(32.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.0),
                  border: Border.all(
                    color: esElegida ? clase.color : ArenaColors.borde,
                    width: esElegida
                        ? ArenaMedidas.grosorBordeSeleccion
                        : ArenaMedidas.grosorBorde,
                  ),
                ),
                padding: const EdgeInsets.all(ArenaMedidas.s8),
                child: SelectorPersonaje(personaje: clase.nombre),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class SelectorPersonaje extends StatelessWidget {
  const SelectorPersonaje({super.key, required this.personaje});

  final String personaje;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImagenAvatar(personaje: personaje),
        const SizedBox(width: ArenaMedidas.s8),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              personaje,
              overflow: TextOverflow.visible,
            ),
          ),
        ),
      ],
    );
  }
}

class ImagenAvatar extends StatelessWidget {
  const ImagenAvatar({super.key, required this.personaje});

  final String personaje;

  @override
  Widget build(BuildContext context) {
    final nombreLimpio = personaje.toLowerCase().trim();

    return Image.asset(
      ArenaAssets.avatar(nombreLimpio),
      width: ArenaMedidas.s32,
      height: ArenaMedidas.s32,
    );
  }
}