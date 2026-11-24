import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../config/arena_config.dart';
import '../services/sesion_service.dart';
import '../theme/arena_assets.dart';
import '../theme/arena_theme.dart';

/// EJERCICIO 1 · Splash: DISEÑO + NAVEGACIÓN.
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

    // TODO 1 (navegación): pushReplacement para que «atrás» no vuelva al Splash
    if (sesion == null) {
      Navigator.pushReplacementNamed(context, Routes.registro);
    } else {
      Navigator.pushReplacementNamed(context, Routes.inicio);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO 2 (diseño)
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            ArenaAssets.fondo,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const ColoredBox(color: Colors.black),
          ),
          ColoredBox(color: Colors.black.withValues(alpha: 0.55)),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  ArenaAssets.emblema,
                  height: 160,
                  errorBuilder: (_, _, _) =>
                  const Icon(Icons.shield, size: 160),
                ),
                const SizedBox(height: ArenaMedidas.s16),
                Text(
                  'ARENA',
                  style: ArenaTextos.titulo.copyWith(color: ArenaColors.dorado),
                ),
                const SizedBox(height: ArenaMedidas.s32),
                const CircularProgressIndicator(color: ArenaColors.dorado),
                const SizedBox(height: ArenaMedidas.s16),
                Text('Comprobando sesión…', style: ArenaTextos.cuerpoSuave),
              ],
            ),
          ),
        ],
      ),
    );
  }
}