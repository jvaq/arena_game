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
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(ArenaMedidas.s8),
            child: SelectorPersonaje(
              tipo: "caballero",
              seleccionado: elegida.nombre.toLowerCase() == "caballero",
              onTap: () => onCambiar(
                clases.firstWhere(
                      (c) => c.nombre.toLowerCase() == "caballero",
                  orElse: () => clases[0],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(ArenaMedidas.s8),
            child: SelectorPersonaje(tipo: "orco",
              seleccionado: elegida.nombre.toLowerCase() == "orco",
              onTap: () => onCambiar(
                clases.firstWhere(
                      (c) => c.nombre.toLowerCase() == "orco",
                  orElse: () => clases[1],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(ArenaMedidas.s8),
            child: SelectorPersonaje(
              tipo: "mago",
              seleccionado: elegida.nombre.toLowerCase() == "mago",
              onTap: () => onCambiar(
                clases.firstWhere(
                      (c) => c.nombre.toLowerCase() == "mago",
                  orElse: () => clases[2],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SelectorPersonaje extends StatelessWidget {
  SelectorPersonaje({
    super.key, required this.tipo, required this.seleccionado, required this.onTap
  });

  final String tipo;
  final bool seleccionado;
  final VoidCallback onTap;

  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
        decoration: BoxDecoration(
          color: ArenaColors.fondo,
          borderRadius: BorderRadius.circular(ArenaMedidas.radioBoton),
          border: Border.all(
            color: seleccionado ? ArenaColors.deClase(tipo) : ArenaColors.borde,
            width: seleccionado
                ? ArenaMedidas.grosorBordeSeleccion
                : ArenaMedidas.grosorBorde,
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AvatarCirculo(tipo: tipo),
              const SizedBox(width: 6.0),
              Text(
                tipo,
                style: ArenaTextos.etiqueta.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AvatarCirculo extends StatelessWidget {
  AvatarCirculo({super.key, required this.tipo});

  final String tipo;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: ArenaMedidas.s16,
      backgroundColor: ArenaColors.fondo,
      child: Image.asset(
          ArenaAssets.avatar(tipo),
        fit: BoxFit.cover,
      ),
    );
  }
}
