// widget_test.dart — ¡Poniendo a prueba nuestra creación!
// ═══════════════════════════════════════════════════════════════════════════
// Esta es una prueba básica de widgets. Para interactuar con un widget en tu
// test, usa la herramienta WidgetTester. Por ejemplo, puedes simular toques
// y scrolls, buscar elementos en el árbol de widgets y verificar que todo
// se vea y funcione como Fon Master manda.
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:byteup_code/main.dart';

void main() {
  testWidgets('Prueba de humo: el contador incrementa', (WidgetTester tester) async {
    // Construimos nuestra app y disparamos un frame.
    await tester.pumpWidget(const ByteUpCodeApp());

    // Verificamos que nuestro contador empiece en 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tocamos el icono '+' y disparamos un frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verificamos que nuestro contador haya subido.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
