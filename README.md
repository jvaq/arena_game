# Arena · App Flutter (PMDM)

App móvil del juego **Arena**: un ranking de jugadores y una pantalla para configurar tu personaje.
Este README explica **cómo usar los recursos del proyecto** (imágenes, datos, colores y tipografías) y
**cómo aplicarlos en cada pantalla**. Los modelos de los JSON están en `lib/models/` (último apartado).

> Antes de empezar: ejecuta `flutter pub get` y lanza la app con `flutter run`.

---

## 1. Estructura del proyecto

```
assets/
  data/
    personajes.json          ← clases, stats base y 4 armas por clase
    ranking_ejemplo.json     ← top 10 + tu posición (datos de prueba)
  images/
    characters/              ← personaje grande (caballero, orco, mago)
    avatars/                 ← avatar redondo para el ranking
    weapons/                 ← 12 armas (4 por clase)
    ui/                      ← fondo, plataforma, medallas, iconos, trofeo...
lib/
  theme/
    arena_theme.dart         ← colores, medidas, estilos de texto y ThemeData
    arena_assets.dart        ← rutas de todas las imágenes
  models/                    ← clases de los JSON (fromJson / toJson)
  main.dart
pubspec.yaml
```

## 2. Puesta en marcha

1. **`pubspec.yaml`**: declara los assets y la dependencia de las fuentes (respeta la sangría):

   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     google_fonts: ^6.2.1      # Cinzel y Nunito

   flutter:
     uses-material-design: true
     assets:
       - assets/images/characters/
       - assets/images/avatars/
       - assets/images/weapons/
       - assets/images/ui/
       - assets/data/
   ```
   Si añades una carpeta nueva de imágenes, **hay que declararla aquí** (y reiniciar la app, no basta con hot reload).

2. **`lib/main.dart`**: aplica el tema a toda la app:

   ```dart
   import 'package:flutter/material.dart';
   import 'theme/arena_theme.dart';

   void main() => runApp(const ArenaApp());

   class ArenaApp extends StatelessWidget {
     const ArenaApp({super.key});

     @override
     Widget build(BuildContext context) => MaterialApp(
           title: 'Arena',
           theme: ArenaTheme.oscuro(),          // ← tema global
           debugShowCheckedModeBanner: false,
           home: const PantallaRanking(),
         );
   }
   ```

---

## 3. Imágenes

**Regla:** nunca escribas una ruta a mano. Usa siempre `ArenaAssets` (`lib/theme/arena_assets.dart`):
si una ruta cambia, solo se toca en un sitio.

```dart
Image.asset(ArenaAssets.personaje('mago'))
```

| Qué | Cómo se usa | Dónde |
|---|---|---|
| Fondo de la arena | `ArenaAssets.fondo` | Config. personaje (fondo de la parte superior) |
| Plataforma | `ArenaAssets.plataforma` | Config. personaje (bajo el personaje) |
| Emblema | `ArenaAssets.emblema` | Opcional: cabecera/splash |
| Trofeo | `ArenaAssets.trofeo` | AppBar del Ranking |
| Corona | `ArenaAssets.corona` | Opcional: primer puesto |
| Medallas oro/plata/bronce | `ArenaAssets.medalla(posicion)` (devuelve `null` si la posición > 3) | Ranking, puestos 1-3 |
| Iconos vida / ataque / velocidad | `ArenaAssets.iconoVida`, `.iconoAtaque`, `.iconoVelocidad` | Barras de stats |
| Personaje grande | `ArenaAssets.personaje('caballero' \| 'orco' \| 'mago')` | Config. personaje |
| Avatar redondo | `ArenaAssets.avatar('caballero' \| 'orco' \| 'mago')` | Ranking y selector de clase |
| Arma | `arma.imagen` (ruta completa en el JSON) o `ArenaAssets.arma('mago', 'libro')` | Rejilla de armas, personaje |

Ejemplos:

```dart
// Avatar circular con borde del color de la clase
Container(
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(color: ArenaColors.deClase(clase), width: 2),
  ),
  child: ClipOval(
    child: Image.asset(ArenaAssets.avatar(clase), width: 44, height: 44, fit: BoxFit.cover),
  ),
)

// Medalla o número según la posición
final medalla = ArenaAssets.medalla(posicion);
medalla != null
    ? Image.asset(medalla, width: 32)
    : Text('$posicion', style: ArenaTextos.subtitulo);

