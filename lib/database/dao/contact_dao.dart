import 'package:bytebank_persistency/models/contact.dart';
import 'package:sqflite/sqflite.dart';

import '../app.database.dart';

class ContactDAO {
  static const String createTableSQL = "CREATE TABLE $_tableName("
      "$_id INTEGER PRIMARY KEY, "
      "$_name TEXT, "
      "$_accountNumber INTEGER)";
  static const String _tableName = 'contacts';
  static const String _id = 'id';
  static const String _accountNumber = 'account_number';
  static const String _name = 'name';

  Future<int> save(Contact contact) async {
    final Database database = await getDatabase();
    Map<String, dynamic> contactMap = _toMap(contact);
    return database.insert(_tableName, contactMap);
  }

  Map<String, dynamic> _toMap(Contact contact) {
    final Map<String, dynamic> contactMap = Map();
    contactMap[_name] = contact.name;
    contactMap[_accountNumber] = contact.accountNumber;
    return contactMap;
  }

  Future<List<Contact>> findAll() async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> queryResult =
        await database.query(_tableName);
    List<Contact> contacts = _toList(queryResult);
    return contacts;
  }

  List<Contact> _toList(List<Map<String, dynamic>> queryResult) {
    final List<Contact> contacts = List();
    for (Map<String, dynamic> row in queryResult) {
      final Contact contact = Contact(
        row[_id],
        row[_name],
        row[_accountNumber],
      );
      contacts.add(contact);
    }
    return contacts;
  }
}
