/// Ajustes generales de la app. Lo mantiene el profesor.
class ArenaConfig {
  ArenaConfig._();

  /// `false` → MODO DEMO: la app funciona sola, con datos de ejemplo (no necesita servidor).
  /// `true`  → usa el servidor real de [urlServidor].
  static const bool usarServidor = false;

  /// Emulador Android: `http://10.0.2.2:8787` (servidor local).
  /// Servidor publicado: su dirección `https://...workers.dev`.
  static const String urlServidor = 'http://10.0.2.2:8787';

  /// Tiempo mínimo que se ve la pantalla de arranque.
  static const Duration esperaSplash = Duration(milliseconds: 1500);
}
