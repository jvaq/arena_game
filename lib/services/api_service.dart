import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/arena_config.dart';
import '../models/models.dart';
import 'sesion_service.dart';

/// Error legible que las pantallas pueden mostrar tal cual (`e.mensaje`).
/// `codigo` es el código HTTP si lo hay (409 = nick repetido, por ejemplo).
class ApiError implements Exception {
  final String mensaje;
  final int? codigo;

  const ApiError(this.mensaje, [this.codigo]);

  @override
  String toString() => mensaje;
}

/// Lo que la app le pide al servidor. Lo mantiene el profesor.
///
///   final api = ArenaApi.crear();   // modo demo o servidor, según ArenaConfig
///   final nuevo = await api.registrar('Aria');
///   final jugador = await api.obtenerJugador(nuevo.id);
///
/// Los dos métodos lanzan [ApiError] si algo falla.
abstract class ArenaApi {
  /// POST /jugadores
  Future<JugadorRegistrado> registrar(String nick);

  /// GET /jugadores/{id}
  Future<Jugador> obtenerJugador(int id);

  factory ArenaApi.crear() =>
      ArenaConfig.usarServidor ? ApiHttp(ArenaConfig.urlServidor) : ApiDemo();
}

/// Servidor real, con el paquete `http`.
class ApiHttp implements ArenaApi {
  ApiHttp(this.base);

  final String base;
  static const _cabeceras = {'Content-Type': 'application/json'};

  @override
  Future<JugadorRegistrado> registrar(String nick) async {
    final datos = await _llamar(() => http.post(
          Uri.parse('$base/jugadores'),
          headers: _cabeceras,
          body: jsonEncode({'nick': nick}),
        ));
    return JugadorRegistrado.fromJson(datos);
  }

  @override
  Future<Jugador> obtenerJugador(int id) async {
    final datos = await _llamar(() => http.get(Uri.parse('$base/jugadores/$id')));
    return Jugador.fromJson(datos);
  }

  Future<Map<String, dynamic>> _llamar(Future<http.Response> Function() peticion) async {
    try {
      final res = await peticion().timeout(const Duration(seconds: 8));
      Map<String, dynamic> cuerpo = {};
      try {
        cuerpo = jsonDecode(res.body) as Map<String, dynamic>;
      } catch (_) {
        // cuerpo vacío o que no es JSON
      }
      if (res.statusCode >= 200 && res.statusCode < 300) return cuerpo;
      throw ApiError(cuerpo['error'] as String? ?? 'Error ${res.statusCode}', res.statusCode);
    } on ApiError {
      rethrow;
    } on TimeoutException {
      throw const ApiError('El servidor tarda demasiado en responder');
    } catch (_) {
      throw const ApiError('No se pudo conectar con el servidor');
    }
  }
}

/// MODO DEMO: no necesita servidor. Sirve para desarrollar y probar los estados.
///
/// Nicks de prueba:
///   Aria, Brakka, Sir_Galvan → «Ese nick ya existe» (409)
///   sinred                   → «No se pudo conectar con el servidor» al registrar
///   nuevo…  (ej. nuevo01)    → jugador SIN personaje configurado
///   error…  (ej. error01)    → falla al cargar el Inicio (para ver el estado de error)
///   cualquier otro           → jugador con personaje (mago, 340 puntos)
class ApiDemo implements ArenaApi {
  static const _ocupados = ['aria', 'brakka', 'sir_galvan'];

  @override
  Future<JugadorRegistrado> registrar(String nick) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    final n = nick.toLowerCase();
    if (n == 'sinred') throw const ApiError('No se pudo conectar con el servidor');
    if (_ocupados.contains(n)) throw const ApiError('Ese nick ya existe', 409);
    return JugadorRegistrado(id: 100 + nick.length, nick: nick, token: 'token-demo-$nick');
  }

  @override
  Future<Jugador> obtenerJugador(int id) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final sesion = await const SesionService().leer();
    final nick = sesion?.nick ?? 'Aria';
    final n = nick.toLowerCase();
    if (n.startsWith('error')) throw const ApiError('No se pudo conectar con el servidor');
    if (n.startsWith('nuevo')) {
      return Jugador(id: id, nick: nick, configurado: false);
    }
    return Jugador(
      id: id,
      nick: nick,
      configurado: true,
      clase: 'mago',
      color: '#8E5CF7',
      puntos: 340,
      victorias: 21,
      derrotas: 3,
    );
  }
}
