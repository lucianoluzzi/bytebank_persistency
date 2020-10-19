import 'package:bytebank_persistency/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Given Dashboard then display main image',
      (WidgetTester tester) async {
    await tester.pumpWidget(_getDashboard());
    final mainImage = find.byType(Image);
    expect(mainImage, findsOneWidget);
  });

  testWidgets('Given Dashboard, then should display transfer FeatureItem',
      (tester) async {
    await tester.pumpWidget(_getDashboard());
    final transferFeatureItem = find.byWidgetPredicate((widget) =>
        featureItemMatcher(widget, 'Transfer', Icons.monetization_on));

    expect(transferFeatureItem, findsOneWidget);
  });

  testWidgets(
      'Given Dashboard, then should display transaction feed FeatureItem',
      (tester) async {
    await tester.pumpWidget(_getDashboard());
    final transactionFeedFeatureItem = find.byWidgetPredicate((widget) =>
        featureItemMatcher(widget, 'Transaction feed', Icons.description));

    expect(transactionFeedFeatureItem, findsOneWidget);
  });
}

bool featureItemMatcher(Widget widget, String name, IconData icon) {
  if (widget is FeatureItem) {
    return widget.name == name && widget.icon == icon;
  }
  return false;
}

Widget _getDashboard() {
  return MaterialApp(home: Dashboard());
}
