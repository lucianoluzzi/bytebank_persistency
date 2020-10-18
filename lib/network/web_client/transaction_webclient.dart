import 'dart:convert';

import 'package:bytebank_persistency/models/transaction.dart';
import 'package:bytebank_persistency/network/web_client.dart';
import 'package:http/http.dart';

class TransactionWebClient {
  static final Map<int, String> _statusCodeResponses = {
    400: 'Error submitting the transaction',
    401: 'Authentication error'
  };

  Future<List<Transaction>> findAll() async {
    final Response response =
        await client.get(baseUrl).timeout(Duration(seconds: 5));
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson
        .map((dynamic json) => Transaction.fromJson(json))
        .toList();
  }

  Future<Transaction> save(String password, Transaction transaction) async {
    final Response response = await client.post(
      baseUrl,
      headers: {'Content-type': 'application/json', 'password': password},
      body: jsonEncode(transaction.toJson()),
    );

    if (response.statusCode == 200) {
      return Transaction.fromJson(jsonDecode(response.body));
    }

    _throwHttpError(response.statusCode);
  }

  void _throwHttpError(int statusCode) =>
      throw Exception(_statusCodeResponses[statusCode]);
}
