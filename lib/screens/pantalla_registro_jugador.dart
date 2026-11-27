import 'package:arena_game/theme/arena_assets.dart';
import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../services/sesion_service.dart';
import '../../theme/arena_theme.dart';
import '../app/routes.dart';

class PantallaRegistroJugador extends StatefulWidget {
  const PantallaRegistroJugador({super.key});

  @override
  State<PantallaRegistroJugador> createState() =>
      _PantallaRegistroJugadorState();
}

class CabeceraFormulario extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  const CabeceraFormulario({
    super.key,
    required this.titulo,
    required this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(titulo, style: ArenaTextos.titulo, textAlign: TextAlign.center),
        const SizedBox(height: ArenaMedidas.s8),
        Text(
          subtitulo,
          style: ArenaTextos.cuerpoSuave,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _PantallaRegistroJugadorState extends State<PantallaRegistroJugador> {
  final _formKey = GlobalKey<FormState>();
  final _nick = TextEditingController();
  bool _aceptaNormas = false;
  bool _cargando = false;
  bool _intentoEnvio = false;

  @override
  void dispose() {
    _nick.dispose();
    super.dispose();
  }

  /// YA HECHO: manda el nick al servidor y guarda la sesión.
  /// Devuelve `null` si todo fue bien, o el mensaje de error para mostrarlo.
  Future<String?> _registrarYGuardar(String nick) async {
    try {
      final nuevo = await ArenaApi.crear().registrar(nick);

      await const SesionService().guardar(nuevo);
      return null;
    } on ApiError catch (e) {
      return e.mensaje;
    }
  }

  String? _validarNick(String? valor) {
    final limpio = valor?.trim() ?? '';

    if (limpio.isEmpty) {
      return 'Escribe un nick';
    }
    if (limpio.length < 3) {
      return 'Mínimo 3 caracteres';
    }
    if (limpio.length > 16) {
      return 'Máximo 16 caracteres';
    }
    if (!RegExp(r'^[A-Za-z0-9_]+$').hasMatch(limpio)) {
      return 'Solo letras, números y _';
    }

    return null;
  }

  Future<void> _entrar() async {
    setState(() {
      _intentoEnvio = true;
    });

    final formValid = _formKey.currentState?.validate() ?? false;
    if (!formValid || !_aceptaNormas) {
      return;
    }

    setState(() {
      _cargando = true;
    });

    final error = await _registrarYGuardar(_nick.text.trim());

    if (!mounted) {
      return;
    }

    setState(() {
      _cargando = false;
    });

    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    } else {
      Navigator.pushReplacementNamed(context, Routes.inicio);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(ArenaMedidas.s24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset(
                  ArenaAssets.emblema,
                  height: 110,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.shield, size: 64),
                ),
                const SizedBox(height: ArenaMedidas.s16),
                const CabeceraFormulario(
                  titulo: 'Únete a la Arena',
                  subtitulo: 'Elige un nick: así te verán en el ranking.',
                ),
                const SizedBox(height: ArenaMedidas.s24),
                TextFormField(
                  controller: _nick,
                  validator: _validarNick,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: 'Nick',
                    helperText: '3 a 16 caracteres: letras, números y _',
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: ArenaMedidas.s16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckboxListTile(
                      title: const Text('Acepto las normas de la Arena'),
                      value: _aceptaNormas,
                      onChanged: _cargando
                          ? null
                          : (valor) {
                              setState(() {
                                _aceptaNormas = valor ?? false;
                              });
                            },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (_intentoEnvio && !_aceptaNormas)
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(
                          'Debes aceptar las normas',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: ArenaMedidas.s24),
                SizedBox(
                  width: double.infinity,
                  child:
                  ElevatedButton(
                    onPressed: _cargando ? null : _entrar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade700,
                      disabledBackgroundColor: Colors.amber.shade700.withValues(alpha: 0.65),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Colors.amber.shade200,
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Visibility(
                          visible: !_cargando,
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          child: const Padding(
                            padding: EdgeInsets.all(25.0),
                            child: Text(
                              'Entrar a la Arena',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        if (_cargando)
                          const SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          ),
                      ],
                    ),
                  ),),
                const SizedBox(height: ArenaMedidas.s16),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.ajustes);
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text('Ajustes del servidor'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
