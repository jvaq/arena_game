import 'dart:async';

import 'package:flutter/material.dart';

import 'soporte/arena_test_binding.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:arena_game/main.dart';
import 'package:arena_game/screens/pantalla_inicio.dart';
import 'package:arena_game/screens/pantalla_registro_jugador.dart';
import 'package:arena_game/services/sesion_service.dart';
import 'package:arena_game/theme/arena_theme.dart';

Future<void> abrir(WidgetTester tester, {String? nick}) async {
  SharedPreferences.setMockInitialValues(
    nick == null ? {} : {'jugadorId': 111, 'nick': nick, 'token': 'demo'},
  );
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pumpWidget(const MyApp());
  await tester.runAsync(() async {
    await GoogleFonts.pendingFonts();
  });
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpAndSettle();
}

Future<void> pulsar(WidgetTester tester, Finder boton) async {
  await tester.ensureVisible(boton);
  await tester.pumpAndSettle();
  await tester.tap(boton);
  await tester.pumpAndSettle();
}

void main() {
  final binding = ArenaTestBinding();
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets(
    'PDF: Splash separa marca y estado y se reemplaza sin dejar Atrás',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(const MyApp());
      await tester.runAsync(() async {
        await GoogleFonts.pendingFonts();
      });
      await tester.pump();
      expect(find.text('ARENA'), findsOneWidget);
      expect(find.text('Comprobando sesión…'), findsOneWidget);
      final marca = tester.getRect(find.byKey(const ValueKey('marca_splash')));
      final estado = tester.getRect(
        find.byKey(const ValueKey('estado_splash')),
      );
      expect(estado.top, greaterThan(marca.bottom));
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      final registro = find.byType(PantallaRegistroJugador);
      expect(registro, findsOneWidget);
      expect(Navigator.of(tester.element(registro)).canPop(), false);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'PDF: el nick muestra contador de 16 y valida también texto pegado largo',
    (tester) async {
      await abrir(tester);
      final campo = find.byKey(const ValueKey('nick'));
      expect(find.text('0/16'), findsOneWidget);
      await tester.enterText(campo, 'ab');
      await tester.pumpAndSettle();
      expect(find.text('2/16'), findsOneWidget);
      expect(
        tester.widget<Text>(find.text('2/16')).style!.color,
        ArenaColors.negativo,
      );
      expect(find.text('Mínimo 3 caracteres'), findsOneWidget);
      await tester.enterText(campo, 'abcdefghijklmnopq');
      await tester.pumpAndSettle();
      expect(find.text('17/16'), findsOneWidget);
      expect(find.text('Máximo 16 caracteres'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'PDF: al enviar se bloquean controles y el error sinred permite reintentar',
    (tester) async {
      await abrir(tester);
      final campo = find.byKey(const ValueKey('nick'));
      await tester.enterText(campo, 'sinred');
      await pulsar(tester, find.byKey(const ValueKey('normas')));
      final entrar = find.widgetWithText(FilledButton, 'Entrar a la Arena');
      await tester.ensureVisible(entrar);
      await tester.pumpAndSettle();
      await tester.tap(entrar);
      await tester.pump();
      expect(tester.widget<TextFormField>(campo).enabled, false);
      expect(
        tester
            .widget<CheckboxListTile>(find.byKey(const ValueKey('normas')))
            .onChanged,
        isNull,
      );
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('No se pudo conectar con el servidor'), findsOneWidget);
      expect(find.byType(PantallaRegistroJugador), findsOneWidget);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNotNull,
      );
      expect(await const SesionService().leer(), isNull);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('PDF: Ajustes vuelve al formulario conservando nick y normas', (
    tester,
  ) async {
    await abrir(tester);
    await tester.enterText(find.byKey(const ValueKey('nick')), 'Aria_77');
    await pulsar(tester, find.byKey(const ValueKey('normas')));
    await pulsar(tester, find.text('Ajustes del servidor'));
    expect(find.text('Próximamente'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextFormField>(find.byKey(const ValueKey('nick')))
          .controller!
          .text,
      'Aria_77',
    );
    expect(
      tester
          .widget<CheckboxListTile>(find.byKey(const ValueKey('normas')))
          .value,
      true,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'PDF: Inicio recarga datos al volver y resalta solo borde y texto sin personaje',
    (tester) async {
      await abrir(tester, nick: 'Joel');
      expect(find.byType(PantallaInicio), findsOneWidget);
      expect(
        Navigator.of(tester.element(find.byType(PantallaInicio))).canPop(),
        false,
      );
      await pulsar(tester, find.text('Historial'));
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('nick', 'nuevo01');
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('nuevo01'), findsOneWidget);
      expect(find.text('Sin personaje'), findsOneWidget);
      final personaje = tester.widget<OutlinedButton>(
        find.widgetWithText(OutlinedButton, 'Mi personaje'),
      );
      expect(
        personaje.style!.backgroundColor!.resolve({}),
        ArenaColors.superficie,
      );
      expect(personaje.style!.side!.resolve({})!.color, ArenaColors.dorado);
      expect(personaje.style!.foregroundColor!.resolve({}), ArenaColors.dorado);
      expect(
        tester
            .widget<OutlinedButton>(
              find.widgetWithText(OutlinedButton, 'Combatir'),
            )
            .onPressed,
        isNull,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('PDF: Registro e Inicio no desbordan en móviles pequeños', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    for (final ancho in [320.0, 360.0]) {
      tester.view.physicalSize = Size(ancho, 568);
      for (final nick in <String?>[null, 'nuevo01', 'abcdefghijklmnop']) {
        await abrir(tester, nick: nick);
        expect(
          tester.takeException(),
          isNull,
          reason: 'Pantalla de ancho $ancho, nick $nick',
        );
      }
    }
  });
  testWidgets(
    'PDF: un reintento reemplaza el aviso anterior por su propio error',
    (tester) async {
      await abrir(tester);
      final campo = find.byKey(const ValueKey('nick'));
      await tester.enterText(campo, 'Aria');
      await pulsar(tester, find.byKey(const ValueKey('normas')));
      await pulsar(tester, find.text('Entrar a la Arena'));
      expect(find.text('Ese nick ya existe'), findsOneWidget);
      await tester.enterText(campo, 'sinred');
      await pulsar(tester, find.text('Entrar a la Arena'));
      expect(find.text('No se pudo conectar con el servidor'), findsOneWidget);
      expect(find.text('Ese nick ya existe'), findsNothing);
      expect(find.byType(PantallaRegistroJugador), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Splash mantiene la espera visible después de un primer fotograma lento',
    (tester) async {
      final primerFotograma = Completer<void>();
      binding.primerFotograma = primerFotograma.future;
      addTearDown(() => binding.primerFotograma = Future<void>.value());
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(const MyApp());
      await tester.runAsync(() async {
        await GoogleFonts.pendingFonts();
      });
      await tester.pump(const Duration(seconds: 5));
      expect(find.text('ARENA'), findsOneWidget);
      expect(find.byType(PantallaRegistroJugador), findsNothing);
      primerFotograma.complete();
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Comprobando sesión…'), findsOneWidget);
      expect(find.byType(PantallaRegistroJugador), findsNothing);
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(find.byType(PantallaRegistroJugador), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
