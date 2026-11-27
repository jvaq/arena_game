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
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/ui/fondo_arena.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const ColoredBox(color: Color(0xFF140F26));
            },
          ),
          ColoredBox(color: Colors.black.withValues(alpha: 0.55)),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/ui/emblema.png',
                  height: 160,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.shield, size: 120);
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'ARENA',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE5A93C),
                  ),
                ),
                const SizedBox(height: 32),
                const CircularProgressIndicator(
                  color: Color(0xFFE5A93C),
                ),
                const SizedBox(height: 16),
                const Text('Comprobando sesión...'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



