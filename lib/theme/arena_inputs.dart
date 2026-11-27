import 'package:flutter/material.dart';

import 'arena_theme.dart';

class ArenaInputs {
  ArenaInputs._();

  static OutlineInputBorder _borde(Color color, double grosor) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
        borderSide: BorderSide(color: color, width: grosor),
      );

  static InputDecoration decoracion({
    required String etiqueta,
    String? ayuda,
    required IconData icono,
  }) => InputDecoration(
    labelText: etiqueta,
    labelStyle: ArenaTextos.cuerpoSuave,
    floatingLabelStyle: WidgetStateTextStyle.resolveWith(
      (estados) => ArenaTextos.etiqueta.copyWith(
        color: estados.contains(WidgetState.error)
            ? ArenaColors.negativo
            : ArenaColors.dorado,
      ),
    ),
    helperText: ayuda,
    helperMaxLines: 2,
    helperStyle: ArenaTextos.etiqueta.copyWith(fontWeight: FontWeight.w500),
    errorStyle: ArenaTextos.etiqueta.copyWith(
      color: ArenaColors.negativo,
      fontWeight: FontWeight.w500,
    ),
    prefixIcon: Icon(icono, color: ArenaColors.caballero),
    filled: true,
    fillColor: ArenaColors.superficie,
    contentPadding: const EdgeInsets.all(ArenaMedidas.s16),
    border: _borde(ArenaColors.borde, ArenaMedidas.grosorBorde),
    enabledBorder: _borde(ArenaColors.borde, ArenaMedidas.grosorBorde),
    disabledBorder: _borde(ArenaColors.borde, ArenaMedidas.grosorBorde),
    focusedBorder: _borde(
      ArenaColors.dorado,
      ArenaMedidas.grosorBordeSeleccion,
    ),
    errorBorder: _borde(ArenaColors.negativo, ArenaMedidas.grosorBorde),
    focusedErrorBorder: _borde(
      ArenaColors.negativo,
      ArenaMedidas.grosorBordeSeleccion,
    ),
  );
}
