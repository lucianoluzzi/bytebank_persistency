import 'dart:convert';

import 'package:bytebank_persistency/models/contact.dart';
import 'package:bytebank_persistency/models/transaction.dart';
import 'package:bytebank_persistency/network/web_client.dart';
import 'package:http/http.dart';

class TransactionWebClient {
  Future<List<Transaction>> findAll() async {
    final Response response =
        await client.get(baseUrl).timeout(Duration(seconds: 5));
    return _toTransactionList(response);
  }

  List<Transaction> _toTransactionList(Response response) {
    final List<dynamic> decodedJson = jsonDecode(response.body);
    final List<Transaction> transactions = List();
    for (Map<String, dynamic> element in decodedJson) {
      final Transaction transaction = Transaction(
          element['value'],
          Contact(
            0,
            element['contact']['name'],
            element['contact']['accountNumber'],
          ));
      transactions.add(transaction);
    }
    return transactions;
  }

  Future<Transaction> save(Transaction transaction) async {
    Map<String, dynamic> transactionMap = _toMap(transaction);

    final String transactionJson = jsonEncode(transactionMap);
    final Response response = await client.post(
      baseUrl,
      headers: {'Content-type': 'application/json', 'password': '1000'},
      body: transactionJson,
    );

    return _toTransaction(response);
  }

  Transaction _toTransaction(Response response) {
    Map<String, dynamic> responseJson = jsonDecode(response.body);
    return Transaction(
      responseJson['value'],
      Contact(0, responseJson['contact']['name'],
          responseJson['contact']['account_number']),
    );
  }

  Map<String, dynamic> _toMap(Transaction transaction) {
    final Map<String, dynamic> transactionMap = {
      'value': transaction.value,
      'contact': {
        'accountNumber': transaction.contact.accountNumber,
        'name': transaction.contact.name
      }
    };
    return transactionMap;
  }
}
