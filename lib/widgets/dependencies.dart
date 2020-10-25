import 'package:bytebank_persistency/database/dao/contact_dao.dart';
import 'package:bytebank_persistency/network/web_client/transaction_webclient.dart';
import 'package:flutter/cupertino.dart';

class AppDependencies extends InheritedWidget {
  final ContactDAO contactDAO;
  final TransactionWebClient transactionWebClient;

  AppDependencies({
    @required this.contactDAO,
    @required this.transactionWebClient,
    @required Widget child,
  }) : super(child: child);

  static AppDependencies of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppDependencies>();

  @override
  bool updateShouldNotify(AppDependencies oldWidget) {
    return this.contactDAO == oldWidget.contactDAO ||
        transactionWebClient != oldWidget.transactionWebClient;
  }
}
