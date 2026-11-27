import 'package:arena_game/models/cabezeraformulario.dart';
import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../services/api_service.dart';
import '../services/sesion_service.dart';
import '../theme/arena_theme.dart';

/// EJERCICIO 2 · Registro: DISEÑO + VALIDACIONES + NAVEGACIÓN.
/// Diseño de referencia: Diseno_completo_Arena.pdf, pantalla «Registro».
class PantallaRegistroJugador extends StatefulWidget {
  const PantallaRegistroJugador({super.key});

  @override
  State<PantallaRegistroJugador> createState() => _PantallaRegistroJugadorState();
}

class _PantallaRegistroJugadorState extends State<PantallaRegistroJugador> {
  // TODO 1: crea la GlobalKey<FormState> del formulario y los controladores.
  final _formKey = GlobalKey<FormState>();
  final _nickCtrl = TextEditingController();

  // Estados locales para las normas y el indicador de carga
  bool _normasAceptadas = false;
  String? _errorNormas;
  bool _cargando = false;

  @override
  void dispose() {
    _nickCtrl.dispose();
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

  // TODO 3 (validación): valida el nick según las reglas solicitadas.
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

  Future<void> _entrar() async {
    // TODO 4 (validación): comprueba el formulario y que las normas estén aceptadas.
    setState(() {
      _errorNormas = _normasAceptadas ? null : 'Debes aceptar las normas';
    });

    final esValidoFormulario = _formKey.currentState?.validate() ?? false;
    if (!esValidoFormulario || !_normasAceptadas) {
      return;
    }

    // TODO 5 (navegación y estado de carga):
    setState(() {
      _cargando = true;
    });

    final error = await _registrarYGuardar(_nickCtrl.text.trim());

    if (!mounted) return;

    setState(() {
      _cargando = false;
    });

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    } else {
      Navigator.pushReplacementNamed(context, Routes.inicio);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO 2 (diseño): SafeArea + SingleChildScrollView + Form + Column
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(ArenaMedidas.s24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const cabezeraformulario(),
                const SizedBox(height: ArenaMedidas.s24),

                // Campo de texto del Nick
                TextFormField(
                  controller: _nickCtrl,
                  validator: _validarNick,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLength: 16,
                  decoration: const InputDecoration(
                    labelText: 'Nick',
                    helperText: '3-16 caracteres: letras, números o _',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: ArenaMedidas.s16),

                // Casilla de verificación de las normas obligatoria
                FormField<bool>(
                  initialValue: _normasAceptadas,
                  builder: (state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CheckboxListTile(
                          value: _normasAceptadas,
                          onChanged: (valor) {
                            setState(() {
                              _normasAceptadas = valor ?? false;
                              if (_normasAceptadas) _errorNormas = null;
                            });
                          },
                          title: const Text('Acepto las normas de la Arena'),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                        if (_errorNormas != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                              _errorNormas!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: ArenaMedidas.s24),

                // Botón principal en amarillo/dorado
                ElevatedButton(
                  onPressed: _cargando ? null : _entrar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE5A93C),
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 48),
                    shape: const StadiumBorder(),
                  ),
                  child: _cargando
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('Entrar a la Arena'),
                ),
                const SizedBox(height: ArenaMedidas.s16),

                // Enlace de ajustes del servidor
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.ajustes);
                  },
                  icon: const Icon(Icons.settings, size: 18),
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