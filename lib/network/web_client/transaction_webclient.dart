import 'dart:convert';

import 'package:bytebank_persistency/models/transaction.dart';
import 'package:bytebank_persistency/network/web_client.dart';
import 'package:http/http.dart';

class TransactionWebClient {
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

    return Transaction.fromJson(jsonDecode(response.body));
  }
}
