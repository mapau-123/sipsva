import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sipsva/app.dart';

void main() {
  testWidgets('muestra splash y abre el centro de monitoreo', (tester) async {
    await tester.pumpWidget(const SipsvaBootstrap());

    expect(find.text('SIPSVA'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 2200));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Centro de monitoreo'), findsOneWidget);
    expect(find.text('NIVEL DE RIESGO'), findsOneWidget);
  });
}
