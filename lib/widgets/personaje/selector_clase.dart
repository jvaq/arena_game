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
      children: clases.map((clase) {
        // ¿Es la clase que está elegida ahora?
        final bool seleccionado = clase.id == elegida.id;

        return Expanded(
          child: GestureDetector(
            onTap: () => onCambiar(clase),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: ArenaMedidas.s4),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              decoration: BoxDecoration(
                color: ArenaColors.superficie,
                borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
                border: Border.all(
                  color: seleccionado ? clase.color : ArenaColors.borde,
                  width: seleccionado
                      ? ArenaMedidas.grosorBordeSeleccion
                      : ArenaMedidas.grosorBorde,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Avatar redondo
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: ArenaColors.fondo,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(child: Image.asset(clase.avatar)),
                  ),
                  const SizedBox(width: ArenaMedidas.s8),

                  // Nombre de la clase
                  Flexible(
                    child: Text(
                      clase.nombre,
                      style: ArenaTextos.cuerpo.copyWith(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
