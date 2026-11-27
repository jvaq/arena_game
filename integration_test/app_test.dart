import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:arena_game/main_arena.dart' as app;
import 'package:arena_game/models/jugador.dart';
import 'package:arena_game/screens/pantalla_inicio.dart';
import 'package:arena_game/screens/pantalla_personaje.dart';
import 'package:arena_game/screens/pantalla_ranking.dart';
import 'package:arena_game/screens/pantalla_registro_jugador.dart';
import 'package:arena_game/services/sesion_service.dart';

Future<void> pulsar(
  WidgetTester tester,
  Finder finder, {
  bool asentar = true,
}) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  if (asentar) await tester.pumpAndSettle();
}

Future<void> esperar(WidgetTester tester, Finder objetivo) async {
  final limite = DateTime.now().add(const Duration(seconds: 15));
  while (objetivo.evaluate().isEmpty && DateTime.now().isBefore(limite)) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  if (objetivo.evaluate().isEmpty) {
    debugPrint(
      'Textos al fallar: ${find.byType(Text).evaluate().map((e) => (e.widget as Text).data).join(" | ")}',
    );
  }
  expect(objetivo, findsOneWidget);
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Flujo Android: Splash, Registro, Inicio y navegación', (
    tester,
  ) async {
    // Evita que el IME nativo reponga un valor anterior al texto simulado.
    tester.testTextInput.register();
    addTearDown(tester.testTextInput.unregister);
    const sesiones = SesionService();
    final anterior = await sesiones.leer();
    addTearDown(() async {
      if (anterior == null) {
        await sesiones.cerrar();
      } else {
        await sesiones.guardar(
          JugadorRegistrado(
            id: anterior.id,
            nick: anterior.nick,
            token: anterior.token,
          ),
        );
      }
    });
    await sesiones.cerrar();
    app.main();
    await tester.pumpAndSettle();
    expect(find.byType(PantallaRegistroJugador), findsOneWidget);
    await pulsar(tester, find.text('Entrar a la Arena'));
    expect(find.text('Escribe un nick'), findsOneWidget);
    expect(find.text('Debes aceptar las normas'), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey('nick')), 'Aria');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextFormField>(find.byKey(const ValueKey('nick')))
          .controller!
          .text,
      'Aria',
    );
    await pulsar(tester, find.byKey(const ValueKey('normas')));
    await pulsar(tester, find.text('Entrar a la Arena'), asentar: false);
    await esperar(tester, find.text('Ese nick ya existe'));
    expect(find.byType(PantallaRegistroJugador), findsOneWidget);
    expect(await sesiones.leer(), isNull);

    await tester.enterText(find.byKey(const ValueKey('nick')), 'sinred');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextFormField>(find.byKey(const ValueKey('nick')))
          .controller!
          .text,
      'sinred',
    );
    await pulsar(tester, find.text('Entrar a la Arena'), asentar: false);
    await esperar(tester, find.text('No se pudo conectar con el servidor'));
    expect(find.byType(PantallaRegistroJugador), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey('nick')), 'nuevo01');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextFormField>(find.byKey(const ValueKey('nick')))
          .controller!
          .text,
      'nuevo01',
    );
    await pulsar(tester, find.text('Entrar a la Arena'));
    expect(find.text('Sin personaje'), findsOneWidget);
    expect(
      find.text('Aún no tienes personaje. Créalo para poder combatir.'),
      findsOneWidget,
    );
    final combatir = find.ancestor(
      of: find.text('Combatir'),
      matching: find.byType(OutlinedButton),
    );
    expect(tester.widget<OutlinedButton>(combatir).onPressed, isNull);
    await pulsar(tester, find.byTooltip('Cerrar sesión'));

    await tester.enterText(find.byKey(const ValueKey('nick')), 'Joel_3');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextFormField>(find.byKey(const ValueKey('nick')))
          .controller!
          .text,
      'Joel_3',
    );
    await tester.pumpAndSettle();
    await pulsar(tester, find.byKey(const ValueKey('normas')));
    await pulsar(tester, find.text('Entrar a la Arena'));
    expect(find.byType(PantallaInicio), findsOneWidget);
    expect((await const SesionService().leer())?.nick, 'Joel_3');

    expect(
      Navigator.of(tester.element(find.byType(PantallaInicio))).canPop(),
      isFalse,
    );
    // Reconstruir la aplicación conserva la sesión y omite Registro.
    await tester.pumpWidget(const SizedBox.shrink());
    app.main();
    await tester.pumpAndSettle();
    expect(find.byType(PantallaInicio), findsOneWidget);
    expect(find.byType(PantallaRegistroJugador), findsNothing);

    await pulsar(tester, find.text('Combatir'));
    expect(find.text('Próximamente'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await pulsar(tester, find.text('Historial'));
    expect(find.text('Próximamente'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await pulsar(tester, find.text('Ranking'));
    expect(find.byType(PantallaRanking), findsOneWidget);
    expect(find.text('TU POSICIÓN'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await pulsar(tester, find.text('Mi personaje'));
    expect(find.byType(PantallaPersonaje), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await pulsar(tester, find.byTooltip('Cerrar sesión'));
    expect(find.byType(PantallaRegistroJugador), findsOneWidget);
    expect(await const SesionService().leer(), isNull);
    expect(tester.takeException(), isNull);
  });
}
