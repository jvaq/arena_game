import 'package:flutter/cupertino.dart';

class CabeceraFormulario extends StatelessWidget {
  const CabeceraFormulario({super.key, required this.titulo, required this.subtitulo});
  final String titulo;
  final String subtitulo;



  @override
  Widget build(BuildContext context) {

    return Column(children: [Text(titulo),Text(subtitulo)],);
  }

}
