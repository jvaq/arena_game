import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:arena_game/services/api_service.dart';

void main() {
  test('API HTTP envía el nick y convierte registro y jugador', () async {
    final servidor = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => servidor.close(force: true));
    String? nickRecibido;
    servidor.listen((peticion) async {
      peticion.response.headers.contentType = ContentType.json;
      if (peticion.method == 'POST') {
        final datos = jsonDecode(
          await utf8.decoder.bind(peticion).join(),
        ) as Map<String, dynamic>;
        nickRecibido = datos['nick'] as String;
        peticion.response.statusCode = HttpStatus.created;
        peticion.response.write(
          jsonEncode({'id': 7, 'nick': nickRecibido, 'token': 'prueba'}),
        );
      } else {
        peticion.response.write(
          jsonEncode({'id': 7, 'nick': 'Joel', 'configurado': false}),
        );
      }
      await peticion.response.close();
    });
    final api = ApiHttp('http://127.0.0.1:${servidor.port}');
    final registrado = await api.registrar('Joel');
    expect(nickRecibido, 'Joel');
    expect(registrado.id, 7);
    expect(registrado.token, 'prueba');
    final jugador = await api.obtenerJugador(7);
    expect(jugador.nick, 'Joel');
    expect(jugador.configurado, false);
  });

  test('API HTTP conserva el error 409 y su mensaje', () async {
    final servidor = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => servidor.close(force: true));
    servidor.listen((peticion) async {
      await peticion.drain<void>();
      peticion.response.statusCode = HttpStatus.conflict;
      peticion.response.write(jsonEncode({'error': 'Ese nick ya existe'}));
      await peticion.response.close();
    });
    await expectLater(
      ApiHttp('http://127.0.0.1:${servidor.port}').registrar('Aria'),
      throwsA(
        isA<ApiError>()
            .having((e) => e.codigo, 'codigo', 409)
            .having((e) => e.mensaje, 'mensaje', 'Ese nick ya existe'),
      ),
    );
  });

  test('API demo comunica fallo de red y nick ocupado', () async {
    await expectLater(ApiDemo().registrar('sinred'), throwsA(isA<ApiError>()));
    await expectLater(
      ApiDemo().registrar('Aria'),
      throwsA(isA<ApiError>().having((e) => e.codigo, 'codigo', 409)),
    );
  });
}
