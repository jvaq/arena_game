import 'package:flutter/material.dart';

import '../../config/arena_config.dart';
import '../../services/sesion_service.dart';

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

  /// Ya hecho: espera un momento y lee la sesión guardada (`sesion` es null si no hay).
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
      body: Container()
    );
  }
}
