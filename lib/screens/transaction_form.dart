import 'dart:async';

import 'package:bytebank_persistency/models/contact.dart';
import 'package:bytebank_persistency/models/transaction.dart';
import 'package:bytebank_persistency/network/http_exception.dart';
import 'package:bytebank_persistency/network/web_client/transaction_webclient.dart';
import 'package:bytebank_persistency/screens/response_dialog.dart';
import 'package:bytebank_persistency/widgets/dependencies.dart';
import 'package:bytebank_persistency/widgets/progress.dart';
import 'package:bytebank_persistency/widgets/transaction_auth_dialog.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  TransactionForm(this.contact);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final String _transactionId = Uuid().v4();
  final TextEditingController _valueController = TextEditingController();

  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    final dependencies = AppDependencies.of(context);

    print('UUID: $_transactionId');
    return Scaffold(
      appBar: AppBar(
        title: Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                visible: _sending,
                child: Progress(
                  message: 'Sending...',
                ),
              ),
              Text(
                widget.contact.name,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  widget.contact.accountNumber.toString(),
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(labelText: 'Value'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: RaisedButton(
                    child: Text('Transfer'),
                    onPressed: () {
                      final double value =
                          double.tryParse(_valueController.text);
                      final transactionCreated =
                          Transaction(_transactionId, value, widget.contact);

                      showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return TransactionAuthDialog(
                              onConfirm: (String password) {
                                _saveTransaction(
                                  password,
                                  dependencies.transactionWebClient,
                                  transactionCreated,
                                  context,
                                );
                              },
                            );
                          });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _saveTransaction(
    String password,
    TransactionWebClient transactionWebClient,
    Transaction transactionCreated,
    BuildContext context,
  ) async {
    Transaction transaction = await _send(
      transactionWebClient,
      transactionCreated,
      password,
      context,
    );

    _showSuccessfulMessage(transaction, context);
  }

  Future _showSuccessfulMessage(
      Transaction transaction, BuildContext context) async {
    setState(() {
      _sending = false;
    });
    if (transaction != null) {
      Navigator.pop(context, 'Successful transaction!');
    }
  }

  Future<Transaction> _send(
    TransactionWebClient transactionWebClient,
    Transaction transactionCreated,
    String password,
    BuildContext context,
  ) async {
    final Transaction transaction = await transactionWebClient
        .save(password, transactionCreated)
        .whenComplete(() {
      setState(() {
        _sending = false;
      });
    }).catchError((e) {
      _showFailureMessage(context, message: e.message);
    }, test: (e) => e is HttpException).catchError((e) {
      _showFailureMessage(context,
          message: 'timeout submitting the transaction');
    }, test: (e) => e is TimeoutException).catchError((e) {
      _showFailureMessage(context);
    }).catchError((e) {
      _showFailureMessage(context);
    });
    return transaction;
  }

  void _showFailureMessage(
    BuildContext context, {
    String message = 'Unknown error',
  }) {
    showDialog(
        context: context,
        builder: (contextDialog) {
          return FailureDialog(message);
        });
  }
}
