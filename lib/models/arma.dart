import 'stats.dart';

/// Un arma de personajes.json.
class Arma {
  final String id;
  final String nombre;
  final String imagen; // ruta de asset completa
  final Stats bonus;
  final String descripcion;

  const Arma({
    required this.id,
    required this.nombre,
    required this.imagen,
    required this.bonus,
    required this.descripcion,
  });

  factory Arma.fromJson(Map<String, dynamic> json) => Arma(
        id: json['id'] as String,
        nombre: json['nombre'] as String,
        imagen: json['imagen'] as String,
        bonus: Stats.fromJson(json['bonus'] as Map<String, dynamic>),
        descripcion: json['descripcion'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'imagen': imagen,
        'bonus': bonus.toJson(),
        'descripcion': descripcion,
      };
}
