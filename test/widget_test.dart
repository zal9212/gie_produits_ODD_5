import 'package:flutter_test/flutter_test.dart';
import 'package:gie_prouits/main.dart';

void main() {
  testWidgets('App renders without error', (WidgetTester tester) async {
    await tester.pumpWidget(const GieProduitsApp());
    expect(find.text('GIE Produits'), findsWidgets);
  });
}
