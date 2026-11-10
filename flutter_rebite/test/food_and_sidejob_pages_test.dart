import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/food_detail.dart';
import '../lib/sidejob_register.dart';

void main() {
  testWidgets('food detail displays food information and claim action', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: FoodDetail(id: 1)));

    expect(tester.takeException(), isNull);
    expect(
      find.text('Surplus Meal Box: Karbohidrat & Protein'),
      findsOneWidget,
    );
    expect(find.text('Restoran Sederhana Food Bank'), findsOneWidget);
    expect(find.text('Klaim Kuota'), findsOneWidget);
  });

  testWidgets('sidejob registration displays the application form', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SidejobRegister()));

    expect(tester.takeException(), isNull);
    expect(find.text('Pendaftaran Kurir Sidejob'), findsOneWidget);
    expect(find.text('FORMULIR PENDAFTARAN KURIR'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(find.text('NOMOR WHATSAPP AKTIF'), findsOneWidget);
    expect(find.text('Kirim Pendaftaran Kurir'), findsOneWidget);
  });
}
