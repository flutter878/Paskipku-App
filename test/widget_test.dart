import 'package:flutter_test/flutter_test.dart';
import 'package:paskibraka_mobile/main.dart';

void main() {
  testWidgets('App loads test', (WidgetTester tester) async {
    await tester.pumpWidget(const PaskibrakaApp());

    expect(find.text('Login Peserta'), findsOneWidget);
  });
}