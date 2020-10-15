import 'dart:convert';

import 'package:bytebank_persistency/models/contact.dart';
import 'package:bytebank_persistency/models/transaction.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

Future<List<Transaction>> findAll() async {
  final HttpClientWithInterceptor client =
      HttpClientWithInterceptor.build(interceptors: [LoggingInterceptor()]);
  final Response response =
      await client.get('http://192.168.0.148:8080/transactions').timeout(Duration(seconds: 5));
  final List<dynamic> decodedJson = jsonDecode(response.body);
  final List<Transaction> transactions = List();
  for (Map<String, dynamic> element in decodedJson) {
    final Transaction transaction = Transaction(
        element['value'],
        Contact(0, element['contact']['name'],
            element['contact']['account_number']));
    transactions.add(transaction);
  }
  return transactions;
}

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    print('Request');
    print('Request URL: ${data.url}');
    print('Headers: ${data.headers}');
    print('Body: ${data.body}');
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    print('Response');
    print('Status code: ${data.statusCode}');
    print('Headers: ${data.headers}');
    print('Body: ${data.body}');
    return data;
  }
}
