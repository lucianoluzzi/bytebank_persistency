import 'package:bytebank_persistency/main.dart';
import 'package:bytebank_persistency/models/contact.dart';
import 'package:bytebank_persistency/screens/contacts_list.dart';
import 'package:bytebank_persistency/screens/dashboard.dart';
import 'package:bytebank_persistency/screens/transaction_form.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.dart';
import 'actions.dart';

void main() {
  testWidgets('Should transfer to a contact', (tester) async {
    final mockContactDAO = MockContactDao();
    await tester.pumpWidget(ByteBank(contactDAO: mockContactDAO));

    final dashboard = find.byType(Dashboard);
    expect(dashboard, findsOneWidget);

    when(mockContactDAO.findAll()).thenAnswer((realInvocation) async {
      return [Contact(0, 'Alex', 1000)];
    });

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


  });
}
