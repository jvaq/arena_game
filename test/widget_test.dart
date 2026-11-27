import 'package:flutter/material.dart';

import 'soporte/arena_test_binding.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:arena_game/main.dart';
import 'package:arena_game/screens/pantalla_inicio.dart';
import 'package:arena_game/screens/pantalla_personaje.dart';
import 'package:arena_game/screens/pantalla_ranking.dart';
import 'package:arena_game/screens/pantalla_registro_jugador.dart';
import 'package:arena_game/services/sesion_service.dart';

Future<void> arrancar(WidgetTester tester, {bool conSesion = false}) async {
  SharedPreferences.setMockInitialValues(
    conSesion ? {'jugadorId': 110, 'nick': 'Joel_test', 'token': 'demo'} : {},
  );
  await tester.pumpWidget(const MyApp());
  await tester.runAsync(() async {
    await GoogleFonts.pendingFonts();
  });
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpAndSettle();
}

Future<void> pulsar(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  ArenaTestBinding();
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('Splash abre Registro sin sesión y valida nick y normas', (
    tester,
  ) async {
    await arrancar(tester);
    expect(find.byType(PantallaRegistroJugador), findsOneWidget);
    await pulsar(tester, find.text('Entrar a la Arena'));
    expect(find.text('Escribe un nick'), findsOneWidget);
    expect(find.text('Debes aceptar las normas'), findsOneWidget);

    for (final caso in {
      'ab': 'Mínimo 3 caracteres',
      'abcdefghijklmnopq': 'Máximo 16 caracteres',
      'Joel!': 'Solo letras, números y _',
    }.entries) {
      await tester.enterText(find.byKey(const ValueKey('nick')), caso.key);
      await tester.pump();
      expect(find.text(caso.value), findsOneWidget);
    }
    await tester.enterText(find.byKey(const ValueKey('nick')), ' Joel_3 ');
    await tester.pumpAndSettle();
    expect(find.text('Solo letras, números y _'), findsNothing);
    expect(await const SesionService().leer(), isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Registro muestra nick ocupado, permite reintentar y guarda sesión',
    (tester) async {
      await arrancar(tester);
      await tester.enterText(find.byKey(const ValueKey('nick')), 'Aria');
      await pulsar(tester, find.byKey(const ValueKey('normas')));
      await pulsar(tester, find.text('Entrar a la Arena'));
      expect(find.text('Ese nick ya existe'), findsOneWidget);
      expect(await const SesionService().leer(), isNull);

      await tester.enterText(find.byKey(const ValueKey('nick')), 'Joel_test');
      await pulsar(tester, find.text('Entrar a la Arena'));
      expect(find.byType(PantallaInicio), findsOneWidget);
      expect(find.text('Joel_test'), findsOneWidget);
      final sesion = await const SesionService().leer();
      expect(sesion?.nick, 'Joel_test');
      expect(sesion?.token, 'token-demo-Joel_test');
      expect(find.byType(PantallaRegistroJugador), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Splash restaura sesión, navega al ranking y permite cerrar sesión',
    (tester) async {
      await arrancar(tester, conSesion: true);
      expect(find.byType(PantallaInicio), findsOneWidget);
      await pulsar(tester, find.text('Ranking'));
      expect(find.byType(PantallaRanking), findsOneWidget);
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });
      await tester.pumpAndSettle();
      expect(find.text('TU POSICIÓN'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await pulsar(tester, find.byTooltip('Cerrar sesión'));
      expect(find.byType(PantallaRegistroJugador), findsOneWidget);
      expect(await const SesionService().leer(), isNull);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Inicio abre personaje, combatir e historial y recarga al volver',
    (tester) async {
      await arrancar(tester, conSesion: true);
      await pulsar(tester, find.text('Mi personaje'));
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });
      await tester.pumpAndSettle();
      expect(find.byType(PantallaPersonaje), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Joel_test'), findsOneWidget);

      await pulsar(tester, find.text('Combatir'));
      expect(find.text('Elegir rival'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await pulsar(tester, find.text('Historial'));
      expect(find.text('Historial'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Joel_test'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Inicio sin personaje desactiva Combatir y muestra el aviso', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'jugadorId': 107,
      'nick': 'nuevo01',
      'token': 'demo',
    });
    await tester.pumpWidget(const MyApp());
    await tester.runAsync(() async {
      await GoogleFonts.pendingFonts();
    });
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Sin personaje'), findsOneWidget);
    expect(
      find.text('Aún no tienes personaje. Créalo para poder combatir.'),
      findsOneWidget,
    );
    final combatir = find.widgetWithText(OutlinedButton, 'Combatir');
    expect(tester.widget<OutlinedButton>(combatir).onPressed, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Error al cargar Inicio ofrece reintento y cierre de sesión', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'jugadorId': 107,
      'nick': 'error01',
      'token': 'demo',
    });
    await tester.pumpWidget(const MyApp());
    await tester.runAsync(() async {
      await GoogleFonts.pendingFonts();
    });
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('No se pudo conectar con el servidor'), findsOneWidget);
    await pulsar(tester, find.text('Reintentar'));
    expect(find.text('No se pudo conectar con el servidor'), findsOneWidget);
    await pulsar(tester, find.byTooltip('Cerrar sesión'));
    expect(find.byType(PantallaRegistroJugador), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
