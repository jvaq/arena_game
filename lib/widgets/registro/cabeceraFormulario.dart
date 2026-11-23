import 'package:flutter/material.dart';

class cabeceraFormulario extends StatelessWidget {
  const cabeceraFormulario({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(children: [
      Text('Únete a la Arena'),
      Text('Elige un nick: así te verán en el ranking.')
    ],);
  }
}
