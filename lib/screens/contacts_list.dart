import 'package:bytebank_persistency/database/dao/contact_dao.dart';
import 'package:bytebank_persistency/models/contact.dart';
import 'package:bytebank_persistency/screens/contact_form.dart';
import 'package:bytebank_persistency/screens/transaction_form.dart';
import 'package:bytebank_persistency/widgets/dependencies.dart';
import 'package:bytebank_persistency/widgets/progress.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatefulWidget {

  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  List<Contact> _contacts = List();

  @override
  Widget build(BuildContext context) {
    final dependencies = AppDependencies.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer'),
      ),
      body: FutureBuilder<List<Contact>>(
        initialData: List(),
        future: dependencies.contactDAO.findAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return Progress();
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              _contacts = snapshot.data;
              return ListView.builder(
                itemBuilder: (context, index) {
                  Contact contact = _contacts[index];
                  return ContactItem(
                    contact,
                    onClick: () {
                      _navigateAndDisplaySuccess(context, contact);
                    },
                  );
                },
                itemCount: _contacts.length,
              );
              break;
          }

          return Text('Unknown error');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => ContactForm(),
            ),
          )
              .then((newContact) {
            setState(() {
              _contacts.add(newContact);
            });
          });
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  void _navigateAndDisplaySuccess(BuildContext context, Contact contact) async {
    final result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => TransactionForm(contact)));

    if (result != null) {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text("$result")));
    }
  }
}

class ContactItem extends StatelessWidget {
  final Contact contact;
  final Function onClick;

  ContactItem(
    this.contact, {
    @required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => onClick(),
        title: Text(
          contact.name,
          style: TextStyle(fontSize: 24),
        ),
        subtitle: Text(
          contact.accountNumber.toString(),
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
