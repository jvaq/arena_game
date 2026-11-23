import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../services/sesion_service.dart';
import '../../theme/arena_theme.dart';
import '../../widgets/registro/cabecera_formulario.dart';
import '../../app/routes.dart';

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
  final _clave = GlobalKey<FormState>();
  bool _cargando = false;
  bool _activo = false;
  final _nickCtrl = TextEditingController();

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
  String? _validarNick(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Escribe un nick';
    }
    if (valor.trim().length < 3) {
      return 'Mínimo 3 caracteres';
    }
    if (valor.trim().length > 16) {
      return 'Máximo 16 caracteres';
    }
    if (!RegExp(r'^[A-Za-z0-9_]+$').hasMatch(valor)) {
      return 'Solo letras, números y _';
    }
    return null;
  }


  Future<void> _entrar() async {
    // TODO 4 (validación): comprueba el formulario (y que las normas estén aceptadas);
    //   si algo falla, sal con `return`.
    if (!_clave.currentState!.validate() || !_activo) {
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
    if (!mounted) return; //se vuelve false cuando el usuario cierra la pantalla

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
            key: _clave,
            child: Column(
              children: [
                CabeceraFormulario(),
                const SizedBox(height: ArenaMedidas.s24),
                TextFormField(
                  controller: _nickCtrl,
                  validator: _validarNick,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  //para que el contador se ponga tambien en rojo si hay un error
                  buildCounter: (context, {required currentLength, required isFocused, required maxLength}) {
                    final esInvalido = currentLength > 0 && currentLength < 3 || currentLength > 16;
                    return Text(
                      '$currentLength/$maxLength',
                      style: TextStyle(
                        color: esInvalido ? ArenaColors.negativo : ArenaColors.textoSuave,
                        fontSize: 12,
                      ),
                    );
                  },
                  style: ArenaTextos.cuerpo.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Nick',
                    helperText: '3 a 16 caracteres: letras, números y _',
                    helperStyle: ArenaTextos.cuerpoSuave.copyWith(fontSize: 12),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.blueAccent,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        ArenaMedidas.radioTarjeta,
                      ),
                    ),
                  ),
                  maxLength: 16,
                ),
                FormField<bool>(
                  initialValue: _activo,
                  validator: (value) {
                    if (value != true) {
                      return 'Debes aceptar las normas';
                    }
                    return null;
                  },
                  builder: (state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CheckboxListTile(
                          dense: true,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          controlAffinity: ListTileControlAffinity.leading, //pone el checkbox a la izquierda
                          contentPadding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          horizontalTitleGap: ArenaMedidas.s4, //Reduce el espacio horizontal entre el checkbox y el texto
                          value: state.value,
                          onChanged: (v) {
                            state.didChange(v); //Actualiza estado del form field
                            setState(() => _activo = v ?? false); //Actualiza variable local
                          },
                          title: Text(
                            'Acepto las normas de la Arena',
                            style: ArenaTextos.cuerpo.copyWith(fontWeight: FontWeight.normal),
                          ),
                        ),
                        if (state.hasError)
                          Padding(
                            padding: const EdgeInsets.only(left: ArenaMedidas.s8),
                            child: Text(
                              state.errorText!,
                              style: ArenaTextos.etiqueta.copyWith(
                                color: ArenaColors.negativo,
                                fontWeight: FontWeight.normal
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: ArenaMedidas.s8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: ArenaMedidas.s16,
                        horizontal: ArenaMedidas.s24,
                      ),
                    ),
                    onPressed: _cargando
                        ? null
                        : _entrar,
                    child: _cargando
                        ? const SizedBox(
                            width: ArenaMedidas.s24,
                            height: ArenaMedidas.s24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: ArenaColors.texto,
                            ),
                          )
                        : Text(
                            'Entrar a la Arena',
                            style: ArenaTextos.boton.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: ArenaMedidas.s4),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.ajustes);
                  },
                  icon: const Icon(
                    Icons.settings,
                    fontWeight: FontWeight.normal,
                    color: ArenaColors.textoSuave
                  ),
                  label: Text(
                    'Ajustes del servidor',
                    style: ArenaTextos.cuerpoSuave.copyWith(fontWeight: FontWeight.normal),
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
