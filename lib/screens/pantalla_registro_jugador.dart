import 'package:arena_game/theme/arena_assets.dart';
import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../services/sesion_service.dart';
import '../app/routes.dart';
import '../../theme/arena_theme.dart';

/// EJERCICIO 2 · Registro: DISEÑO + VALIDACIONES + NAVEGACIÓN.
/// Diseño de referencia: Diseno_completo_Arena.pdf, pantalla «Registro».
class PantallaRegistroJugador extends StatefulWidget {
  const PantallaRegistroJugador({super.key});

  @override
  State<PantallaRegistroJugador> createState() => _PantallaRegistroJugadorState();
}

class CabeceraFormulario extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  const CabeceraFormulario({
    super.key,
    required this.titulo,
    required this.subtitulo
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(titulo),
        Text(subtitulo)
      ],
    );
  }
}


class _PantallaRegistroJugadorState extends State<PantallaRegistroJugador> {
  // TODO 1: crea la GlobalKey<FormState> del formulario (ver ejercicios de formularios).
  bool _cargando = false;

  final _formKey = GlobalKey<FormState>();
  final _nick = TextEditingController();
  bool _aceptaNormas = false;

  @override
  void dispose() {
    _nick.dispose();
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
      return "Escribe un nick";
    }

    if(valor.trim().length < 3 ){
      return 'Debe tener al menos 3 caracteres';
    }

    if(valor.trim().length > 16){
      return 'Debe tener maximo 16 caracteres';
    }

    if(!RegExp(r'^[A-Za-z0-9_]+$').hasMatch(valor.trim())){
        return 'Solo letras, numetros y _';
    }

    // Devolvemos null si pasa todas las validaciones
    return null;
  }

  Future<void> _entrar() async {

    // TODO 4 (validación): comprueba el formulario (y que las normas estén aceptadas);
    //   si algo falla, sal con `return`.
    final formValid = _formKey.currentState?.validate() ?? false;
    if(!formValid || !_aceptaNormas){
      return;
    }
    // TODO 5 (navegación): pon _cargando = true (setState) y llama a
    setState(() {
      _cargando = true;
    });
    final error = await _registrarYGuardar(_nick.text.trim());
    //   - si error != null → muestra un SnackBar con el mensaje
    if(!mounted){
      return;
    }
    setState(() {
      _cargando = false;
    });





    if(error != null){
      SnackBar(content: Text(error));
    }else{
      Navigator.pushReplacementNamed(context, Routes.inicio);
    }
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

    var _nick = TextEditingController();

    void nickChanged(value){
        setState(() {
          _nick.text = value;
        });

    }


    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(ArenaMedidas.s24),
          child: Form(
              key: _formKey,
            child:

            Column(children: [
              Image.asset(ArenaAssets.emblema),
              CabeceraFormulario(titulo: 'Únete a la Arena',
                subtitulo: 'Elige un nick: así te verán en el ranking.',
              ),
              TextFormField(
                  validator: _validarNick,
                  onChanged: nickChanged,
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.red
                      )
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                    ),
                    labelText: 'Nick',

                    helperText: '3 a 16 caracteres: letras, numeros y _',
                    prefixIcon: Icon(Icons.person),

                  )
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CheckboxListTile(
                    title: const Text('Acepto las normas de la Arena'),
                    value: _aceptaNormas,
                    onChanged: (valor) {
                      setState(() {
                        _aceptaNormas = valor ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  // Muestra el texto de error en rojo si el usuario intentó enviar sin marcar
                  if (!_aceptaNormas && _formKey.currentState?.validate() == false)
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        'Debes aceptar las normas',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: ArenaMedidas.s24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(

                  ),
                  onPressed: _cargando ? null : _entrar,
                  child: _cargando
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: const Text('Entrar a la Arena',style: TextStyle(
                          fontSize: 18.0
                        ),),
                      ),
                ),
              ),
              const SizedBox(height: ArenaMedidas.s16),
              TextButton.icon(onPressed: () {
                  Navigator.pushNamed(context, Routes.ajustes );
              }, icon:Icon(Icons.settings) ,label: Text("Ajustes del servidor"))
            ],),
          ),
        ),
      ),
    );
  }
}
