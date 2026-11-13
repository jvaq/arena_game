import 'package:arena_game/app/routes.dart';
import 'package:flutter/material.dart';

import '../../config/arena_config.dart';
import '../../services/sesion_service.dart';
import '../theme/arena_assets.dart';
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
    // TODO 2 (diseño): construye la pantalla de arranque:
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Fondo a pantalla completa con errorBuilder
          Image.asset(
            ArenaAssets.fondo,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const ColoredBox(color: Colors.black);
            },
          ),

          // 2. Capa oscura (opcional) al 55 % compatible con todas las versiones
          const ColoredBox(
            color: Color.fromRGBO(0, 0, 0, 0.55),
          ),

          // 3. Contenido centrado en una Column (mainAxisSize: min)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Emblema con alto 160 y errorBuilder
                Image.asset(
                  ArenaAssets.emblema,
                  height: 160,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      height: 160,
                      child: Icon(
                        Icons.shield,
                        size: 100,
                        color: Colors.amber,
                      ),
                    );
                  },
                ),

                SizedBox(height: ArenaMedidas.s16),

                // Texto «ARENA» con ArenaTextos.titulo en color ArenaColors.dorado
                Text(
                  'ARENA',
                  style: ArenaTextos.titulo.copyWith(
                    color: ArenaColors.dorado,
                  ),
                ),

                SizedBox(height: ArenaMedidas.s32),

                // CircularProgressIndicator dorado
                CircularProgressIndicator(
                  color: ArenaColors.dorado,
                ),

                SizedBox(height: ArenaMedidas.s16),

                // Texto «Comprobando sesión…» con ArenaTextos.cuerpoSuave
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