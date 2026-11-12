import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';
import '../../services/sesion_service.dart';
import '../../theme/arena_theme.dart';
import 'contenido_inicio.dart';

/// YA HECHA (no hay que editarla): carga los datos del jugador y muestra
/// «cargando», «error con reintento» o el [ContenidoInicio] (ejercicio 3).
class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  final _api = ArenaApi.crear();
  late Future<Jugador> _futuro;

  @override
  void initState() {
    super.initState();
    _futuro = _cargar();
  }

  Future<Jugador> _cargar() async {
    final sesion = await const SesionService().leer();
    if (sesion == null) throw const ApiError('No hay sesión iniciada');
    return _api.obtenerJugador(sesion.id);
  }

  void _recargar() => setState(() => _futuro = _cargar());

  Future<void> _cerrarSesion() async {
    await const SesionService().cerrar();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, Routes.registro);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arena'),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: _cerrarSesion,
          ),
        ],
      ),
      body: FutureBuilder<Jugador>(
        future: _futuro,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(ArenaMedidas.s24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off, size: 48, color: ArenaColors.textoSuave),
                    const SizedBox(height: ArenaMedidas.s16),
                    Text(snap.error.toString(), textAlign: TextAlign.center, style: ArenaTextos.cuerpo),
                    const SizedBox(height: ArenaMedidas.s16),
                    ElevatedButton(onPressed: _recargar, child: const Text('Reintentar')),
                  ],
                ),
              ),
            );
          }
          return ContenidoInicio(jugador: snap.data!, alVolver: _recargar);
        },
      ),
    );
  }
}
