import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../config/arena_config.dart';
import '../services/sesion_service.dart';
import '../theme/arena_assets.dart';
import '../theme/arena_theme.dart';

/// Ejercicio 1: marca centrada y estado de arranque en la parte inferior.
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
    final lectura = const SesionService().leer();
    // La espera visible empieza cuando Android ya ha dibujado la pantalla.
    await WidgetsBinding.instance.waitUntilFirstFrameRasterized;
    if (!mounted) return;
    await Future<void>.delayed(ArenaConfig.esperaSplash);
    final sesion = await lectura;
    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      sesion == null ? Routes.registro : Routes.inicio,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          ArenaAssets.fondo,
          fit: BoxFit.cover,
          errorBuilder: (_, error, stackTrace) =>
              const ColoredBox(color: ArenaColors.fondo),
        ),
        const ColoredBox(color: Colors.black54),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: ArenaMedidas.s24),
            child: Stack(
              children: [
                Align(
                  alignment: const Alignment(0, -0.1),
                  child: Column(
                    key: const ValueKey('marca_splash'),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        ArenaAssets.emblema,
                        height: ArenaMedidas.emblemaSplash,
                        errorBuilder: (_, error, stackTrace) => const Icon(
                          Icons.shield,
                          size: ArenaMedidas.emblemaSplash,
                          color: ArenaColors.dorado,
                        ),
                      ),
                      const SizedBox(height: ArenaMedidas.s16),
                      Text(
                        'ARENA',
                        style: ArenaTextos.titulo.copyWith(
                          color: ArenaColors.dorado,
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: ArenaMedidas.s32 * 2,
                    ),
                    child: Column(
                      key: const ValueKey('estado_splash'),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: ArenaMedidas.s24,
                          height: ArenaMedidas.s24,
                          child: CircularProgressIndicator(
                            color: ArenaColors.dorado,
                            strokeWidth: ArenaMedidas.grosorBorde,
                          ),
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
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
