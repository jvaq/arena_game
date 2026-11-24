import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../services/api_service.dart';
import '../services/sesion_service.dart';
import '../theme/arena_theme.dart';
import '../widgets/cabecera_formulario.dart';

/// EJERCICIO 2 · Registro: DISEÑO + VALIDACIONES + NAVEGACIÓN.
class PantallaRegistroJugador extends StatefulWidget {
  const PantallaRegistroJugador({super.key});

  @override
  State<PantallaRegistroJugador> createState() => _PantallaRegistroJugadorState();
}

class _PantallaRegistroJugadorState extends State<PantallaRegistroJugador> {
final _formKey = GlobalKey<FormState>();
final _nickCtrl = TextEditingController();
bool _aceptaNormas = false;
bool _errorNormas = false;
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
}
}

String? _validarNick(String? valor) {
final nick = valor?.trim() ?? '';
if (nick.isEmpty) return 'Escribe un nick';
if (nick.length < 3) return 'Mínimo 3 caracteres';
if (nick.length > 16) return 'Máximo 16 caracteres';
if (!RegExp(r'^[A-Za-z0-9_]+$').hasMatch(nick)) {
return 'Solo letras, números y _';
}
return null;
}

Future<void> _entrar() async {
final nickOk = _formKey.currentState!.validate();
setState(() => _errorNormas = !_aceptaNormas);
if (!nickOk || !_aceptaNormas) return;

setState(() => _cargando = true);
final error = await _registrarYGuardar(_nickCtrl.text.trim());
if (!mounted) return;

if (error != null) {
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
setState(() => _cargando = false);
} else {
Navigator.pushReplacementNamed(context, Routes.inicio);
}
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
automaticallyImplyLeading: false,
title: const Text('Registro'),
),
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
const SizedBox(height: ArenaMedidas.s32),


TextFormField(
controller: _nickCtrl,
maxLength: 16,
decoration: InputDecoration(
labelText: 'Nick',
helperText: '3 a 16 caracteres: letras, números y _',
prefixIcon: const Icon(Icons.person),
filled: true,
fillColor: ArenaColors.superficie,
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(16),
borderSide: BorderSide(color: ArenaColors.borde),
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(16),
borderSide: BorderSide(color: ArenaColors.borde),
),f
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(16),
borderSide: const BorderSide(color: ArenaColors.dorado, width: 1.9),
),
),
validator: _validarNick,
autovalidateMode: AutovalidateMode.onUserInteraction,
),

// Normas: checkbox dorado
CheckboxListTile(
title: const Text('Acepto las normas de la Arena'),
value: _aceptaNormas,
activeColor: ArenaColors.dorado,
checkColor: Colors.black,
onChanged: (v) => setState(() {
_aceptaNormas = v ?? false;
_errorNormas = false;
}),
controlAffinity: ListTileControlAffinity.leading,
contentPadding: EdgeInsets.zero,
),
if (_errorNormas)
Text(
'Debes aceptar las normas',
style: TextStyle(
color: Theme.of(context).colorScheme.error,
fontSize: 12,
),
),
const SizedBox(height: ArenaMedidas.s16),

ElevatedButton(
onPressed: _cargando ? null : _entrar,
style: ElevatedButton.styleFrom(
backgroundColor: ArenaColors.dorado,
foregroundColor: Colors.black,
minimumSize: const Size.fromHeight(50),
shape: const StadiumBorder(),
textStyle: const TextStyle(fontWeight: FontWeight.bold),
),
child: _cargando
? const SizedBox(
height: 25,
width: 25,
child: CircularProgressIndicator(strokeWidth: 2),
)
: const Text('Entrar a la Arena'),
),
const SizedBox(height: ArenaMedidas.s16),

// Enlace gris suave
TextButton.icon(
onPressed: () => Navigator.pushNamed(context, Routes.ajustes),
style: TextButton.styleFrom(foregroundColor: Colors.white54),
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