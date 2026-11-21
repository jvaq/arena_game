import 'package:arena_game/widgets/cabecera_formulario.dart';
import 'package:flutter/material.dart';
import 'package:arena_game/app/routes.dart';
import '../../services/api_service.dart';
import '../../services/sesion_service.dart';
import '../../theme/arena_theme.dart';

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
  final _formKey = GlobalKey<FormState>(); //permite acceder al estado del formulario y comprobar si los campos son validos
  final _nickCtrl = TextEditingController(); //crea el controlador para obtener el nick introducido por el jugador.
  bool _cargando = false;

  @override
  void dispose() {
    super.dispose();
    _nickCtrl.dispose(); //libera recursos es opcional
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
    final String nick = valor?.trim() ?? '';

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

  //creo un widget para crear la clasilla de normas el checkbox
  Widget _crearCasillaNormas() {
    return FormField<bool>(
      initialValue: false,
      validator: (valor) =>
      valor == true ? null : 'Debes aceptar las normas',
      builder: (estado) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              title: const Text('Acepto las normas de la Arena'),
              value: estado.value ?? false,
              onChanged: (valor) => estado.didChange(valor),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            if (estado.hasError)
              Text(
                estado.errorText!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
          ],
        );
      },
    );
  }


    // TODO 4 (validación): comprueba el formulario (y que las normas estén aceptadas);
    //   si algo falla, sal con `return`.
    // TODO 5 (navegación): pon _cargando = true (setState) y llama a
    //   `final error = await _registrarYGuardar(_nickCtrl.text.trim());`
    //   - si error != null → muestra un SnackBar con el mensaje
    //   - si es null       → Navigator.pushReplacementNamed(context, Rutas.inicio)
    //   Comprueba `mounted` antes de usar context y deja _cargando = false al acabar.


Future<void> _entrar() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  setState(() {
    _cargando = true;
  });

  final String? error =
  await _registrarYGuardar(_nickCtrl.text.trim());

  if (!mounted) return;

  if (error != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error)),
    );

    setState(() {
      _cargando = false;
    });
    return;
  }

  setState(() {
    _cargando = false;
  });

  Navigator.pushReplacementNamed(context, Routes.inicio);
}

  @override
  Widget build(BuildContext context) {
    // TODO 2 (diseño): construye la pantalla con SafeArea + SingleChildScrollView
    //   (padding ArenaMedidas.s24) y un Form (con la key del TODO 1) que contenga una Column:
    //     - CabeceraFormulario(titulo: 'Únete a la Arena',
    //                          subtitulo: 'Elige un nick: así te verán en el ranking.')
    //     - TextFormField del nick: ArenaInputs.decoracion(etiqueta: 'Nick',
    //         ayuda: '3 a 16 caracteres: letras, números y _', icono: Icons.person),
    //         con controller, validator (TODO 3) y autovalidateMode onUserInteraction //Hecho
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
            key: _formKey, //permitirá validar todos los campos registrados
            child: Column(
              //se creo la cabecera en un widget y se hace el TextFormFiel para validar su contenido mendiante el form
              children: [
                CabeceraFormulario(
                  titulo: 'Únete a la Arena',
                  subtitulo: 'Elige un nick:así te verán en el ranking.',
                ),
                TextFormField(
                  controller: _nickCtrl,
                  decoration: ArenaInputs.decoracion(
                    etiqueta: 'Nick',
                    ayuda: '3 a 16 caracteres: letras, números y _',
                    icono: Icons.person),
                    maxLength: 16,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: _validarNick,
                  ),
                _crearCasillaNormas(), //se creo en un metodo despues de _validarNick
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _cargando ? null : _entrar,
                    child: _cargando
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
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
