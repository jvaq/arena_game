import 'package:flutter/material.dart';

import '../models/models.dart';
import '../services/ranking_service.dart';
import '../theme/arena_theme.dart';
import '../widgets/ranking/estados_ranking.dart';
import '../widgets/ranking/fila_ranking.dart';
import '../widgets/ranking/tarjeta_tu_posicion.dart';


/// Pantalla 1 · Ranking. La monta el profesor (o el grupo de integración).
/// Ensambla las piezas A, B, C y D. No hay que tocarla para hacer una pieza.
class PantallaRanking extends StatefulWidget {
  const PantallaRanking({super.key});

  @override
  State<PantallaRanking> createState() => _PantallaRankingState();
}

class _PantallaRankingState extends State<PantallaRanking> {
  final _servicio = const RankingService();
  late Future<RankingEjemplo> _futuro;

  @override
  void initState() {
    super.initState();
    _futuro = _servicio.cargarRanking();
  }

  void _reintentar() => setState(() => _futuro = _servicio.cargarRanking());





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ranking')),
      body: FutureBuilder<RankingEjemplo>(
        future: _futuro,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const RankingCargando();
          }
          if (snap.hasError) {
            return RankingError(mensaje: '${snap.error}', onReintentar: _reintentar);
          }
          final ranking = snap.data!;
          if (ranking.top.isEmpty) return const RankingVacio();



          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(ArenaMedidas.s16),
                  itemCount: ranking.top.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemBuilder: (_, i) => FilaRanking(
                    entrada: ranking.top[i],
                    resaltada: ranking.top[i].id == ranking.tu.id,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(ArenaMedidas.s16),
                child: TarjetaTuPosicion(entrada: ranking.tu),
              ),
            ],
          );
        },
      ),
    );
  }
}
