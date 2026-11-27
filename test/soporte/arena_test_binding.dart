import 'package:flutter_test/flutter_test.dart';

/// Las pruebas de widgets no reciben el evento del motor gráfico de Android.
/// Este sustituto permite controlar cuándo termina el primer fotograma.
class ArenaTestBinding extends AutomatedTestWidgetsFlutterBinding {
  Future<void> primerFotograma = Future<void>.value();

  @override
  Future<void> get waitUntilFirstFrameRasterized => primerFotograma;
}