// Fondo a pantalla completa de una zona
Stack(children: [
  Positioned.fill(child: Image.asset(ArenaAssets.fondo, fit: BoxFit.cover)),
  // ...contenido
]);
```

Consejos: pon `width`/`height` para que Flutter no cargue la imagen a tamaño completo, y usa `errorBuilder`
si una ruta puede fallar.

---

## 4. Colores y medidas

Todos los colores salen de `ArenaColors` y las medidas de `ArenaMedidas`. **No uses `Color(0xFF...)` ni números sueltos** en las pantallas.

| Uso | Constante | Valor |
|---|---|---|
| Fondo | `ArenaColors.fondo` | `#14101F` |
| Tarjetas | `ArenaColors.superficie` | `#1F1A33` |
| Tarjetas destacadas / desactivado | `ArenaColors.superficieAlta` | `#2B2447` |
| Bordes | `ArenaColors.borde` | `#3C3361` |
| Acento (puntos, TÚ, botón) | `ArenaColors.dorado` | `#F2B84B` |
| Texto / texto suave | `ArenaColors.texto` / `.textoSuave` | `#F4EFFF` / `#A89FC7` |
| Texto sobre dorado | `ArenaColors.textoSobreDorado` | `#1B1430` |
| Caballero / Orco / Mago | `ArenaColors.caballero` / `.orco` / `.mago` | `#4C8FD6` / `#6BBF59` / `#8E5CF7` |
| Color según clase | `ArenaColors.deClase('mago')` | — |
| Oro / plata / bronce | `ArenaColors.oro` / `.plata` / `.bronce` | `#F2B84B` / `#C9D1DB` / `#CD7F4A` |

Espaciado: `ArenaMedidas.s4 / s8 / s16 / s24 / s32`. Radio de tarjeta `radioTarjeta` (16) y de botón `radioBoton` (26).
Grosor de borde: `grosorBorde` (1.5) y `grosorBordeSeleccion` (2.5).

```dart
Container(
  padding: const EdgeInsets.all(ArenaMedidas.s16),
  decoration: BoxDecoration(
    color: ArenaColors.superficie,
    borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
    border: Border.all(color: ArenaColors.borde, width: ArenaMedidas.grosorBorde),
  ),
  child: ...,
)
```

---

## 5. Tipografías

El proyecto usa dos fuentes de Google, cargadas con el paquete `google_fonts`:

- **Cinzel**: títulos y puntos (aire de juego de rol).
- **Nunito**: todo lo demás (legible en tamaños pequeños).

No hay que descargar nada ni declararlo en `fonts:` del `pubspec`: `google_fonts` las descarga la primera vez
que se usan (**necesita internet la primera ejecución**; luego quedan en caché).

Usa siempre los estilos de `ArenaTextos`:

| Estilo | Fuente · tamaño | Dónde se usa |
|---|---|---|
| `ArenaTextos.titulo` | Cinzel 32 bold | Título grande de pantalla |
| `ArenaTextos.subtitulo` | Cinzel 22 bold | Título del AppBar ("Ranking"), nombre de clase |
| `ArenaTextos.puntos` | Cinzel 18 bold dorado | Puntos de cada fila del ranking |
| `ArenaTextos.cuerpo` | Nunito 16 semibold | Nick, nombres de armas |
| `ArenaTextos.cuerpoSuave` | Nunito 14 | Descripciones, lema de la clase |
| `ArenaTextos.etiqueta` | Nunito 12 bold | "V · D", "TÚ", etiquetas pequeñas |
| `ArenaTextos.boton` | Nunito 16 extra-bold | Texto del botón (ya lo aplica el tema) |

```dart
Text('Ranking', style: ArenaTextos.subtitulo)
Text('${e.puntos}', style: ArenaTextos.puntos)
Text('21 V · 3 D', style: ArenaTextos.etiqueta)

// Cambiar solo un detalle sin perder la fuente:
Text('Aria', style: ArenaTextos.cuerpo.copyWith(fontSize: 18))
```

Si el tema está aplicado, también puedes usar `Theme.of(context).textTheme.headlineMedium`, `bodyLarge`, etc.
(el tema los mapea a los estilos de arriba).

**Fuentes sin internet (opcional):** descarga los `.ttf` de Cinzel y Nunito, ponlos en `assets/fonts/`,
decláralos en `flutter: fonts:` y cambia `GoogleFonts.cinzel(...)` por `TextStyle(fontFamily: 'Cinzel', ...)`.

---

## 6. Pantalla 1 · Ranking

**Qué recursos usa:** `trofeo.png`, `medalla_oro/plata/bronce.png`, avatares, `ranking_ejemplo.json`.

| Zona | Widget | Recursos |
|---|---|---|
| Cabecera | `AppBar` con trofeo + texto "Ranking" | `ArenaAssets.trofeo`, `ArenaTextos.subtitulo` (el tema ya lo aplica al `AppBar`) |
| Lista | `ListView.builder` con 10 tarjetas | `ArenaColors.superficie`, `radioTarjeta`, `grosorBorde` |
| Posición | medalla (1-3) o número | `ArenaAssets.medalla(pos)` / `ArenaTextos.subtitulo` en `textoSuave` |
| Avatar | círculo 38 px con borde del color de la clase | `ArenaAssets.avatar(clase)`, `ArenaColors.deClase(clase)` |
| Nick y "V · D" | `Column` | `ArenaTextos.cuerpo` y `ArenaTextos.etiqueta` |
| Puntos | `Text` a la derecha | `ArenaTextos.puntos` |
| Fila 1 | borde dorado | `ArenaColors.dorado` |
| Tu posición | tarjeta fija abajo (`bottomNavigationBar` o `Stack`), borde dorado 2.5, etiqueta **TÚ** | `ArenaColors.superficieAlta`, `dorado`, `textoSobreDorado` |

