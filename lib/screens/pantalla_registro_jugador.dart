import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../services/sesion_service.dart';
import '../../theme/arena_theme.dart';
import '../../app/routes.dart';

/// EJERCICIO 2 · Registro: DISEÑO + VALIDACIONES + NAVEGACIÓN.
/// Diseño de referencia: Diseno_completo_Arena.pdf, pantalla «Registro».
class PantallaRegistroJugador extends StatefulWidget {
  const PantallaRegistroJugador({super.key});

  @override
  State<PantallaRegistroJugador> createState() => _PantallaRegistroJugadorState();
}

class _PantallaRegistroJugadorState extends State<PantallaRegistroJugador> {
  // TODO 1: crea la GlobalKey<FormState> del formulario (ver ejercicios de formularios).
  final _formKey = GlobalKey<FormState>();
  final _nickCtrl = TextEditingController();

  bool _cargando = false;
  bool _normasAceptadas = false;

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

  // TODO 3 (validación): valida el nick. Devuelve el mensaje de error o null si es válido:
  //   - vacío (tras trim)                  → 'Escribe un nick'
  //   - menos de 3 caracteres              → 'Mínimo 3 caracteres'
  //   - más de 16 caracteres               → 'Máximo 16 caracteres'
  //   - algo que no sea letra, número o _  → 'Solo letras, números y _'
  //     (pista: RegExp(r'^[A-Za-z0-9_]+$').hasMatch(nick))
  // String? _validarNick(String? valor) { ... }
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
    // TODO 4 (validación): comprueba el formulario (y que las normas estén aceptadas);
    //   si algo falla, sal con `return`.
    // TODO 5 (navegación): pon _cargando = true (setState) y llama a
    //   `final error = await _registrarYGuardar(_nickCtrl.text.trim());`
    //   - si error != null → muestra un SnackBar con el mensaje
    //   - si es null       → Navigator.pushReplacementNamed(context, Rutas.inicio)
    //   Comprueba `mounted` antes de usar context y deja _cargando = false al acabar.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _cargando = true;
    });

    try {
      final error = await _registrarYGuardar(_nickCtrl.text.trim());

      if (!mounted) return;

      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
          ),
        );
        return;
      }

      Navigator.pushReplacementNamed(context, Routes.inicio);
    } finally {
      if (mounted) {
        setState(() {
          _cargando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO 2 (diseño): construye la pantalla con SafeArea + SingleChildScrollView
    //   (padding ArenaMedidas.s24) y un Form (con la key del TODO 1) que contenga una Column:
    //     - CabeceraFormulario(titulo: 'Únete a la Arena',
    //                          subtitulo: 'Elige un nick: así te verán en el ranking.')
    //     - TextFormField del nick: ArenaInputs.decoracion(etiqueta: 'Nick',
    //         ayuda: '3 a 16 caracteres: letras, números y _', icono: Icons.person),
    //         con controller, validator (TODO 3) y autovalidateMode onUserInteraction
    //     - casilla «Acepto las normas de la Arena» (CheckboxListTile) obligatoria,
    //         con el error en rojo visible si no se marca (FormField<bool> es lo más limpio)
    //     - botón «Entrar a la Arena» (ancho completo); desactivado y con
    //         CircularProgressIndicator pequeño mientras _cargando
    //     - TextButton.icon «Ajustes del servidor» → Navigator.pushNamed(context, Rutas.ajustes)
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(ArenaMedidas.s24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Únete a la Arena',
                  style: ArenaTextos.titulo,
                ),

                const SizedBox(height: ArenaMedidas.s16),

                Text(
                  'Elige un nick: así te verán en el ranking.',
                  style: ArenaTextos.cuerpoSuave,
                ),

                const SizedBox(height: ArenaMedidas.s24),

                TextFormField(
                  controller: _nickCtrl,
                  decoration: InputDecoration(
                    labelText: 'Nick',
                    helperText: '3 a 16 caracteres: letras, números y _',
                    prefixIcon: const Icon(Icons.person),
                    filled: true,
                    fillColor: ArenaColors.superficie,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
                    ),
                  ),
                  validator: _validarNick,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLength: 16,
                ),

                FormField<bool>(
                  initialValue: false,
                  validator: (valor) {
                    if (valor != true) {
                      return 'Debes aceptar las normas';
                    }
                    return null;
                  },
                  builder: (estado) {
                    return Column(
                      children: [
                        CheckboxListTile(
                          value: estado.value ?? false,
                          title: const Text('Acepto las normas de la Arena'),
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (valor) {
                            estado.didChange(valor);
                            setState(() {
                              _normasAceptadas = valor ?? false;
                            });
                          },
                        ),
                        if (estado.hasError)
                          Text(
                            estado.errorText!,
                            style: const TextStyle(color: ArenaColors.negativo),
                          ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: ArenaMedidas.s24),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _cargando ? null : _entrar,
                    child: _cargando
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: ArenaColors.dorado,
                      ),
                    )
                        : const Text('Entrar a la Arena'),
                  ),
                ),


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