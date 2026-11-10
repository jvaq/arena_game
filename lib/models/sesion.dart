/// La sesión guardada en el móvil: quién eres y tu token.
/// (El token se recibe una sola vez, al registrarse.)
class Sesion {
  final int id;
  final String nick;
  final String token;

  const Sesion({required this.id, required this.nick, required this.token});
}
