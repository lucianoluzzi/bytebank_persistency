import 'package:bytebank_persistency/main.dart';
import 'package:bytebank_persistency/models/contact.dart';
import 'package:bytebank_persistency/models/transaction.dart';
import 'package:bytebank_persistency/screens/contacts_list.dart';
import 'package:bytebank_persistency/screens/dashboard.dart';
import 'package:bytebank_persistency/screens/transaction_form.dart';
import 'package:bytebank_persistency/widgets/transaction_auth_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../matchers/matchers.dart';
import '../mocks/mocks.dart';
import 'actions.dart';

void main() {
  testWidgets('Should transfer to a contact', (tester) async {
    final mockContactDAO = MockContactDao();
    final mockWebClient = MockTransactionWebClient();
    await tester.pumpWidget(ByteBank(
      contactDAO: mockContactDAO,
      transactionWebClient: mockWebClient,
    ));

    final dashboard = find.byType(Dashboard);
    expect(dashboard, findsOneWidget);

    var contact = Contact(0, 'Alex', 1000);
    when(mockContactDAO.findAll())
        .thenAnswer((realInvocation) async => [contact]);

    await clickOnTransferFeatureItem(tester);
    await tester.pumpAndSettle();

    final contactsList = find.byType(ContactsList);
    expect(contactsList, findsOneWidget);

    verify(mockContactDAO.findAll());

    final contactItem = find.byWidgetPredicate((widget) {
      if (widget is ContactItem) {
        return widget.contact.name == 'Alex' &&
            widget.contact.accountNumber == 1000;
      }
      return false;
    });
    expect(contactItem, findsOneWidget);
    await tester.tap(contactItem);
    await tester.pumpAndSettle();

    final transactionForm = find.byType(TransactionForm);
    expect(transactionForm, findsOneWidget);

    final contactName = find.text('Alex');
    expect(contactName, findsOneWidget);
    final contactAccountNumber = find.text('1000');
    expect(contactAccountNumber, findsOneWidget);

    final textFieldValue = find.byWidgetPredicate((widget) {
      return textFieldByLabelMatcher(widget, 'Value');
    });
    expect(textFieldValue, findsOneWidget);
    await tester.enterText(textFieldValue, '100');

    final transferButton = find.widgetWithText(RaisedButton, 'Transfer');
    expect(transferButton, findsOneWidget);
    await tester.tap(transferButton);
    await tester.pumpAndSettle();

    final transactionAuthDialog = find.byType(TransactionAuthDialog);
    expect(transactionAuthDialog, findsOneWidget);

    final passwordTextField = find.byKey(passwordKey);
    expect(passwordTextField, findsOneWidget);
    await tester.enterText(passwordTextField, '1000');

    final cancelButton = find.widgetWithText(FlatButton, 'Cancel');
    expect(cancelButton, findsOneWidget);

    final confirmButton = find.widgetWithText(FlatButton, 'Confirm');
    expect(confirmButton, findsOneWidget);

    when(mockWebClient.save(
      '1000',
      Transaction(null, 100, contact),
    )).thenAnswer((realInvocation) async => Transaction(null, 100, contact));

    await tester.tap(confirmButton);
    await tester.pumpAndSettle();

    expect(contactsList, findsOneWidget);
    final transactionSnackBar = find.text('Successful transaction!');
    expect(transactionSnackBar, findsOneWidget);
  });
}
