import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/routes.dart';
import '../services/api_service.dart';
import '../services/sesion_service.dart';
import '../theme/arena_inputs.dart';
import '../theme/arena_theme.dart';
import '../widgets/formularios/cabecera_formulario.dart';

/// Ejercicio 2: diseño, cuatro reglas del nick, normas y navegación.
class PantallaRegistroJugador extends StatefulWidget {
  const PantallaRegistroJugador({super.key});

  @override
  State<PantallaRegistroJugador> createState() =>
      _PantallaRegistroJugadorState();
}

class _PantallaRegistroJugadorState extends State<PantallaRegistroJugador> {
  final _formKey = GlobalKey<FormState>();
  final _nickCtrl = TextEditingController();
  bool _cargando = false;

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
    } catch (_) {
      return 'No se pudo guardar la sesión. Inténtalo de nuevo.';
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
    if (_cargando || !_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    // Un reintento debe mostrar su propio resultado, sin mensajes anteriores en cola.
    ScaffoldMessenger.of(context).clearSnackBars();
    setState(() => _cargando = true);
    final error = await _registrarYGuardar(_nickCtrl.text.trim());
    if (!mounted) return;
    setState(() => _cargando = false);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(ArenaMedidas.s8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ArenaMedidas.s4),
          ),
          backgroundColor: ArenaColors.texto,
          content: Text(
            error,
            style: ArenaTextos.cuerpoSuave.copyWith(color: ArenaColors.fondo),
          ),
        ),
      );
    } else {
      Navigator.pushReplacementNamed(context, Routes.inicio);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
                key: const ValueKey('nick'),
                controller: _nickCtrl,
                enabled: !_cargando,
                validator: _validarNick,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textInputAction: TextInputAction.done,
                autocorrect: false,
                enableSuggestions: false,
                maxLength: 16,
                buildCounter:
                    (
                      context, {
                      required currentLength,
                      required isFocused,
                      maxLength,
                    }) => Text(
                      '$currentLength/$maxLength',
                      style: ArenaTextos.etiqueta.copyWith(
                        fontWeight: FontWeight.w500,
                        color:
                            currentLength > 0 &&
                                _validarNick(_nickCtrl.text) != null
                            ? ArenaColors.negativo
                            : ArenaColors.textoSuave,
                      ),
                    ),
                // Permite mostrar también el error «Máximo 16» al pegar un nick largo.
                maxLengthEnforcement: MaxLengthEnforcement.none,
                style: ArenaTextos.cuerpo,
                decoration: ArenaInputs.decoracion(
                  etiqueta: 'Nick',
                  ayuda: '3 a 16 caracteres: letras, números y _',
                  icono: Icons.person,
                ),
                onFieldSubmitted: (_) => _entrar(),
              ),
              const SizedBox(height: ArenaMedidas.s8),
              FormField<bool>(
                initialValue: false,
                validator: (acepta) =>
                    acepta == true ? null : 'Debes aceptar las normas',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                builder: (campo) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckboxListTile(
                      key: const ValueKey('normas'),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      minTileHeight: ArenaMedidas.s32 + ArenaMedidas.s8,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ArenaMedidas.s4),
                      ),
                      title: Text(
                        'Acepto las normas de la Arena',
                        style: ArenaTextos.cuerpoSuave.copyWith(
                          color: ArenaColors.texto,
                        ),
                      ),
                      value: campo.value ?? false,
                      onChanged: _cargando ? null : campo.didChange,
                    ),
                    if (campo.hasError)
                      Text(
                        campo.errorText!,
                        style: ArenaTextos.etiqueta.copyWith(
                          color: ArenaColors.negativo,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: ArenaMedidas.s8),
              FilledButton(
                onPressed: _cargando ? null : _entrar,
                child: _cargando
                    ? const SizedBox(
                        width: ArenaMedidas.s24,
                        height: ArenaMedidas.s24,
                        child: CircularProgressIndicator(
                          strokeWidth: ArenaMedidas.grosorBorde,
                          color: ArenaColors.textoSuave,
                        ),
                      )
                    : const Text('Entrar a la Arena'),
              ),
              const SizedBox(height: ArenaMedidas.s8),
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: ArenaColors.textoSuave,
                  textStyle: ArenaTextos.etiqueta.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  minimumSize: const Size.fromHeight(ArenaMedidas.s32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.all(ArenaMedidas.s8),
                ),
                onPressed: _cargando
                    ? null
                    : () => Navigator.pushNamed(context, Routes.ajustes),
                icon: const Icon(
                  Icons.settings,
                  size: ArenaMedidas.s8 + ArenaMedidas.s4,
                ),
                label: const Text('Ajustes del servidor'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
