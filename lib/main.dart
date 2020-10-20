import 'package:bytebank_persistency/database/dao/contact_dao.dart';
import 'package:flutter/material.dart';

import 'screens/dashboard.dart';

void main() {
  runApp(ByteBank(contactDAO: ContactDAO()));
}

class ByteBank extends StatelessWidget {
  final ContactDAO contactDAO;

  ByteBank({@required this.contactDAO});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.green[900],
            accentColor: Colors.blueAccent[700],
            buttonTheme: ButtonThemeData(
              buttonColor: Colors.blueAccent[700],
              textTheme: ButtonTextTheme.primary,
            )),
        home: Dashboard(contactDAO: contactDAO));
  }
}
