import 'dart:html';

import 'package:bytebank_persistency/main.dart';
import 'package:bytebank_persistency/screens/contact_form.dart';
import 'package:bytebank_persistency/screens/contacts_list.dart';
import 'package:bytebank_persistency/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'dashboard_widget_test.dart';

void main() {
  testWidgets('Should save a contact', (tester) async {
    await tester.pumpWidget(ByteBank());

    final dashboard = find.byType(Dashboard);
    expect(dashboard, findsOneWidget);

    final transferFeature = find.byWidgetPredicate((widget) => featureItemMatcher(widget, 'Transfer', Icons.monetization_on));
    expect(transferFeature, findsOneWidget);

    await tester.tap(transferFeature);
    await tester.pumpAndSettle();

    final contactsList = find.byType(ContactsList);
    expect(contactsList, findsOneWidget);

    final fabNewContact = find.widgetWithIcon(FloatingActionButton, Icons.add);
    expect(fabNewContact, findsOneWidget);
    await tester.tap(fabNewContact);
    await tester.pumpAndSettle();

    final contactForm = find.byType(ContactForm);
    expect(contactForm, findsOneWidget);
  });
}