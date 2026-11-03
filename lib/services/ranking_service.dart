import '../models/models.dart';

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
    // TODO(grupo D): fase 1 → return RankingEjemplo.cargar();
    throw UnimplementedError('RankingService.cargarRanking sin implementar');
  }
}
