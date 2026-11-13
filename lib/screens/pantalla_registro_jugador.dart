import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../services/sesion_service.dart';
import '../../theme/arena_theme.dart';
import '../../widgets/registro/cabecera_formulario.dart';

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

  @override
  void dispose() {
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

  Future<void> _entrar() async {
    // TODO 4 (validación): comprueba el formulario (y que las normas estén aceptadas);
    //   si algo falla, sal con `return`.
    // TODO 5 (navegación): pon _cargando = true (setState) y llama a
    //   `final error = await _registrarYGuardar(_nickCtrl.text.trim());`
    //   - si error != null → muestra un SnackBar con el mensaje
    //   - si es null       → Navigator.pushReplacementNamed(context, Rutas.inicio)
    //   Comprueba `mounted` antes de usar context y deja _cargando = false al acabar.
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
                const SizedBox(height: ArenaMedidas.s32),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nick',
                    helperText: '3 a 16 caracteres: letras, números y ...',
                    helperStyle: ArenaTextos.cuerpoSuave,
                    prefixIcon: Icon(
                      Icons.person,
                      color: ArenaColors.caballero,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        ArenaMedidas.radioTarjeta,
                      ),
                    ),
                  ),
                  maxLength: 16,
                ),
                const SizedBox(height: ArenaMedidas.s16),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding:EdgeInsets.zero,
                  value: _activo,
                  onChanged: (v) => setState(() => _activo = v ?? false),
                  title: Text(
                    "Acepto las normas de la Arena",
                    style: ArenaTextos.cuerpo,
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
