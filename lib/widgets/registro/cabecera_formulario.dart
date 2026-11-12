import 'package:flutter/material.dart';

import '../../theme/arena_assets.dart';
import '../../theme/arena_theme.dart';

class CabeceraFormulario extends StatelessWidget {
  const CabeceraFormulario({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(  //cabecera formulario
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: ArenaMedidas.s32,),
        Image.asset(ArenaAssets.emblema, height: 120,),
        const SizedBox(height: ArenaMedidas.s16,),
        Text("Únete a la Arena", style: ArenaTextos.subtitulo,),
        const SizedBox(height: ArenaMedidas.s8,),
        Text("Elige un nick: así te verán en el ranking.", style: ArenaTextos.cuerpoSuave,)
      ],
    );
  }
}