Estados: cargando (`CircularProgressIndicator(color: ArenaColors.dorado)`), error (mensaje + botón *Reintentar*) y lista vacía.

Esqueleto de una fila:

```dart
class FilaRanking extends StatelessWidget {
  const FilaRanking({super.key, required this.entrada});
  final EntradaRanking entrada;

  @override
  Widget build(BuildContext context) {
    final medalla = ArenaAssets.medalla(entrada.posicion);
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: ArenaMedidas.s8),
      decoration: BoxDecoration(
        color: ArenaColors.superficie,
        borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
        border: Border.all(
          color: entrada.posicion == 1 ? ArenaColors.dorado : ArenaColors.borde,
          width: ArenaMedidas.grosorBorde,
        ),
      ),
      child: Row(children: [
        SizedBox(
          width: 36,
          child: medalla != null
              ? Image.asset(medalla)
              : Text('${entrada.posicion}', textAlign: TextAlign.center, style: ArenaTextos.subtitulo),
        ),
        const SizedBox(width: ArenaMedidas.s8),
        // avatar con borde de color de clase ...
        const SizedBox(width: ArenaMedidas.s8),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(entrada.nick, style: ArenaTextos.cuerpo, overflow: TextOverflow.ellipsis),
            Text(entrada.victoriasDerrotas, style: ArenaTextos.etiqueta),
          ]),
        ),
        Text('${entrada.puntos}', style: ArenaTextos.puntos),
      ]),
    );
  }
}
```

Datos de prueba: `final ranking = await RankingEjemplo.cargar();` → `ranking.top` (las 10 filas) y `ranking.tu` (tu tarjeta fija).

---

## 7. Pantalla 2 · Configuración del personaje

**Qué recursos usa:** `fondo_arena.png`, `plataforma.png`, personajes, avatares, armas, iconos de stats y `personajes.json`.

| Zona | Widget | Recursos |
|---|---|---|
| Parte superior | `Stack` con `Positioned` | `ArenaAssets.fondo` (fondo), `ArenaAssets.plataforma` (suelo), `ArenaAssets.personaje(clase)` (grande) y las 2 armas elegidas pequeñas a los lados (`arma.imagen`) |
| Selector de clase | `Row` de 3 tarjetas | avatar + `clase.nombre`; la seleccionada con borde `grosorBordeSeleccion` del color `clase.color` |
| Lema | `Text` | `clase.lema` con `ArenaTextos.cuerpoSuave` |
| Barras de stats | 3 × `LinearProgressIndicator` | valor / `catalogo.maxPuntosBarra` (12); iconos `iconoVida`, `iconoAtaque`, `iconoVelocidad`; stats = `clase.statsCon(armasElegidas)` |
| Rejilla de armas | `GridView.count(crossAxisCount: 2)` | imagen, nombre y bonus de cada arma; **máximo 2** seleccionadas; al cambiar de clase se vacía la selección |
| Botón | `FilledButton` "Guardar personaje" | desactivado (`onPressed: null`) hasta tener exactamente `catalogo.armasPorPersonaje` armas; el tema ya le da el estilo |


Los bonus pueden ser negativos (por ejemplo el hacha de guerra suma ataque pero resta velocidad), así que usa `clamp(0.0, 1.0)` en la barra.

---

## 8. Modelos de los JSON (`lib/models/`)

Cada clase tiene `fromJson` (JSON → objeto) y `toJson` (objeto → JSON). Importa todas con:

```dart
import 'package:arena/models/models.dart';   // «arena» = name: de tu pubspec.yaml
```

### 8.1 Datos locales (`assets/data/`)

| Archivo | Clase raíz | Contiene |
|---|---|---|
| `personajes.json` | `Catalogo` | `version`, `maxPuntosBarra`, `armasPorPersonaje` y `clases` (`List<ClasePersonaje>`) |
| (dentro de `clases`) | `ClasePersonaje` | `id`, `nombre`, `lema`, `color` (convertido a `Color`), `imagen`, `avatar`, `base` (`Stats`) y `armas` (`List<Arma>`) |
| (dentro de `armas`) | `Arma` | `id`, `nombre`, `imagen`, `bonus` (`Stats`), `descripcion` |
| (bonus y base) | `Stats` | `vida`, `ataque`, `velocidad`; admite suma: `base + bonus` |
| `ranking_ejemplo.json` | `RankingEjemplo` | `top` (`List<EntradaRanking>`) y `tu` (`EntradaRanking`) |

```dart
final catalogo = await Catalogo.cargar();                 // lee y convierte el JSON
final mago = catalogo.clasePorId('mago');
final fuego = mago!.armas.first;
final stats = mago.statsCon([fuego]);                     // base + bonus
```
