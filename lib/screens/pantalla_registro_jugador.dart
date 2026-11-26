import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../services/api_service.dart';
import '../../services/sesion_service.dart';
import '../../theme/arena_theme.dart';

/// EJERCICIO 2 · Registro: DISEÑO + VALIDACIONES + NAVEGACIÓN.
/// Diseño de referencia: Diseno_completo_Arena.pdf, pantalla «Registro».
class PantallaRegistroJugador extends StatefulWidget {
  const PantallaRegistroJugador({super.key});

  @override
  State<PantallaRegistroJugador> createState() => _PantallaRegistroJugadorState();
}

class _PantallaRegistroJugadorState extends State<PantallaRegistroJugador> {
  final _formKey = GlobalKey<FormState>();
  final _nickCtrl = TextEditingController();
  bool _cargando = false;

  get ArenaInputs => null;

  @override
  void dispose() {
    _nickCtrl.dispose();
    super.dispose();
  }

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
    final formularioValido = _formKey.currentState?.validate() ?? false;
    if (!formularioValido) return;

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
                const CabeceraFormulario(
                  titulo: 'Únete a la Arena',
                  subtitulo: 'Elige un nick: así te verán en el ranking.',
                ),
                const SizedBox(height: ArenaMedidas.s24),

                TextFormField(
                  controller: _nickCtrl,
                  decoration: ArenaInputs.decoracion(
                    etiqueta: 'Nick',
                    ayuda: '3 a 16 caracteres: letras, números y _',
                    icono: Icons.person,
                  ),
                  maxLength: 16,
                  validator: _validarNick,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: ArenaMedidas.s16),

                FormField<bool>(
                  initialValue: false,
                  validator: (valor) {
                    if (valor != true) {
                      return 'Debes aceptar las normas';
                    }
                    return null;
                  },
                  builder: (state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CheckboxListTile(
                          value: state.value,
                          onChanged: _cargando
                              ? null
                              : (val) => state.didChange(val),
                          title: const Text('Acepto las normas de la Arena'),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                        if (state.hasError)
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                              state.errorText ?? '',
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: ArenaMedidas.s24),

                ElevatedButton(
                  onPressed: _cargando ? null : _entrar,
                  child: _cargando
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('Entrar a la Arena'),
                ),
                const SizedBox(height: ArenaMedidas.s16),

                TextButton.icon(
                  onPressed: _cargando
                      ? null
                      : () => Navigator.pushNamed(context, Routes.ajustes),
                  icon: const Icon(Icons.settings, size: 16),
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

/// Widget auxiliar para la cabecera del formulario (añadido aquí para resolver el error)
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitulo,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}