/// El servidor puede devolver la clase con nombres antiguos (guerrero, arquero).
/// Estas dos ayudas la convierten en una de las tres que tienen imagen:
/// `caballero`, `orco` o `mago`. Si es nula o desconocida, devuelve `caballero`.
String claseVisual(String? clase) {
  switch (clase) {
    case 'orco':
    case 'arquero':
      return 'orco';
    case 'mago':
      return 'mago';
    default:
      return 'caballero';
  }
}

/// Nombre para mostrar: `mago` → `Mago`.
String nombreClase(String? clase) {
  final c = claseVisual(clase);
  return c[0].toUpperCase() + c.substring(1);
}
