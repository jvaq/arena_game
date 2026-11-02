/// Rutas de todas las imágenes y datos del juego.
/// Úsalas así: Image.asset(ArenaAssets.personaje('mago'))
class ArenaAssets {
  ArenaAssets._();

  static const _img = 'assets/images';

  // Datos de ejemplo (mientras no tengas la API)
  static const personajesJson = 'assets/data/personajes.json';
  static const rankingEjemploJson = 'assets/data/ranking_ejemplo.json';

  // Interfaz
  static const fondo = '$_img/ui/fondo_arena.png';
  static const plataforma = '$_img/ui/plataforma.png';
  static const emblema = '$_img/ui/emblema.png';
  static const trofeo = '$_img/ui/trofeo.png';
  static const corona = '$_img/ui/corona.png';
  static const medallaOro = '$_img/ui/medalla_oro.png';
  static const medallaPlata = '$_img/ui/medalla_plata.png';
  static const medallaBronce = '$_img/ui/medalla_bronce.png';
  static const iconoVida = '$_img/ui/icono_vida.png';
  static const iconoAtaque = '$_img/ui/icono_ataque.png';
  static const iconoVelocidad = '$_img/ui/icono_velocidad.png';

  /// Medalla de una posición del podio (1, 2 o 3). Devuelve null si no hay.
  static String? medalla(int posicion) {
    switch (posicion) {
      case 1:
        return medallaOro;
      case 2:
        return medallaPlata;
      case 3:
        return medallaBronce;
      default:
        return null;
    }
  }

  /// clase: 'caballero', 'orco' o 'mago'
  static String personaje(String clase) => '$_img/characters/$clase.png';
  static String avatar(String clase) => '$_img/avatars/$clase.png';

  /// arma: el campo "imagen" del JSON ya trae la ruta completa;
  /// este método es un atajo si solo tienes clase + id del arma.
  static String arma(String clase, String idArma) =>
      '$_img/weapons/${clase}_$idArma.png';
}
