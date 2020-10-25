import 'package:bytebank_persistency/database/dao/contact_dao.dart';
import 'package:bytebank_persistency/network/web_client/transaction_webclient.dart';
import 'package:mockito/mockito.dart';

class MockContactDao extends Mock implements ContactDAO {}

class MockTransactionWebClient extends Mock implements TransactionWebClient {}