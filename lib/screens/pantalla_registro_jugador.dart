import 'package:arena_game/theme/arena_assets.dart';
import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../services/sesion_service.dart';
import '../../theme/arena_theme.dart';

import '../app/routes.dart';

/// EJERCICIO 2 · Registro: DISEÑO + VALIDACIONES + NAVEGACIÓN.
/// Diseño de referencia: Diseno_completo_Arena.pdf, pantalla «Registro».
class PantallaRegistroJugador extends StatefulWidget {
  const PantallaRegistroJugador({super.key});

  @override
  State<PantallaRegistroJugador> createState() =>
      _PantallaRegistroJugadorState();
}

class _PantallaRegistroJugadorState extends State<PantallaRegistroJugador> {
  // TODO 1: crea la GlobalKey<FormState> del formulario (ver ejercicios de formularios).
  bool _cargando = false;
  bool _aceptaNormas = false; //
  final _formKey = GlobalKey<
      FormState>(); // Ejecuta todas las validaciones a la vez cuando se pulsa el boton
  final _nickCtrl = TextEditingController(); // GUarda la informacion que el usuario mete en el campo nick

  @override
  void dispose() {
    _nickCtrl.dispose(); // limpia _nickCtrl de la memoria para evitar fallos.
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

  /// Comprueba en todo momento la informacion en nick y la valida
  String? _validarNick(String? valor) {
    final nick = valor?.trim() ?? '';
    if (nick.isEmpty) {
      return "Escribe un nick";
    }
    if (nick.length < 3) {
      return "El nombre es demasiado corto";
    }
    if (nick.length > 16) {
      return "El nombre es demasiado largo";
    }
    if (!RegExp(r'^[A-Za-z0-9_]+$').hasMatch(
        nick)) { // Comprueba que no haya caracteres distintos a los definidos (^[A-Za-z0-9_]+$) ^ para inicio de cadena,+ obliga a que minimo haya 2 caracteres iguales y $ para finalizar cadena
      return 'Solo letras, números y _';
    }
    return null;
  }

  Future<void> _entrar() async {
    // TODO 4 (validación): comprueba el formulario (y que las normas estén aceptadas);
    //   si algo falla, sal con `return`.

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    // TODO 5 (navegación): pon _cargando = true (setState) y llama a
    //   `final error = await _registrarYGuardar(_nickCtrl.text.trim());`
    //   - si error != null → muestra un SnackBar con el mensaje
    //   - si es null       → Navigator.pushReplacementNamed(context, Rutas.inicio)
    //   Comprueba `mounted` antes de usar context y deja _cargando = false al acabar.

    setState(() {
      _cargando = true;
    });
    final error = await _registrarYGuardar(_nickCtrl.text.trim());

    /// Comprueba si el usuario ha cerrado la pantalla mientras se esperaba, si la pantalla no esta dibujada e inactiva corta la funcion para evitar problemas
    if (!mounted) {
      return;
    }

    /// Quita el estado de carga de la pantalla y reactiva el boton "Entrar a la arena"
    setState(() {
      _cargando = false;
    });

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar( // muestra un mensaje de error
        SnackBar(content: Text(error)),
      );
    } else {
      Navigator.pushReplacementNamed(
          context, Routes.inicio); // te lleva a la pantalla inicio
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const CabeceraFormulario(
                  titulo: 'Únete a la Arena',
                  subtitulo: 'Elige un nick: así te verán en el ranking.',
                ),
                const SizedBox(height: ArenaMedidas.s24),
                TextFormField(
                  controller: _nickCtrl,
                  maxLength: 16,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: 'Nick',
                    helperText: '3 a 16 caracteres: letras, números y _',
                    prefixIcon: const Icon(Icons.person, color: ArenaColors.dorado),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ArenaMedidas.radioBoton),
                    )
                  ),
                  validator: _validarNick,
                ),
                const SizedBox(height: ArenaMedidas.s16),
                FormField<bool>(
                  initialValue: _aceptaNormas,
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
                          value: state.value ?? false,
                          onChanged: (nuevoValor) {
                            setState(() => _aceptaNormas = nuevoValor ?? false);
                            state.didChange(nuevoValor);
                          },
                          title: const Text('Acepto las normas de la Arena'),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                        if (state.hasError)
                          Padding(
                            padding: const EdgeInsets.only(left: ArenaMedidas.s16),
                            child: Text(
                              state.errorText!,
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
                  onPressed: () => Navigator.pushNamed(context, Routes.ajustes),
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
        Image.asset(
            ArenaAssets.emblema,
            height: 100,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.shield,
                size: 80,
                color: ArenaColors.dorado,
              );
            }
        ),
        const SizedBox(height: ArenaMedidas.s16),
        Text(
          titulo.toUpperCase(),
          style: ArenaTextos.titulo,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: ArenaMedidas.s8),
        Text(
          subtitulo,
          style: ArenaTextos.cuerpoSuave,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}

