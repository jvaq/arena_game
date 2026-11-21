import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../services/sesion_service.dart';
import '../../theme/arena_theme.dart';
import '../../theme/arena_assets.dart';
import '../../app/routes.dart';

class PantallaRegistroJugador extends StatefulWidget {
  const PantallaRegistroJugador({super.key});

  @override
  State<PantallaRegistroJugador> createState() => _PantallaRegistroJugadorState();
}

class _PantallaRegistroJugadorState extends State<PantallaRegistroJugador> {
  final _clave=GlobalKey<FormState>();
  final _nickController = TextEditingController();

  bool _cargando = false;

  @override
  void dispose() {
    _nickController.dispose();
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
    final nick = (valor ?? '').trim();
    if (nick.isEmpty) return 'Escribe un nick';
    if (nick.length < 3) return 'Mínimo 3 caracteres';
    if (nick.length > 16) return 'Máximo 16 caracteres';
    if (!RegExp(r'^[A-Za-z0-9_]+$').hasMatch(nick)) {
      return 'Solo letras, números y _';
    }
    return null;
  }

  Future<void> _entrar() async {

    if (!_clave.currentState!.validate()) return;

    setState(() => _cargando = true);
    final error = await _registrarYGuardar(_nickController.text.trim());

    if (!mounted) return;
    setState(() => _cargando = false);

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
            key:_clave,
            child:Column(
              children: [Center(child: Image.asset(
                ArenaAssets.emblema,
                height: 120,

              )
              ),
                Text(
                  "Únete a la Arena",
                  style: ArenaTextos.subtitulo,
                ),
                Text(
                  "Elige un nick: así te verán en el ranking.",

                ),
                TextFormField(
                  controller: _nickController,
                  maxLength: 16,
                  enabled: !_cargando,
                  textInputAction: TextInputAction.done,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: _validarNick,
                  decoration: InputDecoration(
                    labelText: 'Nick',
                    helperText: "3 a 16 caracteres: letras, números y _",
                    prefixIcon: const Icon(Icons.person,color: Colors.blue,),
                  ),
                ),
                FormField<bool>(
                  initialValue: false,
                  validator: (v) => v == true ? null : 'Debes aceptar las normas',
                  builder: (estado) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text('Acepto las normas de la Arena'),
                        value: estado.value ?? false,
                        onChanged: _cargando ? null : estado.didChange,
                      ),
                      if (estado.hasError)
                        Padding(
                          padding: const EdgeInsets.only(bottom: ArenaMedidas.s16),
                          child: Text(
                            estado.errorText!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _cargando ? null : _entrar,
                    child: _cargando
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Text('Entrar a la Arena'),
                  ),
                ),
                TextButton.icon(
                  onPressed: _cargando
                      ? null
                      : () => Navigator.pushNamed(context, Routes.ajustes),
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