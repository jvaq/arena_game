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

  final List<ClasePersonaje> clases ;
  final ClasePersonaje elegida;
  final ValueChanged<ClasePersonaje> onCambiar;

  @override
  Widget build(BuildContext context) {
    // TODO(grupo F)
    return Row(
      children: [
        SelectorPersonaje(personaje: clases.first.nombre),
        SelectorPersonaje(personaje: clases[1].nombre),
        SelectorPersonaje(personaje: clases[2].nombre),
      ],
    );
  }
}

class SelectorPersonaje extends StatelessWidget {
  const SelectorPersonaje({super.key, required this.personaje});

  final String personaje;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          ImagenAvatar(personaje: personaje),
          Text(personaje),
        ],
      ),
    );
  }
}

class ImagenAvatar extends StatelessWidget {
  const ImagenAvatar({super.key, required this.personaje});

  final String personaje;
//ñe
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ArenaAssets.avatar(personaje),
      width: ArenaMedidas.s32,
      height: ArenaMedidas.s32,
    );
  }
}
