import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';
import '../models/sesion.dart';

/// Guarda en el móvil (preferencias) quién eres y tu token.
/// Lo mantiene el profesor: las pantallas solo lo USAN.
///
///   final sesion = await const SesionService().leer();   // Sesion? (null si no hay)
///   await const SesionService().guardar(jugadorRegistrado);
///   await const SesionService().cerrar();                // borra todo
class SesionService {
  const SesionService();

  static const _claveId = 'jugadorId';
  static const _claveNick = 'nick';
  static const _claveToken = 'token';

  Future<Sesion?> leer() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt(_claveId);
    final nick = prefs.getString(_claveNick);
    final token = prefs.getString(_claveToken);
    if (id == null || nick == null || token == null) return null;
    return Sesion(id: id, nick: nick, token: token);
  }

  Future<void> guardar(JugadorRegistrado jugador) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_claveId, jugador.id);
    await prefs.setString(_claveNick, jugador.nick);
    await prefs.setString(_claveToken, jugador.token);
  }

  Future<void> cerrar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_claveId);
    await prefs.remove(_claveNick);
    await prefs.remove(_claveToken);
  }
}
