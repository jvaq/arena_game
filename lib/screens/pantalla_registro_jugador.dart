
import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../services/sesion_service.dart';
import '../../theme/arena_theme.dart';
import '../../widgets/registro/cabeceraFormulario.dart';
import '../../app/routes.dart';

// EJERCICIO 2 · Registro: DISEÑO + VALIDACIONES + NAVEGACIÓN.

class PantallaRegistroJugador extends StatefulWidget {
  const PantallaRegistroJugador({super.key});

  @override
  State<PantallaRegistroJugador> createState() =>
      _PantallaRegistroJugadorState();
}

class _PantallaRegistroJugadorState
    extends State<PantallaRegistroJugador> {

  // Controllers and form
  final _formKey = GlobalKey<FormState>();
  final _nickCtrl = TextEditingController();

  bool _cargando = false;

  @override
  void dispose() {
    _nickCtrl.dispose();
    super.dispose();
  }

  // Sends the nick to the server and saves the session.
  // Returns null if successful, or an error message.
  Future<String?> _registrarYGuardar(String nick) async {
    try {
      final nuevo = await ArenaApi.crear().registrar(nick);

      await const SesionService().guardar(nuevo);

      return null;
    } on ApiError catch (e) {
      return e.mensaje;
    }
  }

  // Nick validation
  String? _validarNick(String? valor) {
    final nick = valor?.trim() ?? '';

    if (nick.isEmpty) {
      return 'Escribe un nick';
    }

    if (nick.length < 3) {
      return 'Mínimo 3 caracteres';
    }

    if (nick.length > 16) {
      return 'Máximo 16 caracteres';
    }

    if (!RegExp(r'^[A-Za-z0-9_]+$').hasMatch(nick)) {
      return 'Solo letras, números y _';
    }

    return null;
  }

  // Registration
  Future<void> _entrar() async {

    // Validate all form fields
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Activate loading
    setState(() {
      _cargando = true;
    });

    String? error;

    try {
      error = await _registrarYGuardar(_nickCtrl.text.trim());
    } catch (_) {
      error = 'No se pudo completar el registro. Inténtalo de nuevo.';
    }

    // Check if the widget still exists
    if (!mounted) return;

    if (error != null) {

      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
        ),
      );

    } else {

      // Navigate to home
      Navigator.pushReplacementNamed(
        context,
        Routes.inicio,
      );

      return;
    }

    // Stop loading
    setState(() {
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ArenaMedidas.s24),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [

                // Header
                cabeceraFormulario(),

                const SizedBox(height: 24),

                // Arena emblem
                Image.asset(
                  'assets/images/ui/emblema.png',
                  height: 140,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 32),

                // Nick field
                TextFormField(controller: _nickCtrl,
                  validator: _validarNick,

                  autovalidateMode:
                  AutovalidateMode.onUserInteraction,
                ),

                const SizedBox(height: 20),

                // Rules checkbox
                FormField<bool>(
                  initialValue: false,

                  autovalidateMode:
                  AutovalidateMode.onUserInteraction,

                  validator: (value) {
                    if (value != true) {
                      return 'Debes aceptar las normas';
                    }

                    return null;
                  },

                  builder: (field) {
                    return Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        CheckboxListTile(
                          value: field.value ?? false,

                          title: const Text(
                            'Acepto las normas de la Arena',
                          ),

                          controlAffinity:
                          ListTileControlAffinity.leading,

                          contentPadding: EdgeInsets.zero,

                          onChanged: (value) {
                            field.didChange(value ?? false);
                          },
                        ),

                        if (field.hasError)
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 12),

                            child: Text(
                              field.errorText!,

                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme.error,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Register button
                ElevatedButton(
                  onPressed: _cargando ? null : _entrar,

                  child: _cargando
                      ? const SizedBox(
                    height: 20,
                    width: 20,

                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                      : const Text('Entrar a la Arena'),
                ),

                const SizedBox(height: 12),

                // Server settings
                TextButton.icon(
                  onPressed: _cargando
                      ? null
                      : () {
                    Navigator.pushNamed(
                      context,
                      Routes.ajustes,
                    );
                  },

                  icon: const Icon(Icons.settings),

                  label: const Text(
                    'Ajustes del servidor',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
