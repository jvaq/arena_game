import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../theme/arena_theme.dart';
//import '../pieza_pendiente.dart';

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
    // TODO(grupo F)
    return Row(
      children: [
        for (var i = 0; i < clases.length; i++) ...[
          if (i > 0) const SizedBox(width: ArenaMedidas.s8),
          Expanded(
            child: _TarjetaClase(
              clase: clases[i],
              seleccionada: clases[i].id == elegida.id,
              onTap: () => onCambiar(clases[i]),
            ),
          ),
        ],
      ],
    );
  }
}

class _TarjetaClase extends StatelessWidget {
  const _TarjetaClase({
    required this.clase,
    required this.seleccionada,
    required this.onTap,
  });

  final ClasePersonaje clase;
  final bool seleccionada;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: ArenaMedidas.s8),
        decoration: BoxDecoration(
          color: ArenaColors.superficie,
          borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
          border: Border.all(
            color: seleccionada ? clase.color : ArenaColors.borde,
            width: seleccionada
                ? ArenaMedidas.grosorBordeSeleccion
                : ArenaMedidas.grosorBorde,
          ),
        ),
        child: Row(
          children: [
            ClipOval(
              child: Image.asset(
                clase.avatar,
                width: 36,
                height: 36,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: ArenaMedidas.s4),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(clase.nombre, style: ArenaTextos.cuerpo),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
