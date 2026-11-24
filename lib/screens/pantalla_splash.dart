import 'package:arena_game/app/routes.dart';
import 'package:arena_game/theme/arena_assets.dart';
import 'package:flutter/material.dart';

import '../../config/arena_config.dart';
import '../../services/sesion_service.dart';
import '../theme/arena_theme.dart';

/// EJERCICIO 1 · Splash: DISEÑO + NAVEGACIÓN.
/// Diseño de referencia: Diseno_completo_Arena.pdf, pantalla «Splash».
class PantallaSplash extends StatefulWidget {
  const PantallaSplash({super.key});

  @override
  State<PantallaSplash> createState() => _PantallaSplashState();
}

class _PantallaSplashState extends State<PantallaSplash> {
  @override
  void initState() {
    super.initState();
    _arrancar();
  }


  Future<void> _arrancar() async {
    final espera = Future<void>.delayed(ArenaConfig.esperaSplash);
    final sesion = await const SesionService().leer();
    await espera;
    if (!mounted) return;

    // TODO 1 (navegación): usa Navigator.pushReplacementNamed(context, ...)
    //   - si sesion == null  → Rutas.registro
    //   - si hay sesión      → Rutas.inicio
    // (pushReplacement: así el botón «atrás» no vuelve al Splash).
    // ignore: unnecessary_null_comparison
    if (sesion == null) {
      Navigator.pushReplacementNamed(context, Routes.registro);
    }else{
      Navigator.pushReplacementNamed(context, Routes.registro);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO 2 (diseño): construye la pantalla de arranque:
    //   - Fondo a pantalla completa: Stack(fit: StackFit.expand) con
    //     Image.asset(ArenaAssets.fondo, fit: BoxFit.cover).
    //   - Centrado, en una Column (mainAxisSize: min):
    //       emblema (ArenaAssets.emblema, alto 160)
    //       «ARENA» con ArenaTextos.titulo en color ArenaColors.dorado
    //       CircularProgressIndicator dorado
    //       «Comprobando sesión…» con ArenaTextos.cuerpoSuave
    //   - Separa los elementos con SizedBox(height: ArenaMedidas.s16 / s32).
    //   - Añade errorBuilder a las Image.asset por si falta una imagen.
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color :Colors.black,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(ArenaAssets.emblema,height: 160,errorBuilder: (context,error,stackTrace) => const Icon(
                  Icons.error,size: 80,color:Colors.white,
                ),
                ),
                const SizedBox(height:ArenaMedidas.s32),
                Text(
                  'ARENA',
                  style: ArenaTextos.titulo.copyWith(
                    color: ArenaColors.dorado,
                  ),
                ),
                const SizedBox(height: ArenaMedidas.s32),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(ArenaColors.dorado),
                ),
                const SizedBox(height: ArenaMedidas.s16),
                Text(
                  'Comprobando sesión…',
                  style: ArenaTextos.cuerpoSuave,
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
