import 'package:bytebank_persistency/network/interceptor/loggin_interceptor.dart';
import 'package:http_interceptor/http_interceptor.dart';

const String baseUrl = 'http://192.168.0.148:8080/transactions';
final HttpClientWithInterceptor client = HttpClientWithInterceptor.build(
  interceptors: [LoggingInterceptor()],
  requestTimeout: Duration(seconds: 5),
);
