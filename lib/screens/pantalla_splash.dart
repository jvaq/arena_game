import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../config/arena_config.dart';
import '../../services/sesion_service.dart';
import '../../theme/arena_assets.dart';
import '../../theme/arena_theme.dart';

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
          Image.asset(
            ArenaAssets.fondo,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const ColoredBox(color: Colors.black),
          ),
          const ColoredBox(color: Color(0x8C000000)),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  ArenaAssets.emblema,
                  height: 160,
                  errorBuilder: (_, __, ___) => const SizedBox(height: 160),
                ),
                const SizedBox(height: ArenaMedidas.s16),
                Text(
                  'ARENA',
                  style: ArenaTextos.titulo.copyWith(color: ArenaColors.dorado),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: ArenaMedidas.s32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: ArenaColors.dorado),
                    const SizedBox(height: ArenaMedidas.s16),
                    Text(
                      'Comprobando sesión…',
                      style: ArenaTextos.cuerpoSuave,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}