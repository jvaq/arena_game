import 'package:arena_game/theme/arena_assets.dart';
import 'package:arena_game/theme/arena_theme.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';
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
      children: [
        Row(
          children: [
           Padding(
             padding: EdgeInsets.all(ArenaMedidas.s8),
             child: SelectorPersonaje(tipo: "caballero"),
           ),
            Padding(
              padding: EdgeInsets.all(ArenaMedidas.s8),
              child: SelectorPersonaje(tipo: "orco"),
            ),
            Padding(
              padding: EdgeInsets.all(ArenaMedidas.s8),
              child: SelectorPersonaje(tipo: "mago"),
            )
          ],
        ),
      ],
    );
  }
}

class SelectorPersonaje extends StatelessWidget {
  SelectorPersonaje({super.key, required this.tipo});

  String tipo;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ArenaColors.fondo,
          borderRadius: BorderRadius.circular(ArenaMedidas.radioBoton)
      ),
      child: Row(
        children: [
          AvatarCirculo(tipo: tipo),
          Text(tipo)
        ],
      ),
    ) ;
  }
}


class AvatarCirculo extends StatelessWidget {
  AvatarCirculo({super.key, required this.tipo});

  String tipo;

  @override
  Widget build(BuildContext context) {
    return Image.asset(ArenaAssets.avatar(tipo));
  }
}
