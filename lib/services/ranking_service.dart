import '../models/models.dart';

/// PIEZA D · Origen de los datos del ranking.
///
/// Fase 1 (obligatoria): devolver los datos de ejemplo con `RankingEjemplo.cargar()`.
/// Fase 2 (opcional): llamar a la API `GET /ranking?top=10` con el paquete `http`,
///                    convertir cada elemento con `EntradaRanking.fromJson`.
///
/// Debe lanzar una excepción si algo falla (la pantalla mostrará RankingError).
/// NO cambies la firma del método.
// class RankingService {
//   const RankingService();
//
//   Future<RankingEjemplo> cargarRanking() async {
//     // TODO(grupo D): fase 1 → return RankingEjemplo.cargar();
//     throw UnimplementedError('RankingService.cargarRanking sin implementar');
//   }
// }


/// PIEZA D · Origen de los datos del ranking.
///
/// Fase 1 (obligatoria): devolver los datos de ejemplo con `RankingEjemplo.cargar()`.
/// Fase 2 (opcional): llamar a la API `GET /ranking?top=10` con el paquete `http`,
///                    convertir cada elemento con `EntradaRanking.fromJson`.
///
/// Debe lanzar una excepción si algo falla (la pantalla mostrará RankingError).
/// NO cambies la firma del método.
class RankingService {
  const RankingService();

  Future<RankingEjemplo> cargarRanking() async {
    // Si prefieres usar el constructor de ejemplo en Dart puro:
    await Future.delayed(const Duration(milliseconds: 300)); // Simula latencia opcional
    return RankingEjemplo.ejemplo();

    // O si prefieres usar el archivo JSON por rootBundle como indicaba el TODO original:
    // return await RankingEjemplo.cargar();
  }
}