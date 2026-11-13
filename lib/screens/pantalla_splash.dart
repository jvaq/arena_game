import 'package:arena_game/app/routes.dart';
import 'package:arena_game/theme/arena_assets.dart';
import 'package:arena_game/theme/arena_theme.dart';
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
      Navigator.pushReplacementNamed(context, Routes.registro);
    } else {
      Navigator.pushReplacementNamed(context, Routes.inicio);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Fondo a pantalla completa
          Image.asset(
            ArenaAssets.fondo,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const SizedBox(),
          ),

          // 2. Contenido centrado por encima del fondo
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Emblema
                Image.asset(
                  ArenaAssets.emblema,
                  height: 160,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(),
                ),
                const SizedBox(height: ArenaMedidas.s16),

                // Título «ARENA» en color dorado
                Text(
                  'ARENA',
                  style: ArenaTextos.titulo.copyWith(color: ArenaColors.dorado),
                ),
                const SizedBox(height: ArenaMedidas.s32),

                // CircularProgressIndicator dorado
                const CircularProgressIndicator(
                  color: ArenaColors.dorado,
                ),
                const SizedBox(height: ArenaMedidas.s16),

                // Texto de comprobación
                Text(
                  'Comprobando sesión…',
                  style: ArenaTextos.cuerpoSuave,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
