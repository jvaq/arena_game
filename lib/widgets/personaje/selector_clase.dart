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
    // TODO(grupo F)
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: clases.map((clase) {
        final bool seleccionado = clase == elegida;

        return Expanded(
          child: GestureDetector(
            // Esto es lo que hace que el botón funcione y avise a la pantalla principal
            onTap: () => onCambiar(clase),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              decoration: BoxDecoration(
                color: ArenaColors.superficie, // Usa el color de superficie del tema
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  // Aplica el color de la clase si está seleccionada, si no, usa el borde por defecto
                  color: seleccionado ? clase.color : ArenaColors.borde,
                  // Aplica el grosor de selección si está elegida
                  width: seleccionado ? ArenaMedidas.grosorBordeSeleccion : 1.0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Círculo oscuro con el avatar
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFF161621),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(clase.avatar),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Nombre de la clase
                  Flexible(
                    child: Text(
                      clase.nombre,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
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
