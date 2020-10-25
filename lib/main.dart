import 'package:bytebank_persistency/database/dao/contact_dao.dart';
import 'package:bytebank_persistency/network/web_client/transaction_webclient.dart';
import 'package:bytebank_persistency/widgets/dependencies.dart';
import 'package:flutter/material.dart';

import 'screens/dashboard.dart';

void main() {
  runApp(ByteBank(
    contactDAO: ContactDAO(),
    transactionWebClient: TransactionWebClient(),
  ));
}

class ByteBank extends StatelessWidget {
  final ContactDAO contactDAO;
  final TransactionWebClient transactionWebClient;

  ByteBank({
    @required this.contactDAO,
    @required this.transactionWebClient,
  });

  @override
  Widget build(BuildContext context) {
    return AppDependencies(
      transactionWebClient: transactionWebClient,
      contactDAO: contactDAO,
      child: MaterialApp(
          theme: ThemeData(
              primaryColor: Colors.green[900],
              accentColor: Colors.blueAccent[700],
              buttonTheme: ButtonThemeData(
                buttonColor: Colors.blueAccent[700],
                textTheme: ButtonTextTheme.primary,
              )),
          home: Dashboard()),
    );
  }
}
