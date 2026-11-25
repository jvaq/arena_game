import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../services/sesion_service.dart';
import '../../theme/arena_theme.dart';
import '../app/routes.dart';
import '../theme/arena_assets.dart';

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
    final nick = (valor ?? '').trim();

    if (nick.isEmpty) return 'Escribe un nick';
    if (nick.length < 3) return 'Mínimo 3 caracteres';
    if (nick.length > 16) return 'Máximo 16 caracteres';
    if (!RegExp(r'^[A-Za-z0-9_]+$').hasMatch(nick)) {
      return 'Solo letras, números y _';
    }
    return null;
  }

  String? _validarNormas(bool? valor) {
    if (valor != true) return 'Debes aceptar las normas';
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

    if (!_formKey.currentState!.validate()) return;

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
  void _irAjustes() {
    Navigator.pushNamed(context, Routes.ajustes);
  }

  OutlineInputBorder _borde(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
      borderSide: BorderSide(color: color, width: ArenaMedidas.grosorBorde),
    );
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
                // --- Cabecera ---
                Center(child: Image.asset(ArenaAssets.emblema, height: 96)),
                const SizedBox(height: ArenaMedidas.s16),
                Text(
                  'Únete a la Arena',
                  textAlign: TextAlign.center,
                  style: ArenaTextos.subtitulo,
                ),
                const SizedBox(height: ArenaMedidas.s8),
                Text(
                  'Elige un nick: así te verán en el ranking.',
                  textAlign: TextAlign.center,
                  style: ArenaTextos.cuerpoSuave,
                ),
                const SizedBox(height: ArenaMedidas.s24),

                // --- Campo nick ---
                TextFormField(
                  controller: _nickCtrl,
                  maxLength: 16,
                  validator: _validarNick,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: ArenaTextos.cuerpo,
                  decoration: InputDecoration(
                    labelText: 'Nick',
                    helperText: '3 a 16 caracteres: letras, números y _',
                    helperStyle: ArenaTextos.etiqueta,
                    errorStyle: ArenaTextos.etiqueta.copyWith(
                      color: ArenaColors.negativo,
                    ),
                    prefixIcon: const Icon(Icons.person),
                    filled: true,
                    fillColor: ArenaColors.superficie,
                    border: _borde(ArenaColors.borde),
                    enabledBorder: _borde(ArenaColors.borde),
                    focusedBorder: _borde(ArenaColors.dorado),
                    errorBorder: _borde(ArenaColors.negativo),
                    focusedErrorBorder: _borde(ArenaColors.negativo),
                  ),
                ),

                // --- Casilla de normas ---
                FormField<bool>(
                  initialValue: false,
                  validator: _validarNormas,
                  builder: (campo) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CheckboxListTile(
                          value: campo.value,
                          onChanged: campo.didChange,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          activeColor: ArenaColors.dorado,
                          checkColor: ArenaColors.textoSobreDorado,
                          title: Text(
                            'Acepto las normas de la Arena',
                            style: ArenaTextos.cuerpo.copyWith(fontSize: 14),
                          ),
                        ),
                        if (campo.hasError)
                          Text(
                            campo.errorText!,
                            style: ArenaTextos.etiqueta.copyWith(
                              color: ArenaColors.negativo,
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: ArenaMedidas.s16),

                // --- Botón ---
                FilledButton(
                  onPressed: _cargando ? null : _entrar,
                  child: _cargando
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: ArenaColors.dorado,
                    ),
                  )
                      : const Text('Entrar a la Arena'),
                ),
                const SizedBox(height: ArenaMedidas.s8),

                // --- Enlace a ajustes ---
                TextButton.icon(
                  onPressed: _irAjustes,
                  icon: const Icon(Icons.settings, size: 16),
                  label: Text(
                    'Ajustes del servidor',
                    style: ArenaTextos.etiqueta,
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
