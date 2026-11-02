import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Colores de la Arena. Todos los colores de la app salen de aquí.
class ArenaColors {
  ArenaColors._();

  // Fondos y superficies (de más oscuro a más claro)
  static const fondo = Color(0xFF14101F);
  static const superficie = Color(0xFF1F1A33);
  static const superficieAlta = Color(0xFF2B2447);
  static const borde = Color(0xFF3C3361);

  // Acento principal
  static const dorado = Color(0xFFF2B84B);
  static const doradoOscuro = Color(0xFFB8812A);

  // Texto
  static const texto = Color(0xFFF4EFFF);
  static const textoSuave = Color(0xFFA89FC7);
  static const textoSobreDorado = Color(0xFF1B1430);

  // Estados
  static const positivo = Color(0xFF4CD08A);
  static const negativo = Color(0xFFE5484D);

  // Medallas del podio
  static const oro = Color(0xFFF2B84B);
  static const plata = Color(0xFFC9D1DB);
  static const bronce = Color(0xFFCD7F4A);

  // Color de cada clase de personaje
  static const caballero = Color(0xFF4C8FD6);
  static const orco = Color(0xFF6BBF59);
  static const mago = Color(0xFF8E5CF7);

  /// clase: 'caballero', 'orco' o 'mago'
  static Color deClase(String clase) {
    switch (clase) {
      case 'orco':
        return orco;
      case 'mago':
        return mago;
      default:
        return caballero;
    }
  }
}

/// Medidas fijas: usa siempre estos valores en lugar de números sueltos.
class ArenaMedidas {
  ArenaMedidas._();

  static const double s4 = 4;
  static const double s8 = 8;
  static const double s16 = 16;
  static const double s24 = 24;
  static const double s32 = 32;

  static const double radioTarjeta = 16;
  static const double radioBoton = 26;
  static const double grosorBorde = 1.5;
  static const double grosorBordeSeleccion = 2.5;
}

/// Estilos de texto. Títulos con Cinzel, resto con Nunito.
/// (google_fonts descarga las fuentes la primera vez que se usan)
class ArenaTextos {
  ArenaTextos._();

  static TextStyle titulo = GoogleFonts.cinzel(
      fontSize: 32, fontWeight: FontWeight.w700, color: ArenaColors.texto);
  static TextStyle subtitulo = GoogleFonts.cinzel(
      fontSize: 22, fontWeight: FontWeight.w700, color: ArenaColors.texto);
  static TextStyle puntos = GoogleFonts.cinzel(
      fontSize: 18, fontWeight: FontWeight.w700, color: ArenaColors.dorado);
  static TextStyle cuerpo = GoogleFonts.nunito(
      fontSize: 16, fontWeight: FontWeight.w600, color: ArenaColors.texto);
  static TextStyle cuerpoSuave = GoogleFonts.nunito(
      fontSize: 14, fontWeight: FontWeight.w500, color: ArenaColors.textoSuave);
  static TextStyle etiqueta = GoogleFonts.nunito(
      fontSize: 12, fontWeight: FontWeight.w700, color: ArenaColors.textoSuave);
  static TextStyle boton = GoogleFonts.nunito(
      fontSize: 16,
      fontWeight: FontWeight.w800,
      color: ArenaColors.textoSobreDorado);
}

/// Tema global. En main.dart: MaterialApp(theme: ArenaTheme.oscuro(), ...)
class ArenaTheme {
  ArenaTheme._();

  static ThemeData oscuro() {
    const esquema = ColorScheme.dark(
      primary: ArenaColors.dorado,
      onPrimary: ArenaColors.textoSobreDorado,
      secondary: ArenaColors.mago,
      onSecondary: ArenaColors.texto,
      surface: ArenaColors.superficie,
      onSurface: ArenaColors.texto,
      error: ArenaColors.negativo,
      onError: ArenaColors.texto,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: esquema,
      scaffoldBackgroundColor: ArenaColors.fondo,
      textTheme: TextTheme(
        headlineLarge: ArenaTextos.titulo,
        headlineMedium: ArenaTextos.subtitulo,
        bodyLarge: ArenaTextos.cuerpo,
        bodyMedium: ArenaTextos.cuerpoSuave,
        labelSmall: ArenaTextos.etiqueta,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: ArenaColors.texto,
        titleTextStyle: ArenaTextos.subtitulo,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: ArenaColors.dorado,
          foregroundColor: ArenaColors.textoSobreDorado,
          disabledBackgroundColor: ArenaColors.superficieAlta,
          disabledForegroundColor: ArenaColors.textoSuave,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ArenaMedidas.radioBoton),
          ),
          textStyle: ArenaTextos.boton,
        ),
      ),
    );
  }
}
