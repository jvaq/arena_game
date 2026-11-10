
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

  // Lista con todas las armas disponibles para la clase del personaje.
  // Los datos de cada arma (nombre, imagen y bonus) se gestionan
  // desde el modelo Arma, desarrollado por otro miembro del equipo.
  final List<Arma> armas;

  // Lista de armas que el usuario ha seleccionado actualmente.
  final List<Arma> elegidas;

  // Numero maximo de armas que puede seleccionar el personaje.
  final int maxArmas;

  // Color asociado a la clase del personaje.
  // Se utiliza para destacar visualmente las armas seleccionadas.
  final Color colorClase;

  // Funcion que se ejecuta cuando el usuario pulsa sobre un arma.
  // La gestion de anadir o quitar armas se realiza desde el widget padre.
  final ValueChanged<Arma> onAlternar;

  @override
  Widget build(BuildContext context) {

    // Comprobamos si ya se ha alcanzado el limite de armas.
    // Si es asi, las armas que no esten seleccionadas quedaran desactivadas.
    final limiteAlcanzado = elegidas.length >= maxArmas;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // CABECERA DE LA SECCION DE ARMAS.
        // Muestra el titulo a la izquierda y el contador a la derecha.
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

            // El contador se actualiza automaticamente segun
            // el numero de armas elegidas y el limite permitido.
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

        // GRIDVIEW.BUILDER:
        // Crea una cuadrícula dinamica para mostrar todas las armas.
        // Utilizamos dos columnas para reproducir el diseño del enunciado.
        GridView.builder(
          shrinkWrap: true,

          // Evita que esta cuadrícula tenga su propio desplazamiento,
          // ya que el desplazamiento se controla desde la pantalla principal.
          physics: const NeverScrollableScrollPhysics(),

          // Numero de tarjetas igual al numero de armas disponibles.
          itemCount: armas.length,

          // Configuracion de la distribucion de las tarjetas.
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.3,
          ),

          // Construye individualmente cada tarjeta de arma.
          itemBuilder: (context, index) {

            // Obtenemos el arma correspondiente a la posicion actual.
            final arma = armas[index];

            // Comprobamos si el arma actual esta dentro de la lista
            // de armas que ha seleccionado el usuario.
            final seleccionada = elegidas.contains(arma);

            // Si se ha alcanzado el limite, desactivamos las armas
            // que todavia no han sido seleccionadas.
            // Las seleccionadas siguen activas para poder deseleccionarlas.
            final deshabilitada =
                limiteAlcanzado && !seleccionada;

            return Opacity(
              // Reducimos la opacidad para distinguir las armas
              // que no se pueden seleccionar en ese momento.
              opacity: deshabilitada ? 0.45 : 1,

              // CARD:
              // Utilizamos Card para crear la tarjeta visual de cada arma,
              // siguiendo la teoria de interfaces de usuario.
              child: Card(
                color: const Color(0xFF211B3A),
                elevation: 0,
                margin: EdgeInsets.zero,

                // Personalizamos el borde de la tarjeta:
                // Dorado cuando esta seleccionada y morado cuando no.
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: seleccionada
                        ? colorClase
                        : const Color(0xFF4B3C88),
                    width: seleccionada ? 2.5 : 1.5,
                  ),
                ),

                // LISTTILE:
                // Organiza los elementos de la tarjeta sin necesidad
                // de crear manualmente filas y columnas.
                child: ListTile(

                  // Desactivamos la interaccion cuando se alcanza
                  // el limite y el arma no esta seleccionada.
                  enabled: !deshabilitada,

                  // Al pulsar sobre la tarjeta llamamos a onAlternar.
                  // El widget padre se encarga de actualizar la seleccion.
                  onTap: deshabilitada
                      ? null
                      : () => onAlternar(arma),

                  // Espacio interior de la tarjeta.
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8),

                  // LEADING:
                  // Imagen del arma situada en la parte izquierda.
                  // Image.asset carga la imagen desde los recursos del proyecto.
                  leading: Image.asset(
                    arma.imagen,
                    width: 42,
                    height: 48,
                    fit: BoxFit.contain,
                  ),

                  // TITLE:
                  // Nombre del arma con texto blanco y negrita.
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

                  // SUBTITLE:
                  // Muestra los bonus y atributos adicionales del arma.
                  subtitle: Text(
                    arma.bonus as String,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),

                  // TRAILING:
                  // Si el arma esta seleccionada, mostramos un circulo
                  // con un icono de verificacion en la esquina derecha.
                  // Si no esta seleccionada, no mostramos ningun icono.
                  trailing: seleccionada
                      ? CircleAvatar(
                    radius: 12,
                    backgroundColor: colorClase,
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
 