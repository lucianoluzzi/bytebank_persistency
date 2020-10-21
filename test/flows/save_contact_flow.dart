import 'package:bytebank_persistency/main.dart';
import 'package:bytebank_persistency/models/contact.dart';
import 'package:bytebank_persistency/screens/contact_form.dart';
import 'package:bytebank_persistency/screens/contacts_list.dart';
import 'package:bytebank_persistency/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.dart';
import '../widgets/dashboard_widget_test.dart';

void main() {
  testWidgets('Should save a contact', (tester) async {
    final mockContactDAO = MockContactDao();
    await tester.pumpWidget(ByteBank(contactDAO: mockContactDAO));

    final dashboard = find.byType(Dashboard);
    expect(dashboard, findsOneWidget);

    final transferFeature = find.byWidgetPredicate((widget) =>
        featureItemMatcher(widget, 'Transfer', Icons.monetization_on));
    expect(transferFeature, findsOneWidget);

    await tester.tap(transferFeature);
    await tester.pumpAndSettle();

    final contactsList = find.byType(ContactsList);
    expect(contactsList, findsOneWidget);

    verify(mockContactDAO.findAll());

    final fabNewContact = find.widgetWithIcon(FloatingActionButton, Icons.add);
    expect(fabNewContact, findsOneWidget);
    await tester.tap(fabNewContact);
    await tester.pumpAndSettle();

    final contactForm = find.byType(ContactForm);
    expect(contactForm, findsOneWidget);

    final nameTextField = find.byWidgetPredicate(
        (widget) => _contactFormLabelMatcher(widget, 'Full name'));
    expect(nameTextField, findsOneWidget);
    await tester.enterText(nameTextField, 'Luzzi');

    final accountNumberTextField = find.byWidgetPredicate(
        (widget) => _contactFormLabelMatcher(widget, 'Account number'));
    expect(accountNumberTextField, findsOneWidget);
    await tester.enterText(accountNumberTextField, '12345');

    final createButton = find.byType(RaisedButton);
    expect(createButton, findsOneWidget);
    await tester.tap(createButton);
    await tester.pumpAndSettle();

    verify(mockContactDAO.save(Contact(0, 'Luzzi', 12345)));

    final contactsListBack = find.byType(ContactsList);
    expect(contactsListBack, findsOneWidget);

    verify(mockContactDAO.findAll());
  });
}

bool _contactFormLabelMatcher(widget, String labelValue) {
  if (widget is TextField) {
    return widget.decoration.labelText == labelValue;
  }
  return false;
}
